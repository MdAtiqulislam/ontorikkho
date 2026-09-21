// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar_controller.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/app/modules/home/views/home_view.dart';
import 'package:ontorikkho/app/modules/notifications/controllers/notifications_controller.dart';

class _FakeHomeController extends HomeController {
  @override
  Future<void> onInit() async {}
}

class _FakeNotificationsController extends NotificationsController {
  @override
  Future<void> getNotifications() async {}

  @override
  void onReady() {}
}

class _FakeBottomNavigationController extends CustomBottomNavigationController {
  @override
  Future<void> onInit() async {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<HomeController>(_FakeHomeController());
    Get.put<NotificationsController>(_FakeNotificationsController());
    Get.put<CustomBottomNavigationController>(
      _FakeBottomNavigationController(),
    );
  });

  tearDown(Get.reset);

  testWidgets('Home screen renders its primary sections', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => GetMaterialApp(home: HomeView()),
      ),
    );
    await tester.pump();

    expect(find.text('WELCOME'), findsOneWidget);
    expect(find.text('Invite Friends'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Announcements'), findsOneWidget);
  });
}
