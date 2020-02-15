import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider {
  AudioProvider._();
  static final AudioProvider audio = AudioProvider._();

  double _volume = 1.0;

  var _isMuted = false;
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
    _loopPlayer =
        await _audioCacheLoop.loop('background_music.mp3', volume: _volume);
  }

  Future stopAudio() async {
    await _loopPlayer.stop();
  }

  void changeVolume(double newVolume) {
    _volume = newVolume;
    _audioCacheLoop.fixedPlayer.setVolume(newVolume);
  }

  void changeMute() {}
}
