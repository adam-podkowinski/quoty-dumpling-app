import 'dart:math';

import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double barWidth;
  final double barHeight;
  final double currentPercent;

  const ProgressBar({
    Key key,
    @required this.barWidth,
    @required this.barHeight,
    @required this.currentPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context)
                .buttonColor
                .withRed(150)
                .withGreen(240)
                .withOpacity(.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Card(
        color: Theme.of(context).backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              width: barWidth,
              height: barHeight,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: min(
                barWidth * currentPercent, // if not all space is taken
                barWidth, // it is taken
              ),
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).secondaryHeaderColor,
                    Theme.of(context).buttonColor.withRed(150).withGreen(240),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
