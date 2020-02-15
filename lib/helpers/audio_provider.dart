import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioProvider extends ChangeNotifier {
  double _volume = 1.0;
  double get volume => _volume;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  static AudioPlayer _loopPlayer = AudioPlayer(playerId: 'loopId');

  AudioCache _audioCacheLoop = AudioCache(
    prefix: 'sounds/',
    fixedPlayer: _loopPlayer,
  );

  AudioCache _audioCache = AudioCache(prefix: 'sounds/');

  Future playDumplingEating() async {
    if (_isMuted || _volume <= 0) return;
    await _audioCache.play(
      'eating_sound.mp3',
      mode: PlayerMode.LOW_LATENCY,
      volume: _volume,
    );
  }

  Future playLoopAudio() async {
    _loopPlayer = await _audioCacheLoop.loop(
      'background_music.mp3',
      volume: _volume,
    );
  }

  Future stopAudio() async {
    await _loopPlayer.stop();
  }

  void changeVolume(double newVolume) {
    _volume = newVolume;
    _loopPlayer.setVolume(newVolume);
    if (_volume <= 0) {
      _isMuted = true;
      _loopPlayer.pause();
    } else {
      _isMuted = false;
      _loopPlayer.resume();
    }
    notifyListeners();
  }

  void changeMute() {
    _isMuted = !_isMuted;

    if (_isMuted) {
      _volume = 0;
      _loopPlayer.setVolume(_volume);
      _loopPlayer.pause();
    } else {
      _volume = 1;
      _loopPlayer.setVolume(_volume);
      _loopPlayer.resume();
    }
    notifyListeners();
  }
}
