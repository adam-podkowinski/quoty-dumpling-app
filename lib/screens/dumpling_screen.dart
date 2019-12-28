import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/unlocked_new_quote.dart';

class DumplingScreen extends StatefulWidget {
  static const routeId = 'dumpling-screen';

  @override
  _DumplingScreenState createState() => _DumplingScreenState();
}

class _DumplingScreenState extends State<DumplingScreen>
    with TickerProviderStateMixin {
  Animation<double> _initAnimation;
  AnimationController _initAnimController;
  var _dumplingProvider;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    //
    _initAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    //
    _initAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _initAnimController,
      ),
    );
    //
    _initAnimController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) _dumplingProvider = Provider.of<DumplingProvider>(context);
    if (_dumplingProvider.isFull) {
      _dumplingProvider.clearClickingProgressWhenFull();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _initAnimController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomAppBar('Dumpling'),
            FadeTransition(
              opacity: _initAnimation,
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
