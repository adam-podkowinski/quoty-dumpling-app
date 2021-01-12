import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final color;
  final text;
  final textColor;
  final width;
  final height;
  final textStyle;
  final borderRadius;

  RoundedButton({
    @required this.onPressed,
    this.color,
    this.text,
    this.textColor,
    this.width,
    this.height,
    this.textStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      color: color ?? Theme.of(context).buttonColor,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            text ?? 'Button',
            style: textStyle ??
                DefaultTextStyle.of(context).style.copyWith(
                      fontFamily: Styles.fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5.sp,
                      color: textColor,
                    ),
          ),
        ),
      ),
    );
  }
}
