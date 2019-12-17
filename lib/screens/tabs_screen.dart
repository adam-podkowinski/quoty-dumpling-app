import 'package:flutter/material.dart';
import 'package:gradient_nav_bar/gradient_nav_bar.dart';
import 'package:gradient_nav_bar/model/tab_info.dart';
import 'package:quoty_dumpling_app/icons/dumpling_icon_icons.dart';

import 'package:quoty_dumpling_app/screens/collection_screen.dart';
import 'package:quoty_dumpling_app/screens/dumpling_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [
    CollectionScreen(),
    DumplingScreen(),
    CollectionScreen(),
  ];

  int _selectedPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: GradientNavigationBar(
        onTap: _selectPage,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
        ),
        currentIndex: _selectedPageIndex,
        backgroundColor: Theme.of(context).buttonColor,
        iconColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        showLabel: true,
        items: [
          TabInfo(
            icon: Icons.settings,
            label: 'Settings',
          ),
          TabInfo(
            icon: DumplingIcon.dumpling,
            label: 'Dumpling',
          ),
          TabInfo(
            icon: Icons.book,
            label: 'Collection',
          ),
          // BottomNavigationBarItem(
          //   // backgroundColor: Theme.of(context).accentColor,
          //   icon: Icon(DumplingIcon.dumpling),
          //   title: Text('Dumpling'),
          // ),
          // BottomNavigationBarItem(
          //   // backgroundColor: Theme.of(context).accentColor,
          //   icon: Icon(Icons.book),
          //   title: Text('Collection'),
          // ),
        ],
      ),
    );
  }
}
