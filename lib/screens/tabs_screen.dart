import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milesrank_app/screens/map_screen.dart';
import 'package:milesrank_app/screens/rankings_screen.dart';
import 'package:milesrank_app/screens/cruises_screen.dart';
import 'package:milesrank_app/screens/search_screen.dart';

class TabsScreen extends StatefulWidget {
  final rankingData;

  TabsScreen({this.rankingData});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _screens = [
    RankingScreen(),
    SailorsScreen(),
    SearchScreen(),
    MapScreen(),
  ];

  int _selectedScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF001E6C),
        buttonBackgroundColor: Color(0xFFFFAA4C),
        color: Color(0xFF5089C6),
        items: <Widget>[
          Icon(Icons.emoji_events, size: 30),
          Icon(Icons.sailing, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.map, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedScreenIndex = index;
          });
        },
      ),
    );
  }
}
