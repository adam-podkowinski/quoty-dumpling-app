import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = .5;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  bool get isFull {
    return _isFull;
  }

  double get progressBarStatus {
    return _progressBarStatus;
  }

  Future initClickingProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _progressBarStatus = prefs.getDouble('clickingProgress') ?? 0.0;
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
    notifyListeners();
    if (_progressBarStatus >= 1.0) {
      Future.delayed(Duration(milliseconds: 100), () {
        _isFull = true;
        notifyListeners();
      });
    }
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setDouble('clickingProgress', _progressBarStatus),
    );
  }

  void isFullStateChanged() {
    _isFull = false;
    notifyListeners();
  }
}
