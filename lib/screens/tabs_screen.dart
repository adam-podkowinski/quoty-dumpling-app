import 'package:flutter/material.dart';
import 'package:gradient_nav_bar/gradient_nav_bar.dart';
import 'package:gradient_nav_bar/model/tab_info.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/dumpling_icon_icons.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

import 'package:quoty_dumpling_app/screens/collection_screen.dart';
import 'package:quoty_dumpling_app/screens/dumpling_screen.dart';

class TabsScreen extends StatefulWidget {
  int selectedPageIndex = 1;

  TabsScreen(this.selectedPageIndex);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [
    CollectionScreen(),
    DumplingScreen(),
    CollectionScreen(),
  ];

  var _isInit = true;

  void _selectPage(int index) {
    setState(() {
      widget.selectedPageIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      SizeConfig().init(context);
      Provider.of<Quotes>(context).fetchQuotes();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: _pages[widget.selectedPageIndex],
        bottomNavigationBar: GradientNavigationBar(
          onTap: _selectPage,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
          currentIndex: widget.selectedPageIndex,
          backgroundColor: Theme.of(context).buttonColor,
          iconColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          selectedIconColor: Theme.of(context).backgroundColor.withBlue(220),
          selectedLabelColor: Theme.of(context).backgroundColor.withBlue(220),
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
          ],
        ),
      ),
    );
  }
}
