import '../screens/auth_screen.dart';

import '../screens/faculty_data_input.dart';
import 'package:flutter/material.dart';
import '../screens/faculty_diary_screen.dart';

class AppDrawer extends StatelessWidget {
  static const routeName = '/main';
  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context).settings.arguments as String;
    /*final drawerHeader = UserAccountsDrawerHeader(
      accountEmail: Text(userName),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(
          size: 42,
        ),
        backgroundColor: Colors.white,
      ),
    );*/
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          //drawerHeader,
          ListTile(
            leading: Icon(Icons.book),
            title: Text('My Diary'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(DiaryPage.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.android),
            title: Text('Page 2'),
            onTap: ()=>Navigator.of(context).pushReplacementNamed(AuthScreen.routeName),
          ),
        ],
      ),
    );
  }
}
