import 'package:flutter/material.dart';
import 'package:gradient_nav_bar/gradient_nav_bar.dart';
import 'package:gradient_nav_bar/model/tab_info.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/dumpling_icon_icons.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

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

  var _selectedPageIndex = 1;

  var _isInit = true;

  var _dumplingProvider;

  var _fetchQuotesFuture;

  void _selectPage(int index) {
    if (index != 1) _dumplingProvider.notifyIsFullStateChanged();
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchQuotesFuture =
        Provider.of<Quotes>(context, listen: false).fetchQuotes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      SizeConfig().init(context);
      _dumplingProvider = Provider.of<DumplingProvider>(context);
      _isInit = false;
    }
    if (_dumplingProvider.goToCollectionScreen) {
      setState(() {
        _selectedPageIndex = 2;
      });
      _dumplingProvider.changeGoToCollectionScreen(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _fetchQuotesFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState != ConnectionState.done
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Scaffold(
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
                      selectedIconColor:
                          Theme.of(context).backgroundColor.withBlue(220),
                      selectedLabelColor:
                          Theme.of(context).backgroundColor.withBlue(220),
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
      ),
    );
  }
}
