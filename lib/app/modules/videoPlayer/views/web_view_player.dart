import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPlayerWidget extends StatefulWidget {
  final String url;

  const WebViewPlayerWidget({super.key, required this.url});

  @override
  State<WebViewPlayerWidget> createState() => _WebViewPlayerWidgetState();
}

class _WebViewPlayerWidgetState extends State<WebViewPlayerWidget> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.url),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            iframeAllowFullscreen: true,
          ),
          onLoadStop: (_, __) {
            setState(() => _isLoaded = true);
          },
        ),
        if (!_isLoaded)
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
      ],
    );
  }
}
