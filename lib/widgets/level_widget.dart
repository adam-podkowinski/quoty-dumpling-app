import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/level.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class LevelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Level ' + Provider.of<Level>(context).level.toString(),
          style: DefaultTextStyle.of(context).style.copyWith(
                fontFamily: Styles.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 19.sp,
                color: Styles.kTitleStyle.color,
              ),
        ),
        ProgressBar(
          barWidth: 100.w,
          barHeight: 10.h,
          currentPercent: 9.5 / 10,
        ),
      ],
    );
  }
}
