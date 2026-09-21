import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String label;

  const CustomCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      splashColor: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? AppColors.primaryColor : Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
           SizedBox(width: AppDimensions.contentPadding.w),
          Expanded(
            child: BodyText(
              text: label,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
