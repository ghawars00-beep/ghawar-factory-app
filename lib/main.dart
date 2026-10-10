import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final dir = await getApplicationDocumentsDirectory();
    final store = FactoryStore(File('${dir.path}/factory.json'));
    await store.load();
    runApp(GhawarApp(store));
  } catch (_) {
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('تعذّر فتح بيانات التطبيق. أعد تشغيل التطبيق دون حذف بياناته.')))));
  }
}
class GhawarApp extends StatelessWidget {
  const GhawarApp(this.store, {super.key});
  final FactoryStore store;
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'غوار الأصلية', locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')], localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff8d151b)), scaffoldBackgroundColor: const Color(0xfff7f3ec)),
    home: AnimatedBuilder(animation: store, builder: (_, __) => store.session == null ? Login(store) : Home(store)),
  );
}
void error(BuildContext c, Object e) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Bad state: ', ''))));
class Login extends StatefulWidget {
  const Login(this.s, {super.key}); final FactoryStore s;
  @override State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final name = TextEditingController(), username = TextEditingController(), password = TextEditingController();
  bool busy = false;
  @override void dispose() { name.dispose(); username.dispose(); password.dispose(); super.dispose(); }
  Future<void> submit() async {
    if (username.text.trim().isEmpty || password.text.isEmpty) { error(context, 'أدخل اسم المستخدم وكلمة المرور'); return; }
    setState(() => busy = true);
    try {
      if (widget.s.rows('users').isEmpty) {
        if (name.text.trim().isEmpty) throw StateError('أدخل اسم المدير');
        await widget.s.setup(name.text.trim(), username.text.trim(), password.text);
      }
      if (!await widget.s.login(username.text.trim(), password.text)) throw StateError('بيانات الدخول غير صحيحة أو الحساب معطل');
    } catch (e) { if (mounted) error(context, e); }
    finally { if (mounted) setState(() => busy = false); }
  }
  @override Widget build(BuildContext c) => Scaffold(body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: SizedBox(width: 420, child: Column(children: [
    const Icon(Icons.factory, size: 80, color: Color(0xff8d151b)), const Text('غوار الأصلية', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
    const Text('إدارة المصنع'), const SizedBox(height: 24),
    if (widget.s.rows('users').isEmpty) ...[const Text('إنشاء حساب المدير الرئيسي لأول تشغيل'), TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المدير'))],
    TextField(controller: username, decoration: const InputDecoration(labelText: 'اسم المستخدم')),
    TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور'), onSubmitted: (_) { if (!busy) submit(); }),
    const SizedBox(height: 20), FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'جارٍ التحقق…' : 'دخول')),
    const SizedBox(height: 20), const Text('هذه النسخة تحفظ البيانات على هذا الجهاز. حسابات الأجهزة المختلفة تحتاج خادماً مشتركاً.', textAlign: TextAlign.center),
  ])))));
}
class Home extends StatefulWidget {
  const Home(this.s, {super.key}); final FactoryStore s;
  @override State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  String key = 'dashboard';
  @override Widget build(BuildContext c) {
    final s = widget.s;
    if (key != 'dashboard' && key != 'devices' && !s.allowed(key)) key = 'dashboard';
    return Scaffold(appBar: AppBar(title: Text(key == 'dashboard' ? 'غوار • الرئيسية' : key == 'devices' ? 'الأجهزة والطابعات' : sections[key]!), actions: [IconButton(onPressed: s.logout, tooltip: 'تسجيل الخروج', icon: const Icon(Icons.logout))]),
      drawer: Drawer(child: SafeArea(child: ListView(children: [ListTile(title: Text('${s.session?['name']}'), subtitle: Text('${s.session?['role']}')), ListTile(title: const Text('الرئيسية'), onTap: () { setState(() => key = 'dashboard'); Navigator.pop(c); }),
        ListTile(leading: const Icon(Icons.print), title: const Text('Wi‑Fi • Bluetooth • الطابعات'), selected: key == 'devices', onTap: () { setState(() => key = 'devices'); Navigator.pop(c); }),
        for (final e in sections.entries) if (s.allowed(e.key)) ListTile(title: Text(e.value), selected: key == e.key, onTap: () { setState(() => key = e.key); Navigator.pop(c); }),
      ]))),
      body: key == 'dashboard' ? dashboard(s) : key == 'devices' ? const DevicesAndPrinters() : records(s),
      floatingActionButton: key != 'dashboard' && key != 'devices' && key != 'audit' && s.allowed(key, write: true) ? FloatingActionButton(onPressed: () => edit(c, s, key), child: const Icon(Icons.add)) : null,
    );
  }
  Widget dashboard(FactoryStore s) => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('لوحة إدارة المصنع', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('البيانات محفوظة محلياً على الجهاز • افتح القائمة للوصول للأقسام'))),
    for (final e in sections.entries) if (s.allowed(e.key)) Card(child: ListTile(title: Text(e.value), trailing: Text('${s.rows(e.key).length}'), onTap: () => setState(() => key = e.key))),
    if (s.allowed('sales')) metric('إجمالي المبيعات', s.total('sales', 'total')),
    if (s.allowed('purchases')) metric('إجمالي المشتريات', s.total('purchases', 'total')),
    if (s.allowed('expenses')) metric('إجمالي المصروفات', s.total('expenses', 'amount')),
    if (s.allowed('sales') && s.allowed('expenses')) metric('هامش المبيعات بعد المصروفات (تقديري)', s.total('sales', 'total') - s.total('sales', 'costTotal') - s.total('expenses', 'amount')),
  ]);
  Widget metric(String title, double v) => Card(child: ListTile(title: Text(title), subtitle: Text('${v.toStringAsFixed(2)} ريال')));
  Widget records(FactoryStore s) {
    final list = s.rows(key);
    return list.isEmpty ? const Center(child: Text('لا توجد سجلات. اضغط + للإضافة.')) : ListView.builder(padding: const EdgeInsets.fromLTRB(12, 12, 12, 90), itemCount: list.length, itemBuilder: (c, i) {
      final r = list[i];
      final immutable = ['stock', 'transfers', 'sales', 'purchases', 'production', 'audit'].contains(key);
      return Card(child: ListTile(leading: avatar(r), title: Text('${r['name'] ?? s.label('products', r['product'])}'),
        subtitle: Text(describe(s, key, r)), isThreeLine: false,
        onTap: !immutable && s.allowed(key, write: true) ? () => edit(c, s, key, r) : null));
    });
  }
}
Widget avatar(Record r) {
  final value = r['image'];
  if (value is String && value.isNotEmpty) {
    try { return CircleAvatar(backgroundImage: MemoryImage(base64Decode(value))); } catch (_) { /* Show placeholder for a malformed image. */ }
  }
  return const CircleAvatar(child: Icon(Icons.inventory_2));
}
String describe(FactoryStore s, String key, Record r) {
  final parts = <String>[];
  for (final e in r.entries) {
    if (['id','name','image','salt','hash','permissions','actor'].contains(e.key) || '${e.value}'.isEmpty) continue;
    final label = fieldLabels[e.key] ?? e.key;
    final ref = references[e.key];
    final value = ref != null ? s.label(ref, e.value) : e.key == 'party' ? s.label(key == 'sales' ? 'customers' : 'suppliers', e.value) : '${e.value}';
    parts.add('$label: $value');
  }
  return parts.join('\n');
}
const fieldLabels = <String, String>{
  'name':'الاسم','category':'القسم','pack':'التعبئة','weight':'الوزن','price':'سعر الوحدة','cost':'تكلفة الوحدة','unit':'الوحدة','kind':'النوع',
  'warehouse':'المستودع','destination':'المستودع المستلم','source':'مستودع المواد','product':'المنتج','material':'المادة الخام','quantity':'الكمية',
  'phone':'الهاتف','address':'العنوان','tax':'الرقم الضريبي','notes':'ملاحظات','status':'الحالة','capacity':'الطاقة في الساعة','supervisor':'المشرف','machine':'الآلة','shift':'الوردية',
  'party':'الطرف','total':'الإجمالي','costTotal':'التكلفة','date':'التاريخ','line':'خط الإنتاج','amount':'المبلغ','username':'اسم المستخدم','role':'نوع الحساب','active':'نشط',
};
const references = <String, String>{'warehouse':'warehouses','destination':'warehouses','source':'warehouses','product':'products','material':'products','line':'lines'};
const fields = <String, List<String>>{
  'products':['name','kind','category','unit','pack','weight','price','cost','notes'],
  'warehouses':['name','address','notes'],
  'suppliers':['name','phone','address','tax','notes'], 'customers':['name','phone','address','tax','notes'],
  'lines':['name','category','status','capacity','supervisor','machine','shift','notes'],
  'recipes':['name','product','material','quantity','notes'],
  'expenses':['name','amount','notes'],
  'users':['name','username','role'],
  'stock':['warehouse','product','quantity'],
  'transfers':['warehouse','destination','product','quantity','notes'],
  'sales':['name','party','warehouse','product','quantity','price','notes'],
  'purchases':['name','party','warehouse','product','quantity','price','notes'],
  'production':['name','line','product','source','warehouse','quantity','notes'],
};
Future<void> edit(BuildContext c, FactoryStore s, String key, [Record? old]) async {
  await showDialog<void>(context: c, builder: (_) => Editor(s, key, old));
}
class Editor extends StatefulWidget {
  const Editor(this.s, this.kind, this.old, {super.key}); final FactoryStore s; final String kind; final Record? old;
  @override State<Editor> createState() => _EditorState();
}
class _EditorState extends State<Editor> {
  late Record value;
  final controllers = <String, TextEditingController>{};
  final password = TextEditingController();
  bool busy = false;
  @override void initState() {
    super.initState(); value = {...?widget.old};
    value['permissions'] = Map<String,dynamic>.from(value['permissions'] as Map? ?? {});
    for (final f in fields[widget.kind]!) { controllers[f] = TextEditingController(text: '${value[f] ?? ''}'); }
  }
  @override void dispose() { for (final x in controllers.values) { x.dispose(); } password.dispose(); super.dispose(); }
  List<Record>? choices(String f) {
    if (references.containsKey(f)) return widget.s.rows(references[f]!);
    if (f == 'party') return widget.s.rows(widget.kind == 'sales' ? 'customers' : 'suppliers');
    final options = switch(f) {
      'kind' => ['منتج جاهز','مادة خام','تعبئة وتغليف'],
      'status' => ['جاهز','يعمل','متوقف','صيانة'],
      'role' => ['مدير رئيسي','مسؤول','مندوب','نقطة بيع'],
      _ => null,
    };
    return options?.map((x) => <String,dynamic>{'id':x,'name':x}).toList();
  }
  Future<void> photo() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 75);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (bytes.length > 2 * 1024 * 1024) throw StateError('اختر صورة أصغر من 2 ميجابايت');
      if (mounted) setState(() => value['image'] = base64Encode(bytes));
    } catch (e) { if (mounted) error(context, e); }
  }
  Future<void> save() async {
    setState(() => busy = true);
    try {
      for (final f in fields[widget.kind]!) {
        if (choices(f) == null) value[f] = controllers[f]!.text.trim();
        if (['name','username','warehouse','destination','source','product','material','line','party','kind','role','unit'].contains(f) && '${value[f] ?? ''}'.trim().isEmpty) throw StateError('${fieldLabels[f]} مطلوب');
        if (['quantity','price','cost','amount','capacity'].contains(f)) {
          final n = double.tryParse('${value[f]}');
          if (n == null || !n.isFinite || n < 0 || (['quantity','amount'].contains(f) && n == 0)) throw StateError('${fieldLabels[f]} غير صالح');
        }
      }
      final s = widget.s, k = widget.kind;
      switch(k) {
        case 'users': await s.saveUser(value, password.text);
        case 'stock': await s.opening('${value['warehouse']}', '${value['product']}', number(value['quantity']));
        case 'transfers': case 'sales': case 'purchases': await s.movement(k, value);
        case 'production': await s.produce(value);
        default: await s.save(k, value);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) { if (mounted) error(context, e); }
    finally { if (mounted) setState(() => busy = false); }
  }
  @override Widget build(BuildContext c) => AlertDialog(title: Text('${widget.old == null ? 'إضافة' : 'تعديل'} • ${sections[widget.kind]}'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      if (widget.kind == 'recipes') const Text('كمية كل مادة لإنتاج وحدة واحدة من المنتج، بوحدة المادة المحددة.'),
      if (widget.kind == 'stock') const Text('إضافة رصيد افتتاحي. استخدم المشتريات للاستلام والتحويلات للنقل.'),
      if (widget.kind == 'production') const Text('حفظ الأمر يستهلك مواد الوصفة ويسجل الإنتاج المكتمل فوراً.'),
      for (final f in fields[widget.kind]!) Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: choices(f) == null
        ? TextField(controller: controllers[f], decoration: InputDecoration(labelText: fieldLabels[f], border: const OutlineInputBorder()), keyboardType: ['quantity','price','cost','amount','capacity'].contains(f) ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text)
        : DropdownButtonFormField<String>(isExpanded: true, value: choices(f)!.any((r) => r['id'] == value[f]) ? value[f] as String? : null,
          decoration: InputDecoration(labelText: fieldLabels[f], border: const OutlineInputBorder()), items: choices(f)!.map((r) => DropdownMenuItem<String>(value: '${r['id']}', child: Text('${r['name']}', overflow: TextOverflow.ellipsis))).toList(), onChanged: busy ? null : (v) => setState(() => value[f] = v))),
      if (['products','users'].contains(widget.kind)) ...[avatar(value), TextButton.icon(onPressed: busy ? null : photo, icon: const Icon(Icons.photo), label: const Text('اختيار صورة'))],
      if (widget.kind == 'users') ...[
        TextField(controller: password, obscureText: true, decoration: InputDecoration(labelText: widget.old == null ? 'كلمة المرور' : 'كلمة مرور جديدة (اختياري)')),
        if (value['id'] != widget.s.session?['id']) SwitchListTile(title: const Text('الحساب نشط'), value: value['active'] != false, onChanged: (v) => setState(() => value['active'] = v)),
        const Text('الصلاحيات: المدير الرئيسي لديه جميع الصلاحيات. الصلاحيات الأخرى يحددها المدير لكل قسم.'),
        for (final e in sections.entries) if (!['users','audit'].contains(e.key)) DropdownButtonFormField<String>(value: (value['permissions'] as Map)[e.key] as String? ?? 'ممنوع', decoration: InputDecoration(labelText: e.value), items: ['ممنوع','قراءة','تعديل'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => (value['permissions'] as Map)[e.key] = v)),
      ],
    ]))), actions: [TextButton(onPressed: busy ? null : () => Navigator.pop(c), child: const Text('إلغاء')), FilledButton(onPressed: busy ? null : save, child: Text(busy ? 'جارٍ الحفظ…' : 'حفظ'))]);
}


