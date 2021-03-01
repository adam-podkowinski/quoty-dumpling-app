import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PowerupState extends StatefulWidget {
  @override
  _PowerupStateState createState() => _PowerupStateState();
}

class _PowerupStateState extends State<PowerupState> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.appBarTextColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 4.w,
        ),
      ),
      width: 40.w,
      height: 40.w,
    );
  }
}
