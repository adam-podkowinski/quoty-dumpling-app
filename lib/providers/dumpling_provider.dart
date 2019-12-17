import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 6;

  double get progressBarStatus {
    return _progressBarStatus;
  }

  void clickedOnDumpling() {
    _progressBarStatus += _clickMultiplier / 100;
    notifyListeners();
  }
}
