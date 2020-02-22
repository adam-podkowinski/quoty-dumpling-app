import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class UpgradeFunctions {
  static void increaseBillsOnClickByOne(context) {
    Provider.of<Shop>(context).increaseBillsOnClick(2);
  }

  static void increaseClickMultiplierByLow(context) {
    Provider.of<DumplingProvider>(context).increaseClickMultiplier(2);
  }

  static void increaseCashOnOpeningMultiplier(context) {
    Provider.of<Shop>(context).increaseCashMultiplierOnOpening(2);
  }
}
