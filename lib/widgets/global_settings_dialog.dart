import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalSettingsDialog extends StatefulWidget {
  @override
  _GlobalSettingsDialogState createState() => _GlobalSettingsDialogState();
}

class _GlobalSettingsDialogState extends State<GlobalSettingsDialog> {
  static const String _iconsURL = 'https://www.flaticon.com/authors/freepik';

  static const String _dumplingImageURL = 'https://www.freepik.com';

  static const String _backgroundMusicURL = 'https://www.zapsplat.com';

  static const List<Tuple2<String, String>> _assetsCreators = [
    Tuple2<String, String>(
      'Icons: Free Pik, bqlqn',
      _iconsURL,
    ),
    Tuple2<String, String>(
      'Dumpling: macrovector / Freepik',
      _dumplingImageURL,
    ),
    Tuple2<String, String>(
      'Music: zapsplat.com',
      _backgroundMusicURL,
    ),
  ];

  late AudioProvider _audioProvider;
  final _isInit = true;
  final _spacing = SizeConfig.screenWidth! * .035;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _audioProvider = Provider.of<AudioProvider>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ThemeColors.background,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              heightFactor: 1,
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_spacing),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: ThemeColors.onBackground,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_spacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    style: Styles.kSettingsTitleStyle,
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                    thickness: 2,
                    endIndent: Styles.kSettingsTitleStyle.fontSize! * 3.6,
                    indent: Styles.kSettingsTitleStyle.fontSize! * 3.6,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Volume:',
                        style: Styles.kSettingsTextStyle,
                      ),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _audioProvider.isMuted
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                              ),
                              color: ThemeColors.secondary,
                              onPressed: () => _audioProvider.changeMute(),
                            ),
                            Positioned.fill(
                              left: SizeConfig.screenWidth! * 0.08,
                              child: Slider(
                                value: _audioProvider.volume,
                                onChanged: (n) =>
                                    _audioProvider.changeVolume(n),
                                activeColor: ThemeColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                    thickness: .75,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RoundedButton(
                    color: ThemeColors.surface,
                    width: SizeConfig.screenWidth! * .5,
                    textColor: ThemeColors.background,
                    text: 'Credits',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeColors.background,
                              borderRadius: BorderRadius.circular(_spacing),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(_spacing),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Credits',
                                    style: Styles.kSettingsTitleStyle,
                                  ),
                                  Divider(
                                    color: ThemeColors.secondary,
                                    thickness: 2,
                                    endIndent:
                                        Styles.kSettingsTitleStyle.fontSize! *
                                            3.8,
                                    indent:
                                        Styles.kSettingsTitleStyle.fontSize! *
                                            3.8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Programming: ',
                                        style: Styles.kSettingsTextStyle,
                                      ),
                                      linkCreator(
                                        'Adam Podkowinski',
                                        'https://github.com/adam-podkowinski',
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: ThemeColors.secondary,
                                    thickness: .75,
                                  ),
                                  Text(
                                    'Game assets created by:',
                                    style: Styles.kSettingsTextStyle,
                                  ),
                                  ..._assetsCreators.map(
                                    (e) => Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        linkCreator(e.item1, e.item2),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: ThemeColors.secondary,
                                    thickness: .75,
                                  ),
                                  RoundedButton(
                                    text: 'Other Licenses',
                                    onPressed: () => showLicensePage(
                                      context: context,
                                      applicationIcon:
                                          Icon(CustomIcons.dumpling),
                                      applicationName: 'Quoty Dumpling',
                                      applicationVersion: '1.0.0',
                                    ),
                                    color: ThemeColors.secondary,
                                    textColor: ThemeColors.background,
                                  ),
                                  RoundedButton(
                                    text: 'OK',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    color: ThemeColors.surface,
                                    textColor: ThemeColors.background,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                    thickness: .75,
                  ),
                  RoundedButton(
                    onPressed: () async {
                      const platform = MethodChannel('quotyDumplingChannel');
                      await platform.invokeMethod('signIn');
                    },
                    color: ThemeColors.surface,
                  ),
                  Divider(
                    color: ThemeColors.secondary,
                    thickness: .75,
                  ),
                  if (!kReleaseMode)
                    RoundedButton(
                      color: Theme.of(context).errorColor,
                      width: SizeConfig.screenWidth! * .5,
                      textColor: ThemeColors.background,
                      text: 'Reset Game',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ThemeColors.background,
                                borderRadius: BorderRadius.circular(_spacing),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(_spacing),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Are you sure?',
                                      style: Styles.kSettingsTitleStyle,
                                    ),
                                    Divider(
                                      color: ThemeColors.secondary,
                                      thickness: 2,
                                      endIndent:
                                          Styles.kSettingsTitleStyle.fontSize! *
                                              2.3,
                                      indent:
                                          Styles.kSettingsTitleStyle.fontSize! *
                                              2.3,
                                    ),
                                    Text(
                                      'Your game data will be lost. All of your items and quotes will be deleted and you won\'t be able to restore them!',
                                      textAlign: TextAlign.justify,
                                      style: Styles.kSettingsTextStyle,
                                    ),
                                    Divider(
                                      color: ThemeColors.secondary,
                                      thickness: .75,
                                    ),
                                    RoundedButton(
                                      text: 'Go back',
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      color: ThemeColors.surface,
                                      textColor: ThemeColors.background,
                                    ),
                                    RoundedButton(
                                      text: 'Reset Game!',
                                      onPressed: () =>
                                          DBProvider.db.resetGame(context),
                                      color: Theme.of(context).errorColor,
                                      textColor: ThemeColors.background,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText linkCreator(String text, String url) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Styles.kSettingsTextStyle.copyWith(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.normal,
        ),
        children: [
          TextSpan(
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                  url,
                );
              },
          ),
        ],
      ),
    );
  }
}
