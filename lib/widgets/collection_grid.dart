import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CollectionGrid extends StatefulWidget {
  @override
  _CollectionGridState createState() => _CollectionGridState();
}

class _CollectionGridState extends State<CollectionGrid> {
  Quotes _quotesProvider;
  Function disposeController;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<CollectionSettings>(context).initScrollControlller();
      disposeController =
          Provider.of<CollectionSettings>(context).disposeScrollController;
      _quotesProvider = Provider.of<Quotes>(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _quotesProvider = Provider.of<Quotes>(context);
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposeController();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: _quotesProvider.visibleQuotes.length > 0
            ? _quotesProvider.areQuotesLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    controller: Provider.of<CollectionSettings>(context)
                        .scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2.2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _quotesProvider.visibleQuotes.length,
                    itemBuilder: (ctx, index) => GridCell(index),
                  )
            : SlideAnimation(
                verticalOffset: 50,
                child: AutoSizeText(
                  'Not found quotes with this particular phrase.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Styles.kSearchBarTextStyle,
                ),
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

class _GridCellState extends State<GridCell>
    with SingleTickerProviderStateMixin {
  Quotes _quotesProvider;
  var _isInit = true;
  Animation<double> _inOutAnimation;
  AnimationController _controller;

  final heartColor = Color(0xfffa4252);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 225),
    );
    _inOutAnimation = Tween<double>(
      begin: 1,
      end: .6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInSine,
      ),
    );
  }

  void animateCollectionTiles() {
    if (_quotesProvider.animateCollectionTiles) {
      if (_quotesProvider.collectionTilesToAnimate.contains(widget.index)) {
        _controller.forward().then(
              (_) => _controller.reverse(),
            );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _quotesProvider = Provider.of<Quotes>(context);
      _quotesProvider.addListener(animateCollectionTiles);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _inOutAnimation,
      child: SlideAnimation(
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
                        _quotesProvider.visibleQuotes[widget.index].quote,
                        textAlign: TextAlign.center,
                        maxLines: 7,
                        style: Styles.kQuoteStyle,
                      ),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _quotesProvider.visibleQuotes[widget.index]
                            .rarityColor(context)
                            .withOpacity(.7),
                        blurRadius: 99,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: GridTileBar(
                    leading: InkWell(
                      onTap: () => setState(() {
                        _quotesProvider.visibleQuotes[widget.index]
                            .changeFavorite();

                        if (_quotesProvider.favoritesOnTop)
                          Future.delayed(
                            Duration(milliseconds: 100),
                            () => _quotesProvider.sortCollection(true),
                          );
                      }),
                      child: Icon(
                        _quotesProvider.visibleQuotes[widget.index].isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: heartColor,
                      ),
                    ),
                    title: Text(
                      _quotesProvider.visibleQuotes[widget.index].author,
                      style: TextStyle(
                        fontFamily: Styles.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.title.color,
                      ),
                    ),
                    subtitle: Text(
                      _quotesProvider.visibleQuotes[widget.index].rarityText(),
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: Styles.fontFamily,
                        color: Theme.of(context).textTheme.title.color,
                      ),
                    ),
                    backgroundColor: _quotesProvider.visibleQuotes[widget.index]
                        .rarityColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// subtitle: Text(
//               DateFormat('d|M|y').add_Hm().format(quote.unlockingTime),
//             ),
