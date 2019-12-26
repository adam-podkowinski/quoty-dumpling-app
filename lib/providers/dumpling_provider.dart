import 'package:flutter/foundation.dart';

class DumplingProvider extends ChangeNotifier {
  //shows progress of status bar
  double _progressBarStatus = 0.0;
  //multiplier which shows how much we can add to progressBarStatus each click
  double _clickMultiplier = 25;
  //if progress bar status is equal to 1 (full)
  var _isFull = false;

  // //is dumpling hidden or shown. Should NOT use _isFull for this operations because after unlocking new quote  _isFull automatically changes to false but we want to show UnlockedNewQuote widget first and then show dumpling
  // var _isFullState = false;

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

  // bool get isFullState {
  //   return _isFullState;
  // }

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
    notifyListeners();
  }

  void notifyIsFullStateChanged() {
    _isFull = false;
    notifyListeners();
  }
}
