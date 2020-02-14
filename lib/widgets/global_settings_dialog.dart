import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/audio_provider.dart';

class GlobalSettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () => AudioProvider.audio.changeVolume(1),
            child: Text('unute'),
          ),
          RaisedButton(
            onPressed: () => AudioProvider.audio.changeVolume(0),
            child: Text('mute'),
          ),
        ],
      ),
    );
  }
}
