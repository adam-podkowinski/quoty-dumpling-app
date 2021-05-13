import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  static double _volume = 1.0;
  double get volume => _volume;

  static double backgroundVolDivider = 2.5;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  static final AudioCache _audioCache = AudioCache(prefix: 'assets/sounds/');

  static final AudioPlayer _loopPlayer = AudioPlayer(playerId: 'loopPlayer');
  static final AudioCache _loopCache = AudioCache(
    prefix: 'assets/sounds/',
    fixedPlayer: _loopPlayer,
  );

  Future playDumplingEating() async {
    if (_isMuted || _volume <= 0) return;
    await _audioCache.play(
      'eating_sound.mp3',
      mode: PlayerMode.LOW_LATENCY,
      volume: _volume,
    );
  }

  Future playUnlockQuote() async {
    if (_isMuted || _volume <= 0) return;
    await _audioCache.play(
      'unlock_sound.mp3',
      mode: PlayerMode.LOW_LATENCY,
      volume: _volume,
    );
  }

  Future playBuyItem() async {
    if (_isMuted || _volume <= 0) return;
    await _audioCache.play(
      'item_purchase.wav',
      mode: PlayerMode.LOW_LATENCY,
      volume: _volume,
    );
  }

  static Future playLoopAudio() async {
    await _loopCache.loop(
      'background_music.mp3',
      volume: _volume / backgroundVolDivider,
    );
  }

  void changeLoopVolume() {
    _loopPlayer.setVolume(_volume / backgroundVolDivider);
  }

  static Future stopLoopAudio() async {
    await _loopPlayer.stop();
  }

  Future initAudio() async {
    final prefs = await SharedPreferences.getInstance();
    _volume = prefs.getDouble('volume') ?? .5;
    _isMuted = _volume <= 0 ? true : false;
    await stopLoopAudio();
    await playLoopAudio();
  }

  void changeVolume(double newVolume) {
    _volume = newVolume;
    changeLoopVolume();
    if (_volume <= 0) {
      _isMuted = true;
      _loopPlayer.pause();
    } else {
      _isMuted = false;
      _loopPlayer.resume();
    }

    SharedPreferences.getInstance().then(
      (prefs) => prefs.setDouble('volume', _volume),
    );
    notifyListeners();
  }

  void changeMute() {
    _isMuted = !_isMuted;

    if (_isMuted) {
      changeVolume(0);
    } else {
      changeVolume(1);
    }
  }
}
