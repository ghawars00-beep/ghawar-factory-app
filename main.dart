import 'package:flutter/material.dart';

void main() => runApp(const GhawarApp());

class Product {
  Product(this.name, this.category, this.pack, {this.weight = ''});
  String name, category, pack, weight;
}
class LineItem {
  LineItem(this.name, this.category, {this.status='جاهز'});
  String name, category, status;
}
class Warehouse { Warehouse(this.name); String name; }

class Store extends ChangeNotifier {
  final categories = <String>['السمبوسة المحشية','رقائق السمبوسة','الكنافة','خبز المرقوق','القرصان','اللحوح'];
  final products = <Product>[
    Product('سمبوسة محشية بالجبن السائل','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('سمبوسة محشية باللحم','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('سمبوسة محشية بالدجاج','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('سمبوسة محشية بالجبن الأبيض فيتا','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('سمبوسة محشية بالجبن الشدر','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('سمبوسة محشية باللحم (حراق)','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('سمبوسة محشية بالدجاج (حراق)','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون'),
    Product('رقائق سمبوسة غوار مقرمش','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة غوار بر','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة غوار فاخرة','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة غوار فاخرة ميني','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق غوار مدور','رقائق السمبوسة','20 كيس/كرتون',weight:'400 جم'),
    Product('رقائق غوار مثلث','رقائق السمبوسة','20 كيس/كرتون',weight:'400 جم'),
    Product('رقائق غوار مطبق','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة ريفي','رقائق السمبوسة','20 كيس/كرتون',weight:'500 جم'),
    Product('رقائق سمبوسة ميتاف','رقائق السمبوسة','20 كيس/كرتون',weight:'500 جم'),
    Product('رقائق سمبوسة سابوسا','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة سابوسا ميني','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة سابوسا فاخر','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
    Product('رقائق سمبوسة سابوسا مطبق','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جم'),
  ];
  final warehouses = List.generate(4, (i)=>Warehouse('المستودع ${i+1}'));
  final lines = <LineItem>[];
  Store(){ for(var i=1;i<=100;i++) lines.add(LineItem('خط ${i.toString().padLeft(3,'0')}', categories[(i-1)%categories.length])); }
  void addProduct(Product p){products.add(p);notifyListeners();}
  void addLine(LineItem l){lines.add(l);notifyListeners();}
  void addWarehouse(String n){warehouses.add(Warehouse(n));notifyListeners();}
}

class GhawarApp extends StatefulWidget { const GhawarApp({super.key}); @override State<GhawarApp> createState()=>_GhawarAppState(); }
class _GhawarAppState extends State<GhawarApp>{ final store=Store();
 @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'غوار الأصلية',locale:const Locale('ar'),theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xff8d151b)),scaffoldBackgroundColor:const Color(0xfff7f3ec)),home:Directionality(textDirection:TextDirection.rtl,child:Home(store:store)));
}

class Home extends StatefulWidget { const Home({super.key,required this.store}); final Store store; @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home>{int tab=0; final titles=['الرئيسية','خطوط الإنتاج','المستودعات','الأصناف','الوصفات'];
 @override Widget build(BuildContext context){final wide=MediaQuery.sizeOf(context).width>850; final pages=[Dashboard(widget.store),LinesPage(widget.store),WarehousesPage(widget.store),ProductsPage(widget.store),const RecipesPage()]; return Scaffold(appBar:AppBar(backgroundColor:const Color(0xff8d151b),foregroundColor:Colors.white,title:Text('غوار الأصلية • ${titles[tab]}',style:const TextStyle(fontWeight:FontWeight.bold))),body:Row(children:[if(wide) NavigationRail(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),labelType:NavigationRailLabelType.all,destinations:const [NavigationRailDestination(icon:Icon(Icons.dashboard),label:Text('الرئيسية')),NavigationRailDestination(icon:Icon(Icons.precision_manufacturing),label:Text('الإنتاج')),NavigationRailDestination(icon:Icon(Icons.warehouse),label:Text('المستودعات')),NavigationRailDestination(icon:Icon(Icons.inventory_2),label:Text('الأصناف')),NavigationRailDestination(icon:Icon(Icons.menu_book),label:Text('الوصفات'))]),Expanded(child:pages[tab])]),bottomNavigationBar:wide?null:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [NavigationDestination(icon:Icon(Icons.dashboard),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.precision_manufacturing),label:'الإنتاج'),NavigationDestination(icon:Icon(Icons.warehouse),label:'المخزون'),NavigationDestination(icon:Icon(Icons.inventory_2),label:'الأصناف'),NavigationDestination(icon:Icon(Icons.menu_book),label:'الوصفات')]));}}

