import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Level extends ChangeNotifier {
  int level = 1;
  int currentXP = 0;
  int maxXP = 500;
  int clickXP = 1;
  int dumplingXP = 6;
  double xpMultiplier = 1;

  Future fetchLevel() async {
    final prefs = await SharedPreferences.getInstance();
    level = prefs.getInt('level') ?? 1;
  }

  void click() {
    print('Clicked');
  }

  void openDumpling() {
    print('Opened dumpling');
  }
}
