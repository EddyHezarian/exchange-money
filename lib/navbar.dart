import 'package:flutter/material.dart';

class navbar extends StatefulWidget {
  const navbar({Key? key}) : super(key: key);

  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children:  [
          UserAccountsDrawerHeader(
            accountName: const Text("eddy hezarian"),
           accountEmail: const Text("eddyhzn@gmail.com"),
           currentAccountPicture: CircleAvatar(child: ClipOval(child: Image.network("https://organicthemes.com/demo/profile/files/2018/05/profile-pic.jpg"),),)),
           
        
        
        ],
      ),


    );

  }
}
