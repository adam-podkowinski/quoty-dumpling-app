import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class Dumpling extends StatefulWidget {
  @override
  _DumplingState createState() => _DumplingState();
}

class _DumplingState extends State<Dumpling>
    with SingleTickerProviderStateMixin {
  var _isPressed = false;

  var _dumplingProvider;
  var _isInit = true;

  AnimationController _moneyAnimController;
  Animation _moneyAnimation;

  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _dumplingProvider = Provider.of<DumplingProvider>(context);
      _moneyAnimController = AnimationController(
          duration: Duration(milliseconds: 150), vsync: this);

      _moneyAnimController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (_moneyAnimController != null) _moneyAnimController.reverse();
          });
        }
      });

      _moneyAnimation =
          Tween<double>(begin: 0, end: 1).animate(_moneyAnimController);
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _moneyAnimController.dispose();
    _moneyAnimController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          child: FadeTransition(
            opacity: _moneyAnimation,
            child: Transform(
              transform: Matrix4.rotationZ(-pi / 5),
              child: Text(
                '+' +
                    Provider.of<Shop>(context).billsPerClick.toString() +
                    '\$',
                style: Styles.kShopItemTitleStyle,
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: SizeConfig.screenWidth * .9,
            maxHeight: SizeConfig.screenWidth * .9,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 120),
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
                if (_dumplingProvider.progressBarStatus < 1)
                  Provider.of<AudioProvider>(context, listen: false)
                      .playDumplingEating()
                      .then(
                    (_) {
                      _dumplingProvider.clickedOnDumpling();
                      Provider.of<Shop>(context, listen: false)
                          .clickOnDumpling();
                      _moneyAnimController.forward();
                    },
                  );
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
          ),
        ),
      ],
    );
  }
}

class DumplingScreenWhileClicking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Dumpling(),
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        ProgressBar(),
      ],
    );
  }
}
