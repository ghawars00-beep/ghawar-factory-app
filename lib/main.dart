import 'package:flutter/material.dart';

void main() => runApp(const GhawarApp());

class Product { Product(this.name,this.category,this.pack,{this.weight='',this.unit='كرتون'}); String name,category,pack,weight,unit; }
class LineItem { LineItem(this.name,this.category,{this.status='جاهز',this.manager='غير محدد',this.quantity=0,this.unit='كرتون'}); String name,category,status,manager,unit; double quantity; }
class Warehouse { Warehouse(this.name,{this.quantity=0}); String name; double quantity; }
class UserItem { UserItem(this.name,this.role,{this.username='',this.password='',this.active=true,this.permissions=const []}); String name,role,username,password; bool active; List<String> permissions; }
class ProductionEntry { ProductionEntry(this.line,this.product,this.quantity,this.unit,this.date); String line,product,unit,date; double quantity; }
class Supplier { Supplier(this.name,this.phone); String name,phone; }
class RawMaterial { RawMaterial(this.name,this.quantity,this.unit); String name,unit; double quantity; }
class PrinterItem { PrinterItem(this.name,this.type,{this.address='',this.connected=false}); String name,type,address; bool connected; }

class WrapperWorker { WrapperWorker(this.id,{this.name='',this.active=true}); final int id; String name; bool active; }
class WrapperProduction { WrapperProduction(this.worker,this.product,this.qty,this.time); String worker,product; double qty; DateTime time; }
class DiscountItem { DiscountItem(this.worker,this.amount,this.reason,this.time); String worker,reason; double amount; DateTime time; }
class CustomerItem { CustomerItem(this.name,this.type,{this.location='',this.active=true}); String name,type,location; bool active; }
class OperationLog { OperationLog(this.action,this.details,this.time); String action,details; DateTime time; }

class Store extends ChangeNotifier {
  final categories=<String>['السمبوسة المحشية','السمبوسة الجاهزة','رقائق السمبوسة','الكنافة','خبز المرقوق','القرصان','اللحوح'];
  static const filledUnits=<String>['حبة','كيس','كرتون'];
  static const readyUnits=<String>['حبة','علبة','كرتون'];
  static const sheetUnits=<String>['1 كيلو','800 جرام','500 جرام','400 جرام'];
  static const generalUnits=<String>['حبة','كيس','علبة','كرتون','كجم'];
  List<String> unitsForCategory(String category){if(category=='السمبوسة المحشية')return filledUnits;if(category=='السمبوسة الجاهزة')return readyUnits;if(category=='رقائق السمبوسة')return sheetUnits;return generalUnits;}
  String defaultUnitForCategory(String category)=>unitsForCategory(category).first;
  final products=<Product>[
    Product('سمبوسة محشية بالجبن السائل','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون',unit:'كرتون'),
    Product('سمبوسة محشية باللحم','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون',unit:'كرتون'),
    Product('سمبوسة محشية بالدجاج','السمبوسة المحشية','100 حبة/كيس × 5 أكياس/كرتون',unit:'كرتون'),
    Product('سمبوسة جاهزة','السمبوسة الجاهزة','24 حبة/علبة × 20 علبة/كرتون',unit:'كرتون'),
    Product('رقائق سمبوسة غوار مقرمش','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جرام',unit:'800 جرام'),
    Product('رقائق سمبوسة غوار فاخرة','رقائق السمبوسة','20 كيس/كرتون',weight:'800 جرام',unit:'800 جرام'),
  ];
  final warehouses=<Warehouse>[Warehouse('الثلاجة المركزية'),Warehouse('ثلاجة المصنع'),Warehouse('المستودع الخارجي'),Warehouse('مستودع المعمل')];
  final users=<UserItem>[UserItem('مدير البرنامج الرئيسي','مدير رئيسي',username:'admin',password:'Ghawar@2026',permissions:['الكل'])];
  final suppliers=<Supplier>[];
  final rawMaterials=<RawMaterial>[];
  final printers=<PrinterItem>[];
  final lines=<LineItem>[];
  final production=<ProductionEntry>[];
  final wrappers=<WrapperWorker>[];
  final wrapperProduction=<WrapperProduction>[];
  final discounts=<DiscountItem>[];
  final customers=<CustomerItem>[];
  final logs=<OperationLog>[];
  double wagePer1000=40;
  int stopMinutes=180;
  Store(){for(var i=1;i<=100;i++){wrappers.add(WrapperWorker(i));}customers.addAll([CustomerItem('مندوب 1','مندوب'),CustomerItem('مندوب 2','مندوب')]);}
  void changed()=>notifyListeners();
  void addLine(LineItem x){lines.add(x);notifyListeners();}
  void addProduction(ProductionEntry x,LineItem line){production.add(x);line.quantity+=x.quantity;logs.add(OperationLog('إنتاج','${x.line} • ${x.product} • ${x.quantity} ${x.unit}',DateTime.now()));notifyListeners();}
  void addWrapperProduction(WrapperProduction x){wrapperProduction.add(x);logs.add(OperationLog('إنتاج لفاف','${x.worker} • ${x.product} • ${x.qty.toStringAsFixed(0)} حبة',x.time));notifyListeners();}
  void addDiscount(DiscountItem x){discounts.add(x);logs.add(OperationLog('خصم','${x.worker} • ${x.amount.toStringAsFixed(2)} ريال • ${x.reason}',x.time));notifyListeners();}
}

