import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:quoty_dumpling_app/data/DBProvider.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';

class GlobalSettingsDialog extends StatefulWidget {
  @override
  _GlobalSettingsDialogState createState() => _GlobalSettingsDialogState();
}

class _GlobalSettingsDialogState extends State<GlobalSettingsDialog> {
  static const String _iconsURL = 'https://www.flaticon.com/authors/freepik';

  static const String _dumplingImageURL =
      'https://pl.freepik.com/darmowe-wektory/realistyczny-zestaw-pierogow-vareniki-pierogi-ravioli-khinkali-pelmeni-manti-momo-tortellini_2238437.htm#';

  static const String _backgroundMusicURL = 'https://www.zapsplat.com';

  AudioProvider _audioProvider;
  var _isInit = true;
  final _padding = SizeConfig.screenWidth * .035;

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
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).backgroundColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              heightFactor: 1,
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_padding),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: Styles.kSettingsTitleStyle.color,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    style: Styles.kSettingsTitleStyle,
                  ),
                  Divider(
                    color: Theme.of(context).accentColor,
                    thickness: 2,
                    endIndent: Styles.kSettingsTitleStyle.fontSize * 3.6,
                    indent: Styles.kSettingsTitleStyle.fontSize * 3.6,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Volume:',
                        style: Styles.kSettingsTextStyle,
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _audioProvider.isMuted
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () => _audioProvider.changeMute(),
                            ),
                            Positioned(
                              left: SizeConfig.screenWidth * 0.08,
                              child: Slider(
                                value: _audioProvider.volume,
                                onChanged: (n) =>
                                    _audioProvider.changeVolume(n),
                                activeColor: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).accentColor,
                    thickness: .75,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Game assets created by:',
                        style: Styles.kSettingsTextStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      assetsCreator('Icons: Free Pik', _iconsURL),
                      SizedBox(
                        height: 5,
                      ),
                      assetsCreator(
                          'Dumpling Image: Vector Pouch', _dumplingImageURL),
                      SizedBox(
                        height: 5,
                      ),
                      assetsCreator('Music: zapsplat.com', _backgroundMusicURL),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Theme.of(context).accentColor,
                    thickness: .75,
                  ),
                  RoundedButton(
                    color: Theme.of(context).errorColor,
                    width: SizeConfig.screenWidth * .5,
                    textColor: Theme.of(context).backgroundColor,
                    text: 'Reset Game',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(_padding),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(_padding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Are you sure?',
                                    style: Styles.kSettingsTitleStyle,
                                  ),
                                  Divider(
                                    color: Theme.of(context).accentColor,
                                    thickness: 2,
                                    endIndent:
                                        Styles.kSettingsTitleStyle.fontSize *
                                            2.3,
                                    indent:
                                        Styles.kSettingsTitleStyle.fontSize *
                                            2.3,
                                  ),
                                  Text(
                                    'Your game data will be lost. All of your items and quotes will be deleted and you won\'t be able to restore them!',
                                    textAlign: TextAlign.justify,
                                    style: Styles.kSettingsTextStyle,
                                  ),
                                  Divider(
                                    color: Theme.of(context).accentColor,
                                    thickness: .75,
                                  ),
                                  RoundedButton(
                                    text: 'Go back',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    textColor:
                                        Theme.of(context).backgroundColor,
                                  ),
                                  RoundedButton(
                                    text: 'Reset Game!',
                                    onPressed: () =>
                                        DBProvider.db.resetGame(context),
                                    color: Theme.of(context).errorColor,
                                    textColor:
                                        Theme.of(context).backgroundColor,
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

  assetsCreator(String text, String url) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Styles.kSettingsTextStyle.copyWith(
          color: Colors.blue,
          decoration: TextDecoration.underline,
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
