import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const routeName='/main';
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountEmail: Text("patelr4142@gmail.com"),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(
          size: 42,
        ),
        backgroundColor: Colors.white,
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text('Diary'),
         //onTap: ()=>Navigator.of(context).push(), 
        )
      ],
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Digital Diary'),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}
