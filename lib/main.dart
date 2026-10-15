import 'package:flutter/material.dart';

void main() => runApp(const GhawarApp());

class Product {
  Product(this.name, this.category, this.pack, {this.weight = ''});
  String name, category, pack, weight;
}

class LineItem {
  LineItem(
    this.name,
    this.category, {
    this.status = 'جاهز',
    this.manager = 'غير محدد',
    this.quantity = 0,
    this.unit = 'كرتون',
  });

  String name, category, status, manager, unit;
  double quantity;
}

class Warehouse {
  Warehouse(this.name, {this.quantity = 0});
  String name;
  double quantity;
}

class UserItem {
  UserItem(
    this.name,
    this.role, {
    this.username = '',
    this.password = '',
    this.active = true,
    this.permissions = const [],
  });

  String name, role, username, password;
  bool active;
  List<String> permissions;
}

class ProductionEntry {
  ProductionEntry(
    this.line,
    this.product,
    this.quantity,
    this.unit,
    this.date,
  );

  String line, product, unit, date;
  double quantity;
}

class Supplier {
  Supplier(this.name, this.phone);
  String name, phone;
}

class RawMaterial {
  RawMaterial(this.name, this.quantity, this.unit);
  String name, unit;
  double quantity;
}

class PrinterItem {
  PrinterItem(
    this.name,
    this.type, {
    this.address = '',
    this.connected = false,
  });

  String name, type, address;
  bool connected;
}

class WrapperWorker {
  WrapperWorker(this.id, {this.name = '', this.active = true});

  final int id;
  String name;
  bool active;
}

class WrapperProduction {
  WrapperProduction(this.worker, this.product, this.qty, this.time);

  String worker, product;
  double qty;
  DateTime time;
}

class DiscountItem {
  DiscountItem(this.worker, this.amount, this.reason, this.time);

  String worker, reason;
  double amount;
  DateTime time;
}

class CustomerItem {
  CustomerItem(
    this.name,
    this.type, {
    this.location = '',
    this.active = true,
  });

  String name, type, location;
  bool active;
}

class OperationLog {
  OperationLog(this.action, this.details, this.time);

  String action, details;
  DateTime time;
}

class Store extends ChangeNotifier {
  final categories = <String>[
    'السمبوسة المحشية',
    'رقائق السمبوسة',
    'الكنافة',
    'خبز المرقوق',
    'القرصان',
    'اللحوح',
  ];

  final products = <Product>[
    Product(
      'سمبوسة محشية بالجبن السائل',
      'السمبوسة المحشية',
      '100 حبة/كيس × 5 أكياس/كرتون',
    ),
    Product(
      'سمبوسة محشية باللحم',
      'السمبوسة المحشية',
      '100 حبة/كيس × 5 أكياس/كرتون',
    ),
    Product(
      'سمبوسة محشية بالدجاج',
      'السمبوسة المحشية',
      '100 حبة/كيس × 5 أكياس/كرتون',
    ),
    Product(
      'رقائق سمبوسة غوار مقرمش',
      'رقائق السمبوسة',
      '20 كيس/كرتون',
      weight: '800 جم',
    ),
    Product(
      'رقائق سمبوسة غوار فاخرة',
      'رقائق السمبوسة',
      '20 كيس/كرتون',
      weight: '800 جم',
    ),
  ];

  final warehouses = <Warehouse>[
    Warehouse('الثلاجة المركزية'),
    Warehouse('ثلاجة المصنع'),
    Warehouse('المستودع الخارجي'),
    Warehouse('مستودع المعمل'),
  ];

  final users = <UserItem>[
    UserItem(
      'مدير البرنامج الرئيسي',
      'مدير رئيسي',
      username: 'admin',
      password: 'Ghawar@2026',
      permissions: ['الكل'],
    ),
  ];

  final suppliers = <Supplier>[];
  final rawMaterials = <RawMaterial>[];
  final printers = <PrinterItem>[];
  final lines = <LineItem>[];
  final production = <ProductionEntry>[];
  final wrappers = <WrapperWorker>[];
  final wrapperProduction = <WrapperProduction>[];
  final discounts = <DiscountItem>[];
  final customers = <CustomerItem>[];
  final logs = <OperationLog>[];

