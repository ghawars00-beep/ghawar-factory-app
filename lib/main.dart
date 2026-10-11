import 'package:flutter/material.dart';

void main() {
  runApp(const GhawarApp());
}

class GhawarApp extends StatelessWidget {
  const GhawarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مصنع الغوار',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB71C1C)),
        scaffoldBackgroundColor: const Color(0xFFF7F4EE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class AppUser {
  AppUser({
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    this.active = true,
  });

  String name;
  String username;
  String password;
  String role;
  bool active;
}

class ProductionSection {
  ProductionSection({
    required this.name,
    required this.lines,
    required this.icon,
  });

  String name;
  int lines;
  IconData icon;
}

class Warehouse {
  Warehouse(this.name, this.stock);
  String name;
  int stock;
}

class ProductItem {
  ProductItem(this.name, this.packaging);
  String name;
  String packaging;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController(text: 'admin');
  final passwordController = TextEditingController(text: 'Ghawar@2026');
  int failedAttempts = 0;
  bool obscure = true;
  String? error;

  void login() {
    final user = usernameController.text.trim();
    final pass = passwordController.text;
    if (user == 'admin' && pass == 'Ghawar@2026') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }
    setState(() {
      failedAttempts++;
      error = failedAttempts >= 5
          ? 'تم إيقاف المحاولة مؤقتًا. راجع مدير النظام.'
          : 'اسم المستخدم أو كلمة المرور غير صحيحة.';
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB71C1C),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.factory,
                            size: 50,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'غوار الأصلية',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000),
                          ),
                        ),
                        const Text('نظام إدارة المصنع'),
                        const SizedBox(height: 24),
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'اسم المستخدم',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: passwordController,
                          obscureText: obscure,
                          onSubmitted: (_) => login(),
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => obscure = !obscure),
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: failedAttempts >= 5 ? null : login,
                            icon: const Icon(Icons.login),
                            label: const Padding(
                              padding: EdgeInsets.all(13),
                              child: Text('دخول المدير'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'نسخة تجريبية محلية - صلاحيات المدير كاملة',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final sections = <ProductionSection>[
    ProductionSection(
      name: 'السمبوسة المحشية',
      lines: 100,
      icon: Icons.restaurant_menu,
    ),
    ProductionSection(
      name: 'رقائق السمبوسة',
      lines: 15,
      icon: Icons.layers,
    ),
    ProductionSection(name: 'الكنافة', lines: 5, icon: Icons.cake),
    ProductionSection(
      name: 'خبز المرقوق',
      lines: 5,
      icon: Icons.bakery_dining,
    ),
    ProductionSection(name: 'القرصان', lines: 5, icon: Icons.flatware),
    ProductionSection(name: 'اللحوح', lines: 5, icon: Icons.breakfast_dining),
  ];

  final warehouses = <Warehouse>[
    Warehouse('الثلاجة المركزية', 1250),
    Warehouse('ثلاجة المصنع', 820),
    Warehouse('المستودع الخارجي', 640),
    Warehouse('مستودع المعمل', 390),
  ];

  final products = <ProductItem>[
    ProductItem('سمبوسة محشية بالجبن السائل', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('سمبوسة محشية باللحم', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('سمبوسة محشية بالدجاج', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('سمبوسة محشية بالجبن الأبيض فيتا', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('سمبوسة محشية بالجبن الشدر', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('سمبوسة محشية باللحم (حراق)', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('سمبوسة محشية بالدجاج (حراق)', '100 حبة بالكيس - 5 أكياس بالكرتون'),
    ProductItem('رقائق سمبوسة غوار مقرمش 800 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق سمبوسة غوار بر 800 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق سمبوسة غوار فاخرة 800 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق سمبوسة غوار فاخرة ميني 800 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق غوار مدور 400 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق غوار مثلث 400 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق غوار مطبق 800 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق سمبوسة ريفي 500 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق سمبوسة ميتاف 500 جرام', '20 كيس بالكرتون'),
    ProductItem('رقائق سمبوسة سابوسا 800 جرام', '20 كيس بالكرتون'),
  ];

  final users = <AppUser>[
    AppUser(
      name: 'مدير البرنامج الرئيسي',
      username: 'admin',
      password: 'Ghawar@2026',
      role: 'مدير رئيسي - جميع الصلاحيات',
    ),
    AppUser(
      name: 'مسؤول السمبوسة المحشية',
      username: 'stuffed.manager',
      password: '123456',
      role: 'إنتاج',
    ),
    AppUser(
      name: 'مسؤول رقائق السمبوسة',
      username: 'sheets.manager',
      password: '123456',
      role: 'إنتاج',
    ),
    AppUser(
      name: 'مسؤول المستودع المركزي',
      username: 'warehouse.manager',
      password: '123456',
      role: 'مستودعات',
    ),
  ];

  void snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      dashboard(),
      production(),
      warehousesPage(),
      management(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('غوار الأصلية - إدارة المصنع'),
          actions: [
            IconButton(
              tooltip: 'تسجيل الخروج',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: pages[pageIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: pageIndex,
          onDestinationSelected: (value) => setState(() => pageIndex = value),
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
              label: 'المستودعات',
            ),
            NavigationDestination(
              icon: Icon(Icons.admin_panel_settings),
              label: 'الإدارة',
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'لوحة التحكم',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            statCard('أقسام الإنتاج', '${sections.length}', Icons.factory),
            statCard('خطوط الإنتاج', '135', Icons.precision_manufacturing),
            statCard('المستودعات', '${warehouses.length}', Icons.warehouse),
            statCard('الأصناف', '${products.length}', Icons.inventory_2),
            statCard('المستخدمون', '${users.length}', Icons.people),
            statCard('نقاط البيع', '10', Icons.point_of_sale),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'تنبيهات الإدارة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            leading: Icon(Icons.security, color: Colors.green),
            title: Text('نظام الدخول والصلاحيات مفعل'),
            subtitle: Text('المدير الرئيسي يملك جميع الصلاحيات.'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info, color: Colors.orange),
            title: Text('الطابعة والبلوتوث والواي فاي'),
            subtitle: Text(
              'واجهات الإعداد جاهزة. الربط الفعلي يضاف بعد اعتماد نوع الأجهزة.',
            ),
          ),
        ),
      ],
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 34, color: const Color(0xFFB71C1C)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget production() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'أقسام وخطوط الإنتاج',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...sections.map(
          (section) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFFE7A3),
                child: Icon(section.icon, color: const Color(0xFF8B0000)),
              ),
              title: Text(
                section.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${section.lines} خط إنتاج'),
              trailing: const Icon(Icons.arrow_back_ios_new),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LinesPage(section: section),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget warehousesPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'المستودعات',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: () => snack('إضافة مستودع جديد متاحة للمدير.'),
              icon: const Icon(Icons.add),
              label: const Text('إضافة'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...warehouses.map(
          (warehouse) => Card(
            child: ListTile(
              leading: const Icon(
                Icons.warehouse,
                color: Color(0xFFB71C1C),
                size: 34,
              ),
              title: Text(warehouse.name),
              subtitle: Text('الرصيد التجريبي: ${warehouse.stock} وحدة'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) => snack('$value - ${warehouse.name}'),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'عرض المخزون', child: Text('عرض المخزون')),
                  PopupMenuItem(value: 'تحويل مخزون', child: Text('تحويل مخزون')),
                  PopupMenuItem(value: 'تعديل', child: Text('تعديل')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget management() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'الإدارة والإعدادات',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        adminTile(
          'المستخدمون والصلاحيات',
          'إنشاء المستخدمين، إيقاف الحساب، تحديد الدور والصلاحيات',
          Icons.manage_accounts,
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UsersPage(users: users),
            ),
          ),
        ),
        adminTile(
          'المنتجات والتعبئة',
          'إدارة الأصناف والأوزان والتعبئة',
          Icons.inventory_2,
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductsPage(products: products),
            ),
          ),
        ),
        adminTile(
          'المواد الخام والموردون',
          'إدارة المواد الخام والموردين وحالة التوريد',
          Icons.local_shipping,
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RawMaterialsPage()),
          ),
        ),
        adminTile(
          'الأمن وسجل الدخول',
          'محاولات الدخول، فتح الحسابات، مراجعة النشاط',
          Icons.security,
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SecurityPage()),
          ),
        ),
        adminTile(
          'الطابعة والاتصال',
          'إعدادات الطابعة والبلوتوث والواي فاي',
          Icons.print,
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ConnectivityPage()),
          ),
        ),
        adminTile(
          'نقاط البيع والمندوبون',
          '10 نقاط بيع قابلة للزيادة مع مخزون مستقل لكل مندوب',
          Icons.point_of_sale,
          () => snack('قسم نقاط البيع جاهز للإضافة في المرحلة التالية.'),
        ),
        adminTile(
          'المشاركة وواتساب',
          'إعداد مشاركة التقارير والفواتير',
          Icons.share,
          () => snack('الربط الفعلي بواتساب يضاف بعد اعتماد طريقة المشاركة.'),
        ),
      ],
    );
  }

  Widget adminTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB71C1C), size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_back_ios_new),
        onTap: onTap,
      ),
    );
  }
}

