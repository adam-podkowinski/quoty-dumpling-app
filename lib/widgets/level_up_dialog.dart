import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/level.dart';

class LevelUpDialog extends StatefulWidget {
  final reward;

  const LevelUpDialog(this.reward);

  static Future showLevelUpDialog(BuildContext context, LevelReward reward) {
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
          child: LevelUpDialog(reward),
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
//  final _isInit = true;
//
//  late Level _levelProvider;
//  late LevelReward _levelReward;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (_isInit) {
//      _levelProvider = Provider.of<Level>(context);
//      _levelReward = _levelProvider.levelRewards[0];
//    }
//  }

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
                //crossAxisAlignment: CrossAxisAlignment.start,
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
                  //TODO: show quote reward
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
