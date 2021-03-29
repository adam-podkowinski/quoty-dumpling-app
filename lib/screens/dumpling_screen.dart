import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/widgets/achievements_dialog.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/global_settings_dialog.dart';
import 'package:quoty_dumpling_app/widgets/level_widget.dart';
import 'package:quoty_dumpling_app/widgets/notification_chip.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';
import 'package:quoty_dumpling_app/widgets/unlocked_new_quote.dart';

class DumplingScreen extends StatefulWidget {
  @override
  _DumplingScreenState createState() => _DumplingScreenState();
}

class _DumplingScreenState extends State<DumplingScreen>
    with TickerProviderStateMixin {
  var _dumplingProvider;
  var _shopProvider;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _dumplingProvider = Provider.of<DumplingProvider>(context)
        ..addListener(() {
          if (_dumplingProvider.isFull) {
            _dumplingProvider.clearClickingProgressWhenFull();
          }
        });
      _shopProvider = Provider.of<Shop>(context);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Styles.backgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomAppBar(
              'Dumpling',
              prefix: Row(
                children: <Widget>[
                  Icon(
                    Icons.attach_money,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: SizeConfig.screenWidth * 0.063,
                  ),
                  Flexible(
                    child: AutoSizeText(
                      _shopProvider.numberAbbreviation(_shopProvider.bills),
                      maxLines: 1,
                      style: Styles.kMoneyTextStyle,
                    ),
                  ),
                ],
              ),
              suffix: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: AutoSizeText(
                        _shopProvider
                            .numberAbbreviation(_shopProvider.diamonds),
                        style: Styles.kMoneyTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      CustomIcons.diamond,
                      color: Colors.blue,
                      size: SizeConfig.screenWidth * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth * 0.05,
                SizeConfig.screenWidth * 0.05,
                SizeConfig.screenWidth * 0.05,
                0,
              ),
              child: SlideAnimation(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: LevelWidget(),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => GlobalSettingsDialog(),
                        ),
                        icon: Icon(Icons.settings),
                        color: Styles.appBarTextColor,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: AchievementsButton(),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            FadeInAnimation(
              duration: Duration(milliseconds: 300),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                child: _dumplingProvider.isFull
                    ? UnlockedNewQuote()
                    : DumplingScreenWhileClicking(),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class AchievementsButton extends StatelessWidget {
  const AchievementsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        RoundedButton(
          text: 'Achievements',
          borderRadius: BorderRadius.circular(10.h),
          width: 100.w,
          height: 50.h,
          textColor: Theme.of(context).backgroundColor,
          color: Theme.of(context).accentColor,
          onPressed: () => showDialog(
            context: context,
            builder: (ctx) => AchievementsDialog(),
          ),
        ),
        if (context.watch<Achievements>().achievementsToReceive.isNotEmpty)
          Positioned(
            top: -10.w,
            left: -10.w,
            child: ScaleAnimation(
              child: NotificationChip(
                color: Theme.of(context).secondaryHeaderColor,
                text: context
                    .watch<Achievements>()
                    .achievementsToReceive
                    .length
                    .toString(),
              ),
            ),
          ),
      ],
    );
  }
}
