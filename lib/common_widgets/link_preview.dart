import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/util.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatefulWidget {
  final String url;

  const LinkPreview({super.key, required this.url});

  @override
  State<LinkPreview> createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  bool loading = false;
  String? title;
  String? channel;

  bool get isYouTube =>
      RegExp(r'(youtube\.com|youtu\.be)', caseSensitive: false)
          .hasMatch(widget.url);

  @override
  void initState() {
    super.initState();
    if (isYouTube) _loadYoutubeMeta();
  }

  Future<void> _loadYoutubeMeta() async {
    setState(() => loading = true);
    try {
      final uri = Uri.parse(
        'https://www.youtube.com/oembed?url=${widget.url}&format=json',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        setState(() {
          title = jsonData['title'];
          channel = jsonData['author_name'];
        });
      }
    } catch (_) {
      // ignore errors
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.url)),
      child: isYouTube ? _buildYouTubePreview() : _buildWebPreview(),
    );
  }

  /// YouTube preview
  Widget _buildYouTubePreview() {
    final thumbnail = getYoutubeThumbnail(widget.url) ?? "";

    return Container(
    //  margin: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomNetworkImage(image: thumbnail),
                const Icon(Icons.play_circle_fill,
                    size: 64, color: Colors.white),
              ],
            ),
          ),
          // Text info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: loading
                ? const SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("youtube.com"),
                Text(
                  title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  channel ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Normal web preview
  Widget _buildWebPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.link),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.url,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}