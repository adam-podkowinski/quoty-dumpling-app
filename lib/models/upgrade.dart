import 'package:quoty_dumpling_app/helpers/upgrade_functions.dart';

class Upgrade {
  final String name;
  final String description;
  final int defaultPriceBills;
  final int defaultPriceDiamonds;
  final int defaultPriceUSD;
  final Function function;
  final int level;
  final String id;

  Upgrade._({
    this.name,
    this.description,
    this.defaultPriceBills,
    this.defaultPriceDiamonds,
    this.defaultPriceUSD,
    this.function,
    this.level,
    this.id,
  });

  factory Upgrade.fromMap(Map<String, dynamic> map) {
    return Upgrade._(
      name: map['name'],
      description: map['description'],
      defaultPriceBills: map['description'],
      defaultPriceDiamonds: map['priceDiamonds'],
      defaultPriceUSD: map['priceUSD'],
      level: map['level'],
      id: map['id'],
    );
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
  }
}
