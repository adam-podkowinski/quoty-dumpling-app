import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  late Quotes _quotesProvider;
  late CollectionSettings _collectionSettings;
  var _isInit = true;
  InterstitialAd? _interstitialAd;
  static const int _adChance = 3; // lower = more money ?????

  @override
  void initState() {
    super.initState();
    _quotesProvider = Provider.of<Quotes>(context, listen: false);
    _quotesProvider.refreshVisibleQuotes();
    _quotesProvider.sortCollection(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _collectionSettings = Provider.of<CollectionSettings>(context)
        ..initScrollControlller();
      var rng = Random();
      if (rng.nextInt(_adChance) == _adChance - 1) {
        InterstitialAd.load(
          adUnitId: kReleaseMode
              ? 'ca-app-pub-4457173945348292/8129158227'
              : 'ca-app-pub-3940256099942544/1033173712',
          request: AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              _interstitialAd = ad;
              _interstitialAd!.show();
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error');
            },
          ),
        );
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _collectionSettings.showScrollFab
          ? FloatingActionButton(
              onPressed: () => _collectionSettings.scrollUp(),
              backgroundColor: ThemeColors.secondaryLight,
              splashColor: ThemeColors.secondary,
              child: Icon(Icons.arrow_upward),
            )
          : null,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Styles.backgroundGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: _quotesProvider.unlockedQuotes.isEmpty &&
                  _quotesProvider.newQuotes.isEmpty
              ? <Widget>[
                  CustomAppBar(
                    'Collection',
                  ),
                  NothingInCollectionWidget(),
                ]
              : <Widget>[
                  CustomAppBar(
                    'Collection',
                    suffix: FittedBox(
                      child: Text(
                        'Quotes: ${_quotesProvider.unlockedQuotes.length + _quotesProvider.newQuotes.length}',
                        style: Styles.kSearchBarTextStyle.copyWith(
                          color: ThemeColors.onSecondary,
                        ),
                      ),
                    ),
                  ),
                  SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth! * 0.03,
                          SizeConfig.screenWidth! * 0.05,
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
          padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.08),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'You haven\'t unlocked any quotes yet!',
                textAlign: TextAlign.center,
                style: Styles.kTitleStyle
                    .copyWith(fontSize: SizeConfig.screenWidth! * 0.07),
              ),
              SizedBox(height: SizeConfig.screenWidth! * 0.03),
              Text(
                'Go and eat your dumplings!',
                textAlign: TextAlign.center,
                style: Styles.kAuthorStyle,
              ),
              SizedBox(height: SizeConfig.screenWidth! * 0.03),
              RoundedButton(
                onPressed: () =>
                    Provider.of<Tabs>(context, listen: false).navigateToPage(1),
                text: 'Open Dumplings!',
                textColor: Theme.of(context).textTheme.headline6!.color,
                width: SizeConfig.screenWidth! * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
