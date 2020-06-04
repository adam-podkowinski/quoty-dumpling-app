import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/models/item.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/items.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class Item extends StatefulWidget {
  final ShopItem item;

  Item(this.item);

  @override
  _ItemState createState() => _ItemState();
}

class ShopTabBarView extends StatefulWidget {
  @override
  _ShopTabBarViewState createState() => _ShopTabBarViewState();
}

class _ItemState extends State<Item> with TickerProviderStateMixin {
  Shop _shopProvider;
  bool _isFree = false;
  bool _isActive = true;
  var _isInit = true;

  AnimationController _iconColorcontroller;
  Animation _iconColorAnim;

  AnimationController _scaleController;
  Animation _scaleAnim;

  TextSpan textSpanSmall;
  TextPainter textPainterSmall;

  TextSpan textSpanBig;
  TextPainter textPainterBig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            width: 3.0,
            color: _isActive ? Theme.of(context).accentColor : Colors.grey,
          ),
        ),
        padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: SizeConfig.screenWidth * 0.24,
              height: SizeConfig.screenWidth * 0.24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SizeConfig.screenWidth * 0.05,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 25,
                    color:
                        Theme.of(context).textTheme.title.color.withOpacity(.3),
                    spreadRadius: 1,
                  ),
                ],
                color: _isActive ? Theme.of(context).accentColor : Colors.grey,
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.screenWidth * .02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      widget.item.itemTypeIcon(),
                      color: Styles.appBarTextColor,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * .01,
                    ),
                    FittedBox(
                      child: Text(
                        'Level: ${widget.item.level.toString()}',
                        style: Styles.kItemLevelTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 0.03,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.item.name,
                    style: Styles.kShopItemTitleStyle,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.005,
                  ),
                  Text(
                    widget.item.description,
                    style: Styles.kShopItemDescriptionStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 0.03,
            ),
            Column(
              children: <Widget>[
                if (_isFree)
                  buildPriceChip(
                    Text(
                      'FREE',
                      style: Styles.kMoneyInShopItemTextStyle,
                    ),
                    avatar: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                if (widget.item.actualPriceBills != 0)
                  buildPriceChip(
                    Text(
                      _shopProvider
                          .numberAbbreviation(widget.item.actualPriceBills),
                      textAlign: TextAlign.center,
                      style: Styles.kMoneyInShopItemTextStyle,
                    ),
                    avatar: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                if (widget.item.actualPriceDiamonds != 0)
                  buildPriceChip(
                    Text(
                      _shopProvider
                          .numberAbbreviation(widget.item.actualPriceDiamonds),
                      style: Styles.kMoneyInShopItemTextStyle,
                    ),
                    avatar: Padding(
                      padding: EdgeInsets.all(SizeConfig.screenWidth * 0.01),
                      child: Icon(
                        CustomIcons.diamond,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                if (widget.item.priceUSD != 0)
                  buildPriceChip(
                    Row(
                      children: <Widget>[
                        Text(
                          'USD ',
                          style: Styles.kMoneyInShopItemTextStyle.copyWith(
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        Text(
                          _shopProvider
                              .numberAbbreviation(widget.item.priceUSD),
                          style: Styles.kMoneyInShopItemTextStyle,
                        ),
                      ],
                    ),
                  ),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isActive
                          ? Theme.of(context).accentColor
                          : Colors.grey,
                    ),
                    child: AnimatedBuilder(
                      animation: _iconColorAnim,
                      child: Icon(Icons.add),
                      builder: (_, ch) => IconButton(
                        icon: ch,
                        color: _iconColorAnim.value,
                        onPressed: () async {
                          if (_isActive) {
                            _scaleController.forward().then(
                                  (_) => _scaleController.reverse(),
                                );
                            await Provider.of<AudioProvider>(context)
                                .playBuyItem();
                            _shopProvider.buyItem(widget.item, context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPriceChip(Widget label, {Widget avatar}) {
    return Chip(
      label: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        constraints: BoxConstraints(
          minWidth: max(widget.item.actualPriceBills,
                      widget.item.actualPriceDiamonds) >
                  999
              ? textPainterBig.width
              : textPainterSmall.width,
          //maxWidth: max(widget.item.actualPriceBills,
          //widget.item.actualPriceDiamonds) >
          //999
          //? textPainterBig.width
          //: textPainterSmall.width,
        ),
        child: label,
      ),
      avatar: avatar,
      backgroundColor: Styles.appBarTextColor,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _iconColorcontroller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      );
      _iconColorAnim = ColorTween(
        begin: Styles.appBarTextColor,
        end: Theme.of(context).disabledColor,
      ).animate(_iconColorcontroller);

      _isFree = widget.item.actualPriceBills <= 0 &&
          widget.item.actualPriceDiamonds <= 0;

      _shopProvider = Provider.of<Shop>(context)..addListener(_shopListener);

      _isActive = _shopProvider.bills >= widget.item.actualPriceBills &&
          _shopProvider.diamonds >= widget.item.actualPriceDiamonds;
      if (!_isActive)
        _iconColorcontroller.forward();
      else
        _iconColorcontroller.reverse();

      //

      _scaleController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 120),
      );
      _scaleAnim = Tween<double>(begin: 1, end: .85).animate(_scaleController);

      _isInit = false;

      textSpanSmall =
          TextSpan(text: '444', style: Styles.kMoneyInShopItemTextStyle);
      textPainterSmall =
          TextPainter(text: textSpanSmall, textDirection: TextDirection.ltr)
            ..layout();

      textSpanBig =
          TextSpan(text: '444.3W', style: Styles.kMoneyInShopItemTextStyle);
      textPainterBig =
          TextPainter(text: textSpanBig, textDirection: TextDirection.ltr)
            ..layout();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _iconColorcontroller.dispose();
    _scaleController.dispose();
    _shopProvider.removeListener(_shopListener);
  }

  void _shopListener() {
    _isActive = _shopProvider.bills >= widget.item.actualPriceBills &&
        _shopProvider.diamonds >= widget.item.actualPriceDiamonds;
    if (!_isActive)
      _iconColorcontroller?.forward();
    else
      _iconColorcontroller?.reverse();
  }
}

class _ShopTabBarViewState extends State<ShopTabBarView> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListView(
          children: Provider.of<ShopItems>(context)
              .upgrades
              .map((u) => Item(u))
              .toList(),
        ),
        ListView(
          children: Provider.of<ShopItems>(context)
              .powerups
              .map((u) => Item(u))
              .toList(),
        ),
        ListView(
          children: Provider.of<ShopItems>(context)
              .money
              .map((u) => Item(u))
              .toList(),
        ),
      ],
    );
  }
}
