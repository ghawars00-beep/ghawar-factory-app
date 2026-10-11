
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = Store();
  await store.load();
  runApp(GhawarApp(store: store));
}

const red = Color(0xFF8B1118);
const gold = Color(0xFFC7A34B);
const bg = Color(0xFFF7F3EC);

class User {
  User(this.name,this.username,this.password,this.role,{this.admin=false,this.active=true,List<String>? permissions,List<String>? sections})
      : permissions=permissions??[], sections=sections??[];
  String name,username,password,role;
  bool admin,active;
  List<String> permissions,sections;
  bool can(String p)=>admin||permissions.contains('الكل')||permissions.contains(p);
  bool section(String s)=>admin||sections.contains('الكل')||sections.contains(s);
}

class Section {
  Section(this.name,this.color);
  String name; int color;
}

class Line {
  Line(this.name,this.section,{this.status='جاهز',this.manager='غير محدد',this.product='غير محدد',
    this.qty=0,this.target=0,this.unit='كرتون',this.recipe='',this.notes='',this.image='',this.color=0xFF8B1118});
  String name,section,status,manager,product,unit,recipe,notes,image;
  double qty,target; int color;
}

class Store extends ChangeNotifier {
  final sections=<Section>[
    Section('السمبوسة المحشية',0xFFB71C1C), Section('رقائق السمبوسة',0xFFE65100),
    Section('الكنافة',0xFF9A7B00), Section('خبز المرقوق',0xFF5D4037),
    Section('القرصان',0xFF6A1B9A), Section('اللحوح',0xFF00695C),
  ];
  final lines=<Line>[];
  final users=<User>[
    User('مدير التطبيق الرئيسي','admin','Ghawar@2026','مدير التطبيق',admin:true,permissions:['الكل'],sections:['الكل'])
  ];
  final warehouses=['الثلاجة المركزية','ثلاجة المصنع','المستودع الخارجي','مستودع المعمل'];
  final products=[
    'سمبوسة محشية بالجبن السائل','سمبوسة محشية باللحم','سمبوسة محشية بالدجاج',
    'سمبوسة محشية بالجبن الأبيض فيتا','سمبوسة محشية بالجبن الشدر',
    'سمبوسة محشية باللحم حراق','سمبوسة محشية بالدجاج حراق',
    'رقائق سمبوسة غوار مقرمش 800 جرام','رقائق سمبوسة غوار بر 800 جرام',
    'رقائق سمبوسة غوار فاخرة 800 جرام','رقائق سمبوسة غوار فاخرة ميني 800 جرام',
    'رقائق غوار مدور 400 جرام','رقائق غوار مثلث 400 جرام','رقائق غوار مطبق 800 جرام',
    'رقائق سمبوسة ريفي 500 جرام','رقائق سمبوسة ميتاف 500 جرام','رقائق سمبوسة سابوسا 800 جرام'
  ];
  final raw=['دقيق','زيت','جبن فيتا','جبن شدر','لحم مفروم','دجاج','بهارات','أكياس','كراتين'];
  final logs=<String>[];
  final tickets=<String>[];
  User? current;
  int failures=0; DateTime? lockedUntil;

