import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class DumplingScreen extends StatefulWidget {
  static const routeId = 'dumpling-screen';

  @override
  _DumplingScreenState createState() => _DumplingScreenState();
}

class _DumplingScreenState extends State<DumplingScreen>
    with TickerProviderStateMixin {
  Animation<double> _dumplingAnimation;
  Animation<double> _initAnimation;
  Animation<Offset> _newQuoteSlideAnimation;
  AnimationController _dumplingAnimController;
  AnimationController _initAnimController;
  var _isFull = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    //
    _dumplingAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
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
    _newQuoteSlideAnimation = Tween<Offset>(
      begin: Offset(0, 10),
      end: Offset(0, -10),
    ).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _dumplingAnimController,
      ),
    );
    _initAnimController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      SizeConfig().init(context);
      _isInit = false;
    }
    // when the progress bar is full dumpling fades out and new_quote widget shows smoothly
    if (Provider.of<DumplingProvider>(context).isFull) {
      _dumplingAnimController.forward();
      Future.delayed(Duration(milliseconds: 250), () {
        setState(() {
          _isFull = true;
          _dumplingAnimController.reverse();
        });
      }).then((_) =>
          Provider.of<DumplingProvider>(context).clearClickingProgress());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dumplingAnimController.dispose();
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
        child: Center(
          child: Column(
            children: <Widget>[
              CustomAppBar(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              //TODO: Show dialog and other widget if dumpling is opened. (unlocked quote widget);
              Center(
                child: FadeTransition(
                  opacity: _initAnimation,
                  child: FadeTransition(
                    opacity: _dumplingAnimation,
                    child: !_isFull
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Dumpling(),
                              ProgressBar(),
                            ],
                          )
                        : SlideTransition(
                            position: _newQuoteSlideAnimation,
                            child: Text('full'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
