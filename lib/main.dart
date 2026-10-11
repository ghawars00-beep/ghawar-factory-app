import 'package:flutter/material.dart';

void main() => runApp(const GhawarApp());

class Product { Product(this.name,this.category,this.pack,{this.weight=''}); String name,category,pack,weight; }
class LineItem { LineItem(this.name,this.category,{this.status='ط¬ط§ظ‡ط²',this.manager='ط؛ظٹط± ظ…ط­ط¯ط¯',this.quantity=0,this.unit='ظƒط±طھظˆظ†'}); String name,category,status,manager,unit; double quantity; }
class Warehouse { Warehouse(this.name,{this.quantity=0}); String name; double quantity; }
class UserItem { UserItem(this.name,this.role,{this.username='',this.password='',this.active=true,this.permissions=const []}); String name,role,username,password; bool active; List<String> permissions; }
class ProductionEntry { ProductionEntry(this.line,this.product,this.quantity,this.unit,this.date); String line,product,unit,date; double quantity; }
class Supplier { Supplier(this.name,this.phone); String name,phone; }
class RawMaterial { RawMaterial(this.name,this.quantity,this.unit); String name,unit; double quantity; }
class PrinterItem { PrinterItem(this.name,this.type,{this.address='',this.connected=false}); String name,type,address; bool connected; }

class Store extends ChangeNotifier {
  final categories=<String>['ط§ظ„ط³ظ…ط¨ظˆط³ط© ط§ظ„ظ…ط­ط´ظٹط©','ط±ظ‚ط§ط¦ظ‚ ط§ظ„ط³ظ…ط¨ظˆط³ط©','ط§ظ„ظƒظ†ط§ظپط©','ط®ط¨ط² ط§ظ„ظ…ط±ظ‚ظˆظ‚','ط§ظ„ظ‚ط±طµط§ظ†','ط§ظ„ظ„ط­ظˆط­'];
  final products=<Product>[
    Product('ط³ظ…ط¨ظˆط³ط© ظ…ط­ط´ظٹط© ط¨ط§ظ„ط¬ط¨ظ† ط§ظ„ط³ط§ط¦ظ„','ط§ظ„ط³ظ…ط¨ظˆط³ط© ط§ظ„ظ…ط­ط´ظٹط©','100 ط­ط¨ط©/ظƒظٹط³ أ— 5 ط£ظƒظٹط§ط³/ظƒط±طھظˆظ†'),
    Product('ط³ظ…ط¨ظˆط³ط© ظ…ط­ط´ظٹط© ط¨ط§ظ„ظ„ط­ظ…','ط§ظ„ط³ظ…ط¨ظˆط³ط© ط§ظ„ظ…ط­ط´ظٹط©','100 ط­ط¨ط©/ظƒظٹط³ أ— 5 ط£ظƒظٹط§ط³/ظƒط±طھظˆظ†'),
    Product('ط³ظ…ط¨ظˆط³ط© ظ…ط­ط´ظٹط© ط¨ط§ظ„ط¯ط¬ط§ط¬','ط§ظ„ط³ظ…ط¨ظˆط³ط© ط§ظ„ظ…ط­ط´ظٹط©','100 ط­ط¨ط©/ظƒظٹط³ أ— 5 ط£ظƒظٹط§ط³/ظƒط±طھظˆظ†'),
    Product('ط±ظ‚ط§ط¦ظ‚ ط³ظ…ط¨ظˆط³ط© ط؛ظˆط§ط± ظ…ظ‚ط±ظ…ط´','ط±ظ‚ط§ط¦ظ‚ ط§ظ„ط³ظ…ط¨ظˆط³ط©','20 ظƒظٹط³/ظƒط±طھظˆظ†',weight:'800 ط¬ظ…'),
    Product('ط±ظ‚ط§ط¦ظ‚ ط³ظ…ط¨ظˆط³ط© ط؛ظˆط§ط± ظپط§ط®ط±ط©','ط±ظ‚ط§ط¦ظ‚ ط§ظ„ط³ظ…ط¨ظˆط³ط©','20 ظƒظٹط³/ظƒط±طھظˆظ†',weight:'800 ط¬ظ…'),
  ];
  final warehouses=<Warehouse>[Warehouse('ط§ظ„ط«ظ„ط§ط¬ط© ط§ظ„ظ…ط±ظƒط²ظٹط©'),Warehouse('ط«ظ„ط§ط¬ط© ط§ظ„ظ…طµظ†ط¹'),Warehouse('ط§ظ„ظ…ط³طھظˆط¯ط¹ ط§ظ„ط®ط§ط±ط¬ظٹ'),Warehouse('ظ…ط³طھظˆط¯ط¹ ط§ظ„ظ…ط¹ظ…ظ„')];
  final users=<UserItem>[UserItem('ظ…ط¯ظٹط± ط§ظ„ط¨ط±ظ†ط§ظ…ط¬ ط§ظ„ط±ط¦ظٹط³ظٹ','ظ…ط¯ظٹط± ط±ط¦ظٹط³ظٹ',username:'admin',password:'Ghawar@2026',permissions:['ط§ظ„ظƒظ„'])];
  final suppliers=<Supplier>[];
  final rawMaterials=<RawMaterial>[];
  final printers=<PrinterItem>[];
  final lines=<LineItem>[];
  final production=<ProductionEntry>[];
  Store(){for(var i=1;i<=100;i++)lines.add(LineItem('ط®ط· ${i.toString().padLeft(3,'0')}','ط§ظ„ط³ظ…ط¨ظˆط³ط© ط§ظ„ظ…ط­ط´ظٹط©'));for(var i=1;i<=15;i++)lines.add(LineItem('ط±ظ‚ط§ط¦ظ‚ ${i.toString().padLeft(2,'0')}','ط±ظ‚ط§ط¦ظ‚ ط§ظ„ط³ظ…ط¨ظˆط³ط©'));for(final c in categories.skip(2))for(var i=1;i<=5;i++)lines.add(LineItem('$c ${i.toString().padLeft(2,'0')}',c));}
  void changed()=>notifyListeners();
  void addLine(LineItem x){lines.add(x);notifyListeners();}
  void addProduction(ProductionEntry x,LineItem line){production.add(x);line.quantity+=x.quantity;notifyListeners();}
}

