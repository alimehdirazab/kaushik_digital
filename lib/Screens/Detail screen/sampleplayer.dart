import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    // Get video URL - use provided URL or fallback to sample
    final videoUrl = widget.movieUrl ?? 
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
        _isLoading = false;
        _duration = _controller.value.duration;
      });
      
      // Auto play
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
      
      // Listen to video player changes
      _controller.addListener(_videoPlayerListener);
      
    } catch (error) {
      debugPrint("Video initialization error: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _videoPlayerListener() {
    if (mounted) {
      setState(() {
        _position = _controller.value.position;
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    
    // Reset orientation on dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    super.dispose();
  }

  // Play/Pause toggle
  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  // Seek forward 10 seconds
  void _seekForward() {
    final newPosition = _position + const Duration(seconds: 10);
    if (newPosition < _duration) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(_duration);
    }
  }

  // Seek backward 10 seconds
  void _seekBackward() {
    final newPosition = _position - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(Duration.zero);
    }
  }

  // Toggle playback speed
  void _togglePlaybackSpeed() {
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
    
    setState(() {
      _playbackSpeed = newSpeed;
    });
    _controller.setPlaybackSpeed(newSpeed);
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

  // Toggle volume
  void _toggleVolume() {
    setState(() {
      _volume = _volume > 0 ? 0.0 : 1.0;
    });
    _controller.setVolume(_volume);
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
    if (_isLoading) {
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

    if (!_isInitialized) {
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
          setState(() {
            _showControls = !_showControls;
          });
        },
        onDoubleTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final tapPosition = details.globalPosition.dx;
          
          if (tapPosition < screenWidth / 2) {
            _seekBackward();
          } else {
            _seekForward();
          }
        },
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            
            // Controls overlay
            if (_showControls)
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
            if (_showControls)
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
                      onTap: _togglePlaybackSpeed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${_playbackSpeed}x",
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
            if (_showControls)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                      onPressed: _seekBackward,
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ),
            
            // Bottom controls
            if (_showControls)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar
                    VideoProgressIndicator(
                      _controller,
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
                                _volume > 0 ? Icons.volume_up : Icons.volume_off,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _toggleVolume,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
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
  }
}
