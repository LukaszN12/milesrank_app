import 'package:flutter/material.dart';
import 'package:milesrank_app/screens/tabs_screen.dart';

import 'screens/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF001E6C),
        scaffoldBackgroundColor: Color(0xFF001E6C),
        cardColor: Color(0xFF035397),
      ),
      home: TabsScreen(),
      //LoadingScreen(),
    );
  }
}
