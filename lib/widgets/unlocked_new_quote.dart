import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class UnlockedNewQuote extends StatefulWidget {
  @override
  _UnlockedNewQuoteState createState() => _UnlockedNewQuoteState();
}

class _UnlockedNewQuoteState extends State<UnlockedNewQuote>
    with SingleTickerProviderStateMixin {
  Animation _newQuoteSlideAnimation;
  AnimationController _controller;
  Quote _newQuote;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _newQuoteSlideAnimation = Tween<Offset>(
      begin: Offset(0, -10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn,
        parent: _controller,
      ),
    )..addStatusListener(
        (_) {
          setState(() {});
        },
      );
    _controller.forward();
    _newQuote = Provider.of<Quotes>(context, listen: false).unlockRandomQuote();
  }

  @override
  void dispose() {
    super.dispose();
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
        duration: Duration(milliseconds: 200),
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Provider.of<Quotes>(context)
                    .rarityColor(_newQuote.rarity, context)
                    .withOpacity(.1),
                Provider.of<Quotes>(context)
                    .rarityColor(_newQuote.rarity, context)
                    .withOpacity(.7),
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
            child: CardContent(newQuote: _newQuote),
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Quote newQuote;
  CardContent({
    @required this.newQuote,
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
                      color: Provider.of<Quotes>(context)
                          .rarityColor(newQuote.rarity, context),
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
            // 'New QUOTE!',
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
            NewQuoteButton(),
            NewQuoteButton(),
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: () {},
      child: Container(
        height: SizeConfig.screenHeight * .05,
        width: SizeConfig.screenHeight * .2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.white,
            ],
          ),
        ),
      ),
    );
  }
}
