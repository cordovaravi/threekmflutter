// import 'dart:io';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:get/get.dart';
// import 'package:threekm/models/news_controller.dart';
// import 'package:video_player/video_player.dart';

// class ChewieVideo extends StatefulWidget {
//   final String url;
//   final int? index;
//   final VoidCallback? onFinished;
//   ChewieVideo(this.url, {this.index, this.onFinished})
//       : super(key: UniqueKey());

//   @override
//   _ChewieVideoState createState() => _ChewieVideoState();
// }

// class _ChewieVideoState extends State<ChewieVideo> {
//   BetterPlayerController? _betterPlayerController;
//   var controller = Get.find<NewsController>();
//   bool error = false;

//   @override
//   void initState() {
//     super.initState();
//     initChewie();
//   }

//   void initChewie() async {
//     try {
//       BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network,
//         widget.url,
//       );

//       void onVisibilityChanged(double visibleFraction) async {
//         print("Visible fraction $visibleFraction");
//         bool isPlaying = _betterPlayerController!.isPlaying()!;
//         bool initialized = _betterPlayerController!.isVideoInitialized()!;
//         if (visibleFraction > 0) {
//           if (initialized && !isPlaying) {
//             print("Visible fraction play");
//             _betterPlayerController!.play();
//           }
//         } else {
//           if (initialized && isPlaying) {
//             print("Visible fraction pause");
//             _betterPlayerController!.pause();
//           }
//         }
//       }

//       _betterPlayerController = BetterPlayerController(
//           BetterPlayerConfiguration(
//             autoPlay: false,
//             fit: BoxFit.fitWidth,
//             eventListener: (event) {
//               if (event.betterPlayerEventType ==
//                   BetterPlayerEventType.finished) {
//                 if (widget.onFinished != null) {
//                   widget.onFinished!();
//                 }
//               }
//             },
//             playerVisibilityChangedBehavior: onVisibilityChanged,
//             controlsConfiguration: BetterPlayerControlsConfiguration(
//                 // enableFullscreen: false,
//                 // showControls: false,
//                 // enableRetry: true,
//                 // enableSkips: false,
//                 // enablePlayPause: false,
//                 // enableProgressBar: false,
//                 // showControlsOnInitialize: false
//                 ),
//           ),
//           betterPlayerPlaylistConfiguration:
//               BetterPlayerPlaylistConfiguration(),
//           betterPlayerDataSource: betterPlayerDataSource);
//       _betterPlayerController?.preCache(betterPlayerDataSource);
//     } catch (e) {
//       setState(() => error = true);
//       print(e.toString());
//     }
//   }

//   @override
//   void dispose() {
//     if (_betterPlayerController != null) {
//       _betterPlayerController!.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BetterPlayer(
//       controller: _betterPlayerController!,
//     );
//     // )
//   }
// }

// class ChewieVideoFeed extends StatefulWidget {
//   final String url;
//   final int? index;
//   final Widget placeHolder;
//   final VoidCallback onFinished;
//   final ValueChanged<double> onProgress;
//   ChewieVideoFeed(
//     this.url, {
//     this.index,
//     required this.placeHolder,
//     required this.onFinished,
//     required this.onProgress,
//   }) : super(key: UniqueKey());

//   @override
//   _ChewieVideoFeedState createState() => _ChewieVideoFeedState();
// }

// class _ChewieVideoFeedState extends State<ChewieVideoFeed> {
//   BetterPlayerController? _betterPlayerController;
//   var controller = Get.find<NewsController>();
//   bool error = false;

//   @override
//   void initState() {
//     super.initState();
//     initChewie();
//   }

//   void initChewie() async {
//     try {
//       BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network,
//         widget.url,
//       );

//       void onVisibilityChanged(double visibleFraction) async {
//         bool isPlaying = await _betterPlayerController!.isPlaying()!;
//         bool initialized = _betterPlayerController!.isVideoInitialized()!;
//         if (visibleFraction >= 0) {
//           if (initialized && !isPlaying) {
//             _betterPlayerController!.play();
//           }
//         } else {
//           if (initialized && isPlaying) {
//             _betterPlayerController!.pause();
//           }
//         }
//       }

//       _betterPlayerController = BetterPlayerController(
//           BetterPlayerConfiguration(
//             autoPlay: true,
//             looping: false,
//             fit: BoxFit.fitWidth,
//             aspectRatio: 9 / 20,
//             playerVisibilityChangedBehavior: onVisibilityChanged,
//             controlsConfiguration: BetterPlayerControlsConfiguration(
//               enableFullscreen: false,
//               backgroundColor: Color(0xFF0F0F2D),
//               showControls: false,
//               showControlsOnInitialize: false,
//             ),
//           ),
//           betterPlayerPlaylistConfiguration:
//               BetterPlayerPlaylistConfiguration(),
//           betterPlayerDataSource: betterPlayerDataSource);
//       _betterPlayerController?.preCache(betterPlayerDataSource);
//       _betterPlayerController?.onPlayerVisibilityChanged(0.6);
//       _betterPlayerController?.addEventsListener((i) {
//         if (i.betterPlayerEventType == BetterPlayerEventType.finished) {
//           widget.onFinished();
//         } else if (i.betterPlayerEventType == BetterPlayerEventType.progress) {
//           if (i.parameters != null &&
//               i.parameters!['progress'] != null &&
//               i.parameters!['duration'] != null) {
//             Duration progress = i.parameters!['progress'];
//             Duration duration = i.parameters!['duration'];
//             double percentage = progress.inSeconds / duration.inSeconds;
//             widget.onProgress(percentage);
//           }
//         }
//       });
//     } catch (e) {
//       setState(() => error = true);
//       print(e.toString());
//     }
//   }

//   @override
//   void dispose() {
//     if (_betterPlayerController != null) {
//       _betterPlayerController!.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BetterPlayer(
//       controller: _betterPlayerController!,
//     );
//   }
// }

// class ChewieVideoFile extends StatefulWidget {
//   final File file;
//   ChewieVideoFile(this.file) : super(key: UniqueKey());
//   @override
//   _ChewieVideoFileState createState() => _ChewieVideoFileState();
// }

// class _ChewieVideoFileState extends State<ChewieVideoFile> {
//   // ChewieController? chewieController;

//   @override
//   void initState() {
//     super.initState();
//     // initChewie();
//   }

//   // initChewie() async {
//   //   final videoPlayerController = VideoPlayerController.file(
//   //     widget.file,
//   //   );

//   //   await videoPlayerController.initialize();

//   //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//   //     if (mounted) {
//   //       setState(() {
//   //         chewieController = ChewieController(
//   //           videoPlayerController: videoPlayerController,
//   //           allowFullScreen: false,
//   //           aspectRatio: 16 / 9,
//   //           autoPlay: false,
//   //           looping: false,
//   //         );
//   //       });
//   //     }
//   //   });
//   // }

//   @override
//   void dispose() {
//     // if (chewieController != null) {
//     //   chewieController!.dispose();
//     // }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BetterPlayer.file(
//       widget.file.path,
//     );
//   }
// }
