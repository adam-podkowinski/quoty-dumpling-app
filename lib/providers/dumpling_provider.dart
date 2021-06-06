import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DumplingProvider extends ChangeNotifier {
  static const defaultClickMultiplier = kReleaseMode ? 0.025 : 10.0;
  //shows progress of status bar
  double _clickingProgress = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = defaultClickMultiplier;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  int _numberOfClicks = 0;
  int _numberOfDumplingsOpened = 0;

  bool get isFull => _isFull;

  double get clickingProgress => _clickingProgress;

  int get numberOfClicks => _numberOfClicks;
  int get numberOfDumplingsOpened => _numberOfDumplingsOpened;

  Future initDumpling() async {
    final prefs = await SharedPreferences.getInstance();
    _clickingProgress = prefs.getDouble('clickingProgress') ?? 0.0;
    _clickMultiplier =
        prefs.getDouble('clickMultiplier') ?? defaultClickMultiplier;
    _numberOfClicks = prefs.getInt('numberOfClicks') ?? 0;
    _numberOfDumplingsOpened = prefs.getInt('numberOfDumplingsOpened') ?? 0;
  }

  void clearClickingProgressWhenFull() {
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setDouble('clickingProgress', 0),
    );
    Future.delayed(
      Duration(milliseconds: 300),
      () => _clickingProgress = 0,
    );
  }

  Future<void> clickedOnDumpling(BuildContext context) async {
    _clickingProgress += _clickMultiplier / 100;
    _numberOfClicks++;
    var dbInstance = await SharedPreferences.getInstance();
    await Provider.of<Level>(context, listen: false).click(context);
    if (_clickingProgress >= 1) {
      _isFull = true;
      _numberOfDumplingsOpened++;
      await Provider.of<Level>(context, listen: false).openDumpling(context);
      await dbInstance.setInt(
        'numberOfDumplingsOpened',
        _numberOfDumplingsOpened,
      );
    }
    await dbInstance.setInt('numberOfClicks', _numberOfClicks);
    await dbInstance.setDouble('clickingProgress', _clickingProgress);
    notifyListeners();
  }

  void isFullStateChanged() {
    _isFull = false;
    notifyListeners();
  }

  //! ITEM FUNCTIONS

  void changeClickMultiplier(double howMuch) {
    _clickMultiplier += howMuch;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setDouble('clickMultiplier', _clickMultiplier);
      },
    );
  }
}
