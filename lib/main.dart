import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/tabs.dart';
import 'package:quoty_dumpling_app/screens/loading_screen.dart';

void main() => runApp(Phoenix(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: DumplingProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Quotes(),
        ),
        ChangeNotifierProvider.value(
          value: CollectionSettings(),
        ),
        ChangeNotifierProvider.value(
          value: Tabs(),
        ),
        ChangeNotifierProvider.value(
          value: AudioProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Shop(),
        ),
      ],
      child: MaterialApp(
        title: 'Quoty Dumpling!',
        theme: Styles.mainTheme,
        home: SafeArea(
          child: LoadingScreen(),
        ),
      ),
    );
  }
}
