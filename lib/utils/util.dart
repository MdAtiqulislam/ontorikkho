/*  ******Function to get http success status***** */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/modules/forYou/views/post_view/reaction_button.dart';
import '../app/modules/friends/models/button_config_model.dart';
import '../models/pagination_model.dart';
import 'enums.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';


bool isHttpStatusSuccess(int statusCode) {
  if (kDebugMode) {
    print(statusCode);
  }

  return statusCode >= 200 && statusCode < 300;
}

/*  ******Function to generate http error message***** */
String generateHttpErrorMessage(int errorCode) {
  switch (errorCode) {
    case 400:
      return "400 Bad Request: The server cannot process the request due to a client error.";
    case 401:
      return "401 Unauthorized: The request has not been applied because it lacks valid authentication credentials for the target resource.";
    case 403:
      return "403 Forbidden: The server understood the request but refuses to authorize it.";
    case 404:
      return "404 Not Found: The server cannot find the requested resource.";
    case 405:
      return "405 Method Not Allowed: The method specified in the request is not allowed for the resource identified by the request.";
    case 406:
      return "406 Not Acceptable: The server cannot produce a response matching the list of acceptable values.";
    case 408:
      return "408 Request Timeout: The server did not receive a complete request message within the time that it was prepared to wait.";
    case 409:
      return "409 Conflict: The request could not be completed due to a conflict with the current state of the target resource.";
    case 410:
      return "410 Gone: The requested resource is no longer available and will not be available again.";
    case 500:
      return "500 Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.";
    case 501:
      return "501 Not Implemented: The server does not support the functionality required to fulfill the request.";
    case 502:
      return "502 Bad Gateway: The server, while acting as a gateway or proxy, received an invalid response from an inbound server it accessed while attempting to fulfill the request.";
    case 503:
      return "503 Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.";
    case 504:
      return "504 Gateway Timeout: The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request.";
    case 505:
      return "505 HTTP Version Not Supported: The server does not support, or refuses to support, the HTTP protocol version that was used in the request message.";
    default:
      return "$errorCode: Unknown Error";
  }
}

void updateStatusBar() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Your desired color
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  });
}

String? getYoutubeThumbnail(String? youtubeLink) {
  if (youtubeLink == null || youtubeLink.isEmpty) return null;

  final uri = Uri.tryParse(youtubeLink);
  if (uri == null) return null;

  String? videoId;

  // 👉 youtu.be/VIDEO_ID
  if (uri.host.contains('youtu.be')) {
    videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }

  // 👉 youtube.com/watch?v=VIDEO_ID
  else if (uri.queryParameters.containsKey('v')) {
    videoId = uri.queryParameters['v'];
  }

  // 👉 youtube.com/embed/VIDEO_ID
  // 👉 youtube.com/shorts/VIDEO_ID
  else {
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      videoId = segments.last;
    }
  }

  if (videoId == null || videoId.isEmpty) return null;

  // maxres না পেলে youtube নিজে fallback করে
  return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
}


Color getColorFromName(String colorName) {
  final Map<String, Color> colorMap = {
    "white": Colors.white,
    "black": Colors.black,
    "red": Colors.red,
    "blue": Colors.blue,
    "green": Colors.green,
    "yellow": Colors.yellow,
    "orange": Colors.orange,
    "gray": Colors.grey,
  };

  // convert input to lowercase for safe matching
  return colorMap[colorName.toLowerCase()] ?? Colors.grey;
}

