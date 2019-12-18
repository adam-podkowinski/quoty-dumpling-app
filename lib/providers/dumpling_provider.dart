import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 6;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  double get progressBarStatus {
    return _progressBarStatus;
  }

  bool get isFull {
    return _isFull;
  }

  void clickedOnDumpling() {
    if (_progressBarStatus >= 1.0) {
      _isFull = true;
      return;
    }
    _progressBarStatus += _clickMultiplier / 100;
    notifyListeners();
  }
}