  Future<void> load() async {
    for(int i=1;i<=100;i++) lines.add(Line('خط ${i.toString().padLeft(3,'0')}','السمبوسة المحشية',color:0xFFB71C1C));
    for(int i=1;i<=15;i++) lines.add(Line('خط ${i.toString().padLeft(2,'0')}','رقائق السمبوسة',color:0xFFE65100));
    for(final s in sections.skip(2)) for(int i=1;i<=5;i++) lines.add(Line('خط ${i.toString().padLeft(2,'0')}',s.name,color:s.color));
    final p=await SharedPreferences.getInstance();
    final pw=p.getString('admin_password');
    if(pw!=null&&pw.isNotEmpty) users.first.password=pw;
  }
  String? login(String u,String p){
    if(lockedUntil!=null&&DateTime.now().isBefore(lockedUntil!)) return 'الدخول مقفل مؤقتاً بعد محاولات خاطئة.';
    User? x;
    for(final a in users){if(a.username.toLowerCase()==u.trim().toLowerCase()){x=a;break;}}
    if(x==null||!x.active||x.password!=p){
      failures++; logs.insert(0,'فشل دخول: ${u.trim()} • ${DateTime.now()}');
      if(failures>=5){lockedUntil=DateTime.now().add(const Duration(minutes:1));failures=0;}
      notifyListeners(); return 'بيانات الدخول غير صحيحة أو الحساب موقوف.';
    }
    current=x; failures=0; lockedUntil=null; logs.insert(0,'دخول ناجح: ${x.username} • ${DateTime.now()}'); notifyListeners(); return null;
  }
  void logout(){logs.insert(0,'خروج: ${current?.username} • ${DateTime.now()}');current=null;notifyListeners();}
  bool can(String p)=>current?.can(p)??false;
  bool canSection(String s)=>current?.section(s)??false;
  void changed(){notifyListeners();}
  Future<void> changeAdminPassword(String p) async {users.first.password=p;final sp=await SharedPreferences.getInstance();await sp.setString('admin_password',p);notifyListeners();}
}

class GhawarApp extends StatelessWidget {
  const GhawarApp({super.key,required this.store}); final Store store;
  @override Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner:false, locale:const Locale('ar'), title:'غوار الأصلية',
    theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:red),scaffoldBackgroundColor:bg,
      appBarTheme:const AppBarTheme(backgroundColor:red,foregroundColor:Colors.white)),
    home:Directionality(textDirection:TextDirection.rtl,child:AnimatedBuilder(animation:store,builder:(_,__)=>store.current==null?Login(store):Home(store)))
  );
}

class Login extends StatefulWidget {const Login(this.s,{super.key});final Store s;@override State<Login> createState()=>_Login();}
class _Login extends State<Login>{
  final u=TextEditingController(),p=TextEditingController(); String? error; bool hide=true;
  @override Widget build(BuildContext context)=>Scaffold(body:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),
    child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:450),child:Card(child:Padding(padding:const EdgeInsets.all(24),child:Column(children:[
      Image.asset('assets/images/ghawar_logo.png',height:100,errorBuilder:(_,__,___)=>const CircleAvatar(radius:48,backgroundColor:red,child:Icon(Icons.factory,color:gold,size:48))),
      const SizedBox(height:8),const Text('غوار الأصلية',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
      const Text('نظام إدارة مصنع المعجنات والحلويات'),const SizedBox(height:22),
      TextField(controller:u,decoration:const InputDecoration(labelText:'اسم المستخدم',prefixIcon:Icon(Icons.person),border:OutlineInputBorder())),
      const SizedBox(height:12),TextField(controller:p,obscureText:hide,onSubmitted:(_)=>go(),decoration:InputDecoration(labelText:'كلمة المرور',prefixIcon:const Icon(Icons.lock),border:const OutlineInputBorder(),suffixIcon:IconButton(onPressed:()=>setState(()=>hide=!hide),icon:Icon(hide?Icons.visibility:Icons.visibility_off)))),
      if(error!=null)...[const SizedBox(height:8),Text(error!,style:const TextStyle(color:Colors.red),textAlign:TextAlign.center)],
      const SizedBox(height:16),SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:go,icon:const Icon(Icons.login),label:const Text('تسجيل الدخول')))
    ])))))));
  void go()=>setState(()=>error=widget.s.login(u.text,p.text));
}