class GhawarApp extends StatefulWidget{const GhawarApp({super.key});@override State<GhawarApp> createState()=>_GhawarAppState();}
class _GhawarAppState extends State<GhawarApp>{final store=Store();@override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'مصنع غوار',theme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xff8d151b),fontFamily:null),builder:(context,child)=>Directionality(textDirection:TextDirection.rtl,child:child!),home:LoginPage(store));}


class LoginPage extends StatefulWidget {
  const LoginPage(this.store,{super.key}); final Store store;
  @override State<LoginPage> createState()=>_LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  final user=TextEditingController(text:'admin'); final pass=TextEditingController();
  bool hide=true; int failures=0; String error='';
  void login(){
    UserItem? found;
    for(final u in widget.store.users){if(u.username==user.text.trim()){found=u;break;}}
    if(found!=null && found.active && found.password==pass.text){
      Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>Home(widget.store)));
    }else{setState((){failures++;error=failures>=5?'محاولات دخول خاطئة متعددة. راجع مدير البرنامج.':'اسم المستخدم أو كلمة المرور غير صحيحة';});}
  }
  @override Widget build(BuildContext c)=>Scaffold(body:Directionality(textDirection:TextDirection.rtl,child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:430),child:Card(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
    const CircleAvatar(radius:42,backgroundColor:Color(0xff8d151b),child:Icon(Icons.factory,color:Colors.white,size:44)),const SizedBox(height:14),
    const Text('غوار الأصلية',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),const Text('نظام إدارة مصنع المعجنات والحلويات'),const SizedBox(height:22),
    TextField(controller:user,decoration:const InputDecoration(labelText:'اسم المستخدم',border:OutlineInputBorder(),prefixIcon:Icon(Icons.person))),const SizedBox(height:12),
    TextField(controller:pass,obscureText:hide,onSubmitted:(_)=>login(),decoration:InputDecoration(labelText:'كلمة المرور',border:const OutlineInputBorder(),prefixIcon:const Icon(Icons.lock),suffixIcon:IconButton(onPressed:()=>setState(()=>hide=!hide),icon:Icon(hide?Icons.visibility:Icons.visibility_off)))),
    if(error.isNotEmpty)...[const SizedBox(height:8),Text(error,style:const TextStyle(color:Colors.red))],const SizedBox(height:16),
    SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:login,icon:const Icon(Icons.login),label:const Padding(padding:EdgeInsets.all(12),child:Text('تسجيل الدخول')))),
    const SizedBox(height:10),const Text('للاختبار الأول فقط: admin / Ghawar@2026',style:TextStyle(fontSize:12,color:Colors.grey))
  ]))))))));
}

class Home extends StatefulWidget{const Home(this.store,{super.key});final Store store;@override State<Home> createState()=>_HomeState();}
class _HomeState extends State<Home>{int tab=0;@override Widget build(BuildContext c){final pages=[Dashboard(widget.store),LinesPage(widget.store),WarehousesPage(widget.store),ProductsPage(widget.store),ManagementPage(widget.store)];return Scaffold(appBar:AppBar(backgroundColor:const Color(0xff8d151b),foregroundColor:Colors.white,title:const Text('غوار الأصلية • إدارة المصنع'),actions:const [Padding(padding:EdgeInsetsDirectional.only(end:10),child:Center(child:LiveDateTime()))]),body:pages[tab],bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [NavigationDestination(icon:Icon(Icons.dashboard),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.precision_manufacturing),label:'الإنتاج'),NavigationDestination(icon:Icon(Icons.warehouse),label:'المخزون'),NavigationDestination(icon:Icon(Icons.inventory_2),label:'الأصناف'),NavigationDestination(icon:Icon(Icons.settings),label:'الإدارة')]));}}

