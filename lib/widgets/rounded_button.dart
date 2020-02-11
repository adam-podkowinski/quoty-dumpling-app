import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final color;
  final text;
  final textColor;
  final width;

  RoundedButton({
    @required this.onPressed,
    this.color,
    this.text,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      color: color ?? Theme.of(context).buttonColor,
      child: SizedBox(
        width: width,
        child: Center(
          child: Text(
            text ?? 'Button',
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontFamily: Styles.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
        ),
      ),
    );
  }
}
