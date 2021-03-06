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
                    color: ThemeColors.surface,
                    size: SizeConfig.screenWidth! * 0.063,
                  ),
                  Flexible(
                    child: AutoSizeText(
                      Shop.numberAbbreviation(Provider.of<Shop>(context).bills),
                      maxLines: 1,
                      style: Styles.moneyTextStyle,
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
                        Shop.numberAbbreviation(
                            Provider.of<Shop>(context).diamonds),
                        style: Styles.moneyTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      CustomIcons.diamond,
                      color: Colors.blue,
                      size: SizeConfig.screenWidth! * 0.05,
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
                    length: 3,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.08,
                          child: TabBar(
                            labelStyle: Styles.tabBarTextStyle,
                            labelColor: ThemeColors.onSecondary,
                            indicatorColor: ThemeColors.secondaryLight,
                            labelPadding: EdgeInsets.only(top: 5),
                            indicatorWeight: 5,
                            tabs: [
                              Text(
                                'Upgrades',
                              ),
                              Text(
                                'Powerups',
                              ),
                              Text(
                                'Other',
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
