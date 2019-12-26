import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/screens/collection_screen.dart';

class UnlockedNewQuote extends StatefulWidget {
  @override
  _UnlockedNewQuoteState createState() => _UnlockedNewQuoteState();
}

class _UnlockedNewQuoteState extends State<UnlockedNewQuote>
    with SingleTickerProviderStateMixin {
  Animation _newQuoteSlideAnimation;
  AnimationController _controller;
  var _newQuote;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _newQuoteSlideAnimation = Tween<Offset>(
      begin: Offset(0, -10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn,
        parent: _controller,
      ),
    )..addListener(
        () {
          setState(() {});
        },
      );

    _newQuote = Provider.of<Quotes>(context, listen: false).unlockRandomQuote();
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _newQuote = null;
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _newQuoteSlideAnimation,
      child: AnimatedContainer(
        constraints: BoxConstraints(
          maxHeight: _controller.isAnimating
              ? SizeConfig.screenWidth * .2
              : SizeConfig.screenWidth,
        ),
        duration: Duration(milliseconds: 300),
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _newQuote.rarityColor(context).withOpacity(.1),
                _newQuote.rarityColor(context).withOpacity(.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.screenHeight * 0.01,
              horizontal: SizeConfig.screenWidth * 0.04,
            ),
            child: CardContent(
              newQuote: _newQuote,
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Quote newQuote;
  final AnimationController controller;
  CardContent({
    @required this.newQuote,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //title
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New ',
                style: kTitleStyle(SizeConfig.screenWidth),
              ),
              SizedBox(width: 5),
              Stack(
                children: <Widget>[
                  Text(
                    '${Provider.of<Quotes>(context).rarityText(newQuote.rarity)} ',
                    style: kTitleStyle(SizeConfig.screenWidth).copyWith(
                      fontFamily: 'Pacifico',
                      fontStyle: FontStyle.italic,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = kTitleStyle(SizeConfig.screenWidth).color,
                    ),
                  ),
                  Text(
                    '${Provider.of<Quotes>(context).rarityText(newQuote.rarity)} ',
                    style: kTitleStyle(SizeConfig.screenWidth).copyWith(
                      fontFamily: 'Pacifico',
                      fontStyle: FontStyle.italic,
                      color: newQuote.rarityColor(context),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5),
              Text(
                'Quote',
                style: kTitleStyle(SizeConfig.screenWidth),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        //Quote content and author
        Text(
          newQuote.quote,
          style: kQuoteStyle(SizeConfig.screenWidth),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 20,
        ),
        FittedBox(
          child: Text(
            'Author: ${newQuote.author == '' ? 'Unknown' : newQuote.author}',
            style: kAuthorStyle(SizeConfig.screenWidth),
          ),
        ),
        //Buttons
        SizedBox(
          height: SizeConfig.screenWidth * .04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NewQuoteButton(
              rarityColor: newQuote.rarityColor(context),
              textContent: 'Eat more!',
              onTap: () {
                Provider.of<DumplingProvider>(context, listen: false)
                    .notifyIsFullStateChanged();
                controller.reverse();
              },
            ),
            NewQuoteButton(
                rarityColor: newQuote.rarityColor(context),
                textContent: 'Go to collection!',
                onTap: () {
                  controller.reverse().then((_) {
                    Provider.of<DumplingProvider>(context)
                        .notifyIsFullStateChanged();
                    Provider.of<DumplingProvider>(context)
                        .changeGoToCollectionScreen(true);
                  });
                }),
          ],
        ),
        SizedBox(
          height: SizeConfig.screenWidth * .01,
        ),
      ],
    );
  }
}

class NewQuoteButton extends StatelessWidget {
  final Color rarityColor;
  final String textContent;
  final Function onTap;

  NewQuoteButton({
    @required this.rarityColor,
    @required this.textContent,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: SizeConfig.screenHeight * .05,
          width: SizeConfig.screenHeight * .2,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(
              color: kTitleStyle(SizeConfig.screenWidth).color,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                rarityColor.withOpacity(.6),
                rarityColor.withOpacity(1),
              ],
              stops: [.2, 1],
            ),
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                textContent,
                style: kButtonTextStyle(SizeConfig.screenWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }
}