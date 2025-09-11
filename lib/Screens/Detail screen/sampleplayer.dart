import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class VideoPlayerStateProvider extends ChangeNotifier {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;
  String _errorMessage = '';

  // Getters
  VideoPlayerController get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get showControls => _showControls;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  double get volume => _volume;
  double get playbackSpeed => _playbackSpeed;
  String get errorMessage => _errorMessage;

  void initializePlayer(String? movieUrl) async {
    _isLoading = true;
    notifyListeners();
    
    final videoUrl = movieUrl ?? 
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    try {
      await _controller.initialize();
      _isInitialized = true;
      _isLoading = false;
      _duration = _controller.value.duration;
      
      // Auto play
      _controller.play();
      _isPlaying = true;
      
      // Listen to video player changes
      _controller.addListener(_videoPlayerListener);
      
      notifyListeners();
    } catch (error) {
      debugPrint("Video initialization error: $error");
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  void _videoPlayerListener() {
    _position = _controller.value.position;
    _isPlaying = _controller.value.isPlaying;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void seekForward() {
    final newPosition = _position + const Duration(seconds: 10);
    if (newPosition < _duration) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(_duration);
    }
  }

  void seekBackward() {
    final newPosition = _position - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(Duration.zero);
    }
  }

  void togglePlaybackSpeed() {
    double newSpeed;
    if (_playbackSpeed == 1.0) {
      newSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      newSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      newSpeed = 2.0;
    } else {
      newSpeed = 1.0;
    }
    
    _playbackSpeed = newSpeed;
    _controller.setPlaybackSpeed(newSpeed);
    notifyListeners();
  }

  void toggleVolume() {
    _volume = _volume > 0 ? 0.0 : 1.0;
    _controller.setVolume(_volume);
    notifyListeners();
  }

  void toggleControls() {
    _showControls = !_showControls;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    super.dispose();
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String? movieTitle;
  final int? movieId;
  final String? movieUrl;
  
  const VideoPlayerScreen({
    super.key, 
    this.movieTitle,
    this.movieId,
    this.movieUrl,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VideoPlayerStateProvider>(context, listen: false);
      provider.initializePlayer(widget.movieUrl);
    });
  }

  @override
  void dispose() {
    // Reset orientation on dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // Toggle fullscreen
  void _toggleFullscreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  // Format duration to string
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerStateProvider>(
      builder: (context, playerState, child) {
        if (playerState.isLoading) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Loading ${widget.movieTitle ?? 'Video'}...",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (!playerState.isInitialized) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    "Failed to load video",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (playerState.errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      playerState.errorMessage,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Go Back"),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () {
              playerState.toggleControls();
            },
            onDoubleTapDown: (details) {
              final screenWidth = MediaQuery.of(context).size.width;
              final tapPosition = details.globalPosition.dx;
              
              if (tapPosition < screenWidth / 2) {
                playerState.seekBackward();
              } else {
                playerState.seekForward();
              }
            },
            child: Stack(
              children: [
                // Video Player
                Center(
                  child: AspectRatio(
                    aspectRatio: playerState.controller.value.aspectRatio,
                    child: VideoPlayer(playerState.controller),
                  ),
                ),
                
                // Controls overlay
                if (playerState.showControls)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                
                // Top controls
                if (playerState.showControls)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            widget.movieTitle ?? "Video Player",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: playerState.togglePlaybackSpeed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${playerState.playbackSpeed}x",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Center controls
                if (playerState.showControls)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                          onPressed: playerState.seekBackward,
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: playerState.togglePlayPause,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                          onPressed: playerState.seekForward,
                        ),
                      ],
                    ),
                  ),
                
                // Bottom controls
                if (playerState.showControls)
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress bar
                        VideoProgressIndicator(
                          playerState.controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.red,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Bottom control row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    playerState.volume > 0 ? Icons.volume_up : Icons.volume_off,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: playerState.toggleVolume,
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: playerState.togglePlayPause,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${_formatDuration(playerState.position)} / ${_formatDuration(playerState.duration)}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                MediaQuery.of(context).orientation == Orientation.portrait
                                    ? Icons.fullscreen
                                    : Icons.fullscreen_exit,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: _toggleFullscreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