class LiveDateTime extends StatefulWidget{const LiveDateTime({super.key});@override State<LiveDateTime> createState()=>_LiveDateTimeState();}
class _LiveDateTimeState extends State<LiveDateTime>{late final Stream<DateTime> _clock;@override void initState(){super.initState();_clock=Stream<DateTime>.periodic(const Duration(seconds:1),(_)=>DateTime.now());}@override Widget build(BuildContext context)=>StreamBuilder<DateTime>(stream:_clock,initialData:DateTime.now(),builder:(_,snap){final d=snap.data??DateTime.now();String two(int v)=>v.toString().padLeft(2,'0');return Text('${d.year}/${two(d.month)}/${two(d.day)}  ${two(d.hour)}:${two(d.minute)}:${two(d.second)}',style:const TextStyle(fontSize:12));});}

class Dashboard extends StatelessWidget {
  const Dashboard(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('لوحة إدارة المصنع', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        Wrap(spacing: 8, runSpacing: 8, children: [
          Stat('خطوط الإنتاج', '${s.lines.length}', Icons.precision_manufacturing),
          Stat('المستودعات', '${s.warehouses.length}', Icons.warehouse),
          Stat('المستخدمون', '${s.users.length}', Icons.people),
          Stat('سجلات الإنتاج', '${s.production.length}', Icons.assignment),
        ]),
        const SizedBox(height: 15),
        const Text('أقسام الإنتاج', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...s.categories.map((x) => Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.factory)),
            title: Text(x, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${s.lines.where((e) => e.category == x).length} خط إنتاج'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => CategoryPage(s, x))),
          ),
        )),
      ],
    ),
  );
}
class Stat extends StatelessWidget{const Stat(this.t,this.v,this.i,{super.key});final String t,v;final IconData i;@override Widget build(BuildContext c)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(i),const SizedBox(width:8),Column(children:[Text(v,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text(t)])])));}
class CategoryPage extends StatelessWidget{const CategoryPage(this.s,this.cat,{super.key});final Store s;final String cat;@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(cat)),body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(children:s.lines.where((x)=>x.category==cat).map((x)=>ListTile(title:Text(x.name),subtitle:Text('المسؤول: ${x.manager} • الإنتاج: ${x.quantity.toStringAsFixed(0)} ${x.unit}'),trailing:const Icon(Icons.chevron_left),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>LineDetails(s,x))))).toList())));}

class LinesPage extends StatefulWidget {
  const LinesPage(this.s, {super.key});
  final Store s;
  @override State<LinesPage> createState() => _LinesPageState();
}
class _LinesPageState extends State<LinesPage> {
  String filter = 'الكل';
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: widget.s,
    builder: (_, __) {
      final list = filter == 'الكل' ? widget.s.lines : widget.s.lines.where((x) => x.category == filter).toList();
      return ListView(padding: const EdgeInsets.all(12), children: [
        Row(children: [
          const Expanded(child: Text('خطوط الإنتاج', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
          FilledButton.icon(onPressed: () => addLine(c), icon: const Icon(Icons.add), label: const Text('إضافة خط')),
        ]),
        DropdownButtonFormField<String>(
          value: filter,
          decoration: const InputDecoration(labelText: 'القسم'),
          items: [
            const DropdownMenuItem<String>(value: 'الكل', child: Text('كل الأقسام')),
            ...widget.s.categories.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))),
          ],
          onChanged: (v) { if (v != null) setState(() => filter = v); },
        ),
        ...list.map((x) => Card(child: ListTile(
          title: Text(x.name), subtitle: Text('${x.category} • ${x.manager}'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => LineDetails(widget.s, x))),
        ))),
      ]);
    },
  );

  void addLine(BuildContext c) {
    final n = TextEditingController();
    String cat = widget.s.categories.first;
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('إضافة خط إنتاج'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'اسم الخط')),
        DropdownButtonFormField<String>(
          value: cat,
          items: widget.s.categories.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(),
          onChanged: (v) { if (v != null) setD(() => cat = v); },
          decoration: const InputDecoration(labelText: 'القسم'),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text('إلغاء')),
        FilledButton(onPressed: () { if (n.text.trim().isNotEmpty) widget.s.addLine(LineItem(n.text.trim(), cat,unit:widget.s.defaultUnitForCategory(cat))); Navigator.pop(d); }, child: const Text('حفظ')),
      ],
    )));
  }
}

