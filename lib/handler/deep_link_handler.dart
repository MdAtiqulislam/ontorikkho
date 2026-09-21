import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';
import '../services/local_services.dart';

class DeepLinkHandler {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<String>? _sub;
  static String? globalReferral;

  static Future<void> init() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) _handleLink(uri.toString());
    } catch (e) {
      print("Error getting initial link: $e");
    }

    _sub = _appLinks.stringLinkStream.listen(
          (link) => _handleLink(link),
      onError: (err) => print("Deep link stream error: $err"),
    );
  }

  static void dispose() {
    _sub?.cancel();
  }

  static void _handleLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;

    print("🔗 Deep Link Received: $link");

    // Only store referral if not handled yet
   // bool handled = await LocalServices.isReferralHandled();
   // if (handled) return;

    if (uri.queryParameters.containsKey("ref")) {
      globalReferral = uri.queryParameters["ref"];
      await LocalServices.storeReferral(globalReferral!);
      print("🎉 Referral stored: $globalReferral");
    }

    await LocalServices.markReferralHandled();

    // Navigation handled by SplashScreen later
  }
}
