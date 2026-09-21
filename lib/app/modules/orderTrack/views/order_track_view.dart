import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';

import '../controllers/order_track_controller.dart';

class OrderTrackView extends GetView<OrderTrackController> {
  const OrderTrackView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true,title: "Order Track",),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: const Center(
          child: Text(
            'OrderTrackView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