class LineDetails extends StatelessWidget{
  const LineDetails(this.s,this.line,{super.key}); final Store s; final LineItem line;
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(line.name),actions:[IconButton(onPressed:()=>editLine(c),icon:const Icon(Icons.edit))]),body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[Card(child:ListTile(title:Text(line.category),subtitle:Text('الحالة: ${line.status}\nالمسؤول: ${line.manager}\nإجمالي الإنتاج: ${line.quantity.toStringAsFixed(0)} ${line.unit}'),isThreeLine:true)),FilledButton.icon(onPressed:line.status=='متوقف'?null:()=>addProduction(c),icon:const Icon(Icons.add_chart),label:const Text('إضافة الإنتاج اللحظي')),const SizedBox(height:8),OutlinedButton.icon(onPressed:()=>editManager(c),icon:const Icon(Icons.person),label:const Text('تحديد المسؤول')),const SizedBox(height:8),OutlinedButton.icon(onPressed:(){line.status=line.status=='متوقف'?'جاهز':'متوقف';s.changed();},icon:Icon(line.status=='متوقف'?Icons.play_arrow:Icons.stop_circle),label:Text(line.status=='متوقف'?'تشغيل خط الإنتاج':'إيقاف خط الإنتاج')),const SizedBox(height:16),const Text('سجل إنتاج الخط',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),...s.production.where((e)=>e.line==line.name).map((e)=>Card(child:ListTile(title:Text(e.product),subtitle:Text('${e.quantity.toStringAsFixed(0)} ${e.unit} • ${e.date}'))))])));
  void addProduction(BuildContext c){final q=TextEditingController();final choices=s.products.where((p)=>p.category==line.category).map((p)=>p.name).toList();if(choices.isEmpty)choices.add('إنتاج عام');String product=choices.first;String unit=s.unitsForCategory(line.category).contains(line.unit)?line.unit:s.defaultUnitForCategory(line.category);showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('تسجيل الإنتاج اللحظي'),content:Column(mainAxisSize:MainAxisSize.min,children:[DropdownButtonFormField<String>(value:product,items:choices.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>product=v);},decoration:const InputDecoration(labelText:'الصنف')),TextField(controller:q,keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:const InputDecoration(labelText:'الكمية')),DropdownButtonFormField<String>(value:unit,items:s.unitsForCategory(line.category).map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>unit=v);},decoration:const InputDecoration(labelText:'وحدة القياس'))]),actions:[FilledButton(onPressed:(){final n=double.tryParse(q.text);if(n!=null&&n>0){line.unit=unit;final now=DateTime.now();String two(int v)=>v.toString().padLeft(2,'0');s.addProduction(ProductionEntry(line.name,product,n,unit,'${now.year}/${two(now.month)}/${two(now.day)} ${two(now.hour)}:${two(now.minute)}:${two(now.second)}'),line);Navigator.pop(d);}},child:const Text('حفظ'))])));}
  void editLine(BuildContext c){final n=TextEditingController(text:line.name);String cat=line.category;String unit=s.unitsForCategory(cat).contains(line.unit)?line.unit:s.defaultUnitForCategory(cat);showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('تعديل خط الإنتاج'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'اسم خط الإنتاج')),DropdownButtonFormField<String>(value:cat,items:s.categories.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD((){cat=v;unit=s.defaultUnitForCategory(cat);});},decoration:const InputDecoration(labelText:'الفئة')),DropdownButtonFormField<String>(value:unit,items:s.unitsForCategory(cat).map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>unit=v);},decoration:const InputDecoration(labelText:'وحدة القياس'))]),actions:[FilledButton(onPressed:(){if(n.text.trim().isNotEmpty){final old=line.name;line.name=n.text.trim();line.category=cat;line.unit=unit;for(final e in s.production.where((e)=>e.line==old)){e.line=line.name;}s.changed();}Navigator.pop(d);},child:const Text('حفظ التعديل'))])));}
  void editManager(BuildContext c){String manager=line.manager;final names=['غير محدد',...s.users.where((u)=>u.active).map((u)=>u.name)];showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('مسؤول الخط'),content:DropdownButtonFormField<String>(value:names.contains(manager)?manager:'غير محدد',items:names.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>manager=v);},decoration:const InputDecoration(labelText:'اختر المسؤول')),actions:[FilledButton(onPressed:(){line.manager=manager;s.changed();Navigator.pop(d);},child:const Text('حفظ'))])));}
}