class DevicesAndPrinters extends StatefulWidget {
  const DevicesAndPrinters({super.key});
  @override State<DevicesAndPrinters> createState() => _DevicesAndPrintersState();
}
class _DevicesAndPrintersState extends State<DevicesAndPrinters> {
  final ip = TextEditingController(text: '192.168.1.100');
  final port = TextEditingController(text: '9100');
  List<BluetoothInfo> paired = const [];
  String? connectedMac;
  bool busy = false;
  String status = 'جاهز للاتصال بطابعة Bluetooth أو Wi‑Fi';
  @override void dispose() { ip.dispose(); port.dispose(); super.dispose(); }
  Future<void> loadBluetooth() async {
    setState(() { busy = true; status = 'جارٍ قراءة أجهزة Bluetooth المقترنة…'; });
    try {
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) throw StateError('فعّل Bluetooth من إعدادات الهاتف أولاً');
      final permission = await PrintBluetoothThermal.isPermissionBluetoothGranted;
      if (!permission) throw StateError('امنح التطبيق صلاحية الأجهزة القريبة / Bluetooth من إعدادات Android');
      final list = await PrintBluetoothThermal.pairedBluetooths;
      if (!mounted) return;
      setState(() { paired = list; status = list.isEmpty ? 'لا توجد طابعات مقترنة. اربط الطابعة من إعدادات Bluetooth في الهاتف ثم أعد البحث.' : 'تم العثور على ${list.length} جهاز/طابعة مقترنة'; });
    } catch (e) { if (mounted) setState(() => status = e.toString().replaceFirst('Bad state: ', '')); }
    finally { if (mounted) setState(() => busy = false); }
  }
  Future<void> connectBluetooth(BluetoothInfo b) async {
    setState(() { busy = true; status = 'جارٍ الاتصال بـ ${b.name}…'; });
    try {
      final ok = await PrintBluetoothThermal.connect(macPrinterAddress: b.macAdress);
      if (!ok) throw StateError('تعذّر الاتصال بالطابعة');
      if (mounted) setState(() { connectedMac = b.macAdress; status = 'متصل عبر Bluetooth: ${b.name}'; });
    } catch (e) { if (mounted) setState(() => status = e.toString().replaceFirst('Bad state: ', '')); }
    finally { if (mounted) setState(() => busy = false); }
  }
  Future<void> printBluetoothTest() async {
    setState(() { busy = true; status = 'جارٍ إرسال صفحة اختبار Bluetooth…'; });
    try {
      if (!await PrintBluetoothThermal.connectionStatus) throw StateError('اتصل بطابعة Bluetooth أولاً');
      final ok = await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 2, text: 'GHAWAR FACTORY\nPrinter Test\n${DateTime.now()}\n\n\n'));
      if (!ok) throw StateError('الطابعة لم تقبل أمر الطباعة');
      if (mounted) setState(() => status = 'تم إرسال صفحة الاختبار إلى طابعة Bluetooth');
    } catch (e) { if (mounted) setState(() => status = e.toString().replaceFirst('Bad state: ', '')); }
    finally { if (mounted) setState(() => busy = false); }
  }
  Future<void> printWifiTest() async {
    setState(() { busy = true; status = 'جارٍ الاتصال بطابعة Wi‑Fi…'; });
    Socket? socket;
    try {
      final host = ip.text.trim(); final p = int.tryParse(port.text.trim());
      if (host.isEmpty || p == null || p < 1 || p > 65535) throw StateError('أدخل عنوان IP ومنفذ صحيحين');
      socket = await Socket.connect(host, p, timeout: const Duration(seconds: 5));
      final bytes = <int>[27,64,27,97,1, ...utf8.encode('GHAWAR FACTORY\nWiFi Printer Test\n${DateTime.now()}\n\n\n'), 29,86,0];
      socket.add(bytes); await socket.flush();
      if (mounted) setState(() => status = 'تم إرسال صفحة الاختبار إلى $host:$p');
    } catch (e) { if (mounted) setState(() => status = 'فشل اتصال Wi‑Fi: ${e.toString().replaceFirst('Bad state: ', '')}'); }
    finally { socket?.destroy(); if (mounted) setState(() => busy = false); }
  }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline), const SizedBox(width: 12), Expanded(child: Text(status))]))),
    const SizedBox(height: 8), const Text('Bluetooth', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const Text('يدعم الطابعات الحرارية 58/80 مم المتوافقة. اقترن بالطابعة أولاً من إعدادات الهاتف.'),
    const SizedBox(height: 8), FilledButton.icon(onPressed: busy ? null : loadBluetooth, icon: const Icon(Icons.bluetooth_searching), label: const Text('البحث في الأجهزة المقترنة')),
    for (final b in paired) Card(child: ListTile(leading: const Icon(Icons.print), title: Text(b.name.isEmpty ? 'طابعة Bluetooth' : b.name), subtitle: Text(b.macAdress), trailing: connectedMac == b.macAdress ? const Icon(Icons.check_circle) : const Icon(Icons.link), onTap: busy ? null : () => connectBluetooth(b))),
    if (connectedMac != null) OutlinedButton.icon(onPressed: busy ? null : printBluetoothTest, icon: const Icon(Icons.print), label: const Text('طباعة اختبار Bluetooth')),
    const Divider(height: 40), const Text('طابعة Wi‑Fi / LAN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const Text('للطابعات التي تستقبل ESC/POS مباشرة عبر الشبكة. المنفذ الشائع 9100.'), const SizedBox(height: 8),
    TextField(controller: ip, keyboardType: TextInputType.url, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'عنوان IP للطابعة', hintText: '192.168.1.100')),
    const SizedBox(height: 8), TextField(controller: port, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'المنفذ', hintText: '9100')),
    const SizedBox(height: 8), FilledButton.icon(onPressed: busy ? null : printWifiTest, icon: const Icon(Icons.wifi), label: const Text('اتصال وطباعة اختبار Wi‑Fi')),
    const SizedBox(height: 24), const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('الخطوة التالية: ربط زر الطباعة بالفواتير، أوامر الإنتاج، سندات المخزون، والملصقات/الباركود بعد تحديد موديلات الطابعات المستخدمة في المصنع.'))),
  ]);
}