class GhawarApp extends StatefulWidget{const GhawarApp({super.key});@override State<GhawarApp> createState()=>_GhawarAppState();}
class _GhawarAppState extends State<GhawarApp>{final store=Store();@override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'ظ…طµظ†ط¹ ط؛ظˆط§ط±',theme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xff8d151b),fontFamily:null),builder:(context,child)=>Directionality(textDirection:TextDirection.rtl,child:child!),home:LoginPage(store));}


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
    }else{setState((){failures++;error=failures>=5?'ظ…ط­ط§ظˆظ„ط§طھ ط¯ط®ظˆظ„ ط®ط§ط·ط¦ط© ظ…طھط¹ط¯ط¯ط©. ط±ط§ط¬ط¹ ظ…ط¯ظٹط± ط§ظ„ط¨ط±ظ†ط§ظ…ط¬.':'ط§ط³ظ… ط§ظ„ظ…ط³طھط®ط¯ظ… ط£ظˆ ظƒظ„ظ…ط© ط§ظ„ظ…ط±ظˆط± ط؛ظٹط± طµط­ظٹط­ط©';});}
  }
  @override Widget build(BuildContext c)=>Scaffold(body:Directionality(textDirection:TextDirection.rtl,child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:430),child:Card(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
    const CircleAvatar(radius:42,backgroundColor:Color(0xff8d151b),child:Icon(Icons.factory,color:Colors.white,size:44)),const SizedBox(height:14),
    const Text('ط؛ظˆط§ط± ط§ظ„ط£طµظ„ظٹط©',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),const Text('ظ†ط¸ط§ظ… ط¥ط¯ط§ط±ط© ظ…طµظ†ط¹ ط§ظ„ظ…ط¹ط¬ظ†ط§طھ ظˆط§ظ„ط­ظ„ظˆظٹط§طھ'),const SizedBox(height:22),
    TextField(controller:user,decoration:const InputDecoration(labelText:'ط§ط³ظ… ط§ظ„ظ…ط³طھط®ط¯ظ…',border:OutlineInputBorder(),prefixIcon:Icon(Icons.person))),const SizedBox(height:12),
    TextField(controller:pass,obscureText:hide,onSubmitted:(_)=>login(),decoration:InputDecoration(labelText:'ظƒظ„ظ…ط© ط§ظ„ظ…ط±ظˆط±',border:const OutlineInputBorder(),prefixIcon:const Icon(Icons.lock),suffixIcon:IconButton(onPressed:()=>setState(()=>hide=!hide),icon:Icon(hide?Icons.visibility:Icons.visibility_off)))),
    if(error.isNotEmpty)...[const SizedBox(height:8),Text(error,style:const TextStyle(color:Colors.red))],const SizedBox(height:16),
    SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:login,icon:const Icon(Icons.login),label:const Padding(padding:EdgeInsets.all(12),child:Text('طھط³ط¬ظٹظ„ ط§ظ„ط¯ط®ظˆظ„')))),
    const SizedBox(height:10),const Text('ظ„ظ„ط§ط®طھط¨ط§ط± ط§ظ„ط£ظˆظ„ ظپظ‚ط·: admin / Ghawar@2026',style:TextStyle(fontSize:12,color:Colors.grey))
  ]))))))));
}

