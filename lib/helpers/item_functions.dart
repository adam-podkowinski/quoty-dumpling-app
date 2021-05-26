import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

const onBuyFunction000 = 1;
const onBuyFunction001 = 0.005;
const onBuyFunction002 = 0.05;
const onBuyFunction007 = 0.04;
const onBuyFunction008 = 20;
const onBuyFunction009 = 0.1;
const onBuyFunction010 = 0.5;
const onBuyFunction011 = 1.0;
const onBuyFunction012 = 0.7;

const onBuyFunction003 = 10;
const onBuyFunction004 = 0.6;
const onBuyFunction005 = 3.0;

Map<String, Function> itemFunctions = {
  // Upgrade on buy functions
  'onBuyFunction000': (context) => Provider.of<Shop>(context, listen: false)
      .changeBillsOnClick(onBuyFunction000),
  'onBuyFunction001': (context) =>
      Provider.of<DumplingProvider>(context, listen: false)
          .changeClickMultiplier(onBuyFunction001),
  'onBuyFunction002': (context) => Provider.of<Shop>(context, listen: false)
      .changeCashMultiplierOnOpening(onBuyFunction002),
  'onBuyFunction007': (context) =>
      Provider.of<DumplingProvider>(context, listen: false)
          .changeClickMultiplier(onBuyFunction007),
  'onBuyFunction008': (context) => Provider.of<Shop>(context, listen: false)
      .changeBillsOnClick(onBuyFunction008),
  'onBuyFunction009': (context) => Provider.of<Shop>(context, listen: false)
      .changeCashMultiplierOnOpening(onBuyFunction009),
  'onBuyFunction010': (context) => Provider.of<Level>(context, listen: false)
      .changeXPMultiplier(onBuyFunction010),
  'onBuyFunction011': (context) => Provider.of<Level>(context, listen: false)
      .changeClickXPMultiplier(onBuyFunction011),
  'onBuyFunction012': (context) => Provider.of<Level>(context, listen: false)
      .changeOpenXPMultiplier(onBuyFunction012),

  // Powerup on buy functions
  // Double dot is necessary
  'onBuyFunction003': (context) => Provider.of<Shop>(context, listen: false)
    ..changeBillsOnClick(onBuyFunction003),
  'onBuyFunction004': (context) =>
      Provider.of<DumplingProvider>(context, listen: false)
        ..changeClickMultiplier(onBuyFunction004),
  'onBuyFunction005': (context) => Provider.of<Shop>(context, listen: false)
    ..changeCashMultiplierOnOpening(onBuyFunction005),

  //Undo powerup functions
  'undoBuyFunction003': (Shop provider) =>
      provider.changeBillsOnClick(-onBuyFunction003),
  'undoBuyFunction004': (DumplingProvider provider) =>
      provider.changeClickMultiplier(-onBuyFunction004),
  'undoBuyFunction005': (Shop provider) =>
      provider.changeCashMultiplierOnOpening(-onBuyFunction005),
};
