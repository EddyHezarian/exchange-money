//------------------------------- packages--------------------------------------
//import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Currancy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as httpconvert;
import 'package:intl/intl.dart';


void main(List<String> args) {
  runApp(config());
}

//---------------------- themes and starter configs-----------------------------
class config extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fa', ''), // farsi
      ],
      theme: ThemeData(
          fontFamily: 'vaziri',
          textTheme: const TextTheme(
            headline1:
                TextStyle(fontFamily: 'vaziri', fontSize: 16, fontWeight: FontWeight.w200, color: Color.fromARGB(255, 0, 0, 0)),
            bodyText1: TextStyle(
                fontFamily: 'vaziri', fontSize: 14, fontWeight: FontWeight.w100, color: Color.fromARGB(255, 255, 255, 255)),
            bodyText2:
                TextStyle(fontFamily: 'vaziri', fontSize: 13, fontWeight: FontWeight.w100, color: Color.fromARGB(255, 0, 0, 0)),
            headline3:
                TextStyle(fontFamily: 'vaziri', fontSize: 13, fontWeight: FontWeight.w200, color: Color.fromARGB(255, 4, 156, 4)),
            headline4:
                TextStyle(fontFamily: 'vaziri', fontSize: 13, fontWeight: FontWeight.w200, color: Color.fromARGB(255, 185, 6, 6)),
          )),
      debugShowCheckedModeBanner: false,
     
      home: const myapp(),
      
    );
  }
}

class myapp extends StatefulWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
//-------------------using http packag and catching data------------------------
  List<currancy> currancyitems = [];

  Future get_result(BuildContext context) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));
    if (currancyitems.isEmpty) {
      //prevent infinit loop in list view
      if (value.statusCode == 200) {
        //if ther is no problem with getting access to the URL :-->
        List jsonlist = httpconvert.jsonDecode(value
            .body); /*catching the url and due to the gradient of Url is in the list 
                      we get qaccess to the body of the list and send them into a varible */
        setState(() {
          // filling the currancyitems indexes with data
          if (jsonlist.isNotEmpty) {
            //
            for (int i = 0; i < jsonlist.length; i++) {
              currancyitems.add(currancy(
                  id: jsonlist[i]["id"],
                  title: jsonlist[i]["title"],
                  price: jsonlist[i]["price"],
                  changes: jsonlist[i]["changes"],
                  status: jsonlist[i]["status"]));
            }
          }
        });
      }
    }
    return url;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_result(context);
  }
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      key: _scaffoldKey,

       

     backgroundColor: const Color.fromARGB(255, 228, 228, 228),
//--------------------------------- body----------------------------------------
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
//-------------------------------upper description--------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/qq9.png",
                    ),
                    Text("نرخ ارز آزاد چیست ؟ ", style: Theme.of(context).textTheme.headline1),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '  نرخ ارزها در معاملات نقدی و رایج روزانه است . معاملات نقدی معاملاتی اند که طرفین معامله به محض انجام معامله ارز و ریال را باهم تبادل میکنند ',
                      style: Theme.of(context).textTheme.bodyText2,
                      //textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
//----------------------------black container-----------------------------------
                Container(
                  height: 38,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1000)), color: Color.fromARGB(255, 119, 119, 119)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("نام ارز ", style: Theme.of(context).textTheme.bodyText1),
                      Text("قیمت", style: Theme.of(context).textTheme.bodyText1),
                      Text(
                        "تغییر",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
//------------------------------item builder------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: currancyitems.length,
                              itemBuilder: (BuildContext contex, int position) {
                                return ITEMS(position, currancyitems);
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                if (index % 6 == 0) {
                                  return const ADs();
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            )
                          : const Center(child: CircularProgressIndicator());
                    },
                    future: get_result(context),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
//-------------------------------refresh box --------------------------------------
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: const Color.fromARGB(255, 232, 232, 232),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextButton.icon(
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000))),
                                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 202, 193, 255)),
                              ),
                              onPressed: () {
                                _refresh_notification(context, "بروز رسانی با موفقیت انجام شد");
                                setState(() {
                                  _lastrefresh();
                                });
                              },
                              icon: const Icon(
                                CupertinoIcons.refresh_bold,
                                color: Colors.black,
                              ),
                              label: Text("بروزرسانی", style: Theme.of(context).textTheme.headline1),
                            ),
                          ),
                          Text("اخرین بروزرسانی در ${_lastrefresh()} "),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),

