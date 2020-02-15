import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/audio_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';

class GlobalSettingsDialog extends StatefulWidget {
  @override
  _GlobalSettingsDialogState createState() => _GlobalSettingsDialogState();
}

class _GlobalSettingsDialogState extends State<GlobalSettingsDialog> {
  final _padding = SizeConfig.screenWidth * .035;
  AudioProvider _audioProvider;
  var _isInit = true;

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
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: Styles.kSettingsTitleStyle,
                ),
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
                    style: Styles.kQuoteDetailsTextStyle,
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
                            onChanged: (n) => _audioProvider.changeVolume(n),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
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
                                    'Your game data will be lost. All of your upgrades and quotes will be deleted and you won\'t be able to restore them!',
                                    textAlign: TextAlign.justify,
                                    style: Styles.kQuoteDetailsTextStyle,
                                  ),
                                  Divider(
                                    color: Theme.of(context).accentColor,
                                    thickness: .75,
                                  ),
                                  RoundedButton(
                                    text: 'Restart Game!',
                                    onPressed: () {},
                                    color: Theme.of(context).errorColor,
                                    textColor:
                                        Theme.of(context).backgroundColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
