import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: Styles.backgroundGradient),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              'Shop',
              prefix: Row(
                children: <Widget>[
                  Icon(
                    Icons.attach_money,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: SizeConfig.screenWidth * 0.063,
                  ),
                  Flexible(
                    child: AutoSizeText(
                      Provider.of<Shop>(context).bills.toString(),
                      maxLines: 1,
                      style: Styles.kMoneyTextStyle,
                    ),
                  ),
                ],
              ),
              suffix: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: AutoSizeText(
                        Provider.of<Shop>(context).gems.toString(),
                        style: Styles.kMoneyTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      CustomIcons.diamond,
                      color: Colors.blue,
                      size: SizeConfig.screenWidth * 0.06,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.07,
                          child: TabBar(
                            labelStyle: Styles.kTabBarTextStyle,
                            indicatorColor: Theme.of(context).buttonColor,
                            labelPadding: EdgeInsets.only(top: 5),
                            indicatorWeight: 5,
                            tabs: [
                              Text(
                                'Upgrades',
                              ),
                              Text(
                                'Coins',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ShopTabBarView(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopTabBarView extends StatefulWidget {
  @override
  _ShopTabBarViewState createState() => _ShopTabBarViewState();
}

class _ShopTabBarViewState extends State<ShopTabBarView> {
  Widget shopItem(
    String name, {
    String description = '',
    int priceBills = 0,
    int priceDiamonds = 0,
  }) {
    bool isFree = priceBills <= 0 && priceDiamonds <= 0;
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
                    name,
                    style: Styles.kShopItemTitleStyle,
                  ),
                  if (description != null)
                    Text(
                      description,
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
                if (isFree)
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
                if (priceBills != 0)
                  Chip(
                    label: Text(
                      '${priceBills ?? 0}',
                      style: Styles.kMoneyInShopTextStyle,
                    ),
                    avatar: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    backgroundColor: Styles.appBarTextColor,
                  ),
                if (priceDiamonds != 0)
                  Chip(
                    label: Text(
                      '${priceDiamonds ?? 0}',
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    color: Styles.appBarTextColor,
                    onPressed: () {
                      Provider.of<Shop>(context).buyItem(
                          priceInBills: priceBills,
                          priceInDiamond: priceDiamonds);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListView(
          children: <Widget>[
            for (int i in Iterable.generate(10))
              shopItem(
                '$i Item',
                description: i == 0
                    ? 'Omg it\'s the best item!'
                    : '${i}th item is $i times better than the ${i - 1} item',
                priceBills: i * 100,
                // priceDiamonds: i * Random().nextInt(10),
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