class Home extends StatefulWidget{const Home(this.store,{super.key});final Store store;@override State<Home> createState()=>_HomeState();}
class _HomeState extends State<Home>{int tab=0;@override Widget build(BuildContext c){final pages=[Dashboard(widget.store),LinesPage(widget.store),WarehousesPage(widget.store),ProductsPage(widget.store),ManagementPage(widget.store)];return Scaffold(appBar:AppBar(backgroundColor:const Color(0xff8d151b),foregroundColor:Colors.white,title:const Text('ط؛ظˆط§ط± ط§ظ„ط£طµظ„ظٹط© â€¢ ط¥ط¯ط§ط±ط© ط§ظ„ظ…طµظ†ط¹')),body:pages[tab],bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [NavigationDestination(icon:Icon(Icons.dashboard),label:'ط§ظ„ط±ط¦ظٹط³ظٹط©'),NavigationDestination(icon:Icon(Icons.precision_manufacturing),label:'ط§ظ„ط¥ظ†طھط§ط¬'),NavigationDestination(icon:Icon(Icons.warehouse),label:'ط§ظ„ظ…ط®ط²ظˆظ†'),NavigationDestination(icon:Icon(Icons.inventory_2),label:'ط§ظ„ط£طµظ†ط§ظپ'),NavigationDestination(icon:Icon(Icons.settings),label:'ط§ظ„ط¥ط¯ط§ط±ط©')]));}}

class Dashboard extends StatelessWidget {
  const Dashboard(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('ظ„ظˆط­ط© ط¥ط¯ط§ط±ط© ط§ظ„ظ…طµظ†ط¹', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        Wrap(spacing: 8, runSpacing: 8, children: [
          Stat('ط®ط·ظˆط· ط§ظ„ط¥ظ†طھط§ط¬', '${s.lines.length}', Icons.precision_manufacturing),
          Stat('ط§ظ„ظ…ط³طھظˆط¯ط¹ط§طھ', '${s.warehouses.length}', Icons.warehouse),
          Stat('ط§ظ„ظ…ط³طھط®ط¯ظ…ظˆظ†', '${s.users.length}', Icons.people),
          Stat('ط³ط¬ظ„ط§طھ ط§ظ„ط¥ظ†طھط§ط¬', '${s.production.length}', Icons.assignment),
        ]),
        const SizedBox(height: 15),
        const Text('ط£ظ‚ط³ط§ظ… ط§ظ„ط¥ظ†طھط§ط¬', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...s.categories.map((x) => Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.factory)),
            title: Text(x, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${s.lines.where((e) => e.category == x).length} ط®ط· ط¥ظ†طھط§ط¬'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => CategoryPage(s, x))),
          ),
        )),
      ],
    ),
  );
}
class Stat extends StatelessWidget{const Stat(this.t,this.v,this.i,{super.key});final String t,v;final IconData i;@override Widget build(BuildContext c)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(i),const SizedBox(width:8),Column(children:[Text(v,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text(t)])])));}
class CategoryPage extends StatelessWidget{const CategoryPage(this.s,this.cat,{super.key});final Store s;final String cat;@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(cat)),body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(children:s.lines.where((x)=>x.category==cat).map((x)=>ListTile(title:Text(x.name),subtitle:Text('ط§ظ„ظ…ط³ط¤ظˆظ„: ${x.manager} â€¢ ط§ظ„ط¥ظ†طھط§ط¬: ${x.quantity.toStringAsFixed(0)} ${x.unit}'),trailing:const Icon(Icons.chevron_left),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>LineDetails(s,x))))).toList())));}

