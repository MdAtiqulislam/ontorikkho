/*

import 'dart:io';
import 'package:flutter/material.dart';
import 'post_video_content.dart';
import 'weblink_preview.dart';
import 'youtube_link_preview.dart';

class MediaPreview extends StatelessWidget {
  final String? mediaUrl;
  final File? mediaFile;

  const MediaPreview({
    super.key,
    this.mediaUrl,
    this.mediaFile,
  }) : assert(
  mediaUrl != null || mediaFile != null,
  'Either mediaUrl or mediaFile must be provided',
  );

  @override
  Widget build(BuildContext context) {
    final mediaType = _detectMediaType();

    switch (mediaType) {

    /// 🖼 IMAGE
      case MediaType.image:
        return _imagePreview();

    /// 🎥 VIDEO
      case MediaType.video:
        return _videoPreview();

    /// ▶️ YOUTUBE
      case MediaType.youtube:
        return YoutubeLinkPreview(url: mediaUrl!);

    /// 📄 PDF
      case MediaType.pdf:
        return _pdfPreview();

    /// 🌐 WEB LINK
      case MediaType.web:
        return WebLinkPreview(url: mediaUrl!);

      default:
        return const SizedBox.shrink();
    }
  }

  // ================= HELPERS =================

  MediaType _detectMediaType() {
    final source = mediaFile?.path ?? mediaUrl ?? '';
    final u = source.toLowerCase();

    if (u.contains('youtube.com') || u.contains('youtu.be')) {
      return MediaType.youtube;
    } else if (u.endsWith('.mp4') || u.endsWith('.mkv')) {
      return MediaType.video;
    } else if (u.endsWith('.jpg') ||
        u.endsWith('.jpeg') ||
        u.endsWith('.png')) {
      return MediaType.image;
    } else if (u.endsWith('.pdf')) {
      return MediaType.pdf;
    } else if (mediaUrl != null) {
      return MediaType.web;
    } else {
      return MediaType.none;
    }
  }

  Widget _imagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 160,
          maxHeight: 320,
        ),
        child: mediaFile != null
            ? Image.file(
          mediaFile!,
          width: double.infinity,
          fit: BoxFit.cover,
        )
            : Image.network(
          mediaUrl!,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _videoPreview() {
    return PostVideoContent(
      url: mediaFile?.path ?? mediaUrl!,
      isLocal: mediaFile != null,
    );
  }

  Widget _pdfPreview() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mediaFile?.path.split('/').last ??
                  mediaUrl!.split('/').last,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
enum MediaType {
  image,
  video,
  youtube,
  pdf,
  web,
  none,
}
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_video_content.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/weblink_preview.dart';
import 'package:ontorikkho/common_widgets/youtube_link_preview.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

/*
class MediaPreview extends StatelessWidget {
  final Media media;

  const MediaPreview({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    switch (media.type?.toLowerCase()) {
      case 'image':
        return _imagePreview();

      case 'video':
        return PostVideoContent(
          url: media.url??"",
          isLocal: false,
        );

      case 'youtube':
        return YoutubeLinkPreview(url: media.url??"");

      case 'pdf':
        return _pdfPreview();

      default:
        return WebLinkPreview(url: media.url??"");
    }
  }

  Widget _imagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 160,
          maxHeight: 320,
        ),
        child: Image.network(
          media.url??"",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _pdfPreview() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              media.url??"".split('/').last,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}*/


class MediaPreview extends StatelessWidget {
  final Media media;
  final VoidCallback? onRemove;

  const MediaPreview({super.key, required this.media, this.onRemove});

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (media.type?.toLowerCase()) {
      case 'image':
        content = _imagePreview();
        break;

      case 'video':
        content = PostVideoContent(
          url: media.url ?? "",
          isLocal: media.isLocal ?? false,
        );
        break;

      case 'youtube':
        content = YoutubeLinkPreview(url: media.url ?? "");
        break;

      case 'pdf':
        content = _pdfPreview();
        break;

      default:
        content = WebLinkPreview(url: media.url ?? "");
    }

    // Wrap with remove icon if onRemove exists
    if (onRemove != null) {
      return Stack(
        children: [
          content,
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return content;
    }
  }

  Widget _imagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 160,
          maxHeight: 320,
        ),
        child: media.isLocal == true
            ? Image.file(
          File(media.url ?? ""),
          width: double.infinity,
          fit: BoxFit.cover,
        )
            : CustomNetworkImage(
            image: media.url ?? "",
          width: double.infinity,
          fit: BoxFit.cover,
          localImage:"assets/icons/no_image.png" ,
        ),
      ),
    );
  }

  Widget _pdfPreview() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              (media.url ?? "").split('/').last,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ],
        ],
      ),
    );
  }
}
