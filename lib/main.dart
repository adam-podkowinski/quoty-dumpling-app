import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/shop_items.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';
import 'package:quoty_dumpling_app/screens/loading_screen.dart';
import 'package:restart_app/restart_app.dart';

const pixel3 = Size(393, 737);
const lgg6 = Size(360, 720);
const currentSize = lgg6;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  runApp(
    Phoenix(
      child: QuotyDumplingApp(),
    ),
  );
  WidgetsBinding.instance!.addObserver(_Handler());
}

class QuotyDumplingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DBProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DumplingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Quotes(),
        ),
        ChangeNotifierProvider(
          create: (_) => CollectionSettings(),
        ),
        ChangeNotifierProvider(
          create: (_) => Tabs(),
        ),
        ChangeNotifierProvider(
          create: (_) => AudioProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ShopItems(),
        ),
        ChangeNotifierProvider(
          create: (_) => Shop(),
        ),
        ChangeNotifierProvider(
          create: (_) => Level(),
        ),
        ChangeNotifierProxyProvider3<DumplingProvider, Shop, Level,
            Achievements>(
          create: (_) => Achievements(),
          update: (
            _,
            dumpling,
            shop,
            level,
            achievements,
          ) {
            achievements!.update(dumpling, shop, level);
            return achievements;
          },
        ),
      ],
      child: ScreenUtilInit(
        designSize: currentSize,
        builder: () => MaterialApp(
          theme: Styles.mainTheme,
          title: 'Quoty Dumpling',
          home: SafeArea(
            child: Builder(
              builder: (context) {
                const platform = MethodChannel('mainChannel');
                print('Running builder');
                Future<dynamic> nativeMethodCallHandler(
                    MethodCall methodCall) async {
                  switch (methodCall.method) {
                    case 'loadDataFromGooglePlay':
                      print('LOADING DATA FROM GOOGLE PLAY FROM DART');
                      print('argument is: ${methodCall.arguments}');

                      if (methodCall.arguments is String) {
                        await DBProvider.fillDatabaseFromJSON(
                          methodCall.arguments as String,
                        );
                        await Restart.restartApp();
                      } else {
                        print('ERROR (methodCall.arguments is not String)');
                      }
                      return true;
                    default:
                      return false;
                  }
                }

                platform.setMethodCallHandler(nativeMethodCallHandler);

                return LoadingScreen();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AudioProvider.playLoopAudio();
    } else {
      AudioProvider.stopLoopAudio();
    }
  }
}