class LinesPage extends StatefulWidget {
  const LinesPage(this.s, {super.key});
  final Store s;
  @override State<LinesPage> createState() => _LinesPageState();
}
class _LinesPageState extends State<LinesPage> {
  String filter = 'ط§ظ„ظƒظ„';
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: widget.s,
    builder: (_, __) {
      final list = filter == 'ط§ظ„ظƒظ„' ? widget.s.lines : widget.s.lines.where((x) => x.category == filter).toList();
      return ListView(padding: const EdgeInsets.all(12), children: [
        Row(children: [
          const Expanded(child: Text('ط®ط·ظˆط· ط§ظ„ط¥ظ†طھط§ط¬', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
          FilledButton.icon(onPressed: () => addLine(c), icon: const Icon(Icons.add), label: const Text('ط¥ط¶ط§ظپط© ط®ط·')),
        ]),
        DropdownButtonFormField<String>(
          value: filter,
          decoration: const InputDecoration(labelText: 'ط§ظ„ظ‚ط³ظ…'),
          items: [
            const DropdownMenuItem<String>(value: 'ط§ظ„ظƒظ„', child: Text('ظƒظ„ ط§ظ„ط£ظ‚ط³ط§ظ…')),
            ...widget.s.categories.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))),
          ],
          onChanged: (v) { if (v != null) setState(() => filter = v); },
        ),
        ...list.map((x) => Card(child: ListTile(
          title: Text(x.name), subtitle: Text('${x.category} â€¢ ${x.manager}'),
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
      title: const Text('ط¥ط¶ط§ظپط© ط®ط· ط¥ظ†طھط§ط¬'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'ط§ط³ظ… ط§ظ„ط®ط·')),
        DropdownButtonFormField<String>(
          value: cat,
          items: widget.s.categories.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(),
          onChanged: (v) { if (v != null) setD(() => cat = v); },
          decoration: const InputDecoration(labelText: 'ط§ظ„ظ‚ط³ظ…'),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text('ط¥ظ„ط؛ط§ط،')),
        FilledButton(onPressed: () { if (n.text.trim().isNotEmpty) widget.s.addLine(LineItem(n.text.trim(), cat)); Navigator.pop(d); }, child: const Text('ط­ظپط¸')),
      ],
    )));
  }
}

