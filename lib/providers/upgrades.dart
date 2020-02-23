import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/models/upgrade.dart';

class Upgrades extends ChangeNotifier {
  List<Upgrade> _upgrades = [];
  List<Upgrade> get upgrades => [..._upgrades];

  Future fetchUpgrades() async {
    List<dynamic> content;

    content = jsonDecode(
        await rootBundle.loadString('assets/upgrades/upgrades.json'));

    _upgrades.clear();

    _upgrades.addAll(
      content.map(
        (e) => Upgrade.fromMap(e),
      ),
    );

    final dbUpgrades = await DBProvider.db.getAllElements('Upgrades');

    _upgrades.forEach((u) {
      u.fetchFromDB(
        dbUpgrades.firstWhere((e) => e['id'] == u.id, orElse: () => Map()),
      );
    });
  }
}
