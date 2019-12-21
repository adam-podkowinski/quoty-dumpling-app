import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class UnlockedNewQuote extends StatefulWidget {
  @override
  _UnlockedNewQuoteState createState() => _UnlockedNewQuoteState();
}

class _UnlockedNewQuoteState extends State<UnlockedNewQuote>
    with SingleTickerProviderStateMixin {
  Animation _newQuoteSlideAnimation;
  Animation _newQuoteSizeAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _newQuoteSlideAnimation = Tween<Offset>(
      begin: Offset(0, -2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _controller,
      ),
    );
    _newQuoteSizeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _controller,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: _newQuoteSizeAnimation,
      child: SlideTransition(
        position: _newQuoteSlideAnimation,
        child: Container(
          height: SizeConfig.screenWidth * .85,
          width: SizeConfig.screenWidth * .85,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.01),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).backgroundColor,
                Theme.of(context).backgroundColor,
                Theme.of(context).backgroundColor,
                Theme.of(context).buttonColor,
                // Theme.of(context).buttonColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'New QUOTE!',
            style: kTitleStyle(SizeConfig.screenWidth),
          ),
        ),
      ),
    );
  }
}