class Home extends StatefulWidget {const Home(this.s,{super.key});final Store s;@override State<Home> createState()=>_Home();}
class _Home extends State<Home>{
  int i=0;
  @override Widget build(BuildContext context){
    final s=widget.s;
    final pages=[Dashboard(s),s.can('الإنتاج')?AllLines(s):const Locked(),s.can('المستودعات')?Warehouses(s):const Locked(),s.can('الأصناف')?Products(s):const Locked(),More(s)];
    return Scaffold(appBar:AppBar(title:Text('غوار الأصلية • ${s.current!.name}'),actions:[IconButton(onPressed:s.logout,icon:const Icon(Icons.logout))]),
      body:pages[i],bottomNavigationBar:NavigationBar(selectedIndex:i,onDestinationSelected:(v)=>setState(()=>i=v),destinations:const[
        NavigationDestination(icon:Icon(Icons.home),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.precision_manufacturing),label:'الإنتاج'),
        NavigationDestination(icon:Icon(Icons.warehouse),label:'المخزون'),NavigationDestination(icon:Icon(Icons.inventory_2),label:'الأصناف'),
        NavigationDestination(icon:Icon(Icons.settings),label:'المزيد')]));
  }
}
class Locked extends StatelessWidget{const Locked({super.key});@override Widget build(BuildContext context)=>const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.lock,size:52),Text('هذا القسم غير مسموح لهذا المستخدم') ]));}

class Dashboard extends StatelessWidget{
  const Dashboard(this.s,{super.key});final Store s;
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(14),children:[
    Text('مرحباً ${s.current!.name}',style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)),Text('الدور: ${s.current!.role}'),const SizedBox(height:12),
    Wrap(spacing:8,runSpacing:8,children:[stat('خطوط الإنتاج','${s.lines.length}',Icons.precision_manufacturing),stat('المستودعات','${s.warehouses.length}',Icons.warehouse),stat('المستخدمون','${s.users.length}',Icons.people),stat('بلاغات الدعم','${s.tickets.length}',Icons.support_agent)]),
    const SizedBox(height:16),Row(children:[const Expanded(child:Text('أقسام الإنتاج',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold))),
      if(s.current!.admin||s.can('إضافة قسم'))IconButton(onPressed:()=>addSection(context,s),icon:const Icon(Icons.add_circle))]),
    ...s.sections.map((x){final ok=s.can('الإنتاج')&&s.canSection(x.name);final n=s.lines.where((l)=>l.section==x.name).length;
      return Card(child:ListTile(leading:CircleAvatar(backgroundColor:ok?Color(x.color):Colors.grey,child:Icon(ok?Icons.factory:Icons.lock,color:Colors.white)),title:Text(x.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('$n خط إنتاج'),
        trailing:Icon(ok?Icons.chevron_left:Icons.lock_outline),onTap:ok?()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>SectionLines(s,x.name))):()=>denied(context)));})
  ]));
  Widget stat(String a,String b,IconData i)=>SizedBox(width:165,child:Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(children:[Icon(i),Text(b,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text(a)]))));
}

