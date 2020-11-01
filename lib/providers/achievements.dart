import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/achievement.dart';

class Achievements extends ChangeNotifier {
  List<Achievement> _achievements = [];

  List<Achievement> get achievements => [..._achievements];

  Future<void> fetchAchievements() async {
    print("fetching achievements");

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

    final dbItems = await DBProvider.db.getAllElements("Achievements");

    _achievements.forEach(
      (a) => a.fetchFromDB(
        dbItems.firstWhere((e) => e['id'] == a.id, orElse: () => Map()),
      ),
    );
  }
}
