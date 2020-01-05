import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class CollectionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: Provider.of<Quotes>(context).unlockedQuotes.length,
          itemBuilder: (ctx, index) => GridCell(index),
        ),
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final index;
  GridCell(this.index);

  @override
  Widget build(BuildContext context) {
    final quote = Provider.of<Quotes>(context).unlockedQuotes[index];
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        child: GridTile(
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  quote.rarityText(),
                ),
                Text(
                  quote.quote,
                ),
              ],
            ),
            color: Colors.white,
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            leading: Icon(Icons.favorite),
            subtitle: Text(
              DateFormat('d|M|y H:m').format(quote.unlockingTime),
            ),
            title: Text(
              quote.author == '' ? 'Unknown' : quote.author,
            ),
          ),
        ),
      ),
    );
  }
}
