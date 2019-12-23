import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';
import 'package:quoty_dumpling_app/widgets/unlocked_new_quote.dart';

class DumplingScreen extends StatefulWidget {
  static const routeId = 'dumpling-screen';

  @override
  _DumplingScreenState createState() => _DumplingScreenState();
}

class _DumplingScreenState extends State<DumplingScreen>
    with TickerProviderStateMixin {
  Animation<double> _dumplingAnimation;
  Animation<double> _initAnimation;
  AnimationController _dumplingAnimController;
  AnimationController _initAnimController;
  var _isFull = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<Quotes>(context, listen: false).fetchQuotes();

    //
    _dumplingAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    //
    _initAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    //
    _dumplingAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _dumplingAnimController,
      ),
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
    // when the progress bar is full dumpling fades out and new_quote widget shows smoothly
    if (Provider.of<DumplingProvider>(context).isFull) {
      _dumplingAnimController.forward().then((_) {
        setState(() {
          _isFull = true;
          _dumplingAnimController.reverse();
          Provider.of<DumplingProvider>(context)
              .clearClickingProgressWhenFull();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dumplingAnimController.dispose();
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
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor.withOpacity(.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomAppBar(),
            FadeTransition(
              opacity: _initAnimation,
              child: FadeTransition(
                opacity: _dumplingAnimation,
                child: Column(
                  children: !_isFull
                      ? <Widget>[
                          Dumpling(),
                          ProgressBar(),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.066,
                          ),
                        ]
                      : <Widget>[
                          UnlockedNewQuote(),
                        ],
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
