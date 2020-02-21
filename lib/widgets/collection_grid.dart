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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _quotesProvider = Provider.of<Quotes>(context);
      disposeController =
          Provider.of<CollectionSettings>(context).disposeScrollController;
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
            ? StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: SizeConfig.screenWidth * 0.0268,
                crossAxisSpacing: SizeConfig.screenWidth * 0.0268,
                controller:
                    Provider.of<CollectionSettings>(context).scrollController,

                //*if new quotes list is empty there are no new quotes so building additional
                //* dividers and new quotes tiles is unnecessary
                //*else we have to add 2 to an item count because there are two dividers which
                //*divides new quotes with old ones and we need to add new quotes length because
                //*they will be displayed
                itemCount: _quotesProvider.newQuotes.length > 0
                    ? _quotesProvider.newQuotes.length +
                        _quotesProvider.visibleQuotes.length +
                        2
                    : _quotesProvider.visibleQuotes.length,

                //*first we need to put one widget on top so on index = 1 => staggered.fit(2), then
                //*new quotes are displayed with old quotes because implementations of them in
                //*staggered tiles is equal. Divider seperates them so another staggeredTile.fit(2)
                //*is necessary
                staggeredTileBuilder: _quotesProvider.newQuotes.length > 0
                    ? (index) {
                        if (index == 0)
                          return StaggeredTile.fit(2);
                        else if (index == _quotesProvider.newQuotes.length + 1)
                          return StaggeredTile.fit(2);
                        else
                          return StaggeredTile.count(1, 1);
                      }
                    : (index) => StaggeredTile.count(1, 1),
                //?
                itemBuilder: _quotesProvider.newQuotes.length > 0
                    ? (ctx, index) {
                        if (index == 0)
                          return _buildNewQuotesTopDivider();
                        else if (index == _quotesProvider.newQuotes.length + 1)
                          return ScaleTransition(
                            scale: _newQuotesAnimation,
                            child: Divider(
                              thickness: 3,
                              color: Theme.of(context).accentColor,
                            ),
                          );
                        else if (index < _quotesProvider.newQuotes.length + 1)
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0, end: 1)
                                .animate(_controller),
                            child: GridCell(
                              _quotesProvider.newQuotes[index - 1],
                            ),
                          );
                        return GridCell(
                          _quotesProvider.visibleQuotes[
                              index - _quotesProvider.newQuotes.length - 2],
                        );
                      }
                    //?
                    : (ctx, index) => GridCell(
                          _quotesProvider.visibleQuotes[index],
                        ),
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
