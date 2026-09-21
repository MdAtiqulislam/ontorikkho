/*
import 'package:flutter/material.dart';
import '../../../videoPlayer/views/universal_video_player.dart';

class PostVideoContent extends StatelessWidget {
 final String url;

  const PostVideoContent({
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: UniversalVideoPlayer(videoUrlOrId: url));
  }
}
*/


/*import 'dart:io';
import 'package:flutter/material.dart';
import '../../../videoPlayer/views/universal_video_player.dart';

class PostVideoContent extends StatelessWidget {
  final String url;
  final bool isLocal;

  const PostVideoContent({
    super.key,
    required this.url,
    this.isLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: isLocal
          ? UniversalVideoPlayer.fromFile(
        File(url),
      )
          : UniversalVideoPlayer.fromLink(
        url,
      ),
    );
  }
}*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../videoPlayer/views/universal_video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class PostVideoContent extends StatefulWidget {
  final String url;
  final bool isLocal;
  final double? borderRadius;

  const PostVideoContent({
    super.key,
    required this.url,
    this.isLocal = false,
    this.borderRadius
  });

  @override
  State<PostVideoContent> createState() => _PostVideoContentState();
}

class _PostVideoContentState extends State<PostVideoContent> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: widget.isLocal ? widget.url : widget.url,
        imageFormat: ImageFormat.PNG,
        maxHeight: 250, // height of the thumbnail
        quality: 75,
      );

      if (uint8list != null && mounted) {
        setState(() {
          _thumbnail = uint8list;
        });
      }
    } catch (e) {
      debugPrint('Thumbnail generation error: $e');
    }
  }

  void _openVideoPlayer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: widget.isLocal
                ? UniversalVideoPlayer.fromFile(File(widget.url))
                : UniversalVideoPlayer.fromLink(widget.url),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openVideoPlayer,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius??AppDimensions.borderRadius.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.black12,
              child: _thumbnail != null
                  ? Image.memory(_thumbnail!, fit: BoxFit.cover)
                  : const Center(child: CircularProgressIndicator()),
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              size: 64,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
