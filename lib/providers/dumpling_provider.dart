import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 100;
  //if progress bar status is equal to 1 (full)
  var _isFull = true;

  var _changeGoToCollectionScreen = false;
  bool get changeGoToCollectionScreen {
    return _changeGoToCollectionScreen;
  }

  double get progressBarStatus {
    return _progressBarStatus;
  }

  bool get isFull {
    return _isFull;
  }

  void clearClickingProgressWhenFull() {
    if (_isFull) {
      _progressBarStatus = 0;
      _isFull = false;
    }
    notifyListeners();
  }

  void clickedOnDumpling() {
    _progressBarStatus += _clickMultiplier / 100;
    if (_progressBarStatus >= 1.0) {
      _isFull = true;
    }
    notifyListeners();
  }

  void changeToCollectionScreen(bool val) {
    _changeGoToCollectionScreen = val;
    notifyListeners();
  }
}
