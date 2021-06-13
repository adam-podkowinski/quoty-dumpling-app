import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/animations.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/models/items/money_item.dart';
import 'package:quoty_dumpling_app/models/items/powerup_item.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/shop_items.dart';

class Item extends StatefulWidget {
  final ShopItem item;
  final Color activeColor;
  final void Function(String id)? onPressedFunction;

  Item(this.item, this.activeColor, [this.onPressedFunction]);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with TickerProviderStateMixin {
  late Shop _shopProvider;
  late ShopItems _shopItemsProvider;
  bool _isFree = false;
  bool _isActive = true;
  var _isInit = true;

  AnimationController? _iconColorcontroller;
  late Animation _iconColorAnim;

  late AnimationController _scaleController;
  late Animation _scaleAnim;

  TextSpan? _textSpanSmall;
  late TextPainter _textPainterSmall;

  TextSpan? _textSpanBig;
  late TextPainter _textPainterBig;

  //Powerup stuff
  bool _isRunningPowerup = false;
  late Animatable<Color?> _runningPowerupColor;
  late AnimationController _runningPowerupColorController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.03),
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
                          _runningPowerupColorController.value,
                        ),
                      )!
                    : _isActive
                        ? widget.activeColor
                        : Colors.grey,
              ),
            ),
            padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _runningPowerupColorController,
                  builder: (context, _) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: SizeConfig.screenWidth! * 0.24,
                      height: SizeConfig.screenWidth! * 0.24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.screenWidth! * 0.05,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 25,
                            color: Theme.of(context)
                                .textTheme
                                .headline6!
                                .color!
                                .withOpacity(.3),
                            spreadRadius: 1,
                          ),
                        ],
                        color: _isRunningPowerup
                            ? _runningPowerupColor.evaluate(
                                AlwaysStoppedAnimation(
                                  _runningPowerupColorController.value,
                                ),
                              )
                            : _isActive
                                ? widget.activeColor
                                : Colors.grey,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.screenWidth! * .02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              widget.item.itemTypeIcon(),
                              color: ThemeColors.onSecondary,
                            ),
                            if (widget.item is LabeledItem)
                              if ((widget.item as LabeledItem).hasLabel) ...[
                                SizedBox(
                                  height: SizeConfig.screenHeight * .01,
                                ),
                                FittedBox(
                                  child: Text(
                                    (widget.item as LabeledItem).getLabel(),
                                    style: Styles.itemLevelTextStyle,
                                  ),
                                ),
                              ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.03,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.item.name!,
                        style: Styles.shopItemTitleStyle,
                      ),
                      if (widget.item.description!.isNotEmpty)
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.005,
                        ),
                      if (widget.item.description!.isNotEmpty)
                        Text(
                          widget.item.description!,
                          style: Styles.shopItemDescriptionStyle,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.03,
                ),
                Column(
                  children: <Widget>[
                    if (_isFree)
                      buildPriceChip(
                        Text(
                          'FREE',
                          style: Styles.moneyInShopItemTextStyle,
                        ),
                        avatar: Icon(
                          Icons.attach_money,
                          color: ThemeColors.surface,
                        ),
                      ),
                    if (widget.item.actualPriceBills != 0)
                      buildPriceChip(
                        Text(
                          Shop.numberAbbreviation(widget.item.actualPriceBills),
                          textAlign: TextAlign.center,
                          style: Styles.moneyInShopItemTextStyle,
                        ),
                        avatar: Icon(
                          Icons.attach_money,
                          color: ThemeColors.surface,
                        ),
                      ),
                    if (widget.item.actualPriceDiamonds != 0)
                      buildPriceChip(
                        Text(
                          Shop.numberAbbreviation(
                              widget.item.actualPriceDiamonds),
                          textAlign: TextAlign.center,
                          style: Styles.moneyInShopItemTextStyle,
                        ),
                        avatar: Padding(
                          padding:
                              EdgeInsets.all(SizeConfig.screenWidth! * 0.01),
                          child: Icon(
                            CustomIcons.diamond,
                            size: SizeConfig.screenWidth! * 0.05,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    if (widget.item.priceUSD != '0')
                      buildPriceChip(
                        Row(
                          children: <Widget>[
                            Text(
                              widget.item.priceUSD ?? '0\$',
                              style: Styles.moneyInShopItemTextStyle,
                            ),
                          ],
                        ),
                      ),
                    AnimatedBuilder(
                      animation: _runningPowerupColorController,
                      builder: (context, _) {
                        return ScaleTransition(
                          scale: _scaleAnim as Animation<double>,
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
                              builder: (_, ch) => IconButton(
                                icon: ch!,
                                color: _iconColorAnim.value,
                                onPressed: () async {
                                  if (_isActive) {
                                    await Provider.of<AudioProvider>(context,
                                            listen: false)
                                        .playBuyItem();
                                    if (widget.item.priceUSD == '0') {
                                      _shopProvider.buyItem(
                                        widget.item,
                                        context,
                                      );
                                    }

                                    if (widget.onPressedFunction != null) {
                                      widget.onPressedFunction!(
                                        widget.item.id ?? '',
                                      );
                                    }

                                    await _scaleController.forward().then(
                                          (_) => _scaleController.reverse(),
                                        );
                                  }
                                },
                              ),
                              child: Icon(Icons.add),
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

  Widget buildPriceChip(Widget label, {Widget? avatar}) {
    return Chip(
      label: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        constraints: BoxConstraints(
          minWidth: max(widget.item.actualPriceBills!,
                      widget.item.actualPriceDiamonds!) >
                  999
              ? _textPainterBig.width
              : _textPainterSmall.width,
        ),
        child: label,
      ),
      avatar: avatar,
      backgroundColor: ThemeColors.onSecondary,
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
        begin: ThemeColors.onSecondary,
        end: Theme.of(context).disabledColor,
      ).animate(_iconColorcontroller!);

      _isFree = widget.item.actualPriceBills! <= 0 &&
          widget.item.actualPriceDiamonds! <= 0 &&
          widget.item.priceUSD! == '0';

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
          TextSpan(text: '444', style: Styles.moneyInShopItemTextStyle);
      _textPainterSmall =
          TextPainter(text: _textSpanSmall, textDirection: TextDirection.ltr)
            ..layout();

      _textSpanBig =
          TextSpan(text: '444.3W', style: Styles.moneyInShopItemTextStyle);
      _textPainterBig =
          TextPainter(text: _textSpanBig, textDirection: TextDirection.ltr)
            ..layout();

      _isInit = false;
    }
  }

  @override
  void dispose() {
    _iconColorcontroller!.dispose();
    _scaleController.dispose();
    _runningPowerupColorController.dispose();
    _shopProvider.removeListener(_itemListener);
    _shopItemsProvider.removeListener(_itemListener);
    super.dispose();
  }

  void _itemListener() {
    print('Item listener!');
    _isActive = _shopProvider.checkIsActiveItem(widget.item, context);
    if (widget.item is PowerupItem) {
      _isRunningPowerup = (widget.item as PowerupItem).isRunning;
    }

    if (widget.item is MoneyItem) {
      _isActive = _shopItemsProvider.isAvailable &&
          _shopItemsProvider.isMoneyItemAvailable(widget.item as MoneyItem);
      return;
    }

    if (!_isActive) {
      _iconColorcontroller?.forward();
    } else {
      _iconColorcontroller?.reverse();
    }

    if (_isRunningPowerup) {
      _runningPowerupColorController.repeat();
    } else {
      _runningPowerupColorController.reset();
    }
  }
}
