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
              SizeConfig.screenWidth * .7, // is is taken
            ),
            height: SizeConfig.screenHeight * 0.02,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).buttonColor,
                  Color.fromRGBO(145, 189, 58, 1),
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
