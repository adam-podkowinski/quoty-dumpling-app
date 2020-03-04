import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/shop_tab_bar_view.dart';

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
                      Provider.of<Shop>(context)
                          .numberAbbreviation(Provider.of<Shop>(context).bills),
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
                        Provider.of<Shop>(context).numberAbbreviation(
                            Provider.of<Shop>(context).diamonds),
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
                                'Currency',
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
