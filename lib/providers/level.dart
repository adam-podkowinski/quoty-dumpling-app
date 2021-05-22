import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Level extends ChangeNotifier {
  int level = 1;
  int currentXP = 0;
  int clickXP = 1;
  int dumplingXP = 100;
  //static const int defaultMaxXP = 500;
  //DEBUG
  static const int defaultMaxXP = 50;
  int maxXP = defaultMaxXP;
  double xpMultiplier = 1;

  List<String> _levelRewards = [];
  List<String> get levelRewards {
    return [..._levelRewards];
  }

  Future fetchLevel() async {
    final prefs = await SharedPreferences.getInstance();
    level = prefs.getInt('level') ?? 1;
    currentXP = prefs.getInt('currentXP') ?? 0;
    clickXP = prefs.getInt('clickXP') ?? 1;
    dumplingXP = prefs.getInt('dumplingXP') ?? 200;
    xpMultiplier = prefs.getDouble('xpMultiplier') ?? 1.0;
    _levelRewards = prefs.getStringList('levelRewards') ?? [];
    calculateMaxXP();
  }

  Future<void> click() async {
    currentXP += (clickXP * xpMultiplier).toInt();
    await checkLevelup();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentXP', currentXP);
  }

  Future<void> openDumpling() async {
    currentXP += (dumplingXP * xpMultiplier).toInt();
    await checkLevelup();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentXP', currentXP);
  }

  Future<void> checkLevelup() async {
    if (currentXP >= maxXP) {
      level++;
      currentXP = currentXP - maxXP;
      calculateMaxXP();
      _levelRewards.add('RARE');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('level', level);
      await prefs.setStringList('levelRewards', _levelRewards);
    }
  }

  void calculateMaxXP() {
    maxXP = (defaultMaxXP * pow(level, 1.5)).toInt();
  }

  //@TODO: remove only one reward (currently debug)
  void removeRewards() {
    _levelRewards.removeAt(0);
    notifyListeners();
  }
}
