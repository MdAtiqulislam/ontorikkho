import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VimeoPlayerWidget extends StatelessWidget {
  final String videoUrlOrId;

  const VimeoPlayerWidget({super.key, required this.videoUrlOrId});

  String _buildVimeoEmbedUrl() {
    final regExp = RegExp(r'vimeo\.com/(?:video/)?(\d+)');
    final match = regExp.firstMatch(videoUrlOrId);
    final videoId = match?.group(1) ?? videoUrlOrId;

    return "https://player.vimeo.com/video/$videoId?autoplay=0&playsinline=1";
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(_buildVimeoEmbedUrl()),
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        iframeAllowFullscreen: true,
      ),
    );
  }
}
