import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late FlickManager flickManager;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        // "assets/video/vid3.mp4"

        Uri.parse(
          // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        ),
      )..initialize().catchError((error) {
          if (!isDisposed) {
            debugPrint("Video initialization error: $error");
          }
        }),
      getPlayerControlsTimeout: (
          {errorInVideo, isPlaying, isVideoEnded, isVideoInitialized}) {
        if (isPlaying == true) {
          return const Duration(seconds: 2); // Hide controls after 33 seconds
        } else {
          return const Duration(seconds: 0); // Keep controls visible
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ModalRoute.of(context)?.addScopedWillPopCallback(handleBackButton);
  }

  @override
  void dispose() {
    isDisposed = true;

    flickManager.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  Future<bool> handleBackButton() async {
    final currentOrientation = MediaQuery.of(context).orientation;

    if (currentOrientation == Orientation.landscape) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {}); // Rebuild the widget tree
      return false;
    }

    return true;
  }

  // void toggleLandscapeMode() {
  //   final currentOrientation = MediaQuery.of(context).orientation;

  //   if (currentOrientation == Orientation.portrait) {
  //     SystemChrome.setPreferredOrientations([
  //       DeviceOrientation.landscapeLeft,
  //       DeviceOrientation.landscapeRight,
  //     ]);

  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //   } else {
  //     SystemChrome.setPreferredOrientations([
  //       DeviceOrientation.portraitUp,
  //       DeviceOrientation.portraitDown,
  //     ]);

  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //   }

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double videoHeight = screenWidth / (16 / 9);

    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: Center(
        child: GestureDetector(
          onTap: () {
            print("aaaaaaaaa");
            if (!flickManager.flickDisplayManager!.showPlayerControls) {
              flickManager.flickDisplayManager!.handleShowPlayerControls();
            } else {
              // flickManager.flickDisplayManager!.handleVideoTap();
              flickManager.flickDisplayManager!.showPlayerControls;
            }
          },
          // onTap: toggleLandscapeMode,
          child: SizedBox(
            width: MediaQuery.of(context).orientation == Orientation.portrait
                ? screenWidth
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? videoHeight
                : MediaQuery.of(context).size.height,
            child: FlickVideoPlayer(
                flickVideoWithControls: FlickVideoWithControls(
                  controls:
                      CustomVideoPlayerControls(flickManager: flickManager),
                ),
                flickManager: flickManager),
          ),
        ),
      ),
    );
  }
}

class CustomVideoPlayerControls extends StatefulWidget {
  final FlickManager flickManager;

  const CustomVideoPlayerControls({super.key, required this.flickManager});

  @override
  State<CustomVideoPlayerControls> createState() =>
      _CustomVideoPlayerControlsState();
}

class _CustomVideoPlayerControlsState extends State<CustomVideoPlayerControls> {
  @override
  void dispose() {
    // _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: FlickAutoHideChild(
        autoHide: true, // Automatically hides after a delay
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlickVideoProgressBar(
                    flickProgressBarSettings: FlickProgressBarSettings(
                      height: 5,
                      handleRadius: 5,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          FlickSoundToggle(),
                          SizedBox(width: 10),
                          FlickPlayToggle(),
                          SizedBox(
                            width: 10,
                          ),
                          FlickCurrentPosition(fontSize: 12),
                          SizedBox(width: 5),
                          Text("/"),
                          SizedBox(width: 5),
                          FlickTotalDuration(fontSize: 12),
                        ],
                      ),
                      IconButton(
                        icon: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? const Icon(Icons.fullscreen, color: Colors.white)
                            : const Icon(Icons.fullscreen_exit,
                                color: Colors.white),
                        onPressed: () {
                          if (MediaQuery.of(context).orientation ==
                              Orientation.portrait) {
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.immersiveSticky);

                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeRight,
                              DeviceOrientation.landscapeLeft,
                            ]);
                          } else {
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.immersiveSticky);

                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Center(
              child: FlickPlayToggle(size: 50),
            ),
          ],
        ),
      ),
    );
  }
}








//Appinio Video player 
// class VideoPlayerScreen extends StatefulWidget {
//   final String image;
//   const VideoPlayerScreen({super.key, required this.image});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late CachedVideoPlayerController videoPlayerController;

//   //  late CachedVideoPlayerController videoPlayerController;
//   late CustomVideoPlayerController _customVideoPlayerController;
//   bool isLoading = true;
//   String videoUrl =
//       // "https://storage.googleapis.com/downloads.webmproject.org/av1/exoplayer/bbb-av1-480p.mp4";
//       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//   // 'https://firebasestorage.googleapis.com/v0/b/chat-app-3c3ad.appspot.com/o/Ariana%20Grande%20-%207%20rings%20(Lyrics).mp4?alt=media&token=49ed705f-f4e3-4d29-8704-b27a6d6489ec';
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       isLoading = true;
//     });
//     videoPlayerController = CachedVideoPlayerController.network(videoUrl)
//       ..initialize().then((value) => setState(() {
//             isLoading = false;
//           }));
//     _customVideoPlayerController = CustomVideoPlayerController(
//       customVideoPlayerSettings: CustomVideoPlayerSettings(
//           systemUIModeAfterFullscreen: SystemUiMode.immersiveSticky,
//           systemUIModeInsideFullscreen: SystemUiMode.immersiveSticky,
//           // enterFullscreenOnStart: true,
//           // exitFullscreenButton: GestureDetector(
//           //   onTap: () {
//           //     exitFullscreen();
//           //   },
//           //   child: Icon(
//           //     Icons.fullscreen_exit,
//           //     size: 23,
//           //     color: whiteColor,
//           //   ),
//           // ),
//           enterFullscreenButton: GestureDetector(
//             onTap: () {
//               _customVideoPlayerController.setFullscreen(true);
//             },
//             child: Icon(
//               Icons.fullscreen,
//               size: 23,
//               color: whiteColor,
//             ),
//           ),
//           // thumbnailWidget: Image(
//           //   fit: BoxFit.fill,
//           //   image: (
//           //     '',
//           //   ),
//           // ),
//           allowVolumeOnSlide: true,
//           showSeekButtons: true),
//       context: context,
//       videoPlayerController: videoPlayerController,
//     );
//   }

//   @override
//   void dispose() {
//     exitFullscreen();
//     _customVideoPlayerController.dispose();
//     super.dispose();
//   }

//   void enterFullscreen() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     setState(() {});
//   }

//   void exitFullscreen() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         backgroundColor: Colors.black26,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: primaryColor,
//           ),
//         ),
//       );
//     } else {
//       return Scaffold(
//         backgroundColor: Colors.black26,
//         // appBar: AppBar(
//         //   title: Text("HEllo"),
//         // ),
//         body: Center(
//           child: CustomVideoPlayer(
//             customVideoPlayerController: _customVideoPlayerController,
//           ),
//         ),
//       );
//     }
//   }
// }