class LineDetails extends StatelessWidget{const LineDetails(this.s,this.line,{super.key});final Store s;final LineItem line;@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(line.name)),body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[Card(child:ListTile(title:Text(line.category),subtitle:Text('ط§ظ„ط­ط§ظ„ط©: ${line.status}\nط§ظ„ظ…ط³ط¤ظˆظ„: ${line.manager}\nط¥ط¬ظ…ط§ظ„ظٹ ط§ظ„ط¥ظ†طھط§ط¬: ${line.quantity.toStringAsFixed(0)} ${line.unit}'),isThreeLine:true)),FilledButton.icon(onPressed:()=>addProduction(c),icon:const Icon(Icons.add_chart),label:const Text('ط¥ط¶ط§ظپط© ظƒظ…ظٹط© ط¥ظ†طھط§ط¬')),const SizedBox(height:8),OutlinedButton.icon(onPressed:()=>editManager(c),icon:const Icon(Icons.person),label:const Text('طھط­ط¯ظٹط¯ ظ…ط¯ظٹط± / ظ…ط³ط¤ظˆظ„ ط§ظ„ط®ط·')),const SizedBox(height:16),const Text('ط³ط¬ظ„ ط¥ظ†طھط§ط¬ ط§ظ„ط®ط·',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),...s.production.where((e)=>e.line==line.name).map((e)=>Card(child:ListTile(title:Text(e.product),subtitle:Text('${e.quantity.toStringAsFixed(0)} ${e.unit} â€¢ ${e.date}'))))])));void addProduction(BuildContext c){final q=TextEditingController();final choices=s.products.where((p)=>p.category==line.category).map((p)=>p.name).toList();if(choices.isEmpty)choices.add('ط¥ظ†طھط§ط¬ ط¹ط§ظ…');String product=choices.first;showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('طھط³ط¬ظٹظ„ ظƒظ…ظٹط© ط¥ظ†طھط§ط¬'),content:Column(mainAxisSize:MainAxisSize.min,children:[DropdownButtonFormField(value:product,items:choices.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>setD(()=>product=v!),decoration:const InputDecoration(labelText:'ط§ظ„طµظ†ظپ')),TextField(controller:q,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'ط§ظ„ظƒظ…ظٹط©')),DropdownButtonFormField(value:line.unit,items:['ظƒط±طھظˆظ†','ظƒظٹط³','ط­ط¨ط©','ظƒط¬ظ…'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v){line.unit=v!;},decoration:const InputDecoration(labelText:'ط§ظ„ظˆط­ط¯ط©'))]),actions:[FilledButton(onPressed:(){final n=double.tryParse(q.text);if(n!=null&&n>0){final now=DateTime.now();s.addProduction(ProductionEntry(line.name,product,n,line.unit,'${now.year}/${now.month}/${now.day}'),line);Navigator.pop(d);}},child:const Text('ط­ظپط¸ ط§ظ„ظƒظ…ظٹط©'))])));}void editManager(BuildContext c){String manager=line.manager;final names=['ط؛ظٹط± ظ…ط­ط¯ط¯',...s.users.where((u)=>u.active).map((u)=>u.name)];showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('ظ…ط³ط¤ظˆظ„ ط§ظ„ط®ط·'),content:DropdownButtonFormField(value:names.contains(manager)?manager:'ط؛ظٹط± ظ…ط­ط¯ط¯',items:names.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>setD(()=>manager=v!),decoration:const InputDecoration(labelText:'ط§ط®طھط± ط§ظ„ظ…ط³ط¤ظˆظ„')),actions:[FilledButton(onPressed:(){line.manager=manager;s.changed();Navigator.pop(d);},child:const Text('ط­ظپط¸'))])));}}