class SectionLines extends StatelessWidget{
  const SectionLines(this.s,this.section,{super.key});final Store s;final String section;
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(section)),
    floatingActionButton:(s.current!.admin||s.can('إضافة خط إنتاج'))?FloatingActionButton.extended(onPressed:()=>addLine(context,s,section),icon:const Icon(Icons.add),label:const Text('خط إنتاج')):null,
    body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(12),children:s.lines.where((l)=>l.section==section).map((l)=>LineTile(s,l)).toList())));
}
class AllLines extends StatelessWidget{const AllLines(this.s,{super.key});final Store s;@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(12),children:s.lines.where((l)=>s.canSection(l.section)).map((l)=>LineTile(s,l)).toList());}
class LineTile extends StatelessWidget{
  const LineTile(this.s,this.l,{super.key});final Store s;final Line l;
  @override Widget build(BuildContext context){final pr=l.target<=0?0.0:(l.qty/l.target).clamp(0.0,1.0);return Card(child:InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>LineDetails(s,l))),child:Padding(padding:const EdgeInsets.all(12),child:Row(children:[
    Container(width:68,height:68,decoration:BoxDecoration(color:Color(l.color).withOpacity(.12),borderRadius:BorderRadius.circular(12)),child:Icon(Icons.precision_manufacturing,color:Color(l.color),size:35)),const SizedBox(width:12),
    Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(l.name,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:17)),Text('${l.status} • ${l.manager}'),Text('${l.qty.toStringAsFixed(0)} / ${l.target.toStringAsFixed(0)} ${l.unit}'),const SizedBox(height:5),LinearProgressIndicator(value:pr)])),const Icon(Icons.chevron_left)
  ]))));}
}
class LineDetails extends StatefulWidget{const LineDetails(this.s,this.l,{super.key});final Store s;final Line l;@override State<LineDetails> createState()=>_LineDetails();}
class _LineDetails extends State<LineDetails>{
  @override Widget build(BuildContext context){final l=widget.l,s=widget.s,edit=s.current!.admin||s.can('تعديل خطوط الإنتاج');return Scaffold(appBar:AppBar(title:Text('${l.section} • ${l.name}'),actions:[if(edit)IconButton(onPressed:()=>editLine(context,s,l),icon:const Icon(Icons.edit))]),
    body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[
      Container(height:150,decoration:BoxDecoration(color:Color(l.color).withOpacity(.13),borderRadius:BorderRadius.circular(18)),child:Icon(Icons.factory,size:70,color:Color(l.color))),
      const SizedBox(height:12),detail('القسم',l.section),detail('حالة الخط',l.status),detail('المسؤول',l.manager),detail('الصنف المنتج',l.product),
      detail('الإنتاج الحالي','${l.qty} ${l.unit}'),detail('الهدف','${l.target} ${l.unit}'),detail('الوصفة والمقادير',l.recipe.isEmpty?'لم تسجل بعد':l.recipe),detail('الملاحظات',l.notes.isEmpty?'لا توجد':l.notes),
      if(edit)FilledButton.icon(onPressed:()=>editLine(context,s,l),icon:const Icon(Icons.edit),label:const Text('تعديل تفاصيل الخط'))
    ])));
  }
  Widget detail(String a,String b)=>Card(child:ListTile(title:Text(a),subtitle:Text(b)));
}

class Warehouses extends StatelessWidget{const Warehouses(this.s,{super.key});final Store s;@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(12),children:[
  const Text('المستودعات والتحويلات',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),...s.warehouses.map((w)=>Card(child:ListTile(leading:const Icon(Icons.warehouse),title:Text(w),subtitle:const Text('مخزون مستقل • التحويل بين المستودعات متاح'),trailing:const Icon(Icons.chevron_left))))
]);}
class Products extends StatelessWidget{const Products(this.s,{super.key});final Store s;@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(12),children:[
  const Text('الأصناف',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),...s.products.map((p)=>Card(child:ListTile(leading:const Icon(Icons.inventory_2),title:Text(p),subtitle:Text(p.contains('محشية')?'100 حبة/كيس • 5 أكياس/كرتون':'20 كيس/كرتون'))))
]);}

class More extends StatelessWidget{
  const More(this.s,{super.key});final Store s;
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(12),children:[
    if(s.current!.admin||s.can('المستخدمون'))menu(context,'المستخدمون والصلاحيات',Icons.admin_panel_settings,Users(s)),
    if(s.current!.admin||s.can('المواد الخام'))menu(context,'المواد الخام',Icons.grain,SimpleList('المواد الخام',s.raw)),
    if(s.current!.admin||s.can('الطابعات'))menu(context,'الطابعات وBluetooth وWi-Fi',Icons.print,ConnectivityPage()),
    menu(context,'المشاركة وواتساب',Icons.share,SharePage()),
    menu(context,'الدعم الفني',Icons.support_agent,Support(s)),
    if(s.current!.admin)menu(context,'الأمان وسجل الدخول',Icons.security,Security(s)),
    if(s.current!.admin)menu(context,'إعدادات المدير',Icons.settings,AdminSettings(s)),
  ]);
  Widget menu(BuildContext c,String t,IconData i,Widget p)=>Card(child:ListTile(leading:Icon(i),title:Text(t),trailing:const Icon(Icons.chevron_left),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p))));
}
class SimpleList extends StatelessWidget{const SimpleList(this.title,this.items,{super.key});final String title;final List<String> items;@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(title)),body:ListView(children:items.map((x)=>ListTile(leading:const Icon(Icons.circle,size:12),title:Text(x))).toList()));}

