import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notification_details_controller.dart';

class NotificationDetailsView extends GetView<NotificationDetailsController> {
  const NotificationDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotificationDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
