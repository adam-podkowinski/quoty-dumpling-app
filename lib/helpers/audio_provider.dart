import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider {
  AudioProvider._();
  static final AudioProvider audio = AudioProvider._();

  static AudioPlayer _loopPlayer = AudioPlayer(playerId: 'loopId');
  AudioPlayer _eatPlayer = AudioPlayer();

  AudioCache _audioCacheLoop = AudioCache(
    prefix: 'sounds/',
    fixedPlayer: _loopPlayer,
  );

  AudioCache _audioCache = AudioCache(
    prefix: 'sounds/',
  );

  Future playDumplingEating() async {
    await _audioCache.play('eating_sound.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  Future playLoopAudio() async {
    _loopPlayer =
        await _audioCacheLoop.loop('background_music.mp3', volume: .2);
  }

  Future stopAudio() async {
    await _loopPlayer.stop();
    await _eatPlayer.stop();
  }

  void changeVolume(double newVolume) {
    // _audioCache.fixedPlayer.setVolume(newVolume);
  }
}
