import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/screens/tabs_screen.dart';

void main() => runApp(MyApp());

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
      ],
      child: MaterialApp(
        title: 'Quoty Dumpling!',
        theme: Styles.mainTheme,
        home: SafeArea(
          child: TabsScreen(),
        ),
      ),
    );
  }
}
