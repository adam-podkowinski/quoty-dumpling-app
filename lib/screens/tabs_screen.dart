import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gradient_nav_bar/gradient_nav_bar.dart';
import 'package:gradient_nav_bar/model/tab_info.dart';

import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/dumpling_icon_icons.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _isInit = true;

  Tabs _tabsProvider;

  void _selectPage(int index) {
    if (index != 1)
      Provider.of<DumplingProvider>(context, listen: false)
          .isFullStateChanged();
    _tabsProvider.navigateToPage(index);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Quotes>(context, listen: false).fetchQuotes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _tabsProvider = Provider.of<Tabs>(context);
      SizeConfig.init(context);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabsProvider.pages[_tabsProvider.selectedPageIndex],
      bottomNavigationBar: GradientNavigationBar(
        onTap: _selectPage,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
        ),
        currentIndex: _tabsProvider.selectedPageIndex,
        backgroundColor: Theme.of(context).buttonColor,
        iconColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        selectedIconColor: Theme.of(context).appBarTheme.textTheme.title.color,
        selectedLabelColor: Theme.of(context).appBarTheme.textTheme.title.color,
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
    );
  }
}
