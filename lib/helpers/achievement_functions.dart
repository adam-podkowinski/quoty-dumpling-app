import 'package:quoty_dumpling_app/models/achievement.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

Map<String, Function> achievementFunctions = {
  '000': (Achievement achievement, DumplingProvider dumpling, Shop shop) {
    achievement.doneVal = dumpling.numberOfDumplingsOpened;
    if (achievement.doneVal >= 1) {
      achievement.doneVal = achievement.maxToDoVal;
      return true;
    }
    return false;
  },
  '001': (Achievement achievement, DumplingProvider dumpling, Shop shop) {
    achievement.doneVal = dumpling.numberOfDumplingsOpened;
    if (achievement.doneVal >= 3) {
      achievement.doneVal = achievement.maxToDoVal;
      return true;
    }
    return false;
  },
  '002': (Achievement achievement, DumplingProvider dumpling, Shop shop) {
    achievement.doneVal = dumpling.numberOfClicks;
    if (achievement.doneVal >= 1000) {
      achievement.doneVal = achievement.maxToDoVal;
      return true;
    }
    return false;
  },
};