class WarehousesPage extends StatelessWidget {
  const WarehousesPage(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('المستودعات والتحويل', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ...s.warehouses.map((w) => Card(child: ListTile(
          leading: const Icon(Icons.warehouse), title: Text(w.name),
          subtitle: Text('الرصيد العام: ${w.quantity.toStringAsFixed(0)}'),
          trailing: PopupMenuButton<int>(
            itemBuilder: (_) => const [
              PopupMenuItem<int>(value: 1, child: Text('إضافة كمية')),
              PopupMenuItem<int>(value: 2, child: Text('تحويل لمستودع')),
            ],
            onSelected: (v) { if (v == 1) { quantity(c, w); } else { transfer(c, w); } },
          ),
        ))),
      ],
    ),
  );
  void quantity(BuildContext c, Warehouse w) {
    final q = TextEditingController();
    showDialog(context: c, builder: (d) => AlertDialog(
      title: Text('إضافة كمية • ${w.name}'),
      content: TextField(controller: q, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الكمية')),
      actions: [FilledButton(onPressed: () { final n = double.tryParse(q.text); if (n != null) { w.quantity += n; s.changed(); } Navigator.pop(d); }, child: const Text('حفظ'))],
    ));
  }
  void transfer(BuildContext c, Warehouse from) {
    final q = TextEditingController();
    Warehouse to = s.warehouses.firstWhere((x) => x != from, orElse: () => from);
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('تحويل بين المستودعات'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<Warehouse>(
          value: to,
          items: s.warehouses.where((x) => x != from).map((x) => DropdownMenuItem<Warehouse>(value: x, child: Text(x.name))).toList(),
          onChanged: (v) { if (v != null) setD(() => to = v); },
          decoration: const InputDecoration(labelText: 'إلى'),
        ),
        TextField(controller: q, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الكمية')),
      ]),
      actions: [FilledButton(onPressed: () { final n = double.tryParse(q.text); if (n != null && n > 0 && from.quantity >= n) { from.quantity -= n; to.quantity += n; s.changed(); Navigator.pop(d); } }, child: const Text('تحويل'))],
    )));
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => ListView(padding: const EdgeInsets.all(12), children: [
      Row(children: [
        const Expanded(child: Text('الأصناف', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        FilledButton.icon(onPressed: () => add(c), icon: const Icon(Icons.add), label: const Text('إضافة')),
      ]),
      ...s.products.map((p) => Card(child: ListTile(title: Text(p.name), subtitle: Text('${p.category} • الوحدة: ${p.unit}${p.weight.isEmpty?'':' • ${p.weight}'} • ${p.pack}'),trailing:IconButton(icon:const Icon(Icons.edit),onPressed:()=>edit(c,p))))),
    ]),
  );
  void add(BuildContext c) {
    final n = TextEditingController(), pack=TextEditingController(), weight=TextEditingController(); String cat = s.categories.first; String unit=s.defaultUnitForCategory(cat);
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('إضافة صنف'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'اسم الصنف')),
        DropdownButtonFormField<String>(value: cat, items: s.categories.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setD(() {cat = v; unit=s.defaultUnitForCategory(cat);}); }, decoration: const InputDecoration(labelText: 'القسم')),
        DropdownButtonFormField<String>(value:unit,items:s.unitsForCategory(cat).map((x)=>DropdownMenuItem<String>(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>unit=v);},decoration:const InputDecoration(labelText:'وحدة القياس')),
        TextField(controller:weight,decoration:const InputDecoration(labelText:'الوزن / المقاس (اختياري)')),
        TextField(controller:pack,decoration:const InputDecoration(labelText:'التعبئة (اختياري)')),
      ]),
      actions: [FilledButton(onPressed: () { if (n.text.trim().isNotEmpty) { s.products.add(Product(n.text.trim(),cat,pack.text.trim().isEmpty?'يحدد لاحقاً':pack.text.trim(),weight:weight.text.trim(),unit:unit)); s.changed(); } Navigator.pop(d); }, child: const Text('حفظ'))],
    )));
  }
  void edit(BuildContext c,Product p){final n=TextEditingController(text:p.name),pack=TextEditingController(text:p.pack),weight=TextEditingController(text:p.weight);String cat=p.category;String unit=s.unitsForCategory(cat).contains(p.unit)?p.unit:s.defaultUnitForCategory(cat);showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('تعديل الصنف'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'اسم الصنف')),DropdownButtonFormField<String>(value:cat,items:s.categories.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD((){cat=v;unit=s.defaultUnitForCategory(cat);});},decoration:const InputDecoration(labelText:'الفئة')),DropdownButtonFormField<String>(value:unit,items:s.unitsForCategory(cat).map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>unit=v);},decoration:const InputDecoration(labelText:'وحدة القياس')),TextField(controller:weight,decoration:const InputDecoration(labelText:'الوزن / المقاس')),TextField(controller:pack,decoration:const InputDecoration(labelText:'التعبئة'))])),actions:[TextButton(onPressed:()=>Navigator.pop(d),child:const Text('إلغاء')),FilledButton(onPressed:(){if(n.text.trim().isNotEmpty){p.name=n.text.trim();p.category=cat;p.unit=unit;p.weight=weight.text.trim();p.pack=pack.text.trim();s.changed();}Navigator.pop(d);},child:const Text('حفظ التعديل'))])));}
}

