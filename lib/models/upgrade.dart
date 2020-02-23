import 'package:quoty_dumpling_app/helpers/upgrade_functions.dart';

class Upgrade {
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

  Upgrade._({
    this.name,
    this.description,
    this.defaultPriceBills,
    this.defaultPriceDiamonds,
    this.priceUSD,
    this.function,
    this.id,
  });

  factory Upgrade.fromMap(Map<String, dynamic> map) {
    return Upgrade._(
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

  void useUpgrade(context) {
    switch (id) {
      case '001':
        UpgradeFunctions.increaseBillsOnClickByOne(context);
        break;
      case '002':
        UpgradeFunctions.increaseClickMultiplierByLow(context);
        break;
      case '003':
        UpgradeFunctions.increaseCashOnOpeningMultiplier(context);
        break;
    }
    level++;
    refreshActualPrices();
  }
}
