/*
// better_player_widget.dart
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';


class BetterPlayerWidget extends StatefulWidget {
  final String url;
  final double aspectRatio;
  final bool autoPlay;
  final bool looping;
  final bool isLive;

  const BetterPlayerWidget({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 9,
    this.autoPlay = true,
    this.looping = false,
    this.isLive = false,
  });

  @override
  State<BetterPlayerWidget> createState() => _BetterPlayerWidgetState();
}

class _BetterPlayerWidgetState extends State<BetterPlayerWidget> {
  late final BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final config = BetterPlayerConfiguration(
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      fit: BoxFit.contain,
      handleLifecycle: true,
      autoDetectFullscreenDeviceOrientation: true,
      fullScreenByDefault: false,
      allowedScreenSleep: false,
    );

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      liveStream: widget.isLive,
    );

    _controller = BetterPlayerController(config);
    _controller.setupDataSource(dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: BetterPlayer(controller: _controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}*/


import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class BetterPlayerWidget extends StatefulWidget {
  final String url;
  final double aspectRatio;
  final bool autoPlay;
  final bool looping;
  final bool isLive;
  final bool isLocal; // 🔥 NEW

  const BetterPlayerWidget({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 9,
    this.autoPlay = true,
    this.looping = false,
    this.isLive = false,
    this.isLocal = false, // default network
  });

  @override
  State<BetterPlayerWidget> createState() => _BetterPlayerWidgetState();
}

class _BetterPlayerWidgetState extends State<BetterPlayerWidget> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    final config = BetterPlayerConfiguration(
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      fit: BoxFit.contain,
      handleLifecycle: true,
      allowedScreenSleep: false,
      autoDetectFullscreenDeviceOrientation: true,
      fullScreenByDefault: false,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enablePlayPause: true,
        enableFullscreen: true,
        enableMute: true,
        enableProgressBar: true,
        enableProgressText: true,
        enablePlaybackSpeed: true,
      ),
    );

    final dataSource = BetterPlayerDataSource(
      widget.isLocal
          ? BetterPlayerDataSourceType.file // 📁 Local file
          : BetterPlayerDataSourceType.network, // 🌐 Network
      widget.url,
      liveStream: widget.isLive,
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 2000,
        maxBufferMs: 10000,
        bufferForPlaybackMs: 1000,
        bufferForPlaybackAfterRebufferMs: 2000,
      ),
    );

    _controller = BetterPlayerController(
      config,
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void didUpdateWidget(covariant BetterPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // url বা isLocal change হলে reload
    if (oldWidget.url != widget.url ||
        oldWidget.isLocal != widget.isLocal ||
        oldWidget.isLive != widget.isLive) {
      final newDataSource = BetterPlayerDataSource(
        widget.isLocal
            ? BetterPlayerDataSourceType.file
            : BetterPlayerDataSourceType.network,
        widget.url,
        liveStream: widget.isLive,
      );
      _controller.setupDataSource(newDataSource);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: BetterPlayer(controller: _controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