class ManagementPage extends StatelessWidget{const ManagementPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(12),children:[const Text('الإدارة والإعدادات',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),Tile('اللفافون وإنتاج الغضارات',Icons.groups,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>WrappersPage(s)))),Tile('الخصومات وتقارير اللفافين',Icons.assessment,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>WrapperReportsPage(s)))),Tile('العملاء والمندوبون',Icons.storefront,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CustomersPage(s)))),Tile('سجل العمليات',Icons.history,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>LogsPage(s)))),Tile('المستخدمون والصلاحيات',Icons.manage_accounts,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>UsersPage(s)))),Tile('المواد الخام',Icons.grain,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RawMaterialsPage(s)))),Tile('الموردون',Icons.local_shipping,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>SuppliersPage(s)))),Tile('الطابعات و Wi‑Fi و Bluetooth',Icons.print,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>PrintersPage(s))))]);}
class Tile extends StatelessWidget{const Tile(this.t,this.i,this.tap,{super.key});final String t;final IconData i;final VoidCallback tap;@override Widget build(BuildContext c)=>Card(child:ListTile(leading:Icon(i),title:Text(t),trailing:const Icon(Icons.chevron_left),onTap:tap));}

class UsersPage extends StatelessWidget{
  const UsersPage(this.s,{super.key}); final Store s;
  @override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('المستخدمون والصلاحيات')),body:ListView(padding:const EdgeInsets.all(12),children:[FilledButton.icon(onPressed:()=>add(c),icon:const Icon(Icons.person_add),label:const Text('إضافة مستخدم / مدير')),...s.users.map((u)=>Card(child:ListTile(onTap:()=>edit(c,u),leading:const Icon(Icons.manage_accounts),title:Text(u.name),subtitle:Text('${u.role} • اسم الدخول: ${u.username}\nالصلاحيات: ${u.permissions.isEmpty?'لم تحدد':u.permissions.join('، ')}'),trailing:Switch(value:u.active,onChanged:(v){u.active=v;s.changed();}))))])));
  List<String> get roles=>['مدير رئيسي','مدير تصنيع','مدير قسم','مسؤول مستودع','مسؤول عمال','مندوب','مسؤول'];
  List<String> get permissions=>['الإنتاج','المستودعات','الأصناف','المستخدمون','الموردون','الطابعات'];
  void add(BuildContext c)=>userDialog(c,null);
  void edit(BuildContext c,UserItem u)=>userDialog(c,u);
  void userDialog(BuildContext c,UserItem? current){final n=TextEditingController(text:current?.name??''),un=TextEditingController(text:current?.username??''),pw=TextEditingController(text:current?.password??'');String role=current?.role??'مسؤول';final selected=<String>[...?current?.permissions];showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:Text(current==null?'إضافة مستخدم / مدير':'تعديل المستخدم وبيانات الدخول'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'الاسم الكامل')),TextField(controller:un,decoration:const InputDecoration(labelText:'اسم المستخدم')),TextField(controller:pw,decoration:const InputDecoration(labelText:'كلمة المرور')),DropdownButtonFormField<String>(value:roles.contains(role)?role:'مسؤول',items:roles.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>role=v);},decoration:const InputDecoration(labelText:'الدور')),...permissions.map((p)=>CheckboxListTile(value:selected.contains(p),title:Text(p),onChanged:(v)=>setD((){if(v==true){if(!selected.contains(p))selected.add(p);}else{selected.remove(p);}})))])),actions:[TextButton(onPressed:()=>Navigator.pop(d),child:const Text('إلغاء')),FilledButton(onPressed:(){if(n.text.trim().isEmpty||un.text.trim().isEmpty||pw.text.isEmpty)return;final duplicate=s.users.any((u)=>u!=current&&u.username==un.text.trim());if(duplicate){ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('اسم المستخدم مستخدم مسبقاً')));return;}if(current==null){s.users.add(UserItem(n.text.trim(),role,username:un.text.trim(),password:pw.text,permissions:List.of(selected)));}else{current.name=n.text.trim();current.role=role;current.username=un.text.trim();current.password=pw.text;current.permissions=List.of(selected);}s.changed();Navigator.pop(d);},child:const Text('حفظ'))])));}
}