const permissions=['الإنتاج','تسجيل الإنتاج','إضافة خط إنتاج','تعديل خطوط الإنتاج','المستودعات','التحويلات','الأصناف','المواد الخام','الموردون','المستخدمون','الطابعات','التقارير','المشاركة'];
class Users extends StatelessWidget{
  const Users(this.s,{super.key});final Store s;
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('المستخدمون والصلاحيات')),floatingActionButton:FloatingActionButton.extended(onPressed:()=>userDialog(context,s),icon:const Icon(Icons.person_add),label:const Text('مسؤول')),
    body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(12),children:s.users.map((u)=>Card(child:ListTile(leading:CircleAvatar(child:Icon(u.admin?Icons.verified_user:Icons.person)),title:Text(u.name),subtitle:Text('${u.role} • ${u.active?'نشط':'موقوف'}\nالأقسام: ${u.admin?'الكل':u.sections.join('، ')}'),isThreeLine:true,trailing:u.admin?const Icon(Icons.lock):const Icon(Icons.edit),onTap:u.admin?null:()=>userDialog(context,s,existing:u)))).toList())));
}

class ConnectivityPage extends StatelessWidget{
  const ConnectivityPage({super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('الطابعات والاتصال')),body:ListView(padding:const EdgeInsets.all(12),children:const[
    Card(child:ListTile(leading:Icon(Icons.bluetooth),title:Text('Bluetooth'),subtitle:Text('إعداد طابعة بلوتوث وحفظ اسم/عنوان الجهاز'))),
    Card(child:ListTile(leading:Icon(Icons.wifi),title:Text('Wi-Fi'),subtitle:Text('إعداد طابعة شبكة عبر عنوان IP'))),
    Card(child:ListTile(leading:Icon(Icons.print),title:Text('الطباعة'),subtitle:Text('واجهة إعداد للطابعة. التشغيل الفعلي يعتمد على موديل وبروتوكول الطابعة.')))
  ]));}
class SharePage extends StatelessWidget{
  const SharePage({super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('المشاركة')),body:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
    SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:()=>Share.share('غوار الأصلية - نظام إدارة المصنع'),icon:const Icon(Icons.share),label:const Text('مشاركة عبر التطبيقات'))),
    const SizedBox(height:12),SizedBox(width:double.infinity,child:OutlinedButton.icon(onPressed:()async{final u=Uri.parse('https://wa.me/?text=${Uri.encodeComponent('غوار الأصلية - نظام إدارة المصنع')}');await launchUrl(u,mode:LaunchMode.externalApplication);},icon:const Icon(Icons.chat),label:const Text('واتساب')))
  ])));}
class Support extends StatefulWidget{const Support(this.s,{super.key});final Store s;@override State<Support> createState()=>_Support();}
class _Support extends State<Support>{
  final title=TextEditingController(),details=TextEditingController();
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('الدعم الفني')),body:ListView(padding:const EdgeInsets.all(16),children:[
    TextField(controller:title,decoration:const InputDecoration(labelText:'عنوان المشكلة',border:OutlineInputBorder())),const SizedBox(height:10),
    TextField(controller:details,maxLines:4,decoration:const InputDecoration(labelText:'تفاصيل المشكلة',border:OutlineInputBorder())),const SizedBox(height:10),
    FilledButton.icon(onPressed:(){if(title.text.trim().isEmpty)return;widget.s.tickets.insert(0,'${title.text.trim()} • ${widget.s.current!.name} • جديد');widget.s.changed();title.clear();details.clear();setState((){});},icon:const Icon(Icons.send),label:const Text('إنشاء بلاغ')),
    const Divider(),...widget.s.tickets.map((x)=>ListTile(leading:const Icon(Icons.confirmation_number),title:Text(x)))
  ]));}
