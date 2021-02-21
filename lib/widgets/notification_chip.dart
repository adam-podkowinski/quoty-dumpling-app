import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationChip extends StatelessWidget {
  final color;
  final text;
  final fontColor;

  const NotificationChip(
      {Key key, this.color, @required this.text, this.fontColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 24.w,
        minHeight: 24.w,
      ),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).accentColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Text(
            text ?? '1',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: fontColor,
            ),
          ),
        ),
      ),
    );
  }
}