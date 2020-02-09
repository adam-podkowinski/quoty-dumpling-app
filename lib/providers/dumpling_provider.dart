import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 25;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  bool get isFull {
    return _isFull;
  }

  double get progressBarStatus {
    return _progressBarStatus;
  }

  void clearClickingProgressWhenFull() {
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
  }

  void isFullStateChanged() {
    _isFull = false;
    notifyListeners();
  }
}