String formatMessages(dynamic message) {
  if (message is List) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < message.length; i++) {
      buffer.writeln("🔹 ${message[i]}");
    }
    return buffer.toString();
  } else if (message is String) {
    return "🔹 $message";
  } else {
    return "";
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'
      r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
      r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

/// Validator Helper
String? validateEmail(String? value) {
  if ((value ?? "").isEmpty) {
    return "Email is required";
  } else if (!(value!.isValidEmail())) {
    return "Email is not valid";
  }
  return null;
}

extension PassworrdValidator on String {
  bool isValidPassword() {
    return RegExp(
      (r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$'),
    ).hasMatch(this);
  }
}

String getMissingDocsMessage(int missingCount) {
  if (missingCount <= 0) {
    return "All required documents are uploaded.";
  }

  return missingCount == 1
      ? "1 missing document → You have 1 missing document. Please upload it to complete your profile."
      : "$missingCount missing documents → You have $missingCount missing documents. Please upload them to complete your profile.";
}

String sanitizePhone(String phone) {
  // সব whitespace, dash, bracket, dot, special char remove
  phone = phone.replaceAll(RegExp(r'[^0-9+]'), '');

  // শুধু 1st character এ + allow করবে, মাঝখানে + থাকলে remove করবে
  if (phone.startsWith('+')) {
    phone = '+${phone.substring(1).replaceAll('+', '')}';
  } else {
    phone = phone.replaceAll('+', '');
  }

  return phone;
}

String formatPhone(String phone) {
  if (phone.length >= 2) {
    return "**** **** ${phone.substring(phone.length - 2)}";
  }
  return phone;
}

/// Mask email: first 2 characters + **** + domain
String formatEmail(String email) {
  if (email.contains("@")) {
    final parts = email.split("@");
    final namePart = parts[0];
    final domain = parts[1];
    final firstTwo = namePart.length >= 2 ? namePart.substring(0, 2) : namePart;
    return "$firstTwo****@$domain";
  }
  return email;
}


final reactions = [
  ReactionItem(
    type: ReactionType.like,
    asset: 'assets/reactions/like.json',
    label: 'Like',
  ),
  ReactionItem(
    type: ReactionType.love,
    asset: 'assets/reactions/love.json',
    label: 'Love',
  ),
  ReactionItem(
    type: ReactionType.haha,
    asset: 'assets/reactions/haha.json',
    label: 'Haha',
  ),
  ReactionItem(
    type: ReactionType.wow,
    asset: 'assets/reactions/wow.json',
    label: 'Wow',
  ),
  ReactionItem(
    type: ReactionType.sad,
    asset: 'assets/reactions/sad.json',
    label: 'Sad',
  ),
  ReactionItem(
    type: ReactionType.angry,
    asset: 'assets/reactions/angry.json',
    label: 'Angry',
  ),
];




VideoSourceType detectSourceType(String url) {
  final lowerUrl = url.toLowerCase().trim();

  // YouTube
  final youtubeRegex = RegExp(r'(?:youtu\.be/|youtube\.com/(watch\?v=|embed/))([\w-]+)');
  if (youtubeRegex.hasMatch(lowerUrl)) return VideoSourceType.youtube;

  // Vimeo
  final vimeoRegex = RegExp(r'vimeo\.com/(?:video/)?\d+');
  if (vimeoRegex.hasMatch(lowerUrl)) return VideoSourceType.vimeo;

  // Live TV / HLS
  final liveRegex = RegExp(r'.*\.m3u8$|.*live.*');
  if (liveRegex.hasMatch(lowerUrl)) return VideoSourceType.liveTV;

  // Uploaded / CDN video
  final videoRegex = RegExp(r'.*\.mp4$|.*cdn.*|.*stream.*|^file://');
  if (videoRegex.hasMatch(lowerUrl)) return VideoSourceType.uploaded;

  // Image detection
  final imageRegex = RegExp(r'.*\.(jpg|jpeg|png|webp|gif)$');
  if (imageRegex.hasMatch(lowerUrl)) return VideoSourceType.image;

  return VideoSourceType.unknown;
}

/// Returns the first URL found in the text, or null if none
String? extractFirstLink(String text) {
  if (text.isEmpty) return null;

  final urlRegex = RegExp(
    r'(https?:\/\/[^\s]+)',
    caseSensitive: false,
  );

  final match = urlRegex.firstMatch(text);
  return match?.group(0);
}





/// Returns the local thumbnail path for a video file
Future<String?> getVideoThumbnail(String videoPath) async {
  try {
    final tempDir = await getTemporaryDirectory();

    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of thumbnail
      quality: 75,
    );

    return thumbPath;
  } catch (e) {
    print("Error generating thumbnail: $e");
    return null;
  }
}

String? buildNextPageUrl({
  required Pagination page,
  required String baseUrl,
})
{
  /// ❌ stop if last page reached
  if (page.currentPage != null &&
      page.lastPage != null &&
      page.currentPage! >= page.lastPage!) {
    return null;
  }

  /// ✅ backend provided next url
  if (page.nextPageUrl != null && page.nextPageUrl!.isNotEmpty) {
    return page.nextPageUrl;
  }

  /// ✅ fallback manual page
  final nextPage = (page.currentPage ?? 0) + 1;

  return "$baseUrl?page=$nextPage";
}