class Dashboard extends StatelessWidget {const Dashboard(this.s,{super.key}); final Store s; @override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[const Text('لوحة إدارة المصنع',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),const SizedBox(height:12),Wrap(spacing:10,runSpacing:10,children:[Stat('خطوط الإنتاج','${s.lines.length}',Icons.precision_manufacturing),Stat('المستودعات','${s.warehouses.length}',Icons.warehouse),Stat('الأصناف','${s.products.length}',Icons.inventory_2),Stat('أقسام الإنتاج','${s.categories.length}',Icons.category)]),const SizedBox(height:20),const Text('أقسام الإنتاج',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),...s.categories.map((x)=>Card(child:ListTile(leading:const CircleAvatar(child:Icon(Icons.factory)),title:Text(x,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${s.lines.where((e)=>e.category==x).length} خط • ${s.products.where((e)=>e.category==x).length} صنف'))))]));}
class Stat extends StatelessWidget {const Stat(this.t,this.v,this.i,{super.key});final String t,v;final IconData i;@override Widget build(BuildContext c)=>SizedBox(width:190,child:Card(child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[CircleAvatar(child:Icon(i)),const SizedBox(width:10),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(v,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text(t)])]))));}

class LinesPage extends StatefulWidget{const LinesPage(this.s,{super.key});final Store s;@override State<LinesPage> createState()=>_LinesPageState();}
class _LinesPageState extends State<LinesPage>{String? filter;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:widget.s,builder:(_,__) {final list=filter==null?widget.s.lines:widget.s.lines.where((x)=>x.category==filter).toList();return ListView(padding:const EdgeInsets.all(16),children:[Row(children:[const Expanded(child:Text('خطوط الإنتاج',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold))),FilledButton.icon(onPressed:()=>addLine(c),icon:const Icon(Icons.add),label:const Text('خط جديد'))]),const SizedBox(height:10),DropdownButtonFormField<String>(value:filter,decoration:const InputDecoration(labelText:'تصفية حسب القسم',border:OutlineInputBorder()),items:[const DropdownMenuItem(value:null,child:Text('كل الأقسام')),...widget.s.categories.map((x)=>DropdownMenuItem(value:x,child:Text(x)))],onChanged:(v)=>setState(()=>filter=v)),const SizedBox(height:10),...list.map((x)=>Card(child:ListTile(leading:const Icon(Icons.precision_manufacturing),title:Text(x.name),subtitle:Text(x.category),trailing:Chip(label:Text(x.status)))))]);});
 void addLine(BuildContext c){final n=TextEditingController();String cat=widget.s.categories.first;showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('إضافة خط إنتاج'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'اسم الخط')),DropdownButtonFormField(value:cat,items:widget.s.categories.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>setD(()=>cat=v!),decoration:const InputDecoration(labelText:'قسم الإنتاج'))]),actions:[TextButton(onPressed:()=>Navigator.pop(d),child:const Text('إلغاء')),FilledButton(onPressed:(){if(n.text.trim().isNotEmpty)widget.s.addLine(LineItem(n.text.trim(),cat));Navigator.pop(d);},child:const Text('حفظ'))])));}}

class WarehousesPage extends StatelessWidget{const WarehousesPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[Row(children:[const Expanded(child:Text('المستودعات',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold))),FilledButton.icon(onPressed:()=>add(c),icon:const Icon(Icons.add),label:const Text('مستودع'))]),...s.warehouses.map((w)=>Card(child:ListTile(leading:const Icon(Icons.warehouse),title:Text(w.name),subtitle:const Text('المخزون • التشغيلات • التحويلات • الجرد'),trailing:const Icon(Icons.chevron_left))))]));void add(BuildContext c){final x=TextEditingController();showDialog(context:c,builder:(d)=>AlertDialog(title:const Text('إضافة مستودع'),content:TextField(controller:x,decoration:const InputDecoration(labelText:'اسم المستودع')),actions:[FilledButton(onPressed:(){if(x.text.trim().isNotEmpty)s.addWarehouse(x.text.trim());Navigator.pop(d);},child:const Text('حفظ'))]));}}

class ProductsPage extends StatelessWidget{const ProductsPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[Row(children:[const Expanded(child:Text('الأصناف',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold))),FilledButton.icon(onPressed:()=>add(c),icon:const Icon(Icons.add),label:const Text('صنف جديد'))]),const Text('الأسماء والأوزان والتعبئة قابلة للتعديل والإضافة.'),const SizedBox(height:8),...s.products.map((p)=>Card(child:ListTile(leading:const Icon(Icons.inventory_2),title:Text(p.name),subtitle:Text('${p.category}${p.weight.isEmpty?'':' • ${p.weight}'}\n${p.pack}'),isThreeLine:true))) ]));void add(BuildContext c){final n=TextEditingController(),w=TextEditingController(),p=TextEditingController();String cat=s.categories.first;showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('إضافة صنف'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'اسم الصنف')),DropdownButtonFormField(value:cat,items:s.categories.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>setD(()=>cat=v!),decoration:const InputDecoration(labelText:'القسم')),TextField(controller:w,decoration:const InputDecoration(labelText:'الوزن (مثال 800 جم)')),TextField(controller:p,decoration:const InputDecoration(labelText:'التعبئة (مثال 20 كيس/كرتون)'))])),actions:[FilledButton(onPressed:(){if(n.text.trim().isNotEmpty)s.addProduct(Product(n.text.trim(),cat,p.text.trim(),weight:w.text.trim()));Navigator.pop(d);},child:const Text('حفظ'))])));}}

class RecipesPage extends StatelessWidget{const RecipesPage({super.key});@override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(16),children:const [Text('الوصفات والمقادير',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),SizedBox(height:10),Card(child:ListTile(leading:Icon(Icons.science),title:Text('إدارة الوصفات'),subtitle:Text('المواد الخام • المقادير • الناتج المتوقع • الهدر\nسيتم ربطها بالمخزون وأوامر التصنيع في المرحلة التالية.'),isThreeLine:true))]);}
