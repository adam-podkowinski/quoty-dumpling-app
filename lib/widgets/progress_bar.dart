import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

class ProgressBar extends StatelessWidget {
  final double? barWidth;
  final double? barHeight;
  final double currentPercent;

  const ProgressBar({
    Key? key,
    this.barWidth,
    this.barHeight,
    required this.currentPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ThemeColors.secondaryLight
                .withRed(150)
                .withGreen(240)
                .withOpacity(.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Card(
        color: ThemeColors.background,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              Container(
                width: barWidth ?? constraints.biggest.width,
                height: barHeight ?? 10.h,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                width: min(
                  (barWidth ?? constraints.biggest.width),
                  (barWidth ?? constraints.biggest.width) * currentPercent,
                ),
                height: barHeight ?? 10.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.surface,
                      ThemeColors.secondaryLight.withRed(150).withGreen(240),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
