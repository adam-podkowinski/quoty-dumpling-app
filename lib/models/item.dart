import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/helpers/item_functions.dart';

class ShopItem {
  final String name;
  final String description;
  final int defaultPriceBills;
  final int defaultPriceDiamonds;
  final int priceUSD;
  final Function function;
  final String id;

  int level;

  int actualPriceBills;
  int actualPriceDiamonds;

  ShopItem._({
    this.name,
    this.description,
    this.defaultPriceBills,
    this.defaultPriceDiamonds,
    this.priceUSD,
    this.function,
    this.id,
  });

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem._(
      name: map['name'],
      description: map['description'],
      defaultPriceBills: map['defaultPriceBills'],
      defaultPriceDiamonds: map['defaultPriceDiamonds'],
      priceUSD: map['priceUSD'],
      id: map['id'],
    );
  }

  void fetchFromDB(Map<String, dynamic> map) {
    level = map.isEmpty ? 1 : map['level'];

    refreshActualPrices();
  }

  void refreshActualPrices() {
    actualPriceBills = level * defaultPriceBills;
    actualPriceDiamonds = level * defaultPriceDiamonds;
  }

  void buyItem(context) {
    switch (id) {
      case '001':
        ItemFunctions.increaseBillsOnClickByOne(context);
        break;
      case '002':
        ItemFunctions.increaseClickMultiplierByLow(context);
        break;
      case '003':
        ItemFunctions.increaseCashOnOpeningMultiplier(context);
        break;
    }
    level++;
    refreshActualPrices();

    DBProvider.db.getElement('Items', id).then((i) {
      if (i.isEmpty)
        DBProvider.db.insert(
          'Items',
          {'id': id, 'level': level},
        );
      else
        DBProvider.db.updateElementById(
          'Items',
          id,
          {'level': level},
        );
    });
  }
}
