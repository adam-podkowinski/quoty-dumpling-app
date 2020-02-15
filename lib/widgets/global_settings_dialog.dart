import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/audio_provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class GlobalSettingsDialog extends StatelessWidget {
  final _padding = SizeConfig.screenWidth * .035;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      backgroundColor: Theme.of(context).backgroundColor,
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
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                  ),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
