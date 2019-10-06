import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './Screens/facluty_data_overview.dart';
import './screens/main_screen.dart';
import './providers/profiles.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(
          value:Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Profiles(),
        )
      ],child:Consumer<Auth>(builder: (ctx,auth, _)=>MaterialApp(
        title: 'Your Diary',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home:auth.isAuth?DataOverview(): AuthScreen(), 
        routes: {
          MainScreen.routeName:(ctx)=>MainScreen(),
        },
      ),)
      
    );
  }
}
