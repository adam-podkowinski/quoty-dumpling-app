import 'package:quoty_dumpling_app/models/achievement.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

Map<String, Function> achievementFunctions = {
  '000': (Achievement achievement, DumplingProvider dumpling, Shop shop) {
    if (dumpling.numberOfDumplingsOpened >= 1) {
      achievement.doneVal = achievement.maxToDoVal;
      return true;
    }
    return false;
  },
};
