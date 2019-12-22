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
      duration: Duration(milliseconds: 200),
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: IntrinsicHeight(
            child: AnimatedContainer(
              // padding: EdgeInsets.all(SizeConfig.screenWidth * 0.01),
              duration: Duration(milliseconds: 200),
              constraints: BoxConstraints(
                maxHeight: _controller.isAnimating
                    ? SizeConfig.screenWidth * .3
                    : SizeConfig.screenHeight,
                // minHeight: SizeConfig.screenWidth * .4,
              ),
              width: SizeConfig.screenWidth * .9,
              alignment: Alignment.topCenter,
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
                padding: EdgeInsets.only(bottom: 10),
                child: Content(newQuote: _newQuote),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final Quote newQuote;
  Content({
    @required this.newQuote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
          ),
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.03,
        ),
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Text(
              newQuote.quote,
              style: kQuoteStyle(SizeConfig.screenWidth),
            ),
            SizedBox(
              height: SizeConfig.screenWidth * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: FittedBox(
                child: Text(
                  'Author: ${newQuote.author == "" ? 'Unknown' : newQuote.author}',
                  style: kAuthorStyle(SizeConfig.screenWidth),
                  // style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