class WarehousesPage extends StatelessWidget {
  const WarehousesPage(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('ط§ظ„ظ…ط³طھظˆط¯ط¹ط§طھ ظˆط§ظ„طھط­ظˆظٹظ„', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ...s.warehouses.map((w) => Card(child: ListTile(
          leading: const Icon(Icons.warehouse), title: Text(w.name),
          subtitle: Text('ط§ظ„ط±طµظٹط¯ ط§ظ„ط¹ط§ظ…: ${w.quantity.toStringAsFixed(0)}'),
          trailing: PopupMenuButton<int>(
            itemBuilder: (_) => const [
              PopupMenuItem<int>(value: 1, child: Text('ط¥ط¶ط§ظپط© ظƒظ…ظٹط©')),
              PopupMenuItem<int>(value: 2, child: Text('طھط­ظˆظٹظ„ ظ„ظ…ط³طھظˆط¯ط¹')),
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
      title: Text('ط¥ط¶ط§ظپط© ظƒظ…ظٹط© â€¢ ${w.name}'),
      content: TextField(controller: q, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ط§ظ„ظƒظ…ظٹط©')),
      actions: [FilledButton(onPressed: () { final n = double.tryParse(q.text); if (n != null) { w.quantity += n; s.changed(); } Navigator.pop(d); }, child: const Text('ط­ظپط¸'))],
    ));
  }
  void transfer(BuildContext c, Warehouse from) {
    final q = TextEditingController();
    Warehouse to = s.warehouses.firstWhere((x) => x != from, orElse: () => from);
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('طھط­ظˆظٹظ„ ط¨ظٹظ† ط§ظ„ظ…ط³طھظˆط¯ط¹ط§طھ'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<Warehouse>(
          value: to,
          items: s.warehouses.where((x) => x != from).map((x) => DropdownMenuItem<Warehouse>(value: x, child: Text(x.name))).toList(),
          onChanged: (v) { if (v != null) setD(() => to = v); },
          decoration: const InputDecoration(labelText: 'ط¥ظ„ظ‰'),
        ),
        TextField(controller: q, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ط§ظ„ظƒظ…ظٹط©')),
      ]),
      actions: [FilledButton(onPressed: () { final n = double.tryParse(q.text); if (n != null && n > 0 && from.quantity >= n) { from.quantity -= n; to.quantity += n; s.changed(); Navigator.pop(d); } }, child: const Text('طھط­ظˆظٹظ„'))],
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
        const Expanded(child: Text('ط§ظ„ط£طµظ†ط§ظپ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        FilledButton.icon(onPressed: () => add(c), icon: const Icon(Icons.add), label: const Text('ط¥ط¶ط§ظپط©')),
      ]),
      ...s.products.map((p) => Card(child: ListTile(title: Text(p.name), subtitle: Text('${p.category} â€¢ ${p.weight} â€¢ ${p.pack}')))),
    ]),
  );
  void add(BuildContext c) {
    final n = TextEditingController(); String cat = s.categories.first;
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('ط¥ط¶ط§ظپط© طµظ†ظپ'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'ط§ط³ظ… ط§ظ„طµظ†ظپ')),
        DropdownButtonFormField<String>(value: cat, items: s.categories.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setD(() => cat = v); }, decoration: const InputDecoration(labelText: 'ط§ظ„ظ‚ط³ظ…')),
      ]),
      actions: [FilledButton(onPressed: () { if (n.text.trim().isNotEmpty) { s.products.add(Product(n.text.trim(), cat, 'ظٹط­ط¯ط¯ ظ„ط§ط­ظ‚ط§ظ‹')); s.changed(); } Navigator.pop(d); }, child: const Text('ط­ظپط¸'))],
    )));
  }
}

