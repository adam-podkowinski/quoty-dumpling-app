import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/models/quote.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/widgets/quote_details.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';

class LevelUpDialog extends StatefulWidget {
  final reward;
  final unlockedQuote;

  const LevelUpDialog(this.reward, this.unlockedQuote);

  static Future showLevelUpDialog(
      BuildContext context, LevelReward reward, Quote unlockedQuote) {
    Provider.of<AudioProvider>(context, listen: false).playLevelup();
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Container();
      },
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, anim1, anim2, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);

        return SlideTransition(
          position: anim1.drive(tween),
          child: LevelUpDialog(reward, unlockedQuote),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    );
  }

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog> {
  final _spacing = 11.w;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_spacing),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_spacing),
          color: ThemeColors.background,
        ),
        //height: 300.h,
        child: Stack(
          children: [
            Align(
              heightFactor: 1,
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_spacing),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: ThemeColors.onBackground,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_spacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      'LEVEL UP!',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: Styles.kSettingsTitleStyle,
                    ),
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                    indent: 11.sp * 7,
                    endIndent: 11.sp * 7,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Level achieved: ${widget.reward.levelAchieved.toString()}',
                    style: Styles.kSettingsTextStyle,
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                  ),
                  Text(
                    'Bills Reward: ${widget.reward.billsReward.toString()}',
                    style: Styles.kSettingsTextStyle,
                  ),
                  Text(
                    'Diamonds Reward: ${widget.reward.diamondsReward.toString()}',
                    style: Styles.kSettingsTextStyle,
                  ),
                  Divider(color: ThemeColors.secondary),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.w,
                      horizontal: 12.w,
                    ),
                    child: AutoSizeText(
                      'UNLOCKED NEW QUOTE',
                      style: Styles.kSettingsTitleStyle,
                      maxLines: 1,
                    ),
                  ),
                  QuoteCardLevelup(widget.unlockedQuote),
                  Divider(
                    color: ThemeColors.secondary,
                  ),
                  RoundedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    width: SizeConfig.screenWidth! * 0.5,
                    color: ThemeColors.surface,
                    text: 'OK',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteCardLevelup extends StatefulWidget {
  final quote;

  const QuoteCardLevelup(this.quote);

  @override
  State<QuoteCardLevelup> createState() => _QuoteCardLevelupState();
}

class _QuoteCardLevelupState extends State<QuoteCardLevelup> {
  final heartColor = Color(0xfffa4252);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => QuoteDetails(
          widget.quote,
        ),
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.screenWidth! * 0.0381),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(
                SizeConfig.screenWidth! * .022,
              ),
              color: ThemeColors.background,
              child: Center(
                child: AutoSizeText(
                  widget.quote.quote,
                  minFontSize: 1,
                  textAlign: TextAlign.justify,
                  style: Styles.kQuoteStyle
                      .copyWith(fontSize: SizeConfig.screenWidth! * .045),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: widget.quote.rarityColor(context).withOpacity(.7),
                    blurRadius: 99,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: GridTileBar(
                leading: InkWell(
                  onTap: () => setState(() {
                    widget.quote.changeFavorite();
                  }),
                  child: Icon(
                    widget.quote.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: heartColor,
                  ),
                ),
                title: AutoSizeText(
                  widget.quote.author,
                  style: TextStyle(
                    fontFamily: Styles.fontFamily,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6!.color,
                    fontSize: SizeConfig.screenWidth! * .035,
                  ),
                ),
                subtitle: Text(
                  widget.quote.rarityText(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: Styles.fontFamily,
                    color: Theme.of(context).textTheme.headline6!.color,
                    fontSize: SizeConfig.screenWidth! * .035,
                  ),
                ),
                backgroundColor: widget.quote.rarityColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
