import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationChip extends StatelessWidget {
  final color;

  const NotificationChip({
    Key key,
    this.color,
  }) : super(key: key);

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
            '99',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
