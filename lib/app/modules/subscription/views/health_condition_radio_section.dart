import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../../../common_widgets/custom_radio_tile.dart';
import '../controllers/subscriprtion_controller.dart';



class HealthConditionRadioSection extends GetView<SubscriptionController> {
  HealthConditionRadioSection({super.key});

  final List<String> conditions = [
    'Diabetes',
    'Blood Pressure',
    'Heart Conditions',
    'Other',
    'None',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Have Any Existing Health Conditions?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...conditions.map((condition) {
          return Padding(
            padding:  EdgeInsets.only(bottom: AppDimensions.contentPadding.h),
            child: CustomRadioTile(
              label: condition,
              value: condition,
              groupValue: controller.selectedCondition.value,
              onChanged: (value){
                controller.selectedCondition.value=value;
              },
            ),
          );
        }),
      ],
    ));
  }
}
