import 'package:flutter/material.dart';

import '../constraints/app_colors.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Show Push Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        Switch(
          value: isEnabled,
          activeColor: Colors.white, // green color like your image
          activeTrackColor: AppColors.primaryColor,
          onChanged: (value) {
            setState(() {
              isEnabled = value;
            });
          },
        ),
      ],
    );
  }
}
