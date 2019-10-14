import './widgets/progresss_indicator.dart';
import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './Screens/faculty_data_input.dart';
import './widgets/app_drawer.dart';
import './providers/profiles.dart';
import './screens/faculty_diary_screen.dart';
import './TO-DO Features/ui/page_addlist.dart';
import './TO-DO Features/ui/page_detail.dart';
import './TO-DO Features/ui/page_task.dart';
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
        ),
        ChangeNotifierProvider.value(
          value: NewLists(),
        )
      ],child:Consumer<Auth>(builder: (ctx,auth, _)=>MaterialApp(
        title: 'Your Diary',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home:auth.isAuth?AppDrawer(): TaskPage(), 
        routes: {
          AppDrawer.routeName:(ctx)=>AppDrawer(),
          DiaryPage.routeName:(ctx)=>DiaryPage(),
        },
      ),)
      
    );
  }
}
