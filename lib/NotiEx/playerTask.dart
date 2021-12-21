// import 'dart:async';

// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerTask extends BaseAudioHandler
//     with SeekHandler, ChangeNotifier
//     implements AudioHandler {
//   final _player = AudioPlayer();

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> stop() async {
//     await _player.stop();
//     await playbackState.firstWhere(
//         (state) => state.processingState == AudioProcessingState.idle);
//   }

//   playBuzzer() {}
// }
