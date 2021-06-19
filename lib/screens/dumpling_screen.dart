import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';
import 'package:quoty_dumpling_app/providers/dumpling_provider.dart';
import 'package:quoty_dumpling_app/providers/shop.dart';
import 'package:quoty_dumpling_app/providers/shop_items.dart';
import 'package:quoty_dumpling_app/widgets/achievements_dialog.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/global_settings_dialog.dart';
import 'package:quoty_dumpling_app/widgets/level_widget.dart';
import 'package:quoty_dumpling_app/widgets/notification_chip.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';
import 'package:quoty_dumpling_app/widgets/unlocked_new_quote.dart';

class AchievementsButton extends StatelessWidget {
  const AchievementsButton({
    Key? key,
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
          textColor: ThemeColors.background,
          color: ThemeColors.secondary,
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
                color: ThemeColors.surface,
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

class DumplingScreen extends StatefulWidget {
  @override
  _DumplingScreenState createState() => _DumplingScreenState();
}

class _DumplingScreenState extends State<DumplingScreen>
    with TickerProviderStateMixin {
  late var _dumplingProvider;

  late var _shopProvider;

  late var _isInit = true;

  BannerAd? myBanner;
  BannerAdListener? listener;
  AdWidget? adWidget;
  Container? adContainer;
  var _showAd = false;

  void _initAds() {
    if (!context.read<ShopItems>().isProductBought('remove_ads1')) {
      listener = BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          setState(() {
            _showAd = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _showAd = false;
          ad.dispose();
          print('Ad failed to load: Error( $error )');
        },
      );

      myBanner = BannerAd(
        adUnitId: kReleaseMode
            ? 'ca-app-pub-4457173945348292/7486886749'
            : 'ca-app-pub-3940256099942544/6300978111',
        size: AdSize.banner,
        request: AdRequest(),
        listener: listener!,
      )..load();

      adWidget = AdWidget(ad: myBanner!);
      adContainer = Container(
        alignment: Alignment.center,
        width: myBanner!.size.width.toDouble(),
        height: myBanner!.size.height.toDouble(),
        child: adWidget,
      );
    }
  }

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

      _initAds();

      _isInit = false;
    }
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
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
                    color: ThemeColors.surface,
                    size: SizeConfig.screenWidth! * 0.063,
                  ),
                  Flexible(
                    child: AutoSizeText(
                      Shop.numberAbbreviation(_shopProvider.bills),
                      maxLines: 1,
                      style: Styles.moneyTextStyle,
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
                        Shop.numberAbbreviation(_shopProvider.diamonds),
                        style: Styles.moneyTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      CustomIcons.diamond,
                      color: Colors.blue,
                      size: SizeConfig.screenWidth! * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth! * 0.05,
                SizeConfig.screenWidth! * 0.05,
                SizeConfig.screenWidth! * 0.05,
                0,
              ),
              child: SlideAnimation(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: LevelWidget(),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => GlobalSettingsDialog(),
                        ),
                        icon: Icon(Icons.settings),
                        color: ThemeColors.onSecondary,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: AchievementsButton(),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            FadeInAnimation(
              duration: Duration(milliseconds: 300),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                child: _dumplingProvider.isFull
                    ? UnlockedNewQuote()
                    : DumplingScreenWhileClicking(),
              ),
            ),
            Spacer(
              flex: 3,
            ),
            if (_showAd && adContainer != null) adContainer!
          ],
        ),
      ),
    );
  }
}
