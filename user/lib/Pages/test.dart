import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Button Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoButtonPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VideoButtonPage extends StatefulWidget {
  const VideoButtonPage({Key? key}) : super(key: key);

  @override
  State<VideoButtonPage> createState() => _VideoButtonPageState();
}

class _VideoButtonPageState extends State<VideoButtonPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/pickup.mp4',
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });

    // Listen to video end
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          _controller.value.isInitialized &&
          !_controller.value.isPlaying) {
        setState(() {
          _isPlaying = false;
          _controller.seekTo(Duration.zero); // Reset the video position
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isInitialized) {
      setState(() {
        _isPlaying = true;
        _controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: const Text('Video Button Example')),
      body: Center(
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _isPlaying
                  ? _isInitialized
                      ? FittedBox(
                          fit: BoxFit.cover,
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator())
                  : const Center(
                      child: Text(
                        'Tap to Play',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
