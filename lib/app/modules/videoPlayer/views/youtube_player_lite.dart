import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:visibility_detector/visibility_detector.dart';

class YoutubePlayerLite extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerLite({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerLite> createState() => _YoutubePlayerLiteState();
}

class _YoutubePlayerLiteState extends State<YoutubePlayerLite>
    with AutomaticKeepAliveClientMixin {

  InAppWebViewController? _controller;
  bool _isReady = false;
  bool _isVisible = false;

  String get _videoId {
    final reg = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11})");
    return reg.firstMatch(widget.videoUrl)?.group(1) ?? "";
  }

  String get _html => '''
<!DOCTYPE html>
<html>
<body style="margin:0">
<div id="player"></div>

<script>
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
document.body.appendChild(tag);

var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    videoId: '$_videoId',
    playerVars: {
      playsinline: 1,
      controls: 1,
      mute: 1
    },
    events: {
      onReady: function() {
        window.flutter_inappwebview.callHandler('ready');
      }
    }
  });
}

function playVideo(){ player && player.playVideo(); }
function pauseVideo(){ player && player.pauseVideo(); }
</script>
</body>
</html>
''';

  void _play() {
    if (_isReady) {
      _controller?.evaluateJavascript(source: "playVideo();");
    }
  }

  void _pause() {
    if (_isReady) {
      _controller?.evaluateJavascript(source: "pauseVideo();");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0.7;
        if (visible != _isVisible) {
          _isVisible = visible;
          visible ? _play() : _pause();
        }
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: InAppWebView(
          initialData: InAppWebViewInitialData(data: _html),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowsInlineMediaPlayback: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          onWebViewCreated: (c) => _controller = c,
          onLoadStop: (_, __) {
            _controller?.addJavaScriptHandler(
              handlerName: 'ready',
              callback: (_) {
                _isReady = true;
                if (_isVisible) _play();
              },
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
