import 'package:flutter/foundation.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class Collection extends ChangeNotifier {
  final Quotes _quotesProvider;

  Collection(this._quotesProvider) {
    if (this._quotesProvider != null) if (this._quotesProvider.items.length >=
        0) fetchUnlockedItems();
  }

  List<Quote> _unlockedItems = [];

  List<Quote> get unlockedItems {
    return [..._unlockedItems];
  }

  void fetchUnlockedItems() {
    print('collection fetch');

    _unlockedItems.clear();
    _unlockedItems.addAll(
      _quotesProvider.items.isNotEmpty
          ? _quotesProvider.items.where((item) => item.isInCollection == true)
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
  }
}
