import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/audio_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/screens/tabs_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  Future _setData(context) async {
    SizeConfig.init(context);
    await Provider.of<AudioProvider>(context, listen: false).initAudio();
    await Provider.of<Quotes>(context, listen: false).fetchQuotes();
    await Provider.of<CollectionSettings>(context, listen: false).initOptions();
  }

  AnimationController _controller;

  var _isInit = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _setData(context).then(
        (_) => _controller.forward().then(
              (_) => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => AnimationConfiguration.synchronized(
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: TabsScreen(),
                    ),
                  ),
                ),
              ),
            ),
      );
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(_controller),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: Styles.backgroundGradient,
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}