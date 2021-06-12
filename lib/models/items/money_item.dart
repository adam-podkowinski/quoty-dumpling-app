import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';

class MoneyItem extends ShopItem {
  MoneyItem(map) : super.fromMap(map);

  MoneyItem.fromProductDetails(ProductDetails details) {
    name = details.title.replaceAll('(Quoty Dumpling)', '');
    description = details.description;
    defaultPriceBills = 0;
    defaultPriceDiamonds = 0;
    priceUSD = details.price;
    id = details.id;
    useCase = ShopItem.useCaseFromString('removeAds');
    iconType = ShopItem.iconTypeFromString('removeAds');
    actualPriceBills = 0;
    actualPriceDiamonds = 0;
    onBuyFunction = () {};
  }
}
