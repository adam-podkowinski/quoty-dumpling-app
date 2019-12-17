import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/models/size_config.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70.withOpacity(.85),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth * .7,
            height: SizeConfig.screenHeight * 0.02,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: min(
              SizeConfig.screenWidth *
                  .7 *
                  Provider.of<DumplingProvider>(context)
                      .progressBarStatus, // if not all space is taken
              SizeConfig.screenWidth * .7, // it is taken
            ),
            height: SizeConfig.screenHeight * 0.02,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff91bd3a),
                  Theme.of(context).buttonColor.withRed(150).withGreen(240),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
