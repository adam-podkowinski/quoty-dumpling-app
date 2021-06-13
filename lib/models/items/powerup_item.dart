import 'package:provider/provider.dart';
import 'package:quiver/async.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/providers/shop_items.dart';

class PowerupItem extends LabeledItem {
  PowerupItem(Map<String, dynamic> map) : super.fromMap(map) {
    _useTime = map['useTime'];
    _current = _useTime;
    _undoBuyFunction = itemFunctions['undoBuyFunction$id'] ??
        (provider) => print('Undo function for this item is not yet prepared');
  }

  @override
  bool hasLabel = false;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  late CountdownTimer timer;
  int? _useTime;
  int? _current;
  late Function _undoBuyFunction;
  // Allow deactivating powerup when state of the context was destroyed.
  //E.g player went to the other screen which is a likely behaviour
  dynamic buyProvider;

  double get fractionToLast {
    return _current! / _useTime!;
  }

  int? get current {
    return _current;
  }

  int? get useTime {
    return _useTime;
  }

  @override
  String getLabel() {
    return 'Last: ${_current.toString()}';
  }

  @override
  void buyItem(context) {
    buyProvider = onBuyFunction(context);
    hasLabel = true;
    _isRunning = true;
    timer = CountdownTimer(Duration(seconds: _useTime!), Duration(seconds: 1));
    Provider.of<ShopItems>(context, listen: false).addPowerup(this);
  }

  void updateTimer(durationTillEnd) {
    _current = _useTime! - durationTillEnd as int?;
  }

  void deactivatePowerup() {
    _undoBuyFunction(buyProvider);
    _current = _useTime;
    hasLabel = false;
    _isRunning = false;
  }
}
