import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/animations.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/models/items/powerupItem.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/items.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';

class ShopTabBarView extends StatefulWidget {
  @override
  _ShopTabBarViewState createState() => _ShopTabBarViewState();
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
              .map((u) => Item(u, Theme.of(context).accentColor))
              .toList(),
        ),
        ListView(
          children: Provider.of<ShopItems>(context)
              .powerups
              .map((u) => Item(u, Theme.of(context).buttonColor))
              .toList(),
        ),
        ListView(
          children: Provider.of<ShopItems>(context)
              .money
              .map((u) => Item(u, Theme.of(context).secondaryHeaderColor))
              .toList(),
        ),
      ],
    );
  }
}

class Item extends StatefulWidget {
  final ShopItem item;
  final Color activeColor;

  Item(this.item, this.activeColor);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with TickerProviderStateMixin {
  Shop _shopProvider;
  ShopItems _shopItemsProvider;
  bool _isFree = false;
  bool _isActive = true;
  var _isInit = true;

  AnimationController _iconColorcontroller;
  Animation _iconColorAnim;

  AnimationController _scaleController;
  Animation _scaleAnim;

  TextSpan _textSpanSmall;
  TextPainter _textPainterSmall;

  TextSpan _textSpanBig;
  TextPainter _textPainterBig;

  //Powerup stuff
  bool _isRunningPowerup = false;
  Animatable<Color> _runningPowerupColor;
  AnimationController _runningPowerupColorController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
      child: AnimatedBuilder(
        animation: _runningPowerupColorController,
        builder: (context, ch) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                width: 3.0,
                color: _isRunningPowerup
                    ? _runningPowerupColor.evaluate(
                        AlwaysStoppedAnimation(
                            _runningPowerupColorController.value),
                      )
                    : _isActive ? widget.activeColor : Colors.grey,
              ),
            ),
            padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedBuilder(
                    animation: _runningPowerupColorController,
                    builder: (context, _) {
                      return AnimatedContainer(
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
                              color: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .color
                                  .withOpacity(.3),
                              spreadRadius: 1,
                            ),
                          ],
                          color: _isRunningPowerup
                              ? _runningPowerupColor.evaluate(
                                  AlwaysStoppedAnimation(
                                      _runningPowerupColorController.value),
                                )
                              : _isActive ? widget.activeColor : Colors.grey,
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
                              if (widget.item is LabeledItem)
                                if ((widget.item as LabeledItem).hasLabel)
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                              if (widget.item is LabeledItem)
                                if ((widget.item as LabeledItem).hasLabel)
                                  FittedBox(
                                    child: Text(
                                      (widget.item as LabeledItem).getLabel(),
                                      style: Styles.kItemLevelTextStyle,
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      );
                    }),
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
                      if (widget.item.description.length > 0)
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.005,
                        ),
                      if (widget.item.description.length > 0)
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
                          _shopProvider.numberAbbreviation(
                              widget.item.actualPriceDiamonds),
                          textAlign: TextAlign.center,
                          style: Styles.kMoneyInShopItemTextStyle,
                        ),
                        avatar: Padding(
                          padding:
                              EdgeInsets.all(SizeConfig.screenWidth * 0.01),
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
                    AnimatedBuilder(
                      animation: _runningPowerupColorController,
                      builder: (context, _) {
                        return ScaleTransition(
                          scale: _scaleAnim,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isRunningPowerup
                                  ? _runningPowerupColor.evaluate(
                                      AlwaysStoppedAnimation(
                                          _runningPowerupColorController.value),
                                    )
                                  : _isActive
                                      ? widget.activeColor
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
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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
              ? _textPainterBig.width
              : _textPainterSmall.width,
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
          widget.item.actualPriceDiamonds <= 0 &&
          widget.item.priceUSD <= 0;

      _runningPowerupColor = runningPowerupColor(context);
      _runningPowerupColorController = AnimationController(
        duration: const Duration(milliseconds: 4500),
        vsync: this,
      );

      _shopItemsProvider = Provider.of<ShopItems>(context)
        ..addListener(_itemListener);
      _shopProvider = Provider.of<Shop>(context)..addListener(_itemListener);
      _itemListener();

      _scaleController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 120),
      );
      _scaleAnim = Tween<double>(begin: 1, end: .85).animate(_scaleController);

      _textSpanSmall =
          TextSpan(text: '444', style: Styles.kMoneyInShopItemTextStyle);
      _textPainterSmall =
          TextPainter(text: _textSpanSmall, textDirection: TextDirection.ltr)
            ..layout();

      _textSpanBig =
          TextSpan(text: '444.3W', style: Styles.kMoneyInShopItemTextStyle);
      _textPainterBig =
          TextPainter(text: _textSpanBig, textDirection: TextDirection.ltr)
            ..layout();

      _isInit = false;
    }
  }

  @override
  void dispose() {
    _iconColorcontroller.dispose();
    _scaleController.dispose();
    _runningPowerupColorController.dispose();
    _shopProvider.removeListener(_itemListener);
    _shopItemsProvider.removeListener(_itemListener);
    super.dispose();
  }

  void _itemListener() {
    _isActive = _shopProvider.checkIsActiveItem(widget.item, context);
    if (widget.item is PowerupItem)
      _isRunningPowerup = (widget.item as PowerupItem).isRunning;

    if (!_isActive)
      _iconColorcontroller?.forward();
    else
      _iconColorcontroller?.reverse();

    if (_isRunningPowerup)
      _runningPowerupColorController.repeat();
    else
      _runningPowerupColorController.reset();
  }
}
