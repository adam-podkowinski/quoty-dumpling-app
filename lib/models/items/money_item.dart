import 'package:quoty_dumpling_app/models/items/item.dart';

class MoneyItem extends ShopItem {
  MoneyItem(map) : super.fromMap(map) {
    isConsumable = map['isConsumable'];
  }
  late final bool isConsumable;
}
