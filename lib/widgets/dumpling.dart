import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quoty_dumpling_app/models/size_config.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';

class Dumpling extends StatefulWidget {
  @override
  _DumplingState createState() => _DumplingState();
}

class _DumplingState extends State<Dumpling> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: () {
        Provider.of<DumplingProvider>(context).clickedOnDumpling();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 120),
        width: SizeConfig.screenWidth * .85,
        height: SizeConfig.screenWidth * .85,
        padding: _isPressed
            ? EdgeInsets.all(
                SizeConfig.screenWidth * .05,
              )
            : EdgeInsets.all(
                SizeConfig.screenWidth * .03,
              ),
        child: ColorFiltered(
          // color: Colors.black,
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 246, 200, 1),
            BlendMode.modulate,
          ),
          child: Image.asset(
            'assets/images/dumpling.png',
            colorBlendMode: BlendMode.colorBurn,
          ),
        ),
      ),
    );
  }
}
