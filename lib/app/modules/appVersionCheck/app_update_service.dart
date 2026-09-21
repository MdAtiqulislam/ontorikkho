
import 'package:flutter/foundation.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';

import 'app_config_model.dart';


class AppUpdateService {
  static Future<AppConfigModel?> getConfig() async {
    var endpoint=APIEndPoints.versionCheck;

    try {
      final res = await RemoteServices.getRequest(endpoint: endpoint);

      if (res!=null) {
        return AppConfigModel.fromJson(res);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Config fetch error: $e");
      }
    }
    return null;
  }
}
