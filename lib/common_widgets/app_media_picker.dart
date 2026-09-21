import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';

class AppMediaPicker {
  /// Picks photos & videos (with camera) and returns List<XFile>
  /// Handles permission safely for Android 13+ and iOS
  static Future<List<XFile>> pickMedia(BuildContext context,
      {int maxAssets = 10}) async {
    try {
      // 1️⃣ Permission check
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) {
        // Open app settings if denied
        await PhotoManager.openSetting();
        debugPrint('AppMediaPicker: Permission denied');
        return [];
      }

      // 2️⃣ Pick assets
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: RequestType.common, // images + videos
          maxAssets: maxAssets,
          themeColor: Colors.blue,
        ),
      );

      if (assets == null || assets.isEmpty) return [];

      // 3️⃣ Convert to XFile
      final List<XFile> files = [];
      for (final asset in assets) {
        final file = await asset.file;
        if (file != null) files.add(XFile(file.path));
      }

      return files;
    } catch (e) {
      debugPrint('AppMediaPicker error: $e');
      return [];
    }
  }
}