class RawMaterialsPage extends StatelessWidget{const RawMaterialsPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('المواد الخام')),floatingActionButton:FloatingActionButton(onPressed:()=>add(c),child:const Icon(Icons.add)),body:ListView(children:s.rawMaterials.map((x)=>ListTile(title:Text(x.name),subtitle:Text('${x.quantity} ${x.unit}'))).toList())));void add(BuildContext c){final n=TextEditingController(),q=TextEditingController();showDialog(context:c,builder:(d)=>AlertDialog(title:const Text('إضافة مادة خام'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'المادة')),TextField(controller:q,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'الكمية'))]),actions:[FilledButton(onPressed:(){final v=double.tryParse(q.text)??0;if(n.text.isNotEmpty){s.rawMaterials.add(RawMaterial(n.text,v,'كجم'));s.changed();}Navigator.pop(d);},child:const Text('حفظ'))]));}}
class SuppliersPage extends StatelessWidget{const SuppliersPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('الموردون')),floatingActionButton:FloatingActionButton(onPressed:()=>add(c),child:const Icon(Icons.add)),body:ListView(children:s.suppliers.map((x)=>ListTile(title:Text(x.name),subtitle:Text(x.phone))).toList())));void add(BuildContext c){final n=TextEditingController(),p=TextEditingController();showDialog(context:c,builder:(d)=>AlertDialog(title:const Text('إضافة مورد'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'اسم المورد')),TextField(controller:p,decoration:const InputDecoration(labelText:'رقم التواصل'))]),actions:[FilledButton(onPressed:(){if(n.text.isNotEmpty){s.suppliers.add(Supplier(n.text,p.text));s.changed();}Navigator.pop(d);},child:const Text('حفظ'))]));}}

class PrintersPage extends StatelessWidget {
  const PrintersPage(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => Scaffold(
      appBar: AppBar(title: const Text('الطابعات والاتصال')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => add(c), icon: const Icon(Icons.add), label: const Text('إضافة طابعة')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('إعدادات الاتصال'), subtitle: Text('يمكن تسجيل طابعة Bluetooth أو طابعة Wi‑Fi / شبكة. الاتصال والطباعة الفعلية تتطلب حزمة متوافقة مع موديل الطابعة وصلاحيات Android.'))),
        ...s.printers.map((p) => Card(child: SwitchListTile(
          value: p.connected, onChanged: (v) { p.connected = v; s.changed(); },
          secondary: Icon(p.type == 'Bluetooth' ? Icons.bluetooth : Icons.wifi),
          title: Text(p.name), subtitle: Text('${p.type} • ${p.address.isEmpty ? 'بدون عنوان' : p.address}'),
        ))),
      ]),
    ),
  );
  void add(BuildContext c) {
    final n = TextEditingController(), a = TextEditingController(); String type = 'Wi‑Fi';
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('إضافة طابعة'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'اسم الطابعة')),
        DropdownButtonFormField<String>(value: type, items: ['Wi‑Fi','Bluetooth'].map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setD(() => type = v); }, decoration: const InputDecoration(labelText: 'نوع الاتصال')),
        TextField(controller: a, decoration: InputDecoration(labelText: type == 'Wi‑Fi' ? 'IP / عنوان الشبكة' : 'اسم أو عنوان Bluetooth')),
      ]),
      actions: [FilledButton(onPressed: () { if (n.text.isNotEmpty) { s.printers.add(PrinterItem(n.text, type, address: a.text)); s.changed(); } Navigator.pop(d); }, child: const Text('حفظ'))],
    )));
  }
}


class WrappersPage extends StatelessWidget {
  const WrappersPage(this.s,{super.key}); final Store s;
  @override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(
    appBar:AppBar(title:const Text('اللفافون وإنتاج الغضارات')),
    floatingActionButton:FloatingActionButton.extended(onPressed:()=>addProduction(c),icon:const Icon(Icons.add),label:const Text('إدخال إنتاج')),
    body:ListView(padding:const EdgeInsets.all(12),children:[
      Card(child:ListTile(title:const Text('إعداد الأجر'),subtitle:Text('${s.wagePer1000.toStringAsFixed(0)} ريال لكل 1000 حبة • التوقف بعد ${s.stopMinutes} دقيقة'))),
      ...s.wrappers.map((w){final total=s.wrapperProduction.where((x)=>x.worker==w.name && w.name.isNotEmpty).fold<double>(0,(a,b)=>a+b.qty);return Card(child:SwitchListTile(value:w.active,onChanged:(v){w.active=v;s.changed();},title:Text(w.name.isEmpty?'لفاف رقم ${w.id}':w.name),subtitle:Text('الإنتاج المسجل: ${total.toStringAsFixed(0)} حبة'),secondary:CircleAvatar(child:Text('${w.id}')),));})
    ])
  ));
  void addProduction(BuildContext c){
    final named=s.wrappers.where((w)=>w.name.isNotEmpty&&w.active).toList();
    if(named.isEmpty){ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('أضف أسماء اللفافين أولاً من القائمة بالضغط على اللفاف')));return;}
    WrapperWorker worker=named.first; String product='لحم'; final q=TextEditingController();
    showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('إدخال إنتاج لفاف'),content:Column(mainAxisSize:MainAxisSize.min,children:[
      DropdownButtonFormField<WrapperWorker>(value:worker,items:named.map((x)=>DropdownMenuItem(value:x,child:Text(x.name))).toList(),onChanged:(v){if(v!=null)setD(()=>worker=v);},decoration:const InputDecoration(labelText:'اللفاف')),
      DropdownButtonFormField<String>(value:product,items:['لحم','دجاج','جبن أبيض فيتا'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>product=v);},decoration:const InputDecoration(labelText:'الصنف')),
      TextField(controller:q,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'الكمية بالحبة')),
    ]),actions:[FilledButton(onPressed:(){final n=double.tryParse(q.text)??0;if(n>0)s.addWrapperProduction(WrapperProduction(worker.name,product,n,DateTime.now()));Navigator.pop(d);},child:const Text('حفظ'))])));
  }
}

