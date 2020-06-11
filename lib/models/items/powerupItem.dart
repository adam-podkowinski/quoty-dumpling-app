import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quiver/async.dart';
import 'package:quoty_dumpling_app/providers/items.dart';

class PowerupItem extends LabeledItem {
  PowerupItem(Map<String, dynamic> map) : super.fromMap(map) {
    _useTime = map['useTime'];
    _current = _useTime;
    _undoBuyFunction = ItemFunctions.itemFunctions['undoBuyFunction$id'] ??
        () => print('Undo function for this item is not yet prepared');
  }

  @override
  bool hasLabel = false;

  CountdownTimer timer;
  int _useTime;
  int _current;
  Function _undoBuyFunction;
  // Allow deactivating powerup when state of the context was destroyed.
  //E.g player went to the other screen which will be a likely behaviour
  dynamic buyProvider;

  @override
  String getLabel() {
    return 'Last: ${_current.toString()}';
  }

  @override
  void buyItem(context) {
    buyProvider = onBuyFunction(context);
    hasLabel = true;
    timer = CountdownTimer(Duration(seconds: _useTime), Duration(seconds: 1));
    Provider.of<ShopItems>(context, listen: false).addPowerup(this);
  }

  void updateTimer(durationTillEnd) {
    _current = _useTime - durationTillEnd;
  }

  void deactivatePowerup() {
    _undoBuyFunction(buyProvider);
    _current = _useTime;
    hasLabel = false;
  }
}
