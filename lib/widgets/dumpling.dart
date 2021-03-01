import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/animations.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/models/items/item.dart' show UseCase;
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/items.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/widgets/powerup_state.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class Dumpling extends StatefulWidget {
  @override
  _DumplingState createState() => _DumplingState();
}

class DumplingScreenWhileClicking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Provider.of<ShopItems>(context).currentPowerup != null
            ? PowerupState()
            : SizedBox(),
        Dumpling(),
        SizedBox(height: SizeConfig.screenHeight * 0.03),
        ProgressBar(
          barWidth: SizeConfig.screenWidth * .7,
          barHeight: SizeConfig.screenHeight * .02,
          currentPercent:
              Provider.of<DumplingProvider>(context).progressBarStatus,
        ),
      ],
    );
  }
}

class _DumplingState extends State<Dumpling> with TickerProviderStateMixin {
  bool _isPressed = false;
  bool _isInit = true;
  bool _isPowerupBillsOnClick = false;
  bool _isPowerupClicks = false;
  final ValueNotifier<bool> _isTextOnRight = ValueNotifier(false);

  DumplingProvider _dumplingProvider;
  ShopItems _itemsProvider;

  AnimationController _moneyAnimController;
  Animation _moneyAnimation;

  Animatable<Color> _clicksPowerupColor;
  AnimationController _clicksPowerupController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10.h,
          right: _isTextOnRight.value ? 16.w : null,
          left: _isTextOnRight.value ? null : 16.w,
          child: FadeTransition(
            opacity: _moneyAnimation,
            child: Transform(
              transform: _isTextOnRight.value
                  ? Matrix4.rotationZ(pi / 5)
                  : Matrix4.rotationZ(-pi / 5),
              alignment: Alignment.center,
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: _isPowerupBillsOnClick
                    ? Styles.kShopItemTitleStyle.copyWith(
                        color: Theme.of(context).errorColor,
                        fontSize: 30.sp,
                      )
                    : Styles.kShopItemTitleStyle.copyWith(fontSize: 25.sp),
                child: Text(
                  '+' +
                      Provider.of<Shop>(context).billsPerClick.toString() +
                      '\$',
                ),
              ),
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * .85,
          height: SizeConfig.screenWidth * .85,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            padding: _isPressed
                ? EdgeInsets.all(
                    SizeConfig.screenWidth * .03,
                  )
                : EdgeInsets.zero,
            child: GestureDetector(
              onPanDown: (_) => setState(
                () => _isPressed = true,
              ),
              onVerticalDragCancel: () {
                if (_isPressed) {
                  setState(
                    () => _isPressed = false,
                  );
                }
              },
              onHorizontalDragCancel: () {
                if (_isPressed) {
                  setState(
                    () => _isPressed = false,
                  );
                }
              },
              onTap: () {
                if (_dumplingProvider.progressBarStatus < 1) {
                  Provider.of<AudioProvider>(context, listen: false)
                      .playDumplingEating()
                      .then(
                    (_) {
                      _dumplingProvider.clickedOnDumpling();
                      Provider.of<Shop>(context, listen: false)
                          .clickOnDumpling();
                      if (_moneyAnimController.status ==
                          AnimationStatus.reverse) _moneyAnimController.stop();
                      _moneyAnimController.forward();
                    },
                  );
                }
              },
              child: AnimatedBuilder(
                animation: _clicksPowerupController,
                builder: (context, _) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _isPowerupClicks
                          ? _clicksPowerupColor.evaluate(
                              AlwaysStoppedAnimation(
                                _clicksPowerupController.value,
                              ),
                            )
                          : Theme.of(context).backgroundColor.withRed(255),
                      BlendMode.modulate,
                    ),
                    child: Image.asset(
                      'assets/images/dumpling2.png',
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _clicksPowerupColor = runningPowerupColor(context);
      _clicksPowerupController = AnimationController(
        duration: Duration(milliseconds: 3000),
        vsync: this,
      );

      _dumplingProvider = Provider.of<DumplingProvider>(context);
      _itemsProvider = Provider.of<ShopItems>(context)
        ..addListener(_powerupListener);
      _powerupListener();

      _moneyAnimController = AnimationController(
        duration: Duration(milliseconds: 150),
        vsync: this,
      );
      _moneyAnimController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 250), () {
            if (_moneyAnimController != null) _moneyAnimController.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          _isTextOnRight.value = !_isTextOnRight.value;
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
    _clicksPowerupController.dispose();
    _itemsProvider.removeListener(_powerupListener);
    super.dispose();
  }

  void _powerupListener() {
    var currentPowerup = _itemsProvider.currentPowerup;
    if (currentPowerup == null) {
      if (_isPowerupBillsOnClick) _isPowerupBillsOnClick = false;
      if (_isPowerupClicks) _isPowerupClicks = false;
      return;
    }
    switch (currentPowerup.useCase) {
      case UseCase.BILLS_ON_CLICK:
        _isPowerupBillsOnClick = true;
        break;
      case UseCase.CLICK_MULTIPLIER:
        _isPowerupClicks = true;
        _clicksPowerupController.repeat();
        break;
      default:
        break;
    }

    if (!_isPowerupClicks) _clicksPowerupController.reset();
  }
}
