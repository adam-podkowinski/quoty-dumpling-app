import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quoty_dumpling_app/widgets/quote_details.dart';

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
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenWidth * 0.0268,
        ),
        child: _quotesProvider.visibleQuotes.length > 0 ||
                _quotesProvider.newQuotes.length > 0
            ? _quotesProvider.areQuotesLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2.2,
                      mainAxisSpacing: 10,
                    ),
                    children: <Widget>[
                      // Row(
                      //   children: <Widget>[
                      //     Flexible(
                      //       flex: 1,
                      //       child: Divider(
                      //         thickness: 3,
                      //         color: Theme.of(context).accentColor,
                      //       ),
                      //     ),
                      //     // SizedBox(
                      //     //   width: 5,
                      //     // ),
                      //     // Text(
                      //     //   'New quotes',
                      //     //   style: Styles.kSettingsTextStyle,
                      //     // ),
                      //     // SizedBox(
                      //     //   width: 5,
                      //     // ),
                      //     Flexible(
                      //       flex: 4,
                      //       child: Divider(
                      //         thickness: 3,
                      //         color: Theme.of(context).accentColor,
                      //       ),
                      //     ),
                      //   ],
                      // // ),
                      // Divider(
                      //   color: Theme.of(context).accentColor,
                      //   thickness: 3,
                      // ),
                      // Divider(
                      //   color: Theme.of(context).accentColor,
                      //   thickness: 3,
                      // ),
                      for (var q in _quotesProvider.visibleQuotes) GridCell(q)
                    ],
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
  final Quote quote;
  GridCell(this.quote);

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
      duration: Quotes.animationTime,
    );
    _inOutAnimation = Tween<double>(
      begin: 1,
      end: .1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  void animateCollectionTiles() {
    if (_quotesProvider.animateCollectionTiles) {
      if (_quotesProvider.collectionTilesToAnimate.contains(
        _quotesProvider.visibleQuotes.indexOf(widget.quote),
      )) {
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
          child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => QuoteDetails(
                widget.quote,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 0.0134,
              ),
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
                            widget.quote.quote,
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
                            color: widget.quote
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
                            widget.quote.changeFavorite();

                            if (_quotesProvider.favoritesOnTop)
                              _quotesProvider.sortCollection(true);
                          }),
                          child: Icon(
                            widget.quote.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: heartColor,
                          ),
                        ),
                        title: Text(
                          widget.quote.author,
                          style: TextStyle(
                            fontFamily: Styles.fontFamily,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.title.color,
                          ),
                        ),
                        subtitle: Text(
                          widget.quote.rarityText(),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: Styles.fontFamily,
                            color: Theme.of(context).textTheme.title.color,
                          ),
                        ),
                        backgroundColor: widget.quote.rarityColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
