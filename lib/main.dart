import 'package:faculty_diary/Screens/main_screen.dart';
import 'package:flutter/material.dart';
import './Screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './Providers/auth.dart';
import './Screens/faculty_profile_Data.dart';
import './Screens/profile_data.dart';
import './Screens/facluty_data_overview.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(
          value:Auth(),
        )
      ],child:Consumer<Auth>(builder: (ctx,auth, _)=>MaterialApp(
        title: 'Your Diary',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home:DataOverview(),
      ),)
      
    );
  }
}
