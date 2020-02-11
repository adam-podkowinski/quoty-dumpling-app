import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';
import 'package:quoty_dumpling_app/widgets/collection_grid.dart';
import 'package:quoty_dumpling_app/widgets/collection_settings.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';
import 'package:quoty_dumpling_app/widgets/search_bar.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  Quotes _quotesProvider;
  @override
  void initState() {
    super.initState();
    _quotesProvider = Provider.of<Quotes>(context, listen: false);
    _quotesProvider.refreshVisibleQuotes();
    _quotesProvider.sortCollection(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Provider.of<CollectionSettings>(context).showScrollFab
              ? FloatingActionButton(
                  onPressed: () =>
                      Provider.of<CollectionSettings>(context).scrollUp(),
                  child: Icon(Icons.arrow_upward),
                  backgroundColor: Theme.of(context).buttonColor,
                  splashColor: Theme.of(context).accentColor,
                )
              : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: Styles.backgroundGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: _quotesProvider.unlockedQuotes.length <= 0
              ? <Widget>[
                  CustomAppBar('Collection'),
                  NothingInCollectionWidget(),
                ]
              : <Widget>[
                  CustomAppBar('Collection'),
                  SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth * 0.03,
                          SizeConfig.screenWidth * 0.05,
                          0,
                          0,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SearchBar(),
                              SettingsIcon(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  CollectionGrid(),
                ],
        ),
      ),
    );
  }
}

class NothingInCollectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenWidth * 0.08),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'You haven\'t unlocked any quotes yet!',
                textAlign: TextAlign.center,
                style: Styles.kTitleStyle
                    .copyWith(fontSize: SizeConfig.screenWidth * 0.07),
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.03),
              Text(
                'Go and eat your dumplings!',
                textAlign: TextAlign.center,
                style: Styles.kAuthorStyle,
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.03),
              RoundedButton(
                onPressed: () =>
                    Provider.of<Tabs>(context, listen: false).navigateToPage(1),
                text: 'Open Dumplings!',
                textColor: Theme.of(context).textTheme.title.color,
                width: SizeConfig.screenWidth * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
