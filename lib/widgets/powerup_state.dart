import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:quoty_dumpling_app/providers/items.dart';

class PowerupState extends StatefulWidget {
  @override
  _PowerupStateState createState() => _PowerupStateState();
}

class _PowerupStateState extends State<PowerupState>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late ShopItems itemsProvider;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit == true) {
      controller = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 1,
        ),
        value: Provider.of<ShopItems>(context, listen: false)
            .currentPowerup!
            .fractionToLast,
      );

      itemsProvider = Provider.of<ShopItems>(context);
      isInit = false;
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller!.animateBack(itemsProvider.currentPowerup?.fractionToLast ?? 0);
    var outerCircleRadius = 20.w;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: outerCircleRadius,
          height: outerCircleRadius,
          child: AnimatedBuilder(
            animation: controller!,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: PowerupStatePainter(
                  animation: controller,
                  color: ThemeColors.onSecondary,
                  backgroundColor: ThemeColors.secondary,
                ),
              );
            },
          ),
        ),
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: ThemeColors.onSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            itemsProvider.currentPowerup?.itemTypeIcon(),
            color: Styles.kTitleStyle.color,
            size: 20.w,
          ),
        )
      ],
    );
  }
}

class PowerupStatePainter extends CustomPainter {
  PowerupStatePainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double>? animation;
  final Color? backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    var outerCircleRadius = 20.w;
    var paint = Paint()
      ..color = backgroundColor!
      ..strokeWidth = outerCircleRadius
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color!;
    var progress = (1.0 - animation!.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(PowerupStatePainter old) {
    return animation!.value != old.animation!.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
