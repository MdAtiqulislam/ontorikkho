
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/comment_controller.dart';
import 'package:ontorikkho/app/modules/friends/controllers/friends_controller.dart';
import 'package:ontorikkho/services/my_pages_service.dart';
import 'package:ontorikkho/services/notification_service.dart';
import 'package:ontorikkho/stores/friends_store.dart';
import 'package:ontorikkho/stores/post_store.dart';
import 'package:ontorikkho/theme/theme.dart';
import 'app/modules/cart/models/cart_item_model.dart';
import 'app/modules/forYou/controllers/reaction_manager.dart';
import 'app/modules/notifications/controllers/notifications_controller.dart';
import 'app/routes/app_pages.dart';
import 'handler/deep_link_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(
    options: (Platform.isIOS || Platform.isMacOS)
        ? const FirebaseOptions(
      apiKey: "AIzaSyAZaZjkPjAiYtHClcW61tSFa8pliszzh7o",
      appId: "1:174086628924:ios:5ad4260d24f34d262d8539",
      messagingSenderId: "174086628924",
      projectId: "themall-361715",
    )
        : const FirebaseOptions(
      apiKey: 'AIzaSyDv79ZdI2rTM95uZedSrQuq9zhDTaFXY_E',
      appId: '1:979394384810:android:ac99ab86c7a299849411d3',
      messagingSenderId: '979394384810',
      projectId: 'ontorikkho-d658c',
      storageBucket: 'ontorikkho-d658c.firebasestorage.app',
    ),
  );
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  Get.put(NotificationsController(), permanent: true);
  Get.put(PostStore(), permanent: true);
  Get.put(FriendStore(), permanent: true);
  Get.put(ReactionManager(), permanent: true);
  Get.put(CommentsController(), permanent: true);
  Get.put(FriendsController(), permanent: true);
  Get.put(MyPageService(), permanent: true);


  await NotificationServices.instance.init();

  NotificationServices.instance.getDeviceToken();
  NotificationServices.instance.subscribeToTopic("general_push_notification");

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>('cartBox');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());

  /// IMPORTANT FIX — DeepLink init AFTER Flutter fully has navigator key
  WidgetsBinding.instance.addPostFrameCallback((_) {
    DeepLinkHandler.init();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale("en", "US"),
          fallbackLocale: const Locale("en", "US"),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: CustomTheme.lightTheme,
          builder: (context, widget) {
            widget = EasyLoading.init()(context, widget);
            return widget;
          },
        );
      },
    );
  }
}

