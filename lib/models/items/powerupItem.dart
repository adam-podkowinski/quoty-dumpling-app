import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quiver/async.dart';
import 'package:quoty_dumpling_app/providers/items.dart';

class PowerupItem extends LabeledItem {
  PowerupItem(Map<String, dynamic> map) : super.fromMap(map) {
    this._useTime = map['useTime'];
    this._current = _useTime;
  }

  @override
  bool hasLabel = false;

  CountdownTimer timer;
  int _useTime;
  int _current;

  @override
  String getLabel() {
    return 'Last: ${_current.toString()}';
  }

  @override
  void buyItem(context) {
    super.buyItem(context);
    hasLabel = true;
    timer = CountdownTimer(Duration(seconds: _useTime), Duration(seconds: 1));
    Provider.of<ShopItems>(context, listen: false).addPowerup(this);
  }

  void updateTimer(durationTillEnd) {
    _current = _useTime - durationTillEnd;
  }

  void doneTimer() {
    _current = _useTime;
    this.hasLabel = false;
  }
}
