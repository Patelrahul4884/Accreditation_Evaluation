import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class DiaryPage extends StatelessWidget {
static  const routeName='/diary';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Diary'),
      ),
      drawer: AppDrawer(),
    );
  }
}
