import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CollectionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount:
              Provider.of<Quotes>(context, listen: false).unlockedQuotes.length,
          itemBuilder: (ctx, index) => GridCell(index),
        ),
      ),
    );
  }
}

class GridCell extends StatefulWidget {
  final int index;
  GridCell(this.index);

  @override
  _GridCellState createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  var quotesProvider;
  var _isInit = true;

  final heartColor = Color(0xfffa4252);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      quotesProvider = Provider.of<Quotes>(context);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      verticalOffset: 50.0,
      child: FadeInAnimation(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.screenWidth * 0.0381),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(
                    SizeConfig.screenWidth * .022,
                  ),
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: AutoSizeText(
                      quotesProvider.unlockedQuotes[widget.index].quote,
                      textAlign: TextAlign.center,
                      maxLines: 7,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: SizeConfig.screenWidth * 0.04328,
                        color: Theme.of(context).textTheme.title.color,
                      ),
                    ),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: quotesProvider.unlockedQuotes[widget.index]
                          .rarityColor(context)
                          .withOpacity(.7),
                      blurRadius: 99,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: GridTileBar(
                  leading: InkWell(
                    onTap: () => setState(
                      () => quotesProvider.unlockedQuotes[widget.index]
                          .changeFavorite(),
                    ),
                    child: Icon(
                      quotesProvider.unlockedQuotes[widget.index].isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: heartColor,
                    ),
                  ),
                  title: Text(
                    quotesProvider.unlockedQuotes[widget.index].author == ''
                        ? 'Unknown'
                        : quotesProvider.unlockedQuotes[widget.index].author,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.title.color,
                    ),
                  ),
                  subtitle: Text(
                    quotesProvider.unlockedQuotes[widget.index].rarityText(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Lato',
                      color: Theme.of(context).textTheme.title.color,
                    ),
                  ),
                  backgroundColor: quotesProvider.unlockedQuotes[widget.index]
                      .rarityColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// subtitle: Text(
//               DateFormat('d|M|y').add_Hm().format(quote.unlockingTime),
//             ),
