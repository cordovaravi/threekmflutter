import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final bool play;
  final String? thubnail;
  final bool? fromSinglePage;

  const VideoWidget(
      {Key? key,
      this.fromSinglePage,
      this.thubnail,
      required this.url,
      required this.play})
      : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    log('_betterPlayerController init here....... ${widget.url}');
    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);
    _betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
      //autoDetectFullscreenAspectRatio: true,
      playerVisibilityChangedBehavior: (visibilityFraction) {
        if (visibilityFraction == 1.0) {
          _betterPlayerController!.play();
          _betterPlayerController!.setControlsVisibility(false);
        } else {
          // _betterPlayerController!.clearCache();
          _betterPlayerController!.pause();
          _betterPlayerController!.setControlsVisibility(true);
        }
      },
    ), betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController!.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        log("this is video height ${_betterPlayerController!.videoPlayerController!.value.size!.height}");
        log("and aspect Ratio is ${_betterPlayerController!.videoPlayerController!.value.aspectRatio}");
        if (widget.fromSinglePage == true) {
          setState(() {});
        }
        //setState(() {});
        setState(() {
          _betterPlayerController!.setOverriddenAspectRatio(
              _betterPlayerController!
                  .videoPlayerController!.value.aspectRatio);
          _betterPlayerController!.setOverriddenFit(BoxFit.contain);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController!.clearCache();
    _betterPlayerController!.dispose();
    log('_betterPlayerController dispose here .....');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("building video context");
    return Container(
        child:
            _betterPlayerController?.videoPlayerController?.value.initialized ==
                    true
                ? BetterPlayer(controller: _betterPlayerController!)
                : Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: 254,
                    width: MediaQuery.of(context).size.width,
                  ));
    // AspectRatio(
    //   aspectRatio: _betterPlayerController
    //               ?.videoPlayerController?.value.aspectRatio !=
    //           null
    //       ? _betterPlayerController!.videoPlayerController!.value.aspectRatio
    //       : 16 / 9,
    //   //  height:
    //   //     _betterPlayerController?.videoPlayerController?.value.size?.height ??
    //   //         300,
    //   // width:
    //   //     _betterPlayerController?.videoPlayerController?.value.size?.width ??
    //   //         300,
    //   child: BetterPlayer(
    //     controller: _betterPlayerController!,
    //   ),
    // );
    // Container(
    //   height: _betterPlayerController
    //               ?.videoPlayerController?.value.size?.height !=
    //           null
    //       ? _betterPlayerController!.videoPlayerController!.value.size!.height
    //       : 300,
    //   width: MediaQuery.of(context).size.width,
    //   child: BetterPlayer(
    //     controller: _betterPlayerController!,
    //   ),
    // );
  }
}

// class VideoWidget extends StatefulWidget {
//   final String url;
//   final bool play;
//   final String? thubnail;

//   const VideoWidget(
//       {Key? key, this.thubnail, required this.url, required this.play})
//       : super(key: key);
//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }

// class _VideoWidgetState extends State<VideoWidget>
//     with AutomaticKeepAliveClientMixin {
//   VideoPlayerController? _videoPlayerController1;
//   //VideoPlayerController? _videoPlayerController2;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }

//   Future<void> initializePlayer() async {
//     _videoPlayerController1 = VideoPlayerController.network(widget.url);
//     await Future.wait([
//       _videoPlayerController1!.initialize(),
//     ]);
//     _createChewieController();
//     setState(() {});
//   }

//   void _createChewieController() {
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController1!,
//       autoPlay: widget.play,
//       looping: false,
//       subtitleBuilder: (context, dynamic subtitle) => Container(
//         padding: const EdgeInsets.all(10.0),
//         child: subtitle is InlineSpan
//             ? RichText(
//                 text: subtitle,
//               )
//             : Text(
//                 subtitle.toString(),
//                 style: const TextStyle(color: Colors.black),
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController1!.dispose();
//     //  _videoPlayerController2!.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       child: _chewieController != null &&
//               _chewieController!.videoPlayerController.value.isInitialized
//           ? Chewie(
//               controller: _chewieController!,
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 20),
//                 Text('Loading'),
//               ],
//             ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }


// class _VideoWidgetState extends State<VideoWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.url,
//         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//       setState(() {});
//     });
//     _controller.addListener(() {
//       setState(() {});
//     });
//     if (widget.play) {
//       _controller.play();
//       _controller.setLooping(true);
//     }
//   }

