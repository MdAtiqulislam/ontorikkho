/*


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sa_officer/controllers/web_page_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServices.instance.setupFlutterNotificaions();
  await NotificationServices.instance.showNotification(message);
}

class NotificationServices {
  NotificationServices._();
  static final NotificationServices instance = NotificationServices._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocationNotificationsInitialized = false;

  final RxString newUrl = "".obs; // ✅ Observable to store new URL
  final RxString jsFunctionName = "".obs; // ✅ Observable for function name
  final RxString jsParameter = "".obs; // ✅ Observable for function parameter


  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPersmission();
    await setupFlutterNotificaions();
    await _setupMessageHandlers();

    final token = await _messaging.getToken();
    print('FCM Token: $token');

    subscribeToTopic('all_devices');
  }

  Future<void> _requestPersmission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotificaions() async {
    if (_isFlutterLocationNotificationsInitialized) {
      return;
    }

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    final initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    _isFlutterLocationNotificationsInitialized = true;
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    print(message.toMap().toString());

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    String? url = message.data['url']; // ✅ Extract URL from notification data
    print(url);
    jsFunctionName.value=message.data["function"];

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            icon: '@mipmap/launcher_icon',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: url, // ✅ Pass the URL as payload
      );
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data.containsKey('url')) {
      newUrl.value = message.data['url']; // ✅ Update the new URL
      jsFunctionName.value=message.data['function'];
      jsParameter.value=message.data['id'];
    }
  }

  void _handleNotificationClick(String? payload) {
    
    print(">>>>>>>>>>>>>>>");
    Get.put(WebPageController()).loadData(jsFunctionName.value);

    if (payload != null && payload.isNotEmpty) {
      print(payload);


      newUrl.value = payload; // ✅ Update URL when clicking notification
      //jsFunctionName.value=message.data['function'];
    //  jsParameter.value=message.data['id'];
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print("FCM Token: $token");
    }
    return token!;
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribed to $topic');
  }
}
*/



/*
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sa_officer/app/routes/app_pages.dart';

import '../app/modules/webPageView/controllers/web_page_view_controller.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  static Timer? soundTimer;

  static int notificationCount = 0;
  static bool isCallEnded = false; // Add a flag to manage call state

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User granted permission");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  static void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("response: $response");
          handleForegroundNotification(context,response,message);
      },
    );
  }

  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {

      showNotificationWithoutContext(message);
      //handleMessageClick(context, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("message.data:${message.data}");

    });

  }



  static Future<void> showNotificationWithoutContext(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound

    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
      styleInformation: InboxStyleInformation(
        [], // Add the messages here
        contentTitle: 'You have ${notificationCount + 1} new messages',
        summaryText: 'New messages',
      ),
      icon: '@mipmap/ic_launcher',
    );

    DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: notificationCount + 1,
      // sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['requestId'],
    );

    notificationCount++;
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (kDebugMode) {
      print("FCM Token:$token");
    }
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {

    print("Message clicked....");

    if (message.data['function']!=null) {
      Get.put(WebPageViewController());
      Get.find<WebPageViewController>().loadData(message.data['function']);
      Get.toNamed(Routes.WEB_PAGE_VIEW);
    }
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data.isNotEmpty) {
        handleMessageClick(context, initialMessage);
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  static Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void handleForegroundNotification(BuildContext context, NotificationResponse response,RemoteMessage message) async {
    print("requestId:${response.payload}");

      Get.find<WebPageViewController>().loadData(message.data["function"]);
      Get.toNamed(Routes.WEB_PAGE_VIEW);

  }

}
*/


//working code...

