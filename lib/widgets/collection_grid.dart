import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

class _CollectionGridState extends State<CollectionGrid>
    with SingleTickerProviderStateMixin {
  Quotes _quotesProvider;
  Function disposeController;
  var _isInit = true;

  AnimationController _controller;
  Animation _newQuotesAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _newQuotesAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();

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
    disposeController();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildNewQuotesTopDivider() => ScaleTransition(
        scale: _newQuotesAnimation,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Divider(
                thickness: 3,
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'New quotes',
              style: Styles.kSettingsTextStyle,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 4,
              child: Divider(
                thickness: 3,
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(width: 5),
            FlatButton(
              onPressed: () {
                _controller.reverse().then(
                      (e) => _quotesProvider.addToUnlockedFromNew(),
                    );
              },
              child: Text(
                'OK',
                style: Styles.kSettingsTextStyle,
              ),
              color: Theme.of(context).accentColor.withOpacity(.8),
            ),
            SizedBox(width: 5),
            Flexible(
              flex: 1,
              child: Divider(
                thickness: 3,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(
          SizeConfig.screenWidth * 0.0234,
        ),
        child: _quotesProvider.visibleQuotes.length > 0 ||
                _quotesProvider.newQuotes.length > 0
            ? _quotesProvider.areQuotesLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StaggeredGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: SizeConfig.screenWidth * 0.0268,
                    crossAxisSpacing: SizeConfig.screenWidth * 0.0268,
                    controller: Provider.of<CollectionSettings>(context)
                        .scrollController,
                    children: _quotesProvider.newQuotes.length > 0
                        ? <Widget>[
                            _buildNewQuotesTopDivider(),
                            for (var q in _quotesProvider.newQuotes)
                              ScaleTransition(
                                scale: Tween<double>(begin: 0, end: 1)
                                    .animate(_controller),
                                child: GridCell(
                                  q,
                                  _quotesProvider.newQuotes.indexOf(q),
                                ),
                              ),
                            ScaleTransition(
                              scale: _newQuotesAnimation,
                              child: Divider(
                                thickness: 3,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            for (var q in _quotesProvider.visibleQuotes)
                              GridCell(
                                q,
                                _quotesProvider.visibleQuotes.indexOf(q),
                              ),
                          ]
                        : <Widget>[
                            for (var q in _quotesProvider.visibleQuotes)
                              GridCell(
                                q,
                                _quotesProvider.visibleQuotes.indexOf(q),
                              ),
                          ],
                    staggeredTiles: _quotesProvider.newQuotes.length > 0
                        ? [
                            StaggeredTile.fit(2),
                            for (int i = 0;
                                i < _quotesProvider.newQuotes.length;
                                i++)
                              StaggeredTile.count(1, 1),
                            StaggeredTile.fit(2),
                            for (int i = 0;
                                i < _quotesProvider.visibleQuotes.length;
                                i++)
                              StaggeredTile.count(1, 1),
                          ]
                        : [
                            for (int i = 0;
                                i < _quotesProvider.visibleQuotes.length;
                                i++)
                              StaggeredTile.count(1, 1),
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
  final int index;
  GridCell(this.quote, this.index);

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
      duration: Quotes.animationDuration,
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

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  void animateCollectionTiles() {
    if (!(_quotesProvider.newQuotes.contains(widget.quote)) &&
        _quotesProvider.animateCollectionTiles &&
        _quotesProvider.collectionTilesToAnimate.contains(
          _quotesProvider.visibleQuotes.indexOf(widget.quote),
        ) &&
        _controller != null) {
      _controller.forward().then(
            (_) => _controller.reverse(),
          );
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
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenWidth * 0.0381),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
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
                          color:
                              widget.quote.rarityColor(context).withOpacity(.7),
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
    );
  }
}
