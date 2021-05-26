import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

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
  static const int defaultMaxXP = kReleaseMode ? 500 : 30;
  int maxXP = defaultMaxXP;
  double clickXPMultiplier = 1;
  double openXPMultiplier = 1;

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
    clickXPMultiplier = prefs.getDouble('clickXPMultiplier') ?? 1.0;
    openXPMultiplier = prefs.getDouble('openXPMultiplier') ?? 1.0;
    var levelRewardsMap = await DBProvider.db.getAllElements('LevelRewards');

    _levelRewards = levelRewardsMap.map((rewardMap) {
      return LevelReward.fromMap(rewardMap);
    }).toList();

    calculateMaxXP();
  }

  Future<void> click() async {
    currentXP += (clickXP * clickXPMultiplier).round();
    await checkLevelup();

    print(
        'CLICK XP: $clickXP ; CLICKXPMULTIPLIER: $clickXPMultiplier ; lol ${(clickXP * clickXPMultiplier).round()}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentXP', currentXP);
  }

  Future<void> openDumpling() async {
    currentXP += (dumplingXP * openXPMultiplier).toInt();
    await checkLevelup();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentXP', currentXP);
  }

  Future<void> checkLevelup() async {
    if (currentXP >= maxXP) {
      //LEVEL UP
      level++;
      currentXP = currentXP - maxXP;
      calculateMaxXP();
      var levelupReward = LevelReward(
        id: _levelRewards.length,
        levelAchieved: level,
        billsReward: level * 500,
        diamondsReward: level,
        rarityUp: Rarity.rare,
      );

      _levelRewards.add(levelupReward);
      await DBProvider.db.insert('LevelRewards', levelupReward.toMap());

      if (currentXP >= maxXP) {
        await checkLevelup();
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('level', level);
      }
    }
  }

  void calculateMaxXP() {
    maxXP = (defaultMaxXP * pow(level, 1.5)).toInt();
  }

  void changeXPMultiplier(double howMuch) {
    openXPMultiplier += howMuch;
    clickXPMultiplier += howMuch;
    SharedPreferences.getInstance().then(
      (prefs) => {
        prefs.setDouble('openXPMultiplier', openXPMultiplier),
        prefs.setDouble('clickXPMultiplier', clickXPMultiplier),
      },
    );
  }

  void changeClickXPMultiplier(double howMuch) {
    clickXPMultiplier += howMuch;
    SharedPreferences.getInstance().then(
      (prefs) => {
        prefs.setDouble('clickXPMultiplier', clickXPMultiplier),
      },
    );
  }

  void changeOpenXPMultiplier(double howMuch) {
    openXPMultiplier += howMuch;
    SharedPreferences.getInstance().then(
      (prefs) => {
        prefs.setDouble('openXPMultiplier', openXPMultiplier),
      },
    );
  }

  Tuple2<LevelReward, Quote> claimReward(BuildContext context) {
    if (_levelRewards.isNotEmpty) {
      var reward = _levelRewards[0];
      Provider.of<Shop>(context, listen: false).receiveLevelReward(reward);
      var unlockedQuote = Provider.of<Quotes>(context, listen: false)
          .unlockRandomQuoteFromRarity(reward.rarityUp);
      DBProvider.db.removeElementById('LevelRewards', _levelRewards[0].id);
      _levelRewards.removeAt(0);
      notifyListeners();
      return Tuple2(reward, unlockedQuote);
    }
    return Tuple2(
      LevelReward(
        id: 0,
        levelAchieved: 0,
        billsReward: 0,
        diamondsReward: 0,
        rarityUp: Rarity.common,
      ),
      Quote(
        author: 'No quotes loaded',
        quote: 'No quotes loaded',
        rarity: Rarity.legendary,
        id: 'No quotes loaded',
      ),
    );
  }
}
