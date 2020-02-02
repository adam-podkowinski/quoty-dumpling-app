import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/widgets/collection_grid.dart';
import 'package:quoty_dumpling_app/widgets/collection_settings.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    _quotesProvider.sortCollection(true);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor.withOpacity(.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [.66, 1],
          ),
        ),
        child: AnimationConfiguration.synchronized(
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
      ),
    );
  }
}

class NothingInCollectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'You haven\'t unlocked anything yet. Go and open your dumplings!',
      textAlign: TextAlign.center,
    );
    //TODO: Add button which goes to dumpling screen and add some styling
  }
}
