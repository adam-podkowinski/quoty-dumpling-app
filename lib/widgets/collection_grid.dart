import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class CollectionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: Provider.of<Quotes>(context).unlockedQuotes.length,
          itemBuilder: (ctx, index) => GridCell(index),
        ),
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final int index;
  GridCell(this.index);

  @override
  Widget build(BuildContext context) {
    final quote = Provider.of<Quotes>(context).unlockedQuotes[index];
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          GridTileBar(
            leading: InkWell(
              child: Icon(
                Icons.favorite,
              ),
            ),
            title: Text(
              quote.author == '' ? 'Unknown' : quote.author,
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
            subtitle: Text(
              quote.rarityText(),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontFamily: 'Lato',
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
            backgroundColor: quote.rarityColor(context),
          ),
        ],
      ),
    );
  }
}
// subtitle: Text(
//               DateFormat('d|M|y').add_Hm().format(quote.unlockingTime),
//             ),
