import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class QuoteDetails extends StatefulWidget {
  final Quote quote;

  QuoteDetails(this.quote);

  @override
  _QuoteDetailsState createState() => _QuoteDetailsState();
}

class _QuoteDetailsState extends State<QuoteDetails> {
  Quotes _quotesProvider;
  final _heartColor = Color(0xfffa4252);
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    _quotesProvider = Provider.of<Quotes>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      FocusScope.of(context).unfocus();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(SizeConfig.screenWidth * 0.06),
                child: Center(
                  child: Text(
                    widget.quote.quote,
                    textAlign: TextAlign.justify,
                    style: Styles.kQuoteStyle,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.quote.rarityColor(context),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: widget.quote.rarityColor(context).withOpacity(.7),
                      blurRadius: 99,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
                  child: Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => setState(
                            () {
                              widget.quote.changeFavorite();

                              _quotesProvider.sortCollection(true);
                            },
                          ),
                          icon: Icon(
                            widget.quote.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _heartColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            'By: ${widget.quote.author}',
                            style: Styles.kQuoteDetailsTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Rarity: ${widget.quote.rarityText()}',
                            style: Styles.kQuoteDetailsTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Unlocking day: ${DateFormat('d | M | y').format(widget.quote.unlockingTime)}',
                            style: Styles.kQuoteDetailsTextStyle,
                          ),
                        ],
                      ),
                    ],
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
