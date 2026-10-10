import 'package:flutter/material.dart';

void main() {
  runApp(const GhawarFactoryApp());
}

class GhawarFactoryApp extends StatelessWidget {
  const GhawarFactoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'غوار الأصلية',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> productionLines = [
    'السمبوسة المحشية',
    'رقائق السمبوسة',
    'الكنافة',
    'خبز المرقوق',
    'القرصان',
    'اللحوح',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00695C),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'مصنع غوار الأصلية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Icon(
                          Icons.factory,
                          size: 55,
                          color: Color(0xFF00695C),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'نظام إدارة مصنع غوار الأصلية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'إدارة ومتابعة خطوط الإنتاج',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'خطوط الإنتاج',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: productionLines.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFF00695C),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            productionLines[index],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text(
                            'اضغط لعرض تفاصيل خط الإنتاج',
                          ),
                          trailing:
                              const Icon(Icons.arrow_back_ios_new),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductionPage(
                                  name: productionLines[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductionPage extends StatelessWidget {
  final String name;

  const ProductionPage({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00695C),
          foregroundColor: Colors.white,
          title: Text(name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _item(
                Icons.play_circle_outline,
                'حالة خط الإنتاج',
                'جاهز للإنتاج',
              ),
              _item(
                Icons.inventory_2_outlined,
                'المواد الخام',
                'إدارة المواد المستخدمة',
              ),
              _item(
                Icons.precision_manufacturing,
                'الإنتاج اليومي',
                'تسجيل كميات الإنتاج',
              ),
              _item(
                Icons.people_outline,
                'العمال',
                'متابعة فريق خط الإنتاج',
              ),
              _item(
                Icons.warehouse_outlined,
                'المستودع',
                'متابعة المخزون',
              ),
              _item(
                Icons.assessment_outlined,
                'التقارير',
                'عرض تقارير الإنتاج',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
          color: const Color(0xFF00695C),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
