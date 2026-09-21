import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPlayerWidget extends StatefulWidget {
  final String url;
  const NetworkVideoPlayerWidget({super.key, required this.url});

  @override
  State<NetworkVideoPlayerWidget> createState() => _NetworkVideoPlayerWidgetState();
}

class _NetworkVideoPlayerWidgetState extends State<NetworkVideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
    _controller.addListener(() {
      setState(() {}); // update UI for slider/progress
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      _isPlaying = false;
    } else {
      _controller.play();
      _isPlaying = true;
    }
    setState(() {});
  }

  void _seekForward() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    _controller.seekTo(position + const Duration(seconds: 10) > duration
        ? duration
        : position + const Duration(seconds: 10));
  }

  void _seekBackward() {
    final position = _controller.value.position;
    _controller.seekTo(position - const Duration(seconds: 10) < Duration.zero
        ? Duration.zero
        : position - const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const CircularProgressIndicator();
    }

    final duration = _controller.value.duration;
    final position = _controller.value.position;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(_controller),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white),
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white),
                      onPressed: _seekForward,
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.red,
                        inactiveColor: Colors.white54,
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Text(
                      "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2,'0')}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
