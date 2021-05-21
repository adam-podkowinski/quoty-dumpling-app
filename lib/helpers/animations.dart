import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

Animatable<Color?> runningPowerupColor(context) => TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: ThemeColors.legendary,
            end: ThemeColors.epic,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: ThemeColors.epic,
            end: ThemeColors.surface,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: ThemeColors.surface,
            end: ThemeColors.legendary,
          ),
        ),
      ],
    );