/*import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sa_officer/app/routes/app_pages.dart';
import '../app/modules/webPageView/controllers/web_page_view_controller.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  static Timer? soundTimer;
  static int notificationCount = 0;

  /// 🔹 **Request Notification Permissions**
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) print("✅ User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) print("✅ User granted provisional permission");
    } else {
      if (kDebugMode) print("❌ User denied permission");
    }
  }

  /// 🔹 **Initialize Local Notifications**
  static void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("🔔 Notification clicked: ${response.payload}");
        handleMessageClick(context, response.payload);
      },
    );
  }

  /// 🔹 **Create Notification Channel**
  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 🔹 **Firebase Message Listeners**
  static Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 New message received in foreground: ${message.data}");
      showNotificationWithoutContext(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Notification clicked (background): ${message.data}");
      handleMessageClick(context, message.data['function']);
    });
  }

  /// 🔹 **Show Local Notification**
  static Future<void> showNotificationWithoutContext(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
      styleInformation: InboxStyleInformation(
        [],
        contentTitle: 'You have ${notificationCount + 1} new messages',
        summaryText: 'New messages',
      ),
      icon: '@mipmap/ic_launcher',
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['function'], // ✅ Pass data for navigation
    );

    notificationCount++;
  }

  /// 🔹 **Handle Notification Click**
  static Future<void> handleMessageClick(BuildContext context, String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      print("📩 Navigating to: $payload");
      Get.put(WebPageViewController());
      Get.find<WebPageViewController>().loadData(payload);
      Get.toNamed(Routes.WEB_PAGE_VIEW);
    } else {
      print("❌ No payload data found for navigation");
    }
  }

  /// 🔹 **Get FCM Token**
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (kDebugMode) print("🔑 FCM Token: $token");
    return token!;
  }

  /// 🔹 **Handle Messages When App is Killed (Terminated)**
  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      handleMessageClick(context, initialMessage.data['function']);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessageClick(context, message.data['function']);
    });
  }

  /// 🔹 **Handle Foreground Notification Click**
  static void handleForegroundNotification(BuildContext context, NotificationResponse response) async {
    print("🔔 Foreground notification clicked: ${response.payload}");
    handleMessageClick(context, response.payload);
  }

  /// 🔹 **Set Foreground Notification Presentation Options**
  static Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}*/


/*import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../app/modules/webPageView/controllers/web_page_view_controller.dart';
import '../app/routes/app_pages.dart';
class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    if (kDebugMode) print("Subscribed to topic: $topic");
  }

  /// Request permission (Android skip)
  Future<void> requestPermission() async {
    if (Platform.isAndroid) return; // skip Android
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (kDebugMode) print("Permission: ${settings.authorizationStatus}");
  }

  /// Initialize local notification
  Future<void> initLocalNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.high,
      playSound: true,
    );

    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        if ((payload.payload ?? "").isNotEmpty) {
          _handleTap(payload.payload);
        }
      },
    );
  }

  /// Public method to show notification (foreground & background)
  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      details,
      payload: message.data["function"], // function name on tap
    );
  }

  /// Handle notification tap
  void _handleTap(String? functionName) {
    if (functionName == null || functionName.isEmpty) return;

    if (!Get.isRegistered<WebPageViewController>()) {
      Get.put(WebPageViewController());
    }

    final controller = Get.find<WebPageViewController>();
    controller.loadData(functionName);
    Get.toNamed(Routes.WEB_PAGE_VIEW);
  }

  /// Setup FCM listeners
  Future<void> setupFirebaseMessaging() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) print("🔔 Foreground FCM: ${message.data}");
      await showNotification(message);
    });

    // When notification is tapped (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) print("🔔 Notification tap: ${message.data}");
      _handleTap(message.data["function"]);
    });

    // App launched via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      _handleTap(initialMessage.data["function"]);
    }
  }

  /// Get FCM device token
  Future<String?> getDeviceToken() async {
    final token = await _messaging.getToken();
    if (kDebugMode) print("FCM Token: $token");
    return token;
  }
}*/


/*import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../app/modules/webPageView/controllers/web_page_view_controller.dart';
import '../app/routes/app_pages.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    if (kDebugMode) print("Subscribed to topic: $topic");
  }

  /// Request permission (skip Android)
  Future<void> requestPermission() async {
    if (Platform.isAndroid) return;
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (kDebugMode) print("Permission: ${settings.authorizationStatus}");
  }

  /// Initialize local notifications (for foreground)
  Future<void> initLocalNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.high,
      playSound: true,
    );

    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
    }

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        if ((payload.payload ?? "").isNotEmpty) {
          _handleTap(payload.payload);
        }
      },
    );
  }


  Future<void> showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    if (kDebugMode) {
      print(message.toMap().toString());
    }

    String? imageUrl;
    if (message.notification?.android?.imageUrl != null) {
      imageUrl = message.notification!.android!.imageUrl;
    } else if (message.notification?.apple?.imageUrl != null) {
      imageUrl = message.notification!.apple!.imageUrl;
    }

    print(imageUrl);

    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Download the image first
      final String localPath = await _downloadAndSaveImage(imageUrl, 'notification_image.jpg');

      final bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(localPath), // now it's a local file
        contentTitle: notification.title,
        summaryText: notification.body,
      );

      androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        styleInformation: bigPictureStyle,
      );
    } else {
      androidDetails = const AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );
    }

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      details,
      payload: message.data["function"],
    );
  }

// Helper function to download image
  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }



  /// Handle notification tap
  void _handleTap(String? functionName) {
    if (functionName == null || functionName.isEmpty) return;

    if (!Get.isRegistered<WebPageViewController>()) {
      Get.put(WebPageViewController());
    }

    final controller = Get.find<WebPageViewController>();
    controller.loadData(functionName);
    Get.toNamed(Routes.WEB_PAGE_VIEW);
  }

  /// Setup FCM
  Future<void> setupFirebaseMessaging() async {
    // Foreground: show local notification
    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) print("🔔 Foreground FCM: ${message.data}");
      await showForegroundNotification(message);
    });

    // Background / killed: handled by system notification automatically
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) print("🔔 Notification tap: ${message.data}");
      _handleTap(message.data["function"]);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      _handleTap(initialMessage.data["function"]);
    }
  }

  /// Get device token
  Future<String?> getDeviceToken() async {
    final token = await _messaging.getToken();
    if (kDebugMode) print("FCM Token: $token");
    return token;
  }
}*/


