import 'package:flutter/material.dart';
import './Screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './Providers/auth.dart';
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
      ],child:MaterialApp(
        title: 'Your Diary',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home: AuthScreen(),
      ),
      
    );
  }
}