  double wagePer1000 = 40;
  int stopMinutes = 180;

  Store() {
    for (var i = 1; i <= 100; i++) {
      lines.add(
        LineItem(
          'خط ${i.toString().padLeft(3, '0')}',
          'السمبوسة المحشية',
        ),
      );
      wrappers.add(WrapperWorker(i));
    }

    for (var i = 1; i <= 15; i++) {
      lines.add(
        LineItem(
          'رقائق ${i.toString().padLeft(2, '0')}',
          'رقائق السمبوسة',
        ),
      );
    }

    for (final c in categories.skip(2)) {
      for (var i = 1; i <= 5; i++) {
        lines.add(
          LineItem(
            '$c ${i.toString().padLeft(2, '0')}',
            c,
          ),
        );
      }
    }

    customers.addAll([
      CustomerItem('مندوب 1', 'مندوب'),
      CustomerItem('مندوب 2', 'مندوب'),
    ]);
  }

  void changed() => notifyListeners();

  void addLine(LineItem x) {
    lines.add(x);
    notifyListeners();
  }

  void addProduction(ProductionEntry x, LineItem line) {
    production.add(x);
    line.quantity += x.quantity;

    logs.add(
      OperationLog(
        'إنتاج',
        '${x.line} • ${x.product} • ${x.quantity} ${x.unit}',
        DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void addWrapperProduction(WrapperProduction x) {
    wrapperProduction.add(x);

    logs.add(
      OperationLog(
        'إنتاج لفاف',
        '${x.worker} • ${x.product} • ${x.qty.toStringAsFixed(0)} حبة',
        x.time,
      ),
    );

    notifyListeners();
  }

  void addDiscount(DiscountItem x) {
    discounts.add(x);

    logs.add(
      OperationLog(
        'خصم',
        '${x.worker} • ${x.amount.toStringAsFixed(2)} ريال • ${x.reason}',
        x.time,
      ),
    );

    notifyListeners();
  }
}

class GhawarApp extends StatefulWidget {
  const GhawarApp({super.key});

  @override
  State<GhawarApp> createState() => _GhawarAppState();
}

class _GhawarAppState extends State<GhawarApp> {
  final store = Store();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مصنع غوار',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff8d151b),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: LoginPage(store),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage(this.store, {super.key});

  final Store store;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController(text: 'admin');
  final pass = TextEditingController();

  bool hide = true;
  int failures = 0;
  String error = '';

  void login() {
    UserItem? found;

    for (final u in widget.store.users) {
      if (u.username == user.text.trim()) {
        found = u;
        break;
      }
    }

    if (found != null &&
        found.active &&
        found.password == pass.text) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Home(widget.store),
        ),
      );
    } else {
      setState(() {
        failures++;

        error = failures >= 5
            ? 'محاولات دخول خاطئة متعددة. راجع مدير البرنامج.'
            : 'اسم المستخدم أو كلمة المرور غير صحيحة';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xff8d151b),
                      child: Icon(
                        Icons.factory,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'غوار الأصلية',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'نظام إدارة مصنع المعجنات والحلويات',
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: user,
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pass,
                      obscureText: hide,
                      onSubmitted: (_) => login(),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => hide = !hide);
                          },
                          icon: Icon(
                            hide
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: login,
                        icon: const Icon(Icons.login),
                        label: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('تسجيل الدخول'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'للاختبار الأول فقط: admin / Ghawar@2026',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home(this.store, {super.key});

  final Store store;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Dashboard(widget.store),
      LinesPage(widget.store),
      WarehousesPage(widget.store),
      ProductsPage(widget.store),
      ManagementPage(widget.store),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8d151b),
        foregroundColor: Colors.white,
        title: const Text(
          'غوار الأصلية • إدارة المصنع',
        ),
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) {
          setState(() => tab = v);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing),
            label: 'الإنتاج',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse),
            label: 'المخزون',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2),
            label: 'الأصناف',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'الإدارة',
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard(this.s, {super.key});

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'لوحة إدارة المصنع',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Stat(
                  'خطوط الإنتاج',
                  '${s.lines.length}',
                  Icons.precision_manufacturing,
                ),
                Stat(
                  'المستودعات',
                  '${s.warehouses.length}',
                  Icons.warehouse,
                ),
                Stat(
                  'المستخدمون',
                  '${s.users.length}',
                  Icons.people,
                ),
                Stat(
                  'سجلات الإنتاج',
                  '${s.production.length}',
                  Icons.assignment,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'أقسام الإنتاج',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...s.categories.map(
              (x) => Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.factory),
                  ),
                  title: Text(
                    x,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${s.lines.where((e) => e.category == x).length} خط إنتاج',
                  ),
                  trailing: const Icon(
                    Icons.chevron_left,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryPage(s, x),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Stat extends StatelessWidget {
  const Stat(
    this.t,
    this.v,
    this.i, {
    super.key,
  });

  final String t;
  final String v;
  final IconData i;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(i),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  v,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(t),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  const CategoryPage(
    this.s,
    this.cat, {
    super.key,
  });

  final Store s;
  final String cat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat),
      ),
      body: AnimatedBuilder(
        animation: s,
        builder: (_, __) {
          return ListView(
            children: s.lines
                .where((x) => x.category == cat)
                .map(
                  (x) => ListTile(
                    title: Text(x.name),
                    subtitle: Text(
                      'المسؤول: ${x.manager} • الإنتاج: ${x.quantity.toStringAsFixed(0)} ${x.unit}',
                    ),
                    trailing: const Icon(
                      Icons.chevron_left,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LineDetails(s, x),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class LinesPage extends StatefulWidget {
  const LinesPage(this.s, {super.key});

  final Store s;

  @override
  State<LinesPage> createState() =>
      _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {
  String filter = 'الكل';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.s,
      builder: (_, __) {
        final list = filter == 'الكل'
            ? widget.s.lines
            : widget.s.lines
                .where(
                  (x) => x.category == filter,
                )
                .toList();

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'خطوط الإنتاج',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () =>
                      addLine(context),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة خط'),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: filter,
              decoration: const InputDecoration(
                labelText: 'القسم',
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: 'الكل',
                  child: Text('كل الأقسام'),
                ),
                ...widget.s.categories.map(
                  (x) => DropdownMenuItem<String>(
                    value: x,
                    child: Text(x),
                  ),
                ),
              ],
              onChanged: (v) {
                if (v != null) {
                  setState(() => filter = v);
                }
              },
            ),
            ...list.map(
              (x) => Card(
                child: ListTile(
                  title: Text(x.name),
                  subtitle: Text(
                    '${x.category} • ${x.manager}',
                  ),
                  trailing: const Icon(
                    Icons.chevron_left,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LineDetails(widget.s, x),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addLine(BuildContext context) {
    final n = TextEditingController();
    String cat = widget.s.categories.first;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'إضافة خط إنتاج',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: n,
                    decoration:
                        const InputDecoration(
                      labelText: 'اسم الخط',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: cat,
                    items: widget.s.categories
                        .map(
                          (x) =>
                              DropdownMenuItem<String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => cat = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'القسم',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('إلغاء'),
                ),
                FilledButton(
                  onPressed: () {
                    if (n.text
                        .trim()
                        .isNotEmpty) {
                      widget.s.addLine(
                        LineItem(
                          n.text.trim(),
                          cat,
                        ),
                      );
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class LineDetails extends StatelessWidget {
  const LineDetails(
    this.s,
    this.line, {
    super.key,
  });

  final Store s;
  final LineItem line;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(line.name),
      ),
      body: AnimatedBuilder(
        animation: s,
        builder: (_, __) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: Text(line.category),
                  subtitle: Text(
                    'الحالة: ${line.status}\n'
                    'المسؤول: ${line.manager}\n'
                    'إجمالي الإنتاج: '
                    '${line.quantity.toStringAsFixed(0)} '
                    '${line.unit}',
                  ),
                  isThreeLine: true,
                ),
              ),
              FilledButton.icon(
                onPressed: () =>
                    addProduction(context),
                icon: const Icon(
                  Icons.add_chart,
                ),
                label: const Text(
                  'إضافة كمية إنتاج',
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    editManager(context),
                icon: const Icon(Icons.person),
                label: const Text(
                  'تحديد مدير / مسؤول الخط',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'سجل إنتاج الخط',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...s.production
                  .where(
                    (e) => e.line == line.name,
                  )
                  .map(
                    (e) => Card(
                      child: ListTile(
                        title: Text(e.product),
                        subtitle: Text(
                          '${e.quantity.toStringAsFixed(0)} '
                          '${e.unit} • ${e.date}',
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  void addProduction(BuildContext context) {
    final q = TextEditingController();

    final choices = s.products
        .where(
          (p) => p.category == line.category,
        )
        .map((p) => p.name)
        .toList();

    if (choices.isEmpty) {
      choices.add('إنتاج عام');
    }

    String product = choices.first;
    String unit = line.unit;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'تسجيل كمية إنتاج',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: product,
                    items: choices
                        .map(
                          (x) =>
                              DropdownMenuItem<String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => product = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'الصنف',
                    ),
                  ),
                  TextField(
                    controller: q,
                    keyboardType:
                        TextInputType.number,
                    decoration:
                        const InputDecoration(
                      labelText: 'الكمية',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: unit,
                    items: [
                      'كرتون',
                      'كيس',
                      'حبة',
                      'كجم',
                    ]
                        .map(
                          (x) =>
                              DropdownMenuItem<String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => unit = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'الوحدة',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    final n =
                        double.tryParse(q.text);

                    if (n != null && n > 0) {
                      line.unit = unit;

                      final now =
                          DateTime.now();

                      s.addProduction(
                        ProductionEntry(
                          line.name,
                          product,
                          n,
                          unit,
                          '${now.year}/${now.month}/${now.day}',
                        ),
                        line,
                      );

                      Navigator.pop(
                        dialogContext,
                      );
                    }
                  },
                  child:
                      const Text('حفظ الكمية'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editManager(BuildContext context) {
    String manager = line.manager;

    final names = [
      'غير محدد',
      ...s.users
          .where((u) => u.active)
          .map((u) => u.name),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('مسؤول الخط'),
              content:
                  DropdownButtonFormField<String>(
                value: names.contains(manager)
                    ? manager
                    : 'غير محدد',
                items: names
                    .map(
                      (x) =>
                          DropdownMenuItem<String>(
                        value: x,
                        child: Text(x),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setDialogState(
                      () => manager = v,
                    );
                  }
                },
                decoration:
                    const InputDecoration(
                  labelText: 'اختر المسؤول',
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    line.manager = manager;
                    s.changed();

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class WarehousesPage extends StatelessWidget {
  const WarehousesPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text(
              'المستودعات والتحويل',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...s.warehouses.map(
              (w) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.warehouse,
                  ),
                  title: Text(w.name),
                  subtitle: Text(
                    'الرصيد العام: '
                    '${w.quantity.toStringAsFixed(0)}',
                  ),
                  trailing: PopupMenuButton<int>(
                    itemBuilder: (_) => const [
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          'إضافة كمية',
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text(
                          'تحويل لمستودع',
                        ),
                      ),
                    ],
                    onSelected: (v) {
                      if (v == 1) {
                        quantity(context, w);
                      } else {
                        transfer(context, w);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void quantity(
    BuildContext context,
    Warehouse w,
  ) {
    final q = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'إضافة كمية • ${w.name}',
          ),
          content: TextField(
            controller: q,
            keyboardType:
                TextInputType.number,
            decoration:
                const InputDecoration(
              labelText: 'الكمية',
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                final n =
                    double.tryParse(q.text);

                if (n != null) {
                  w.quantity += n;
                  s.changed();
                }

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void transfer(
    BuildContext context,
    Warehouse from,
  ) {
    final q = TextEditingController();

    Warehouse to = s.warehouses.firstWhere(
      (x) => x != from,
      orElse: () => from,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'تحويل بين المستودعات',
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  DropdownButtonFormField<
                      Warehouse>(
                    value: to,
                    items: s.warehouses
                        .where(
                          (x) => x != from,
                        )
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  Warehouse>(
                            value: x,
                            child:
                                Text(x.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => to = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'إلى',
                    ),
                  ),
                  TextField(
                    controller: q,
                    keyboardType:
                        TextInputType.number,
                    decoration:
                        const InputDecoration(
                      labelText: 'الكمية',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    final n =
                        double.tryParse(q.text);

                    if (n != null &&
                        n > 0 &&
                        from.quantity >= n) {
                      from.quantity -= n;
                      to.quantity += n;
                      s.changed();

                      Navigator.pop(
                        dialogContext,
                      );
                    }
                  },
                  child: const Text('تحويل'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'الأصناف',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () =>
                      add(context),
                  icon:
                      const Icon(Icons.add),
                  label:
                      const Text('إضافة'),
                ),
              ],
            ),
            ...s.products.map(
              (p) => Card(
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text(
                    '${p.category} • '
                    '${p.weight} • '
                    '${p.pack}',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void add(BuildContext context) {
    final n = TextEditingController();

    String cat = s.categories.first;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('إضافة صنف'),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  TextField(
                    controller: n,
                    decoration:
                        const InputDecoration(
                      labelText: 'اسم الصنف',
                    ),
                  ),
                  DropdownButtonFormField<
                      String>(
                    value: cat,
                    items: s.categories
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => cat = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'القسم',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    if (n.text
                        .trim()
                        .isNotEmpty) {
                      s.products.add(
                        Product(
                          n.text.trim(),
                          cat,
                          'يحدد لاحقاً',
                        ),
                      );

                      s.changed();
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ManagementPage
    extends StatelessWidget {
  const ManagementPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'الإدارة والإعدادات',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Tile(
          'اللفافون وإنتاج الغضارات',
          Icons.groups,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WrappersPage(s),
              ),
            );
          },
        ),
        Tile(
          'الخصومات وتقارير اللفافين',
          Icons.assessment,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WrapperReportsPage(s),
              ),
            );
          },
        ),
        Tile(
          'العملاء والمندوبون',
          Icons.storefront,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CustomersPage(s),
              ),
            );
          },
        ),
        Tile(
          'سجل العمليات',
          Icons.history,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LogsPage(s),
              ),
            );
          },
        ),
        Tile(
          'المستخدمون والصلاحيات',
          Icons.manage_accounts,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    UsersPage(s),
              ),
            );
          },
        ),
        Tile(
          'المواد الخام',
          Icons.grain,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RawMaterialsPage(s),
              ),
            );
          },
        ),
        Tile(
          'الموردون',
          Icons.local_shipping,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SuppliersPage(s),
              ),
            );
          },
        ),
        Tile(
          'الطابعات و Wi-Fi و Bluetooth',
          Icons.print,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PrintersPage(s),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(
    this.t,
    this.i,
    this.tap, {
    super.key,
  });

  final String t;
  final IconData i;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(i),
        title: Text(t),
        trailing:
            const Icon(Icons.chevron_left),
        onTap: tap,
      ),
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'المستخدمون والصلاحيات',
            ),
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(12),
            children: [
              FilledButton.icon(
                onPressed: () =>
                    add(context),
                icon: const Icon(
                  Icons.person_add,
                ),
                label: const Text(
                  'إضافة مستخدم / مدير',
                ),
              ),
              ...s.users.map(
                (u) => Card(
                  child: SwitchListTile(
                    value: u.active,
                    onChanged: (v) {
                      u.active = v;
                      s.changed();
                    },
                    title: Text(u.name),
                    subtitle: Text(
                      '${u.role}\n'
                      'الصلاحيات: '
                      '${u.permissions.isEmpty ? 'لم تحدد' : u.permissions.join('، ')}',
                    ),
                    secondary: const Icon(
                      Icons.manage_accounts,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void add(BuildContext context) {
    final n = TextEditingController();
    final un = TextEditingController();
    final pw = TextEditingController();

    String role = 'مسؤول';

    final roles = [
      'مدير رئيسي',
      'مدير تصنيع',
      'مدير قسم',
      'مسؤول مستودع',
      'مسؤول عمال',
      'مندوب',
      'مسؤول',
    ];

    final all = [
      'الإنتاج',
      'المستودعات',
      'الأصناف',
      'المستخدمون',
      'الموردون',
      'الطابعات',
    ];

    final selected = <String>[];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'إضافة مستخدم / مدير',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller: n,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'الاسم الكامل',
                      ),
                    ),
                    TextField(
                      controller: un,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'اسم الدخول',
                      ),
                    ),
                    TextField(
                      controller: pw,
                      obscureText: true,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'كلمة المرور',
                      ),
                    ),
                    DropdownButtonFormField<
                        String>(
                      value: role,
                      items: roles
                          .map(
                            (x) =>
                                DropdownMenuItem<
                                    String>(
                              value: x,
                              child: Text(x),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(
                            () => role = v,
                          );
                        }
                      },
                      decoration:
                          const InputDecoration(
                        labelText: 'الدور',
                      ),
                    ),
                    ...all.map(
                      (p) =>
                          CheckboxListTile(
                        value:
                            selected.contains(p),
                        title: Text(p),
                        onChanged: (v) {
                          setDialogState(() {
                            if (v == true) {
                              if (!selected
                                  .contains(p)) {
                                selected.add(p);
                              }
                            } else {
                              selected.remove(p);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    if (n.text
                        .trim()
                        .isNotEmpty) {
                      s.users.add(
                        UserItem(
                          n.text.trim(),
                          role,
                          username:
                              un.text.trim(),
                          password: pw.text,
                          permissions:
                              List.of(selected),
                        ),
                      );

                      s.changed();
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class RawMaterialsPage
    extends StatelessWidget {
  const RawMaterialsPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title:
                const Text('المواد الخام'),
          ),
          floatingActionButton:
              FloatingActionButton(
            onPressed: () =>
                add(context),
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: s.rawMaterials
                .map(
                  (x) => ListTile(
                    title: Text(x.name),
                    subtitle: Text(
                      '${x.quantity} ${x.unit}',
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void add(BuildContext context) {
    final n = TextEditingController();
    final q = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('إضافة مادة خام'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: n,
                decoration:
                    const InputDecoration(
                  labelText: 'المادة',
                ),
              ),
              TextField(
                controller: q,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'الكمية',
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                final v =
                    double.tryParse(q.text) ??
                        0;

                if (n.text.isNotEmpty) {
                  s.rawMaterials.add(
                    RawMaterial(
                      n.text,
                      v,
                      'كجم',
                    ),
                  );

                  s.changed();
                }

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

class SuppliersPage
    extends StatelessWidget {
  const SuppliersPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('الموردون'),
          ),
          floatingActionButton:
              FloatingActionButton(
            onPressed: () =>
                add(context),
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: s.suppliers
                .map(
                  (x) => ListTile(
                    title: Text(x.name),
                    subtitle:
                        Text(x.phone),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void add(BuildContext context) {
    final n = TextEditingController();
    final p = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('إضافة مورد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: n,
                decoration:
                    const InputDecoration(
                  labelText:
                      'اسم المورد',
                ),
              ),
              TextField(
                controller: p,
                decoration:
                    const InputDecoration(
                  labelText:
                      'رقم التواصل',
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                if (n.text.isNotEmpty) {
                  s.suppliers.add(
                    Supplier(
                      n.text,
                      p.text,
                    ),
                  );

                  s.changed();
                }

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

class PrintersPage
    extends StatelessWidget {
  const PrintersPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'الطابعات والاتصال',
            ),
          ),
          floatingActionButton:
              FloatingActionButton.extended(
            onPressed: () =>
                add(context),
            icon: const Icon(Icons.add),
            label:
                const Text('إضافة طابعة'),
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(12),
            children: [
              const Card(
                child: ListTile(
                  leading:
                      Icon(Icons.info_outline),
                  title:
                      Text('إعدادات الاتصال'),
                  subtitle: Text(
                    'يمكن تسجيل طابعة Bluetooth '
                    'أو طابعة Wi-Fi / شبكة. '
                    'الاتصال والطباعة الفعلية '
                    'تتطلب حزمة متوافقة مع موديل '
                    'الطابعة وصلاحيات Android.',
                  ),
                ),
              ),
              ...s.printers.map(
                (p) => Card(
                  child: SwitchListTile(
                    value: p.connected,
                    onChanged: (v) {
                      p.connected = v;
                      s.changed();
                    },
                    secondary: Icon(
                      p.type == 'Bluetooth'
                          ? Icons.bluetooth
                          : Icons.wifi,
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      '${p.type} • '
                      '${p.address.isEmpty ? 'بدون عنوان' : p.address}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void add(BuildContext context) {
    final n = TextEditingController();
    final a = TextEditingController();

    String type = 'Wi-Fi';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('إضافة طابعة'),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  TextField(
                    controller: n,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'اسم الطابعة',
                    ),
                  ),
                  DropdownButtonFormField<
                      String>(
                    value: type,
                    items: [
                      'Wi-Fi',
                      'Bluetooth',
                    ]
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => type = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText:
                          'نوع الاتصال',
                    ),
                  ),
                  TextField(
                    controller: a,
                    decoration:
                        InputDecoration(
                      labelText:
                          type == 'Wi-Fi'
                              ? 'IP / عنوان الشبكة'
                              : 'اسم أو عنوان Bluetooth',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    if (n.text.isNotEmpty) {
                      s.printers.add(
                        PrinterItem(
                          n.text,
                          type,
                          address: a.text,
                        ),
                      );

                      s.changed();
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class WrappersPage
    extends StatelessWidget {
  const WrappersPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'اللفافون وإنتاج الغضارات',
            ),
          ),
          floatingActionButton:
              FloatingActionButton.extended(
            onPressed: () =>
                addProduction(context),
            icon: const Icon(Icons.add),
            label:
                const Text('إدخال إنتاج'),
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(12),
            children: [
              Card(
                child: ListTile(
                  title:
                      const Text('إعداد الأجر'),
                  subtitle: Text(
                    '${s.wagePer1000.toStringAsFixed(0)} '
                    'ريال لكل 1000 حبة • '
                    'التوقف بعد '
                    '${s.stopMinutes} دقيقة',
                  ),
                ),
              ),
              ...s.wrappers.map(
                (w) {
                  final total = s
                      .wrapperProduction
                      .where(
                        (x) =>
                            x.worker ==
                                w.name &&
                            w.name.isNotEmpty,
                      )
                      .fold<double>(
                        0,
                        (a, b) =>
                            a + b.qty,
                      );

                  return Card(
                    child: SwitchListTile(
                      value: w.active,
                      onChanged: (v) {
                        w.active = v;
                        s.changed();
                      },
                      title: Text(
                        w.name.isEmpty
                            ? 'لفاف رقم ${w.id}'
                            : w.name,
                      ),
                      subtitle: Text(
                        'الإنتاج المسجل: '
                        '${total.toStringAsFixed(0)} حبة',
                      ),
                      secondary:
                          CircleAvatar(
                        child:
                            Text('${w.id}'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void addProduction(BuildContext context) {
    final named = s.wrappers
        .where(
          (w) =>
              w.name.isNotEmpty &&
              w.active,
        )
        .toList();

    if (named.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'أضف أسماء اللفافين أولاً.',
          ),
        ),
      );
      return;
    }

    WrapperWorker worker = named.first;
    String product = 'لحم';

    final q = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'إدخال إنتاج لفاف',
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  DropdownButtonFormField<
                      WrapperWorker>(
                    value: worker,
                    items: named
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  WrapperWorker>(
                            value: x,
                            child:
                                Text(x.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => worker = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'اللفاف',
                    ),
                  ),
                  DropdownButtonFormField<
                      String>(
                    value: product,
                    items: [
                      'لحم',
                      'دجاج',
                      'جبن أبيض فيتا',
                    ]
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => product = v,
                        );
                      }
                    },
                    decoration:
                        const InputDecoration(
                      labelText: 'الصنف',
                    ),
                  ),
                  TextField(
                    controller: q,
                    keyboardType:
                        TextInputType.number,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'الكمية بالحبة',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    final n =
                        double.tryParse(q.text) ??
                            0;

                    if (n > 0) {
                      s.addWrapperProduction(
                        WrapperProduction(
                          worker.name,
                          product,
                          n,
                          DateTime.now(),
                        ),
                      );
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class WrapperReportsPage
    extends StatelessWidget {
  const WrapperReportsPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'تقارير اللفافين والخصومات',
            ),
          ),
          floatingActionButton:
              FloatingActionButton.extended(
            onPressed: () =>
                discount(context),
            icon: const Icon(
              Icons.remove_circle,
            ),
            label:
                const Text('إضافة خصم'),
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(12),
            children: [
              const Text(
                'ملخص من بداية العمل',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              ...s.wrappers
                  .where(
                    (w) =>
                        w.name.isNotEmpty,
                  )
                  .map(
                    (w) {
                      final qty = s
                          .wrapperProduction
                          .where(
                            (x) =>
                                x.worker ==
                                w.name,
                          )
                          .fold<double>(
                            0,
                            (a, b) =>
                                a + b.qty,
                          );

                      final wage =
                          qty /
                              1000 *
                              s.wagePer1000;

                      final disc = s
                          .discounts
                          .where(
                            (x) =>
                                x.worker ==
                                w.name,
                          )
                          .fold<double>(
                            0,
                            (a, b) =>
                                a + b.amount,
                          );

                      final net =
                          (wage - disc)
                              .clamp(
                                0,
                                double.infinity,
                              );

                      return Card(
                        child: ListTile(
                          title:
                              Text(w.name),
                          subtitle: Text(
                            'الإنتاج: '
                            '${qty.toStringAsFixed(0)} حبة • '
                            'الأجر: '
                            '${wage.toStringAsFixed(2)} ر.س\n'
                            'الخصم: '
                            '${disc.toStringAsFixed(2)} • '
                            'الصافي: '
                            '${net.toStringAsFixed(2)} ر.س',
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }

  void discount(BuildContext context) {
    final named = s.wrappers
        .where(
          (w) => w.name.isNotEmpty,
        )
        .toList();

    if (named.isEmpty) {
      return;
    }

    WrapperWorker w = named.first;

    String reason =
        'يستخدم رقائق متعددة';

    final amount =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('إضافة خصم'),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  DropdownButtonFormField<
                      WrapperWorker>(
                    value: w,
                    items: named
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  WrapperWorker>(
                            value: x,
                            child:
                                Text(x.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => w = v,
                        );
                      }
                    },
                  ),
                  DropdownButtonFormField<
                      String>(
                    value: reason,
                    items: [
                      'يستخدم رقائق متعددة',
                      'عدم قفل السمبوسة جيدا',
                      'استخدام قلوب الرقائق فقط',
                    ]
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => reason = v,
                        );
                      }
                    },
                  ),
                  TextField(
                    controller: amount,
                    keyboardType:
                        TextInputType.number,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'مبلغ الخصم',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    final a =
                        double.tryParse(
                              amount.text,
                            ) ??
                            0;

                    if (a > 0) {
                      s.addDiscount(
                        DiscountItem(
                          w.name,
                          a,
                          reason,
                          DateTime.now(),
                        ),
                      );
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CustomersPage
    extends StatelessWidget {
  const CustomersPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'العملاء والمندوبون',
            ),
          ),
          floatingActionButton:
              FloatingActionButton(
            onPressed: () =>
                add(context),
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: s.customers
                .map(
                  (x) =>
                      SwitchListTile(
                    value: x.active,
                    onChanged: (v) {
                      x.active = v;
                      s.changed();
                    },
                    title: Text(x.name),
                    subtitle: Text(
                      '${x.type} • '
                      '${x.location.isEmpty ? 'الموقع غير محدد' : x.location}',
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void add(BuildContext context) {
    final n = TextEditingController();
    final loc =
        TextEditingController();

    String type = 'عميل';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'إضافة عميل / مندوب',
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  TextField(
                    controller: n,
                    decoration:
                        const InputDecoration(
                      labelText: 'الاسم',
                    ),
                  ),
                  DropdownButtonFormField<
                      String>(
                    value: type,
                    items: [
                      'عميل',
                      'مندوب',
                    ]
                        .map(
                          (x) =>
                              DropdownMenuItem<
                                  String>(
                            value: x,
                            child: Text(x),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(
                          () => type = v,
                        );
                      }
                    },
                  ),
                  TextField(
                    controller: loc,
                    decoration:
                        const InputDecoration(
                      labelText: 'الموقع',
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    if (n.text
                        .trim()
                        .isNotEmpty) {
                      s.customers.add(
                        CustomerItem(
                          n.text.trim(),
                          type,
                          location:
                              loc.text.trim(),
                        ),
                      );

                      s.changed();
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class LogsPage extends StatelessWidget {
  const LogsPage(
    this.s, {
    super.key,
  });

  final Store s;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: s,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title:
                const Text('سجل العمليات'),
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(12),
            children: s.logs.reversed
                .map(
                  (x) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.history,
                      ),
                      title:
                          Text(x.action),
                      subtitle: Text(
                        '${x.details}\n${x.time}',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
