import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../common_widgets/custom_snackbar.dart';
import '../services/local_services.dart';

var isDownloading = false.obs;
var downloadProgress = 0.0.obs;

Future<void> downloadFile({required String fileUrl}) async {
  if (fileUrl.isEmpty) {
    Get.snackbar("Error", "File URL is empty");
    return;
  }

  try {
    isDownloading.value = true;
    downloadProgress.value = 0.0;
    EasyLoading.show(status: 'Downloading...');

    Directory? downloadsDir = await getDownloadDirectory();
    if (downloadsDir == null) throw Exception("Download directory not accessible");

    // Token (if needed)
    String? token = await LocalServices.getToken();

    // Request
    var response = await http.get(
      Uri.parse(fileUrl),
      headers: {
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
        "User-Agent": "Mozilla/5.0",
      },
    );

    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw Exception("Download failed with status: ${response.statusCode}");
    }

    // Get filename from URL or headers
    String fileName = Uri.parse(fileUrl).pathSegments.last.split("?").first;

    // Try to guess extension if not found
    if (!fileName.contains('.')) {
      String? contentType = response.headers['content-type'];
      String guessedExt = _guessExtension(contentType);
      fileName += guessedExt;
    }

    // Clean filename
    fileName = fileName.replaceAll(RegExp(r'[^\w\s.-]'), '_');

    // Full path
    String savePath = '${downloadsDir.path}/$fileName';
    File file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);

    isDownloading.value = false;
    EasyLoading.dismiss();

    bool? openFileDialog = await Get.dialog(
      AlertDialog(
        title: Text("Download Complete"),
        content: Text("Do you want to open the file?"),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text("No")),
          TextButton(onPressed: () => Get.back(result: true), child: Text("Yes")),
        ],
      ),
    );

    if (openFileDialog == true) {
      OpenFile.open(savePath);
    } else {
      CustomSnackBar(
        title: "File Saved",
        msg: "You can find it in: $savePath",
        isSuccess: true,
      ).showSnackBar();
    }
  } catch (e) {
    isDownloading.value = false;
    EasyLoading.dismiss();
    print(e);
    CustomSnackBar(
      title: "Download Failed",
      msg: "Error: $e",
      isSuccess: false,
      duration: 5
    ).showSnackBar();
  }
}

Future<Directory?> getDownloadDirectory() async {
  if (Platform.isAndroid) {
    final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    final customFolderPath = '$downloadsPath/Ontorikkho';
    final customFolder = Directory(customFolderPath);

    if (!await customFolder.exists()) {
      await customFolder.create(recursive: true);
    }

    return customFolder;
  } else if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  }
  return null;
}

String _guessExtension(String? contentType) {
  if (contentType == null) return '.bin';

  final map = {
    'application/pdf': '.pdf',
    'application/msword': '.doc',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document': '.docx',
    'application/vnd.ms-excel': '.xls',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': '.xlsx',
    'application/zip': '.zip',
    'image/jpeg': '.jpg',
    'image/png': '.png',
    'video/mp4': '.mp4',
    'text/plain': '.txt',
  };

  return map[contentType.toLowerCase()] ?? '.bin';
}

/*

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


var isDownloading = false.obs;
var downloadProgress = 0.0.obs;

Future<void> downloadFile({required String fileUrl}) async {
  if (fileUrl.isEmpty) {
    Get.snackbar("Error", "File URL is empty");
    return;
  }

  try {
    isDownloading.value = true;
    downloadProgress.value = 0.0;
    EasyLoading.show(status: 'Downloading...');

    // Permission (Only for Android)
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) throw Exception("Storage permission denied");
    }

    // Get folder path
    final Directory downloadsDir = await _getDownloadsDirectory();

    // File name
    String fileName = Uri.parse(fileUrl).pathSegments.last.split("?").first;
    if (!fileName.contains(".")) fileName += ".bin"; // fallback extension

    fileName = fileName.replaceAll(RegExp(r'[^\w\s.-]'), '_');
    final String fullPath = "${downloadsDir.path}/$fileName";

    // Get file
    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw Exception("Failed to download file. Code: ${response.statusCode}");
    }

    // Save file
    final File file = File(fullPath);
    await file.writeAsBytes(response.bodyBytes);

    isDownloading.value = false;
    EasyLoading.dismiss();

    bool? openFileDialog = await Get.dialog(
      AlertDialog(
        title: Text("Download Complete"),
        content: Text("Do you want to open the file?"),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text("No")),
          TextButton(onPressed: () => Get.back(result: true), child: Text("Yes")),
        ],
      ),
    );

    if (openFileDialog == true) {
      OpenFile.open(fullPath);
    } else {
      Get.snackbar("File Saved", "Location: $fullPath", snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    isDownloading.value = false;
    EasyLoading.dismiss();
    Get.snackbar("Download Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}

Future<Directory> _getDownloadsDirectory() async {
  if (Platform.isAndroid) {
    Directory? baseDir = await getExternalStorageDirectory();
    final customDir = Directory("${baseDir!.parent.parent.parent.parent.path}/Download/YourAppFolder");

    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    return customDir;
  } else {
    return await getApplicationDocumentsDirectory();
  }
}
*/