class LinesPage extends StatefulWidget {
  const LinesPage({super.key, required this.section});

  final ProductionSection section;

  @override
  State<LinesPage> createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {
  final statuses = ['يعمل', 'تجهيز', 'متوقف', 'صيانة'];

  Color statusColor(String status) {
    switch (status) {
      case 'يعمل':
        return Colors.green;
      case 'تجهيز':
        return Colors.orange;
      case 'صيانة':
        return Colors.blueGrey;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.section.name)),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: widget.section.lines,
          itemBuilder: (context, index) {
            final status = statuses[index % statuses.length];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor(status),
                  foregroundColor: Colors.white,
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  'خط إنتاج ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('الحالة: $status • المسؤول: غير محدد'),
                trailing: const Icon(Icons.arrow_back_ios_new),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LineDetailsPage(
                        sectionName: widget.section.name,
                        lineNumber: index + 1,
                        initialStatus: status,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class LineDetailsPage extends StatefulWidget {
  const LineDetailsPage({
    super.key,
    required this.sectionName,
    required this.lineNumber,
    required this.initialStatus,
  });

  final String sectionName;
  final int lineNumber;
  final String initialStatus;

  @override
  State<LineDetailsPage> createState() => _LineDetailsPageState();
}

class _LineDetailsPageState extends State<LineDetailsPage> {
  late String status;
  final managerController = TextEditingController();
  final quantityController = TextEditingController(text: '0');
  final recipeController = TextEditingController();
  final notesController = TextEditingController();
  int selectedColor = 0;

  final palette = const [
    Color(0xFFB71C1C),
    Color(0xFFD4AF37),
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.deepPurple,
  ];

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
  }

  @override
  void dispose() {
    managerController.dispose();
    quantityController.dispose();
    recipeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ بيانات الخط داخل النسخة التجريبية.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('خط إنتاج ${widget.lineNumber}')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: palette[selectedColor].withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: palette[selectedColor], width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.precision_manufacturing,
                    size: 65,
                    color: palette[selectedColor],
                  ),
                  Text(
                    widget.sectionName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: status,
              decoration: const InputDecoration(
                labelText: 'حالة الخط',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'يعمل', child: Text('يعمل')),
                DropdownMenuItem(value: 'تجهيز', child: Text('تجهيز')),
                DropdownMenuItem(value: 'متوقف', child: Text('متوقف')),
                DropdownMenuItem(value: 'صيانة', child: Text('صيانة')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => status = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: managerController,
              decoration: const InputDecoration(
                labelText: 'المسؤول عن الخط',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'كمية الإنتاج',
                suffixText: 'وحدة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: recipeController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'المقادير / الوصفة / الأوزان',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'لون الخط',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: List.generate(
                palette.length,
                (index) => InkWell(
                  onTap: () => setState(() => selectedColor = index),
                  child: CircleAvatar(
                    backgroundColor: palette[index],
                    child: selectedColor == index
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'إضافة صورة فعلية للخط ستربط بعد اعتماد مكتبة الصور.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_a_photo),
              label: const Text('صورة خط الإنتاج'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('حفظ بيانات الخط'),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key, required this.users});

  final List<AppUser> users;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  void addUser() {
    final name = TextEditingController();
    final username = TextEditingController();
    final password = TextEditingController();
    final role = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إضافة مستخدم'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'الاسم'),
                ),
                TextField(
                  controller: username,
                  decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                ),
                TextField(
                  controller: password,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                ),
                TextField(
                  controller: role,
                  decoration: const InputDecoration(labelText: 'الدور'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty ||
                    username.text.trim().isEmpty ||
                    password.text.isEmpty) {
                  return;
                }
                setState(() {
                  widget.users.add(
                    AppUser(
                      name: name.text.trim(),
                      username: username.text.trim(),
                      password: password.text,
                      role: role.text.trim().isEmpty
                          ? 'صلاحيات محدودة'
                          : role.text.trim(),
                    ),
                  );
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المستخدمون والصلاحيات')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: addUser,
          icon: const Icon(Icons.person_add),
          label: const Text('مستخدم'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: widget.users.length,
          itemBuilder: (context, index) {
            final user = widget.users[index];
            return Card(
              child: SwitchListTile(
                value: user.active,
                onChanged: index == 0
                    ? null
                    : (value) => setState(() => user.active = value),
                secondary: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(user.name),
                subtitle: Text('${user.username}\n${user.role}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.products});

  final List<ProductItem> products;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  void addProduct() {
    setState(() {
      widget.products.add(
        ProductItem('صنف جديد ${widget.products.length + 1}', 'تعبئة قابلة للتعديل'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المنتجات والتعبئة')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: addProduct,
          icon: const Icon(Icons.add),
          label: const Text('إضافة صنف'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final item = widget.products[index];
            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.inventory_2,
                  color: Color(0xFFB71C1C),
                ),
                title: Text(item.name),
                subtitle: Text(item.packaging),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تعديل: ${item.name}')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class RawMaterialsPage extends StatelessWidget {
  const RawMaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const materials = [
      'دقيق',
      'زيت',
      'ملح',
      'جبن',
      'لحم',
      'دجاج',
      'مواد تغليف',
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المواد الخام والموردون')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ...materials.map(
              (item) => Card(
                child: ListTile(
                  leading: const Icon(Icons.grain),
                  title: Text(item),
                  subtitle: const Text('المخزون والمورد قابلان للتعديل'),
                ),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text('الموردون'),
                subtitle: Text('إضافة الموردين وأرقام التواصل وحالة التوريد'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    const events = [
      'نجاح دخول المدير الرئيسي',
      'تسجيل خروج آمن',
      'مراقبة محاولات الدخول الفاشلة',
      'إمكانية تعطيل حسابات المسؤولين',
      'صلاحيات الأقسام حسب المستخدم',
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأمن وسجل الدخول')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.verified_user, color: Colors.green),
                title: Text('حماية الدخول'),
                subtitle: Text(
                  'هذه حماية على مستوى التطبيق. حماية الخادم والتشفير والنسخ الاحتياطي تضاف عند ربط السحابة.',
                ),
              ),
            ),
            ...events.map(
              (event) => Card(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(event),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({super.key});

  @override
  State<ConnectivityPage> createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  bool wifi = true;
  bool bluetooth = false;
  bool printer = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الطابعة والاتصال')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            SwitchListTile(
              value: wifi,
              onChanged: (value) => setState(() => wifi = value),
              secondary: const Icon(Icons.wifi),
              title: const Text('واي فاي'),
              subtitle: const Text('إعداد واجهة الاتصال بالشبكة'),
            ),
            SwitchListTile(
              value: bluetooth,
              onChanged: (value) => setState(() => bluetooth = value),
              secondary: const Icon(Icons.bluetooth),
              title: const Text('بلوتوث'),
              subtitle: const Text('إعداد واجهة أجهزة البلوتوث'),
            ),
            SwitchListTile(
              value: printer,
              onChanged: (value) => setState(() => printer = value),
              secondary: const Icon(Icons.print),
              title: const Text('الطابعة'),
              subtitle: const Text('تفعيل إعداد الطابعة التجريبي'),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('ملاحظة'),
                subtitle: Text(
                  'الربط الفعلي بالطابعة والبلوتوث يحتاج تعريف نوع الطابعة وبروتوكولها قبل إضافة مكتبة الجهاز.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
