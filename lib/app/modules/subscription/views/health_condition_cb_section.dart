import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ontorikkho/app/modules/subscription/controllers/subscriprtion_controller.dart';

import '../../../../common_widgets/custom_check_box.dart';

class HealthConditionCheckboxSection extends GetView<SubscriptionController> {
  const HealthConditionCheckboxSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Have Any Existing Health Conditions?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...controller.healthConditions.map((condition) {
          final isChecked = controller.selectedConditions.contains(condition.key);
          return Padding(
            padding:  EdgeInsets.only(bottom: 8.0),
            child: CustomCheckboxTile(
              label: condition.label,
              value: isChecked,
              onChanged: (_) => controller.toggleCondition(condition.key),
            ),
          );
        }),
      ],
    ));
  }
}