class WrapperReportsPage extends StatelessWidget {
  const WrapperReportsPage(this.s,{super.key}); final Store s;
  @override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('تقارير اللفافين والخصومات')),floatingActionButton:FloatingActionButton.extended(onPressed:()=>discount(c),icon:const Icon(Icons.remove_circle),label:const Text('إضافة خصم')),body:ListView(padding:const EdgeInsets.all(12),children:[
    const Text('ملخص من بداية العمل',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
    ...s.wrappers.where((w)=>w.name.isNotEmpty).map((w){final qty=s.wrapperProduction.where((x)=>x.worker==w.name).fold<double>(0,(a,b)=>a+b.qty);final wage=qty/1000*s.wagePer1000;final disc=s.discounts.where((x)=>x.worker==w.name).fold<double>(0,(a,b)=>a+b.amount);return Card(child:ListTile(title:Text(w.name),subtitle:Text('الإنتاج: ${qty.toStringAsFixed(0)} حبة • الأجر: ${wage.toStringAsFixed(2)} ر.س\nالخصم: ${disc.toStringAsFixed(2)} • الصافي: ${(wage-disc).clamp(0,double.infinity).toStringAsFixed(2)} ر.س')));}),
  ])));
  void discount(BuildContext c){final named=s.wrappers.where((w)=>w.name.isNotEmpty).toList();if(named.isEmpty)return;WrapperWorker w=named.first;String reason='يستخدم رقائق متعددة';final amount=TextEditingController();showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('إضافة خصم'),content:Column(mainAxisSize:MainAxisSize.min,children:[DropdownButtonFormField<WrapperWorker>(value:w,items:named.map((x)=>DropdownMenuItem(value:x,child:Text(x.name))).toList(),onChanged:(v){if(v!=null)setD(()=>w=v);}),DropdownButtonFormField<String>(value:reason,items:['يستخدم رقائق متعددة','عدم قفل السمبوسة جيدا','استخدام قلوب الرقائق فقط'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>reason=v);}),TextField(controller:amount,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'مبلغ الخصم'))]),actions:[FilledButton(onPressed:(){final a=double.tryParse(amount.text)??0;if(a>0)s.addDiscount(DiscountItem(w.name,a,reason,DateTime.now()));Navigator.pop(d);},child:const Text('حفظ'))])));}
}

class CustomersPage extends StatelessWidget{
  const CustomersPage(this.s,{super.key});final Store s;
  @override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('العملاء والمندوبون')),floatingActionButton:FloatingActionButton(onPressed:()=>add(c),child:const Icon(Icons.add)),body:ListView(children:s.customers.map((x)=>SwitchListTile(value:x.active,onChanged:(v){x.active=v;s.changed();},title:Text(x.name),subtitle:Text('${x.type} • ${x.location.isEmpty?'الموقع غير محدد':x.location}'))).toList())));
  void add(BuildContext c){final n=TextEditingController(),loc=TextEditingController();String type='عميل';showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('إضافة عميل / مندوب'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'الاسم')),DropdownButtonFormField<String>(value:type,items:['عميل','مندوب'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){if(v!=null)setD(()=>type=v);}),TextField(controller:loc,decoration:const InputDecoration(labelText:'الموقع'))]),actions:[FilledButton(onPressed:(){if(n.text.trim().isNotEmpty){s.customers.add(CustomerItem(n.text.trim(),type,location:loc.text.trim()));s.changed();}Navigator.pop(d);},child:const Text('حفظ'))])));}
}

class LogsPage extends StatelessWidget{const LogsPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('سجل العمليات')),body:ListView(padding:const EdgeInsets.all(12),children:s.logs.reversed.map((x)=>Card(child:ListTile(leading:const Icon(Icons.history),title:Text(x.action),subtitle:Text('${x.details}\n${x.time}')))).toList())));}
