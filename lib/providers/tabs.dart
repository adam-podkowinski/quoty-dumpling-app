import 'package:flutter/foundation.dart';
import 'package:quoty_dumpling_app/screens/collection_screen.dart';
import 'package:quoty_dumpling_app/screens/dumpling_screen.dart';

class Tabs extends ChangeNotifier {
  final List pages = [
    CollectionScreen(),
    DumplingScreen(),
    CollectionScreen(),
  ];

  int _selectedPageIndex = 1;
  int get selectedPageIndex {
    return _selectedPageIndex;
  }

  void navigateToPage(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }
}
