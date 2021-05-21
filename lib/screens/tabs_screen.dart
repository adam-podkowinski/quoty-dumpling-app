import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:gradient_nav_bar/gradient_nav_bar.dart';
import 'package:gradient_nav_bar/model/tab_info.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _isInit = true;

  late Tabs _tabsProvider;

  void _selectPage(int index) {
    if (index != 1) {
      Provider.of<DumplingProvider>(context, listen: false)
          .isFullStateChanged();
    }
    _tabsProvider.navigateToPage(index);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _tabsProvider = Provider.of<Tabs>(context);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _tabsProvider.pages[_tabsProvider.selectedPageIndex],
        bottomNavigationBar: GradientNavigationBar(
          containerHeight: 70.h,
          itemContainerHeight: 70.h,
          selectedFontSize: 14.sp,
          unselectedFontSize: 12.sp,
          onTap: _selectPage,
          gradient: LinearGradient(
            colors: [
              ThemeColors.primary,
              ThemeColors.secondary,
            ],
          ),
          currentIndex: _tabsProvider.selectedPageIndex,
          backgroundColor: ThemeColors.secondaryLight,
          iconColor: ThemeColors.primary,
          labelColor: ThemeColors.primary,
          selectedIconColor:
              Theme.of(context).appBarTheme.textTheme!.headline6!.color!,
          selectedLabelColor:
              Theme.of(context).appBarTheme.textTheme!.headline6!.color!,
          showLabel: true,
          items: [
            TabInfo(
              icon: Icons.shopping_cart,
              label: 'Shop',
            ),
            TabInfo(
              icon: CustomIcons.dumpling,
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
