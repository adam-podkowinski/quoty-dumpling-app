import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/helpers/achievement_functions.dart';
import 'package:quoty_dumpling_app/models/achievement.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class Achievements extends ChangeNotifier {
  final List<Achievement> _achievements = [];

  List<Achievement> get achievements => [..._achievements];

  int get numberOfRewardsToReceive => _achievements
      .where((element) => element.isDone && !element.isRewardReceived)
      .length;

  Future<void> fetchAchievements() async {
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

    final dbItems = await DBProvider.db.getAllElements('Achievements');

    _achievements.forEach(
      (a) => a.fetchFromDB(
        dbItems.firstWhere((e) => e['id'] == a.id, orElse: () => {}),
      ),
    );
  }

  void update(DumplingProvider dumpling, Shop shop) {
    if (_achievements != null &&
        _achievements.isNotEmpty &&
        dumpling != null &&
        shop != null) {
      var shouldUpdate = false;
      _achievements
        ..where((element) => !element.isDone)
        ..toList()
        ..forEach((achievement) {
          bool finished =
              achievementFunctions[achievement.id](achievement, dumpling, shop);

          if (!shouldUpdate) shouldUpdate = finished;
        });

      if (shouldUpdate) notifyListeners();
    }
  }
}
