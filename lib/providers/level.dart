import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Level extends ChangeNotifier {
  int level = 1;
  int currentXP = 0;
  int clickXP = 1;
  int dumplingXP = 6;
  static const defaultMaxXP = 500;
  int maxXP = defaultMaxXP;
  double xpMultiplier = 1;

  Future fetchLevel() async {
    final prefs = await SharedPreferences.getInstance();
    level = prefs.getInt('level') ?? 1;
    calculateMaxXP();
  }

  void click() {
    currentXP += (clickXP * xpMultiplier).toInt();
    checkLevelup();
    notifyListeners();
  }

  void openDumpling() {
    currentXP += (dumplingXP * xpMultiplier).toInt();
    checkLevelup();
  }

  void checkLevelup() {
    if (currentXP >= maxXP) {
      level++;
      currentXP = currentXP - maxXP;
      calculateMaxXP();
    }
  }

  void calculateMaxXP() {
    maxXP = defaultMaxXP * (level ^ 2);
  }
}
