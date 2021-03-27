import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quoty_dumpling_app/helpers/achievement_functions.dart';
import 'package:quoty_dumpling_app/models/achievement.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class Achievements extends ChangeNotifier {
  final List<Achievement> _achievements = [];

  List<Achievement> get achievements => [..._achievements];

  List<Achievement> get achievementsToReceive =>
      achievements.where((a) => a.isDone && !a.isRewardReceived).toList();

  int get numberOfRewardsToReceive => _achievements
      .where((element) => element.isDone && !element.isRewardReceived)
      .length;

  Future<void> fetchAchievements(
    DumplingProvider dumpling,
    Shop shop,
    Level level,
  ) async {
    print('fetching achievements');

    List<dynamic> content;

    content = jsonDecode(
      await rootBundle.loadString('assets/achievements/achievements.json'),
    );

    _achievements.clear();

    _achievements.addAll(
      content.map(
        (e) => Achievement(e),
      ),
    );

    update(dumpling, shop, level);
  }

  void update(DumplingProvider dumpling, Shop shop, level) {
    if (_achievements != null &&
        _achievements.isNotEmpty &&
        dumpling != null &&
        shop != null) {
      var shouldUpdate = false;
      _achievements
        ..where((element) => !element.isDone)
        ..toList()
        ..forEach((achievement) {
          bool finished = achievementFunctions[achievement.id](
              achievement, dumpling, shop, level);

          if (!shouldUpdate) shouldUpdate = finished;
        });

      if (shouldUpdate) notifyListeners();
    }
  }

  void receiveReward(String id, BuildContext context) {
    _achievements.firstWhere((a) => a.id == id).receiveReward(context);
    notifyListeners();
  }
}
