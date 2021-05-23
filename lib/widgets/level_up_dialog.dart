import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/level.dart';

class LevelUpDialog extends StatefulWidget {
  static Future showLevelUpDialog(BuildContext context) {
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
          child: LevelUpDialog(),
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
  final _isInit = true;

  late Level _levelProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _levelProvider = Provider.of<Level>(context);
    }
  }

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
                    'Level achieved: ${_levelProvider.level.toString()}',
                    style: Styles.kSettingsTextStyle,
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                  ),
                  Text(
                    'Reward: ',
                    style: Styles.kSettingsTextStyle,
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
