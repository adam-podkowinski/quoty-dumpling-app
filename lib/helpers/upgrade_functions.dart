import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class UpgradeFunctions {
  static void increaseBillsOnClickByOne(context) {
    Provider.of<Shop>(context).increaseBillsOnClick(1);
  }

  static void increaseClickMultiplierByLow(context) {
    Provider.of<DumplingProvider>(context).increaseClickMultiplier(.1);
  }

  static void increaseCashOnOpeningMultiplier(context) {
    Provider.of<Shop>(context).increaseCashMultiplierOnOpening(1);
  }
}
