import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/search_bar.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  Quotes _quotesProvider;
  List<Quote> _unlockedQuotes = [];

  @override
  void initState() {
    super.initState();
    _quotesProvider = Provider.of<Quotes>(context, listen: false);
    _unlockedQuotes =
        _quotesProvider.items.where((e) => e.isUnlocked == true).toList();

    //sort by time first LESS IMPORTANT THAN BY RARITY
    _unlockedQuotes.sort(
      (a, b) =>
          a.unlockingTime.millisecond.compareTo(b.unlockingTime.millisecond),
    );
    //then sort by rarity MORE IMPORTANT THAN BY TIME
    _unlockedQuotes.sort(
      (a, b) => a.rarity.index.compareTo(b.rarity.index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor.withOpacity(.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [.66, 1],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: _unlockedQuotes.length <= 0
              ? <Widget>[
                  CustomAppBar('Collection'),
                  NothingInCollectionWidget(),
                ]
              : <Widget>[
                  CustomAppBar('Collection'),
                  SearchBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _unlockedQuotes.length,
                      itemBuilder: (ctx, index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(_unlockedQuotes[index].rarityText()),
                          Text(
                            _unlockedQuotes[index]
                                .unlockingTime
                                .millisecond
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

class NothingInCollectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'You haven\'t unlocked anything yet. Go and open your dumplings!',
      textAlign: TextAlign.center,
    );
    //TODO: Add button which goes to dumpling screen and add some styling
  }
}
