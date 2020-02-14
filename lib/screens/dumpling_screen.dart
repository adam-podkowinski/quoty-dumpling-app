import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/global_settings_dialog.dart';
import 'package:quoty_dumpling_app/widgets/unlocked_new_quote.dart';

class DumplingScreen extends StatefulWidget {
  @override
  _DumplingScreenState createState() => _DumplingScreenState();
}

class _DumplingScreenState extends State<DumplingScreen>
    with TickerProviderStateMixin {
  var _dumplingProvider;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _dumplingProvider = Provider.of<DumplingProvider>(context)
        ..addListener(() {
          if (_dumplingProvider.isFull) {
            _dumplingProvider.clearClickingProgressWhenFull();
          }
        });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Styles.backgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomAppBar(
              'Dumpling',
              suffix: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => GlobalSettingsDialog(),
                ),
                icon: Icon(Icons.settings),
              ),
            ),
            FadeInAnimation(
              duration: Duration(milliseconds: 200),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _dumplingProvider.isFull
                    ? UnlockedNewQuote()
                    : DumplingScreenWhileClicking(),
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
