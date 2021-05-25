import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/widgets/level_up_dialog.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';

class LevelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _levelProvider = Provider.of<Level>(context);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: _levelProvider.levelRewards.isNotEmpty
          ? RoundedButton(
              text: 'LEVEL UP!',
              borderRadius: BorderRadius.circular(10.h),
              width: 100.w,
              height: 50.h,
              textColor: Styles.kTitleStyle.color,
              color: ThemeColors.surface,
              onPressed: () async {
                var reward = _levelProvider.claimReward();
                return await LevelUpDialog.showLevelUpDialog(context, reward);
              },
            )
          : Column(
              children: [
                Text(
                  'Level ' + _levelProvider.level.toString(),
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontFamily: Styles.fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.sp,
                        color: Styles.kTitleStyle.color,
                      ),
                ),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ProgressBar(
                      currentPercent:
                          _levelProvider.currentXP / _levelProvider.maxXP,
                      barHeight: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: AutoSizeText(
                        '${Shop.numberAbbreviation(_levelProvider.currentXP)} / ${Shop.numberAbbreviation(_levelProvider.maxXP)}',
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