class ManagementPage extends StatelessWidget{const ManagementPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(12),children:[const Text('ط§ظ„ط¥ط¯ط§ط±ط© ظˆط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),Tile('ط§ظ„ظ…ط³طھط®ط¯ظ…ظˆظ† ظˆط§ظ„طµظ„ط§ط­ظٹط§طھ',Icons.manage_accounts,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>UsersPage(s)))),Tile('ط§ظ„ظ…ظˆط§ط¯ ط§ظ„ط®ط§ظ…',Icons.grain,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RawMaterialsPage(s)))),Tile('ط§ظ„ظ…ظˆط±ط¯ظˆظ†',Icons.local_shipping,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>SuppliersPage(s)))),Tile('ط§ظ„ط·ط§ط¨ط¹ط§طھ ظˆ Wiâ€‘Fi ظˆ Bluetooth',Icons.print,()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>PrintersPage(s))))]);}
class Tile extends StatelessWidget{const Tile(this.t,this.i,this.tap,{super.key});final String t;final IconData i;final VoidCallback tap;@override Widget build(BuildContext c)=>Card(child:ListTile(leading:Icon(i),title:Text(t),trailing:const Icon(Icons.chevron_left),onTap:tap));}

class UsersPage extends StatelessWidget{const UsersPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('ط§ظ„ظ…ط³طھط®ط¯ظ…ظˆظ† ظˆط§ظ„طµظ„ط§ط­ظٹط§طھ')),body:ListView(padding:const EdgeInsets.all(12),children:[FilledButton.icon(onPressed:()=>add(c),icon:const Icon(Icons.person_add),label:const Text('ط¥ط¶ط§ظپط© ظ…ط³طھط®ط¯ظ… / ظ…ط¯ظٹط±')),...s.users.map((u)=>Card(child:SwitchListTile(value:u.active,onChanged:(v){u.active=v;s.changed();},title:Text(u.name),subtitle:Text('${u.role}\nط§ظ„طµظ„ط§ط­ظٹط§طھ: ${u.permissions.isEmpty?'ظ„ظ… طھط­ط¯ط¯':u.permissions.join('طŒ ')}'),secondary:const Icon(Icons.manage_accounts))))])));void add(BuildContext c){final n=TextEditingController(),un=TextEditingController(),pw=TextEditingController();String role='ظ…ط³ط¤ظˆظ„';final roles=['ظ…ط¯ظٹط± ط±ط¦ظٹط³ظٹ','ظ…ط¯ظٹط± طھطµظ†ظٹط¹','ظ…ط¯ظٹط± ظ‚ط³ظ…','ظ…ط³ط¤ظˆظ„ ظ…ط³طھظˆط¯ط¹','ظ…ط³ط¤ظˆظ„ ط¹ظ…ط§ظ„','ظ…ظ†ط¯ظˆط¨','ظ…ط³ط¤ظˆظ„'];final all=['ط§ظ„ط¥ظ†طھط§ط¬','ط§ظ„ظ…ط³طھظˆط¯ط¹ط§طھ','ط§ظ„ط£طµظ†ط§ظپ','ط§ظ„ظ…ط³طھط®ط¯ظ…ظˆظ†','ط§ظ„ظ…ظˆط±ط¯ظˆظ†','ط§ظ„ط·ط§ط¨ط¹ط§طھ'];final selected=<String>[];showDialog(context:c,builder:(d)=>StatefulBuilder(builder:(d,setD)=>AlertDialog(title:const Text('ط¥ط¶ط§ظپط© ظ…ط³طھط®ط¯ظ… / ظ…ط¯ظٹط±'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'ط§ظ„ط§ط³ظ… ط§ظ„ظƒط§ظ…ظ„')),TextField(controller:un,decoration:const InputDecoration(labelText:'ط§ط³ظ… ط§ظ„ط¯ط®ظˆظ„')),TextField(controller:pw,obscureText:true,decoration:const InputDecoration(labelText:'ظƒظ„ظ…ط© ط§ظ„ظ…ط±ظˆط±')),DropdownButtonFormField(value:role,items:roles.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>setD(()=>role=v!),decoration:const InputDecoration(labelText:'ط§ظ„ط¯ظˆط±')),...all.map((p)=>CheckboxListTile(value:selected.contains(p),title:Text(p),onChanged:(v)=>setD(()=>v!?selected.add(p):selected.remove(p))))])),actions:[FilledButton(onPressed:(){if(n.text.trim().isNotEmpty){s.users.add(UserItem(n.text.trim(),role,username:un.text.trim(),password:pw.text,permissions:List.of(selected)));s.changed();}Navigator.pop(d);},child:const Text('ط­ظپط¸'))])));}}

class RawMaterialsPage extends StatelessWidget{const RawMaterialsPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('ط§ظ„ظ…ظˆط§ط¯ ط§ظ„ط®ط§ظ…')),floatingActionButton:FloatingActionButton(onPressed:()=>add(c),child:const Icon(Icons.add)),body:ListView(children:s.rawMaterials.map((x)=>ListTile(title:Text(x.name),subtitle:Text('${x.quantity} ${x.unit}'))).toList())));void add(BuildContext c){final n=TextEditingController(),q=TextEditingController();showDialog(context:c,builder:(d)=>AlertDialog(title:const Text('ط¥ط¶ط§ظپط© ظ…ط§ط¯ط© ط®ط§ظ…'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'ط§ظ„ظ…ط§ط¯ط©')),TextField(controller:q,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'ط§ظ„ظƒظ…ظٹط©'))]),actions:[FilledButton(onPressed:(){final v=double.tryParse(q.text)??0;if(n.text.isNotEmpty){s.rawMaterials.add(RawMaterial(n.text,v,'ظƒط¬ظ…'));s.changed();}Navigator.pop(d);},child:const Text('ط­ظپط¸'))]));}}
class SuppliersPage extends StatelessWidget{const SuppliersPage(this.s,{super.key});final Store s;@override Widget build(BuildContext c)=>AnimatedBuilder(animation:s,builder:(_,__)=>Scaffold(appBar:AppBar(title:const Text('ط§ظ„ظ…ظˆط±ط¯ظˆظ†')),floatingActionButton:FloatingActionButton(onPressed:()=>add(c),child:const Icon(Icons.add)),body:ListView(children:s.suppliers.map((x)=>ListTile(title:Text(x.name),subtitle:Text(x.phone))).toList())));void add(BuildContext c){final n=TextEditingController(),p=TextEditingController();showDialog(context:c,builder:(d)=>AlertDialog(title:const Text('ط¥ط¶ط§ظپط© ظ…ظˆط±ط¯'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:n,decoration:const InputDecoration(labelText:'ط§ط³ظ… ط§ظ„ظ…ظˆط±ط¯')),TextField(controller:p,decoration:const InputDecoration(labelText:'ط±ظ‚ظ… ط§ظ„طھظˆط§طµظ„'))]),actions:[FilledButton(onPressed:(){if(n.text.isNotEmpty){s.suppliers.add(Supplier(n.text,p.text));s.changed();}Navigator.pop(d);},child:const Text('ط­ظپط¸'))]));}}

