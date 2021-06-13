import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/shop_items.dart';
import 'package:quoty_dumpling_app/widgets/item_widget.dart';

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
              .map((u) => Item(u, ThemeColors.secondary))
              .toList(),
        ),
        ListView(
          children: Provider.of<ShopItems>(context)
              .powerups
              .map((u) => Item(u, ThemeColors.secondaryLight))
              .toList(),
        ),
        ListView(
          children: Provider.of<ShopItems>(context)
              .money
              .map(
                (u) => Item(
                  u,
                  ThemeColors.surface,
                  Provider.of<ShopItems>(context).buyProduct,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