class Security extends StatelessWidget{const Security(this.s,{super.key});final Store s;@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('الأمان وسجل الدخول')),body:AnimatedBuilder(animation:s,builder:(_,__)=>ListView(padding:const EdgeInsets.all(12),children:[
  Card(child:ListTile(leading:const Icon(Icons.shield),title:const Text('حماية الدخول'),subtitle:const Text('تسجيل المحاولات + قفل مؤقت بعد 5 محاولات خاطئة'))),
  ...s.logs.map((x)=>ListTile(leading:const Icon(Icons.history),title:Text(x)))
])));}
class AdminSettings extends StatefulWidget{const AdminSettings(this.s,{super.key});final Store s;@override State<AdminSettings> createState()=>_AdminSettings();}
class _AdminSettings extends State<AdminSettings>{final p=TextEditingController();@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('إعدادات المدير')),body:ListView(padding:const EdgeInsets.all(16),children:[
  const Text('تغيير كلمة مرور مدير التطبيق',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:8),TextField(controller:p,obscureText:true,decoration:const InputDecoration(border:OutlineInputBorder(),labelText:'كلمة المرور الجديدة')),
  const SizedBox(height:10),FilledButton(onPressed:()async{if(p.text.length<8){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('استخدم 8 أحرف على الأقل')));return;}await widget.s.changeAdminPassword(p.text);if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم تغيير كلمة المرور')));},child:const Text('حفظ'))
]));}

