import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application
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
      ],
      child: MaterialApp(
        title: 'Quoty Dumpling!',
        theme: mainTheme.copyWith(
          appBarTheme: AppBarTheme(color: mainTheme.accentColor),
        ),
        home: SafeArea(
          child: TabsScreen(),
        ),
      ),
    );
  }
}
