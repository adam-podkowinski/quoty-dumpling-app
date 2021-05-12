import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/items.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';
import 'package:quoty_dumpling_app/screens/loading_screen.dart';

const pixel3 = Size(393, 737);
const lgg6 = Size(360, 720);
const currentSize = lgg6;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Phoenix(
      child: QuotyDumplingApp(),
    ),
  );
  WidgetsBinding.instance.addObserver(_Handler());
}

class QuotyDumplingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          ) =>
              achievements..update(dumpling, shop, level),
        ),
      ],
      child: ScreenUtilInit(
        designSize: currentSize,
        builder: () => MaterialApp(
          theme: Styles.mainTheme,
          home: SafeArea(
            child: LoadingScreen(),
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
