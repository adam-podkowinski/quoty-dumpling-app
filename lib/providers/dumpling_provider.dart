import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 1;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  int _numberOfClicks = 0;
  int _numberOfDumplingsOpened = 0;

  bool get isFull => _isFull;

  double get progressBarStatus => _progressBarStatus;

  int get numberOfClicks => _numberOfClicks;
  int get numberOfDumplingsOpened => _numberOfDumplingsOpened;

  Future initDumpling() async {
    final prefs = await SharedPreferences.getInstance();
    _progressBarStatus = prefs.getDouble('clickingProgress') ?? 0.0;
    _clickMultiplier = prefs.getDouble('clickMultiplier') ?? 20;
  }

  void clearClickingProgressWhenFull() {
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setDouble('clickingProgress', 0),
    );
    Future.delayed(
      Duration(milliseconds: 300),
      () => _progressBarStatus = 0,
    );
  }

  void clickedOnDumpling() {
    _progressBarStatus += _clickMultiplier / 100;
    _numberOfClicks++;
    if (_progressBarStatus >= 1) {
      _isFull = true;
      _numberOfDumplingsOpened++;
    }
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setDouble('clickingProgress', _progressBarStatus),
    );
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