Future<void> addSection(BuildContext c,Store s) async{
  final n=TextEditingController();int color=0xFF8B1118;
  await showDialog(context:c,builder:(ctx)=>AlertDialog(title:const Text('إضافة قسم'),content:TextField(controller:n,decoration:const InputDecoration(labelText:'اسم القسم')),actions:[
    TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('إلغاء')),FilledButton(onPressed:(){if(n.text.trim().isNotEmpty){s.sections.add(Section(n.text.trim(),color));s.changed();Navigator.pop(ctx);}},child:const Text('إضافة'))]));
}
Future<void> addLine(BuildContext c,Store s,String section) async{
  final n=TextEditingController(text:'خط ${(s.lines.where((x)=>x.section==section).length+1).toString().padLeft(2,'0')}');
  await showDialog(context:c,builder:(ctx)=>AlertDialog(title:const Text('إضافة خط إنتاج'),content:TextField(controller:n,decoration:const InputDecoration(labelText:'اسم/رقم الخط')),actions:[
    TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('إلغاء')),FilledButton(onPressed:(){if(n.text.trim().isNotEmpty){final sc=s.sections.firstWhere((x)=>x.name==section);s.lines.add(Line(n.text.trim(),section,color:sc.color));s.changed();Navigator.pop(ctx);}},child:const Text('إضافة'))]));
}
Future<void> editLine(BuildContext c,Store s,Line l) async{
  final manager=TextEditingController(text:l.manager),product=TextEditingController(text:l.product),qty=TextEditingController(text:'${l.qty}'),target=TextEditingController(text:'${l.target}'),recipe=TextEditingController(text:l.recipe),notes=TextEditingController(text:l.notes);
  String status=l.status;int color=l.color;
  await showDialog(context:c,builder:(ctx)=>StatefulBuilder(builder:(ctx,setD)=>AlertDialog(title:Text('تعديل ${l.name}'),content:SizedBox(width:500,child:SingleChildScrollView(child:Column(children:[
    TextField(controller:manager,decoration:const InputDecoration(labelText:'المسؤول')),TextField(controller:product,decoration:const InputDecoration(labelText:'الصنف المنتج')),
    Row(children:[Expanded(child:TextField(controller:qty,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'الكمية'))),const SizedBox(width:8),Expanded(child:TextField(controller:target,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'الهدف')))]),
    DropdownButtonFormField<String>(value:status,items:['جاهز','يعمل','تجهيز','متوقف','صيانة'].map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(v)=>status=v??status,decoration:const InputDecoration(labelText:'الحالة')),
    TextField(controller:recipe,maxLines:3,decoration:const InputDecoration(labelText:'الوصفة والمقادير')),TextField(controller:notes,maxLines:2,decoration:const InputDecoration(labelText:'الملاحظات')),
    const SizedBox(height:8),const Align(alignment:Alignment.centerRight,child:Text('لون الخط')),Wrap(children:[0xFFB71C1C,0xFFE65100,0xFF2E7D32,0xFF1565C0,0xFF6A1B9A,0xFFC7A34B,0xFF616161].map((v)=>IconButton(onPressed:()=>setD(()=>color=v),icon:Icon(v==color?Icons.check_circle:Icons.circle,color:Color(v)))).toList()),
    const ListTile(leading:Icon(Icons.image),title:Text('صورة خط الإنتاج'),subtitle:Text('حقل الصورة موجود في بيانات الخط؛ يمكن ربط اختيار الصور المحلية حسب منصة التشغيل.'))
  ]))),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('إلغاء')),FilledButton(onPressed:(){l.manager=manager.text;l.product=product.text;l.qty=double.tryParse(qty.text)??0;l.target=double.tryParse(target.text)??0;l.status=status;l.recipe=recipe.text;l.notes=notes.text;l.color=color;s.changed();Navigator.pop(ctx);},child:const Text('حفظ'))])));
}
Future<void> userDialog(BuildContext c,Store s,{User? existing}) async{
  final name=TextEditingController(text:existing?.name??''),username=TextEditingController(text:existing?.username??''),password=TextEditingController(text:existing?.password??''),role=TextEditingController(text:existing?.role??'مسؤول');
  final ps=<String>{...?existing?.permissions},ss=<String>{...?existing?.sections};bool active=existing?.active??true;
  await showDialog(context:c,builder:(ctx)=>StatefulBuilder(builder:(ctx,setD)=>AlertDialog(title:Text(existing==null?'إضافة مسؤول':'تعديل المسؤول'),content:SizedBox(width:560,child:SingleChildScrollView(child:Column(children:[
    TextField(controller:name,decoration:const InputDecoration(labelText:'الاسم')),TextField(controller:username,decoration:const InputDecoration(labelText:'اسم المستخدم')),TextField(controller:password,decoration:const InputDecoration(labelText:'كلمة المرور')),TextField(controller:role,decoration:const InputDecoration(labelText:'المسمى الوظيفي')),
    SwitchListTile(value:active,onChanged:(v)=>setD(()=>active=v),title:const Text('الحساب نشط')),const Divider(),const Align(alignment:Alignment.centerRight,child:Text('الأقسام المسموحة',style:TextStyle(fontWeight:FontWeight.bold))),
    ...s.sections.map((x)=>CheckboxListTile(value:ss.contains(x.name),onChanged:(v)=>setD(()=>v==true?ss.add(x.name):ss.remove(x.name)),title:Text(x.name),dense:true)),
    const Divider(),const Align(alignment:Alignment.centerRight,child:Text('الصلاحيات',style:TextStyle(fontWeight:FontWeight.bold))),
    ...permissions.map((x)=>CheckboxListTile(value:ps.contains(x),onChanged:(v)=>setD(()=>v==true?ps.add(x):ps.remove(x)),title:Text(x),dense:true))
  ]))),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('إلغاء')),FilledButton(onPressed:(){
    if(name.text.trim().isEmpty||username.text.trim().isEmpty||password.text.isEmpty)return;
    if(existing==null)s.users.add(User(name.text.trim(),username.text.trim(),password.text,role.text.trim(),permissions:ps.toList(),sections:ss.toList(),active:active));
    else{existing.name=name.text.trim();existing.username=username.text.trim();existing.password=password.text;existing.role=role.text.trim();existing.permissions=ps.toList();existing.sections=ss.toList();existing.active=active;}
    s.changed();Navigator.pop(ctx);
  },child:const Text('حفظ'))])));
}
void denied(BuildContext c)=>ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('مدير التطبيق لم يمنحك صلاحية هذا القسم.')));
