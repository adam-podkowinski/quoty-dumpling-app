import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 25;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  var _goToCollectionScreen = false;

  bool get goToCollectionScreen {
    return _goToCollectionScreen;
  }

  double get progressBarStatus {
    return _progressBarStatus;
  }

  bool get isFull {
    return _isFull;
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

  void changeGoToCollectionScreen(bool val) {
    _goToCollectionScreen = val;
  }

  void notifyIsFullStateChanged() {
    _isFull = false;
    notifyListeners();
  }
}
