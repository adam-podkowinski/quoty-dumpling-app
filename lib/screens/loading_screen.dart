import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/shop_items.dart';
import 'package:quoty_dumpling_app/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef FutureVoidCallback = Future<void> Function();

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final FutureVoidCallback? resumeCallBack;
  final FutureVoidCallback? detachedCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        detachedCallBack == null ? print('') : await detachedCallBack!();
        break;
      case AppLifecycleState.resumed:
        resumeCallBack == null ? print('') : await resumeCallBack!();
        break;
    }
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  Future _setData(context) async {
    SizeConfig.init(context);
    //  await Provider.of<DBProvider>(context, listen: false).fillDatabaseFromJSON(
    //   await Provider.of<DBProvider>(context, listen: false).databaseToJSON(),
    //  );
    //  await Provider.of<DBProvider>(context, listen: false).resetGame(context);

    await Provider.of<Shop>(context, listen: false).initShop();
    await Provider.of<ShopItems>(context, listen: false).fetchItems(context);
    await Provider.of<DumplingProvider>(context, listen: false).initDumpling();
    await Provider.of<AudioProvider>(context, listen: false).initAudio();
    await Provider.of<Quotes>(context, listen: false).fetchQuotes(context);
    await Provider.of<Level>(context, listen: false).fetchLevel(context);
    await Provider.of<Achievements>(context, listen: false).fetchAchievements(
      Provider.of<DumplingProvider>(context, listen: false),
      Provider.of<Shop>(context, listen: false),
      Provider.of<Level>(context, listen: false),
    );
    await Provider.of<CollectionSettings>(context, listen: false).initOptions();

    var prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('loginOnStartup') ?? true) {
      await Provider.of<DBProvider>(context, listen: false).signIn();
    }

    WidgetsBinding.instance!.addObserver(
      LifecycleEventHandler(detachedCallBack: DBProvider.saveJSONToGooglePlay),
    );
  }

  late AnimationController _controller;

  var _isInit = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _setData(context).then(
        (_) => _controller.forward().then(
              (_) => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => AnimationConfiguration.synchronized(
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: TabsScreen(),
                    ),
                  ),
                ),
              ),
            ),
      );
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(_controller),
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: Styles.backgroundGradient,
          ),
          child: Center(
            child: Icon(
              CustomIcons.dumpling,
              color: Colors.white,
              size: 70,
            ),
          ),
        ),
      ),
    );
  }
}
