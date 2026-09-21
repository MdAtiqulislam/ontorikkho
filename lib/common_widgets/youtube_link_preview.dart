import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/util.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeLinkPreview extends StatefulWidget {
  final String url;

  const YoutubeLinkPreview({super.key, required this.url});

  @override
  State<YoutubeLinkPreview> createState() => _YoutubeLinkPreviewState();
}

class _YoutubeLinkPreviewState extends State<YoutubeLinkPreview> {
  String? title;
  String? channel;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final uri = Uri.parse(
        'https://www.youtube.com/oembed?url=${widget.url}&format=json',
      );

      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        setState(() {
          title = json['title'];
          channel = json['author_name'];
          loading = false;
        });
      }
    } catch (_) {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
       return GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.url)),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Thumbnail
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomNetworkImage(image: getYoutubeThumbnail(widget.url??"")??""),
                  const Icon(Icons.play_circle_fill,
                      size: 64, color: Colors.white),
                ],
              ),
            ),

            /// Text area
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
                  Text("youtube.com"),
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
      ),
    );
  }

}
