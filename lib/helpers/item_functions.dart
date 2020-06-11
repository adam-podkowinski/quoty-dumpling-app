import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class ItemFunctions {
  static Map<String, Function> itemFunctions = {
    // Upgrade on buy functions
    'onBuyFunction000': (context) =>
        Provider.of<Shop>(context, listen: false).changeBillsOnClick(1),
    'onBuyFunction001': (context) =>
        Provider.of<DumplingProvider>(context, listen: false)
            .increaseClickMultiplier(.1),
    'onBuyFunction002': (context) => Provider.of<Shop>(context, listen: false)
        .changeCashMultiplierOnOpening(1),

    // Powerup on buy functions
    // Double dot is necessary
    'onBuyFunction003': (context) =>
        Provider.of<Shop>(context, listen: false)..changeBillsOnClick(10),

    //Undo powerup functions
    'undoBuyFunction003': (provider) => provider.changeBillsOnClick(-10),
  };
}