import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// 🔔 Background handler (MUST be top-level)
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('🔔 Background FCM: ${message.messageId}');
  }
}

class NotificationServices {
  NotificationServices._();
  static final NotificationServices instance = NotificationServices._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// 🔑 Notification Channel
  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.high,
    playSound: true,
  );

  /* ------------------------------------------------------------ */
  /* INIT */
  /* ------------------------------------------------------------ */

  Future<void> init() async {
    await requestPermission();
    await initLocalNotification();
    await setupFirebaseMessaging();
  }

  /* ------------------------------------------------------------ */
  /* PERMISSION */
  /* ------------------------------------------------------------ */

  Future<void> requestPermission() async {
    // iOS
    if (Platform.isIOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print('🔐 iOS Permission: ${settings.authorizationStatus}');
      }
    }

    // Android 13+
    if (Platform.isAndroid) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print('🤖 Android Permission: ${settings.authorizationStatus}');
      }
    }
  }


  /* ------------------------------------------------------------ */
  /* LOCAL NOTIFICATION INIT */
  /* ------------------------------------------------------------ */

  Future<void> initLocalNotification() async {
    const androidInit =
    AndroidInitializationSettings('@drawable/ic_stat_notification');
    //AndroidInitializationSettings('@mipmap/ic_notification');

    const iosInit = DarwinInitializationSettings();

    const initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleTap(details.payload);
      },
    );

    // Create channel
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  /* ------------------------------------------------------------ */
  /* FCM LISTENERS */
  /* ------------------------------------------------------------ */

  Future<void> setupFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        print('🔔 Foreground FCM: ${message.data}');
      }
      await showForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('🔔 Notification tapped: ${message.data}');
      }
      _handleTap(message.data['function']);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      _handleTap(initialMessage.data['function']);
    }
  }

  /* ------------------------------------------------------------ */
  /* SHOW FOREGROUND NOTIFICATION */
  /* ------------------------------------------------------------ */

  Future<void> showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final String? imageUrl =
        notification.android?.imageUrl ?? notification.apple?.imageUrl;

    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final localPath =
      await _downloadAndSaveImage(imageUrl, 'notif_${_randomId()}.jpg');

      if (localPath.isNotEmpty) {
        androidDetails = AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigPictureStyleInformation(
            FilePathAndroidBitmap(localPath),
            contentTitle: notification.title,
            summaryText: notification.body,
          ),
        );
      } else {
        androidDetails = _defaultAndroidDetails();
      }
    } else {
      androidDetails = _defaultAndroidDetails();
    }

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      _randomId(),
      notification.title,
      notification.body,
      details,
      payload: message.data['function'],
    );
  }

  /* ------------------------------------------------------------ */
  /* HELPERS */
  /* ------------------------------------------------------------ */

  AndroidNotificationDetails _defaultAndroidDetails() {
    return AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
  }

  int _randomId() => Random().nextInt(100000);

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return '';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (_) {
      return '';
    }
  }

  /* ------------------------------------------------------------ */
  /* TAP HANDLER */
  /* ------------------------------------------------------------ */

  void _handleTap(String? functionName) {
    if (functionName == null || functionName.isEmpty) return;

    if (kDebugMode) {
      print('👉 Notification action: $functionName');
    }

    switch (functionName) {
      case 'open_profile':
      // Get.toNamed(Routes.PROFILE);
        break;

      case 'open_video':
      // Get.toNamed(Routes.VIDEO_DETAILS);
        break;

      default:
        if (kDebugMode) {
          print('⚠️ Unknown notification function');
        }
    }
  }

  /* ------------------------------------------------------------ */
  /* TOKEN & TOPIC */
  /* ------------------------------------------------------------ */

  Future<String?> getDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      if (kDebugMode) print('📱 FCM Token: $token');
      return token;
    } catch (_) {
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) print('✅ Subscribed to $topic');
    } catch (e) {
      if (kDebugMode) print('❌ Topic error: $e');
    }
  }
}


