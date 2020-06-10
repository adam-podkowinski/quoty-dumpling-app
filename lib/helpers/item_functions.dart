import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class ItemFunctions {
  static Map<String, Function> itemFunctions = {
    // On buy functions
    'onBuyFunction000': (context) =>
        Provider.of<Shop>(context).changeBillsOnClick(1),
    'onBuyFunction001': (context) =>
        Provider.of<DumplingProvider>(context).increaseClickMultiplier(.1),
    'onBuyFunction002': (context) =>
        Provider.of<Shop>(context).changeCashMultiplierOnOpening(1),
    'onBuyFunction003': (context) =>
        Provider.of<Shop>(context).changeBillsOnClick(10),
    //Undo powerup functions
    'undoBuyFunction003': (context) =>
        Provider.of<Shop>(context).changeBillsOnClick(-10),
  };
}