class PrintersPage extends StatelessWidget {
  const PrintersPage(this.s, {super.key});
  final Store s;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: s,
    builder: (_, __) => Scaffold(
      appBar: AppBar(title: const Text('ط§ظ„ط·ط§ط¨ط¹ط§طھ ظˆط§ظ„ط§طھطµط§ظ„')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => add(c), icon: const Icon(Icons.add), label: const Text('ط¥ط¶ط§ظپط© ط·ط§ط¨ط¹ط©')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('ط¥ط¹ط¯ط§ط¯ط§طھ ط§ظ„ط§طھطµط§ظ„'), subtitle: Text('ظٹظ…ظƒظ† طھط³ط¬ظٹظ„ ط·ط§ط¨ط¹ط© Bluetooth ط£ظˆ ط·ط§ط¨ط¹ط© Wiâ€‘Fi / ط´ط¨ظƒط©. ط§ظ„ط§طھطµط§ظ„ ظˆط§ظ„ط·ط¨ط§ط¹ط© ط§ظ„ظپط¹ظ„ظٹط© طھطھط·ظ„ط¨ ط­ط²ظ…ط© ظ…طھظˆط§ظپظ‚ط© ظ…ط¹ ظ…ظˆط¯ظٹظ„ ط§ظ„ط·ط§ط¨ط¹ط© ظˆطµظ„ط§ط­ظٹط§طھ Android.'))),
        ...s.printers.map((p) => Card(child: SwitchListTile(
          value: p.connected, onChanged: (v) { p.connected = v; s.changed(); },
          secondary: Icon(p.type == 'Bluetooth' ? Icons.bluetooth : Icons.wifi),
          title: Text(p.name), subtitle: Text('${p.type} â€¢ ${p.address.isEmpty ? 'ط¨ط¯ظˆظ† ط¹ظ†ظˆط§ظ†' : p.address}'),
        ))),
      ]),
    ),
  );
  void add(BuildContext c) {
    final n = TextEditingController(), a = TextEditingController(); String type = 'Wiâ€‘Fi';
    showDialog(context: c, builder: (d) => StatefulBuilder(builder: (d, setD) => AlertDialog(
      title: const Text('ط¥ط¶ط§ظپط© ط·ط§ط¨ط¹ط©'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'ط§ط³ظ… ط§ظ„ط·ط§ط¨ط¹ط©')),
        DropdownButtonFormField<String>(value: type, items: ['Wiâ€‘Fi','Bluetooth'].map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setD(() => type = v); }, decoration: const InputDecoration(labelText: 'ظ†ظˆط¹ ط§ظ„ط§طھطµط§ظ„')),
        TextField(controller: a, decoration: InputDecoration(labelText: type == 'Wiâ€‘Fi' ? 'IP / ط¹ظ†ظˆط§ظ† ط§ظ„ط´ط¨ظƒط©' : 'ط§ط³ظ… ط£ظˆ ط¹ظ†ظˆط§ظ† Bluetooth')),
      ]),
      actions: [FilledButton(onPressed: () { if (n.text.isNotEmpty) { s.printers.add(PrinterItem(n.text, type, address: a.text)); s.changed(); } Navigator.pop(d); }, child: const Text('ط­ظپط¸'))],
    )));
  }
}
