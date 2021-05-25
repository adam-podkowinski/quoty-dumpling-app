import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelReward {
  late final int id;
  late final int levelAchieved;
  late final int billsReward;
  late final int diamondsReward;
  late final Rarity rarityUp;

  LevelReward({
    required this.id,
    required this.levelAchieved,
    required this.billsReward,
    required this.diamondsReward,
    required this.rarityUp,
  });

  LevelReward.fromMap(Map<String, dynamic> levelRewardMap) {
    id = levelRewardMap['id'];
    levelAchieved = levelRewardMap['levelAchieved'];
    billsReward = levelRewardMap['billsReward'];
    diamondsReward = levelRewardMap['diamondsReward'];
    rarityUp = Quote.getRarityByText(levelRewardMap['rarityUp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'levelAchieved': levelAchieved,
      'billsReward': billsReward,
      'diamondsReward': diamondsReward,
      'rarityUp': Quote.getTextByRarity(rarityUp),
    };
  }
}

class Level extends ChangeNotifier {
  int level = 1;
  int currentXP = 0;
  int clickXP = 1;
  int dumplingXP = 100;
  static const int defaultMaxXP = 500;
  int maxXP = defaultMaxXP;
  double xpMultiplier = 1;

  List<LevelReward> _levelRewards = [];
  List<LevelReward> get levelRewards {
    return [..._levelRewards];
  }

  Future fetchLevel() async {
    final prefs = await SharedPreferences.getInstance();
    level = prefs.getInt('level') ?? 1;
    currentXP = prefs.getInt('currentXP') ?? 0;
    clickXP = prefs.getInt('clickXP') ?? 1;
    dumplingXP = prefs.getInt('dumplingXP') ?? 200;
    xpMultiplier = prefs.getDouble('xpMultiplier') ?? 1.0;
    var levelRewardsMap = await DBProvider.db.getAllElements('LevelRewards');

    _levelRewards = levelRewardsMap.map((rewardMap) {
      return LevelReward.fromMap(rewardMap);
    }).toList();

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

  //@TODO: apply recurrential functionality (in case someone levelups 2 levels during one event - clicking or opening a dumpling)
  Future<void> checkLevelup() async {
    if (currentXP >= maxXP) {
      //LEVEL UP
      level++;
      currentXP = currentXP - maxXP;
      calculateMaxXP();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('level', level);

      var levelupReward = LevelReward(
          id: _levelRewards.length,
          levelAchieved: level,
          billsReward: level * 500,
          diamondsReward: level,
          rarityUp: Rarity.rare);

      _levelRewards.add(levelupReward);
      await DBProvider.db.insert('LevelRewards', levelupReward.toMap());
    }
  }

  void calculateMaxXP() {
    maxXP = (defaultMaxXP * pow(level, 1.5)).toInt();
  }

  //@TODO: apply rewards through shop provider
  void claimReward() {
    if (_levelRewards.isNotEmpty) {
      DBProvider.db.removeElementById('LevelRewards', _levelRewards[0].id);
      _levelRewards.removeAt(0);
      notifyListeners();
    }
  }
}