//   @override
//   void didUpdateWidget(VideoWidget oldWidget) {
//     if (oldWidget.play != widget.play) {
//       if (widget.play) {
//         _controller.play();
//         _controller.setLooping(true);
//       } else {
//         _controller.pause();
//       }
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             children: [
//               VideoPlayer(_controller),
//               ClosedCaption(text: _controller.value.caption.text),
//               _ControlsOverlay(controller: _controller),
//             ],
//           );
//         } else {
//           return Center(
//               child: Stack(
//             children: [
//               //CircularProgressIndicator(),
//               widget.thubnail != null
//                   ? CachedNetworkImage(
//                       imageUrl: widget.thubnail!,
//                     )
//                   : Container(),
//               Center(
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   child: Lottie.asset("assets/videoLoading2.json"),
//                   // child: CupertinoActivityIndicator(
//                   //   animating: true,
//                   // ),
//                 ),
//               )
//             ],
//           ));
//         }
//       },
//     );
//   }
// }

// class _ControlsOverlay extends StatelessWidget {
//   const _ControlsOverlay({Key? key, required this.controller})
//       : super(key: key);

//   static const _examplePlaybackRates = [
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//     3.0,
//     5.0,
//     10.0,
//   ];

//   final VideoPlayerController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 50),
//           reverseDuration: Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 50.0,
//                       semanticLabel: 'Play',
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//         // Align(
//         //   alignment: Alignment.topRight,
//         //   child: PopupMenuButton<double>(
//         //     initialValue: controller.value.playbackSpeed,
//         //     tooltip: 'Playback speed',
//         //     onSelected: (speed) {
//         //       controller.setPlaybackSpeed(speed);
//         //     },
//         //     itemBuilder: (context) {
//         //       return [
//         //         for (final speed in _examplePlaybackRates)
//         //           PopupMenuItem(
//         //             value: speed,
//         //             child: Text('${speed}x'),
//         //           )
//         //       ];
//         //     },
//         //     child: Padding(
//         //       padding: const EdgeInsets.symmetric(
//         //         // Using less vertical padding as the text is also longer
//         //         // horizontally, so it feels like it would need more spacing
//         //         // horizontally (matching the aspect ratio of the video).
//         //         vertical: 12,
//         //         horizontal: 16,
//         //       ),
//         //       child: Text('${controller.value.playbackSpeed}x'),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }



// /// flick code
// class VideoWidget extends StatefulWidget {
//   final String url;
//   final bool play;
//   final String? thubnail;

//   const VideoWidget(
//       {Key? key, this.thubnail, required this.url, required this.play})
//       : super(key: key);

//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }

// class _VideoWidgetState extends State<VideoWidget> {
//   late FlickManager flickManager;
//   @override
//   void initState() {
//     super.initState();
//     flickManager = FlickManager(
//       videoPlayerController: VideoPlayerController.network(
//         widget.url,
//       ),
//     );
//   }

//   ///If you have subtitle assets
//   // Future<ClosedCaptionFile> _loadCaptions() async {
//   //   final String fileContents = await DefaultAssetBundle.of(context)
//   //       .loadString('images/bumble_bee_captions.srt');
//   //   flickManager.flickControlManager!.toggleSubtitle();
//   //   return SubRipCaptionFile(fileContents);
//   // }
//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeVideoPlayerFuture(bool isPlaying) async {
//     // if (isPlaying && this.mounted) {
//     //   flickManager.flickControlManager?.autoPause();
//     // // } else if (isPlaying) {
//     // //   flickManager.flickControlManager?.autoResume();
//     // // }
//     isPlaying
//         ? flickManager.flickControlManager?.play()
//         : flickManager.flickControlManager!.pause();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture(widget.play),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//               child: FlickVideoPlayer(
//                 flickManager: flickManager,
//                 flickVideoWithControls: FlickVideoWithControls(
//                   // controls: FeedPlayerPortraitControls(
//                   //   flickMultiManager: widget.flickMultiManager,
//                   //   flickManager: flickManager,
//                   // ),
//                   controls: FlickPortraitControls(),
//                   videoFit: BoxFit.contain,
//                 ),
//                 //preferredDeviceOrientationFullscreen: [],
//                 // flickVideoWithControlsFullscreen: FlickVideoWithControls(
//                 //   willVideoPlayerControllerChange: false,
//                 //   controls: FlickPortraitControls(),
//                 // ),
//               ),
//             );
//           } else {
//             return Center(
//               child: widget.thubnail != null
//                   ? CachedNetworkImage(
//                       imageUrl: widget.thubnail!,
//                     )
//                   : CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