//-------------------------------- Appbar---------------------------------------
        appBar: AppBar(
          backgroundColor: Colors.white,
          

          // leading: Padding(
          //   padding: const EdgeInsets.fromLTRB(0,0,0,0),
          //   child: Image.asset('assets/images/icons8_money_bag_48px_4.png'),
          // ),
          // title: Text("صرافی انلاین", style: Theme.of(context).textTheme.headline1),
          
          actions: [

           
            Align(alignment: Alignment.centerRight,child: Image.asset("assets/images/icons8_money_bag_48px_4.png")),
            
            Expanded(child: Align(alignment: Alignment.centerRight, child: Text("صرافی آنلاین ", style: Theme.of(context).textTheme.headline1))),
          Expanded(child: Align(alignment: Alignment.centerLeft,
           child: InkWell(child: Image.asset("assets/images/icons8_menu_24px.png"),onTap: ()=>_scaffoldKey.currentState!.openDrawer()))),

            const SizedBox(
              width: 8,
            ),

          ],
       ),

        drawer: Drawer(
          
        child: ListView(
        children:[
          UserAccountsDrawerHeader(
            accountName: const Text("eddy hezarian"),
            accountEmail: const Text("eddyhzn@gmail.com"),
            currentAccountPicture: CircleAvatar(backgroundColor: Color.fromARGB(255, 247, 247, 247),child: ClipOval(child: Image.network("https://www.kindpng.com/picc/m/685-6851196_person-icon-grey-hd-png-download.png",)
            ,)
            ,),
            decoration: const BoxDecoration(color: Color.fromARGB(255, 209, 209, 209)),

            ),
       const SizedBox(height: 15,),
         ListTile(
            leading: const Icon(Icons.payment,size: 40,),
            title: Text("تراکنش ها ",style: Theme.of(context).textTheme.headline1,),
           
            onTap: (){} ,
          ),
           Divider(),
          const SizedBox(height: 15,),
          ListTile(
            leading: const Icon(CupertinoIcons.bitcoin,size: 40,),
            title: Text(" معامله ارز دیجیتال "  ,style: Theme.of(context).textTheme.headline1,),
            onTap: (){}  ,
          ),
           Divider(),
          const SizedBox(height: 15,),
          ListTile(
            leading: const Icon(Icons.person,size: 40,),
            title: Text("ارتباط با ما "  ,style: Theme.of(context).textTheme.headline1,),
            onTap: (){}  ,
          ),
           Divider(),
          const SizedBox(height: 15,),
          ListTile(
            leading: const Icon(Icons.star,size: 40,),
            title: Text("امتیاز دادن  "  ,style: Theme.of(context).textTheme.headline1,),
            onTap:(){}  ,
          )

           , Divider(),
           const SizedBox(height: 15,),
          
          ListTile(
            leading: const Icon(Icons.share, size: 40,),
            title: Text(" اشتراک گذاری  "  ,style: Theme.of(context).textTheme.headline1,),
            onTap:(){}  ,
          )


        ],
      ),
 ),
  
       );
  }

  String _lastrefresh() {
    // bulshit yet
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }
}

class ITEMS extends StatelessWidget {
  //this part will make the main boxes ...
  int position;
  List<currancy> currancyitems;
  ITEMS(this.position, this.currancyitems);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(blurRadius: 4.0, color: Colors.grey),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(currancyitems[position].title!, style: Theme.of(context).textTheme.headline1)),
            Container(
                width: MediaQuery.of(context).size.width / 5,
                child: Text(farsinumbers(currancyitems[position].price.toString()),
                    style: Theme.of(context).textTheme.headline1)),

            Container(
              width: MediaQuery.of(context).size.width / 5,
              child: Align(
                alignment: Alignment.center,
                child: Text(currancyitems[position].changes!,
                    style: currancyitems[position].status == "n"
                        ? Theme.of(context).textTheme.headline4
                        : Theme.of(context).textTheme.headline3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ADs extends StatelessWidget {
  //this part will make the orange boxes ...
  const ADs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: Color.fromARGB(255, 255, 0, 0),
          boxShadow: const <BoxShadow>[
            BoxShadow(blurRadius: 4.0, color: Colors.grey),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("تبلیغات ", style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}

void _refresh_notification(BuildContext context, String msg) {
  //this function will creat the snak bar messenger for refresh button...
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.bodyText2,
    ),
    backgroundColor: Colors.lightGreen,
  ));
}

String farsinumbers(String number) {
  const operators = ['.', '+', '-', '%'];
  const En = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const Fa = ['۰', '١', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  En.forEach((element) {
    number = number.replaceAll(element, Fa[En.indexOf(element)]);
  });

  return number;
}
