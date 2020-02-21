import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/audio_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
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
          children: <Widget>[
            for (int i in Iterable.generate(10))
              ShopItem(
                '$i Item',
                description: i == 0
                    ? 'Omg it\'s the best item!'
                    : '${i}th item is $i times better than the ${i - 1} item',
                priceBills: i * 100,
              ),
          ],
        ),
        Container(
          color: Colors.yellow.withOpacity(.5),
        ),
      ],
    );
  }
}

class ShopItem extends StatefulWidget {
  final String name;
  final String description;
  final int priceBills;
  final int priceDiamonds;

  ShopItem(
    this.name, {
    this.description = '',
    this.priceBills = 0,
    this.priceDiamonds = 0,
  });

  @override
  _ShopItemState createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem>
    with SingleTickerProviderStateMixin {
  Shop _shopProvider;
  bool _isFree = false;
  bool _isActive = true;
  var _isInit = true;

  AnimationController _controller;
  Animation _iconColorAnim;

  void _shopListener() {
    _isActive = _shopProvider.bills >= widget.priceBills &&
        _shopProvider.diamonds >= widget.priceDiamonds;
    if (!_isActive)
      _controller?.forward();
    else
      _controller?.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      );
      _iconColorAnim = ColorTween(
        begin: Styles.appBarTextColor,
        end: Theme.of(context).disabledColor,
      ).animate(_controller);

      _isFree = widget.priceBills <= 0 && widget.priceDiamonds <= 0;

      _shopProvider = Provider.of<Shop>(context)..addListener(_shopListener);

      _isActive = _shopProvider.bills >= widget.priceBills &&
          _shopProvider.diamonds >= widget.priceDiamonds;
      if (!_isActive)
        _controller.forward();
      else
        _controller.reverse();

      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _shopProvider.removeListener(_shopListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            width: 3.0,
            color: Theme.of(context).accentColor,
          ),
        ),
        padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
        child: Row(
          children: <Widget>[
            Container(
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
                color: Theme.of(context).accentColor,
              ),
              child: Icon(
                Icons.exposure,
                color: Styles.appBarTextColor,
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 0.03,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: Styles.kShopItemTitleStyle,
                  ),
                  if (widget.description != null)
                    Text(
                      widget.description,
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
                  Chip(
                    label: Text(
                      'FREE',
                      style: Styles.kMoneyInShopTextStyle,
                    ),
                    avatar: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    backgroundColor: Styles.appBarTextColor,
                  ),
                if (widget.priceBills != 0)
                  Chip(
                    label: Text(
                      '${widget.priceBills ?? 0}',
                      style: Styles.kMoneyInShopTextStyle,
                    ),
                    avatar: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    backgroundColor: Styles.appBarTextColor,
                  ),
                if (widget.priceDiamonds != 0)
                  Chip(
                    label: Text(
                      '${widget.priceDiamonds ?? 0}',
                      style: Styles.kMoneyInShopTextStyle,
                    ),
                    avatar: Padding(
                      padding: EdgeInsets.all(SizeConfig.screenWidth * 0.01),
                      child: Icon(
                        CustomIcons.diamond,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                    backgroundColor: Styles.appBarTextColor,
                  ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _isActive ? Theme.of(context).accentColor : Colors.grey,
                  ),
                  child: AnimatedBuilder(
                    animation: _iconColorAnim,
                    child: Icon(Icons.add),
                    builder: (_, ch) => IconButton(
                      icon: ch,
                      color: _iconColorAnim.value,
                      onPressed: () async {
                        if (_isActive) {
                          await Provider.of<AudioProvider>(context)
                              .playBuyUpgrade();
                          _shopProvider.buyItem(
                              priceInBills: widget.priceBills,
                              priceInDiamond: widget.priceDiamonds);
                        }
                      },
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
}
