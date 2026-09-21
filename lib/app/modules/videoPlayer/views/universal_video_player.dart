/*

import 'package:flutter/material.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/vimeo_player.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/web_view_player.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/youtube_player_lite.dart';
import 'package:ontorikkho/utils/util.dart';

import '../../../../utils/enums.dart';
import 'better_player.dart';


class UniversalVideoPlayer extends StatelessWidget {
  final SourceType sourceType;
  final String videoUrlOrId;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  const UniversalVideoPlayer({
    super.key,
    this.sourceType = SourceType.unknown,
    required this.videoUrlOrId,
    this.autoPlay = true,
    this.looping = false,
    this.aspectRatio = 16 / 9,
  });

  factory UniversalVideoPlayer.fromLink(
    String link, {
    Key? key,
    bool autoPlay = true,
    bool looping = false,
    double aspectRatio = 16 / 9,
  }) {
    final type = detectSourceType(link);
    return UniversalVideoPlayer(
      key: key,
      sourceType: type,
      videoUrlOrId: link,
      autoPlay: autoPlay,
      looping: looping,
      aspectRatio: aspectRatio,
    );
  }


  @override
  Widget build(BuildContext context) {
    switch (sourceType) {
      case SourceType.youtube:
        return YoutubePlayerLite(
          videoUrl: videoUrlOrId,
        );
      case SourceType.vimeo:
        return VimeoPlayerWidget(
          videoUrlOrId: videoUrlOrId,
          // aspectRatio: aspectRatio,
        );
      case SourceType.network:
      case SourceType.uploaded:
      case SourceType.liveTV:
        return BetterPlayerWidget(
          url: videoUrlOrId,
          aspectRatio: aspectRatio,
          autoPlay: autoPlay,
          looping: looping,
          isLive: sourceType == SourceType.liveTV,
        );
      case SourceType.unknown:
        return WebViewPlayerWidget(url: videoUrlOrId);
      case SourceType.image:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/vimeo_player.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/web_view_player.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/youtube_player_lite.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/util.dart';
import 'better_player.dart';

class UniversalVideoPlayer extends StatelessWidget {
  final VideoSourceType sourceType;
  final String videoUrlOrId;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final bool isLocalFile;

  const UniversalVideoPlayer({
    super.key,
    required this.sourceType,
    required this.videoUrlOrId,
    this.autoPlay = true,
    this.looping = false,
    this.aspectRatio = 16 / 9,
    this.isLocalFile = false,
  });

  /// 🌐 NETWORK / YOUTUBE / VIMEO
  factory UniversalVideoPlayer.fromLink(
      String link, {
        Key? key,
        bool autoPlay = true,
        bool looping = false,
        double aspectRatio = 16 / 9,
      }) {
    final type = detectSourceType(link);
    return UniversalVideoPlayer(
      key: key,
      sourceType: type,
      videoUrlOrId: link,
      autoPlay: autoPlay,
      looping: looping,
      aspectRatio: aspectRatio,
      isLocalFile: false,
    );
  }

  /// 📁 LOCAL FILE
  factory UniversalVideoPlayer.fromFile(
      File file, {
        Key? key,
        bool autoPlay = true,
        bool looping = false,
        double aspectRatio = 16 / 9,
      }) {
    return UniversalVideoPlayer(
      key: key,
      sourceType: VideoSourceType.uploaded,
      videoUrlOrId: file.path,
      autoPlay: autoPlay,
      looping: looping,
      aspectRatio: aspectRatio,
      isLocalFile: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (sourceType) {
      case VideoSourceType.youtube:
        return YoutubePlayerLite(videoUrl: videoUrlOrId);

      case VideoSourceType.vimeo:
        return VimeoPlayerWidget(videoUrlOrId: videoUrlOrId);

      case VideoSourceType.network:
      case VideoSourceType.uploaded:
      case VideoSourceType.liveTV:
        return BetterPlayerWidget(
          url: videoUrlOrId,
          aspectRatio: aspectRatio,
          autoPlay: autoPlay,
          looping: looping,
          isLive: sourceType == VideoSourceType.liveTV,
          isLocal: isLocalFile,
        );

      case VideoSourceType.unknown:
        return WebViewPlayerWidget(url: videoUrlOrId);

      case VideoSourceType.image:
        return const SizedBox.shrink();
    }
  }
}
