import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'seed.dart';

typedef Record = Map<String, dynamic>;
const sections = <String, String>{
  'products': 'المنتجات والمواد الخام', 'warehouses': 'المستودعات',
  'stock': 'أرصدة المخزون', 'transfers': 'التحويل بين المستودعات',
  'suppliers': 'الموردون', 'customers': 'العملاء',
  'purchases': 'المشتريات', 'sales': 'المبيعات',
  'lines': 'خطوط الإنتاج', 'recipes': 'مكونات الوصفات',
  'production': 'أوامر التصنيع', 'expenses': 'المصروفات',
  'users': 'المستخدمون والصلاحيات', 'audit': 'سجل العمليات',
};
String newId() => '${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 30)}';
double number(dynamic x) => double.tryParse('$x') ?? 0;
String passwordHash(String password, String salt) {
  // PBKDF2-HMAC-SHA256, one 32-byte block, 120000 iterations.
  final h = Hmac(sha256, utf8.encode(password));
  var u = h.convert([...base64Decode(salt), 0, 0, 0, 1]).bytes;
  final result = List<int>.from(u);
  for (var i = 1; i < 120000; i++) {
    u = h.convert(u).bytes;
    for (var j = 0; j < result.length; j++) { result[j] ^= u[j]; }
  }
  return base64Encode(result);
}
Record credentials(String password) {
  final salt = base64Encode(List.generate(16, (_) => Random.secure().nextInt(256)));
  return {'salt': salt, 'hash': passwordHash(password, salt)};
}
bool equalHash(String a, String b) {
  final x = utf8.encode(a), y = utf8.encode(b);
  if (x.length != y.length) return false;
  var diff = 0;
  for (var i = 0; i < x.length; i++) { diff |= x[i] ^ y[i]; }
  return diff == 0;
}

