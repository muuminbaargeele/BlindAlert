import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class Base64AudioPlayer {
  final String base64Audio;
  static AudioPlayer? _currentAudioPlayer;
  late AudioPlayer _audioPlayer;
  late Uint8List _audioBytes;
  static const platform = MethodChannel('com.example.blind_alert/audio');

  Base64AudioPlayer({required this.base64Audio}) {
    _audioPlayer = AudioPlayer();
    _audioBytes = base64Decode(base64Audio);
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _stopCurrentAudio();  // Ensure any currently playing audio is stopped
      _currentAudioPlayer = _audioPlayer; // Set the current audio player to this instance
      await _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.dataFromBytes(
          _audioBytes,
          mimeType: 'audio/mpeg', // Adjust the mime type according to your audio type
        ),
      ));
      await _audioPlayer.play();
    } catch (e) {
      print("Error setting audio source: $e");
    }
  }

  static Future<void> _stopCurrentAudio() async {
    try {
      if (_currentAudioPlayer != null && _currentAudioPlayer!.playing) {
        await _currentAudioPlayer!.stop();
        _currentAudioPlayer = null;
      }
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  Future<void> stopAllAudio() async {
    try {
      await platform.invokeMethod('stopAllAudio');
    } on PlatformException catch (e) {
      print("Failed to stop all audio: '${e.message}'.");
    }
  }

  Future<void> play() async {
    try {
      await _stopCurrentAudio();  // Ensure any currently playing audio is stopped
      _currentAudioPlayer = _audioPlayer; // Set the current audio player to this instance
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  void dispose() {
    if (_currentAudioPlayer == _audioPlayer) {
      _currentAudioPlayer = null;
    }
    _audioPlayer.dispose();
  }
}
