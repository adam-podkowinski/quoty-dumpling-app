import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class Dumpling extends StatefulWidget {
  @override
  _DumplingState createState() => _DumplingState();
}

class _DumplingState extends State<Dumpling> {
  var _isPressed = false;

  var _dumplingProvider;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) _dumplingProvider = Provider.of<DumplingProvider>(context);
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      width: SizeConfig.screenWidth * .85,
      height: SizeConfig.screenWidth * .85,
      padding: _isPressed
          ? EdgeInsets.all(
              SizeConfig.screenWidth * .03,
            )
          : EdgeInsets.zero,
      child: GestureDetector(
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
          _dumplingProvider.clickedOnDumpling();
        },
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Theme.of(context).backgroundColor.withRed(255),
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

class DumplingScreenWhileClicking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Dumpling(),
        ProgressBar(),
      ],
    );
  }
}
