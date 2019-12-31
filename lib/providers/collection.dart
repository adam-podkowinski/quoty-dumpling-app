import 'package:flutter/foundation.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class Collection extends ChangeNotifier {
  List<Quote> _unlockedItems = [];

  List<Quote> get unlockedItems {
    return [..._unlockedItems];
  }

  void fetchUnlockedItems() {
    _unlockedItems.clear();
    _unlockedItems.addAll(
      Quotes().items.isNotEmpty
          ? Quotes().items.where((item) => item.isInCollection == true)
          : [
              Quote(
                author: '',
                quote: '',
              ),
              Quote(
                author: '',
                quote: '',
              ),
            ],
    );
    print(_unlockedItems[0].quote);
  }
}
