import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

Animatable<Color?> runningPowerupColor(context) => TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Styles.legendaryColor,
            end: Styles.epicColor,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Styles.epicColor,
            end: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Theme.of(context).secondaryHeaderColor,
            end: Styles.legendaryColor,
          ),
        ),
      ],
    );
