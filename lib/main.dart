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
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';
import 'package:quoty_dumpling_app/screens/loading_screen.dart';

const pixel3 = Size(393, 737);
const lgg6 = Size(360, 720);
const currentSize = lgg6;

void main() => runApp(
      Phoenix(
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
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
        ChangeNotifierProxyProvider2<DumplingProvider, Shop, Achievements>(
          create: (_) => Achievements(),
          update: (_, dumpling, shop, achievements) =>
              achievements..update(dumpling, shop),
        ),
      ],
      child: ScreenUtilInit(
        designSize: currentSize,
        child: MaterialApp(
          theme: Styles.mainTheme,
          home: SafeArea(
            child: LoadingScreen(),
          ),
        ),
      ),
    );
  }
}