class FactoryStore extends ChangeNotifier {
  FactoryStore(this.file);
  final File file;
  Map<String, List<Record>> data = {};
  Record? session;
  bool busy = false;
  List<Record> rows(String key) => data[key] ?? [];
  Future<void> load() async {
    if (await file.exists()) {
      final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      data = raw.map((k, v) => MapEntry(k, (v as List).map((r) => Record.from(r as Map)).toList()));
    } else {
      data = {for (final k in sections.keys) k: []};
      data['products'] = initialProducts.map((p) => {...p, 'kind': 'منتج جاهز', 'unit': 'كرتون'}).toList();
      data['warehouses'] = List.generate(4, (i) => {'id': 'w$i', 'name': 'المستودع ${i + 1}'});
      data['lines'] = List.generate(100, (i) => {'id': 'l$i', 'name': 'خط ${(i + 1).toString().padLeft(3, '0')}', 'status': 'جاهز', 'capacity': '0'});
    }
  }
  bool allowed(String key, {bool write = false}) {
    final u = session;
    if (u == null || u['active'] == false) return false;
    if (u['role'] == 'مدير رئيسي') return true;
    if (key == 'users' || key == 'audit') return false;
    final perms = u['permissions'] as Map? ?? {};
    return write ? perms[key] == 'تعديل' : ['قراءة', 'تعديل'].contains(perms[key]);
  }
  String label(String key, dynamic id) => rows(key).where((r) => r['id'] == id).map((r) => '${r['name']}').firstOrNull ?? 'غير محدد';
  Record get(String key, String id) => rows(key).firstWhere((r) => r['id'] == id, orElse: () => throw StateError('السجل غير موجود'));
  Future<void> persist() async {
    await file.parent.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(jsonEncode(data), flush: true);
    await temp.rename(file.path);
  }
  Future<void> transact(String key, void Function() action, {bool setup = false}) async {
    if (busy) throw StateError('انتظر اكتمال الحفظ');
    if (!setup && !allowed(key, write: true)) throw StateError('لا تملك صلاحية التعديل');
    busy = true;
    final before = jsonEncode(data);
    try {
      action();
      rows('audit').add({'id': newId(), 'name': sections[key], 'actor': session?['name'] ?? 'تهيئة المدير', 'date': DateTime.now().toIso8601String()});
      await persist();
    } catch (_) {
      final old = jsonDecode(before) as Map<String, dynamic>;
      data = old.map((k, v) => MapEntry(k, (v as List).map((r) => Record.from(r as Map)).toList()));
      rethrow;
    } finally { busy = false; notifyListeners(); }
  }
  Future<void> setup(String name, String username, String password) async {
    if (rows('users').isNotEmpty) throw StateError('تم إنشاء المدير مسبقاً');
    if (password.length < 8) throw StateError('كلمة المرور ثمانية أحرف على الأقل');
    final auth = await compute(_credentials, password);
    await transact('users', () => rows('users').add({'id': newId(), 'name': name, 'username': username, 'role': 'مدير رئيسي', 'active': true, ...auth}), setup: true);
  }
  Future<bool> login(String username, String password) async {
    final candidates = rows('users').where((u) => u['username'] == username && u['active'] != false);
    if (candidates.isEmpty) return false;
    final u = candidates.first;
    final hash = await compute(_hash, [password, '${u['salt']}']);
    if (!equalHash(hash, '${u['hash']}')) return false;
    session = u; notifyListeners(); return true;
  }
  void logout() { session = null; notifyListeners(); }
  Future<void> saveUser(Record value, String password) async {
    if (rows('users').any((u) => u['username'] == value['username'] && u['id'] != value['id'])) throw StateError('اسم المستخدم مستخدم بالفعل');
    if (value['role'] != 'مدير رئيسي' && value['id'] == session?['id']) throw StateError('لا يمكن إزالة صلاحيتك كمدير رئيسي');
    if (password.isNotEmpty) {
      if (password.length < 8) throw StateError('كلمة المرور ثمانية أحرف على الأقل');
      value.addAll(await compute(_credentials, password));
    } else if (value['hash'] == null) { throw StateError('أدخل كلمة مرور'); }
    await save('users', value);
    if (session?['id'] == value['id']) session = value;
  }
  Future<void> save(String key, Record value) => transact(key, () {
    if ('${value['name'] ?? ''}'.trim().isEmpty) throw StateError('الاسم مطلوب');
    value['id'] ??= newId();
    final i = rows(key).indexWhere((r) => r['id'] == value['id']);
    if (i < 0) { rows(key).add(value); } else { rows(key)[i] = value; }
  });
  double balance(String warehouse, String product) => rows('stock').where((s) => s['warehouse'] == warehouse && s['product'] == product).fold(0.0, (sum, s) => sum + number(s['quantity']));
  void adjust(String warehouse, String product, double delta) {
    get('warehouses', warehouse); get('products', product);
    final next = balance(warehouse, product) + delta;
    if (next < -0.000001) throw StateError('الرصيد غير كافٍ: ${label('products', product)}');
    rows('stock').removeWhere((s) => s['warehouse'] == warehouse && s['product'] == product);
    rows('stock').add({'id': newId(), 'warehouse': warehouse, 'product': product, 'quantity': max(0, next)});
  }
  Future<void> opening(String warehouse, String product, double qty) => transact('stock', () {
    if (!qty.isFinite || qty <= 0) throw StateError('الكمية يجب أن تكون موجبة');
    adjust(warehouse, product, qty);
  });
  Future<void> movement(String key, Record r) => transact(key, () {
    final qty = number(r['quantity']);
    if (qty <= 0 || !qty.isFinite) throw StateError('الكمية يجب أن تكون موجبة');
    final wh = '${r['warehouse']}', product = '${r['product']}';
    if (key == 'transfers') {
      if (wh == r['destination']) throw StateError('اختر مستودعين مختلفين');
      adjust(wh, product, -qty); adjust('${r['destination']}', product, qty);
    } else {
      final price = number(r['price']);
      if (price < 0 || !price.isFinite) throw StateError('السعر غير صالح');
      get(key == 'sales' ? 'customers' : 'suppliers', '${r['party']}');
      adjust(wh, product, key == 'sales' ? -qty : qty);
      r['total'] = qty * price;
      if (key == 'sales') r['costTotal'] = qty * number(get('products', product)['cost']);
      r['actor'] = session?['id'];
    }
    rows(key).add({...r, 'id': newId(), 'date': DateTime.now().toIso8601String()});
  });
  Future<void> produce(Record r) => transact('production', () {
    final qty = number(r['quantity']);
    if (qty <= 0 || !qty.isFinite) throw StateError('كمية الإنتاج غير صالحة');
    get('lines', '${r['line']}');
    final recipe = rows('recipes').where((x) => x['product'] == r['product']).toList();
    if (recipe.isEmpty) throw StateError('أضف مكونات الوصفة أولاً');
    for (final item in recipe) {
      final required = number(item['quantity']) * qty;
      if (required <= 0) throw StateError('كمية مكون الوصفة غير صالحة');
      adjust('${r['source']}', '${item['material']}', -required);
    }
    adjust('${r['warehouse']}', '${r['product']}', qty);
    rows('production').add({...r, 'id': newId(), 'status': 'مكتمل', 'date': DateTime.now().toIso8601String(), 'actor': session?['id']});
  });
  double total(String key, String field) => rows(key).fold(0.0, (sum, r) => sum + number(r[field]));
}
Record _credentials(String password) => credentials(password);
String _hash(List<String> args) => passwordHash(args[0], args[1]);
