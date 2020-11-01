import 'package:flutter/cupertino.dart';
import 'package:quoty_dumpling_app/models/achievement.dart';

class Achievements extends ChangeNotifier {
  List<Achievement> _achievements = [Achievement()];

  List<Achievement> get achievements => [..._achievements];
}
