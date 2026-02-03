import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'settings_service.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SettingsService _settingsService = SettingsService();

  factory SoundService() {
    return _instance;
  }

  SoundService._internal();

  /// Plays a sound from the assets folder.
  /// [fileName] should be the path relative to assets/sounds/, e.g. "click.mp3".
  Future<void> playSound(String fileName) async {
    if (!_settingsService.isSoundEnabled) return;

    try {
      await _audioPlayer.stop(); // Stop any currently playing sound
      await _audioPlayer.setReleaseMode(ReleaseMode.stop); // Default mode
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  /// Plays a sound in a loop.
  Future<void> startLoop(String fileName) async {
    if (!_settingsService.isSoundEnabled) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('Error playing loop: $e');
    }
  }

  /// Stops current sound.
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  /// Disposes the audio player.
  void dispose() {
    _audioPlayer.dispose();
  }
}
