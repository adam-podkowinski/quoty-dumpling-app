import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 50;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  //is dumpling hidden or shown. Should NOT use _isFull for this operations because after unlocking new quote  _isFull automatically changes to false but we want to show UnlockedNewQuote widget first and then show dumpling
  var _isFullState = false;

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

  bool get isFullState {
    return _isFullState;
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
      _isFullState = true;
      _isFull = true;
    }
    notifyListeners();
  }

  void changeToCollectionScreen(bool val) {
    _changeGoToCollectionScreen = val;
    notifyListeners();
  }

  void notifyIsFullStateChanged() {
    _isFullState = _isFull;
    notifyListeners();
  }
}
