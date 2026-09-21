import 'package:flutter/material.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';

class CustomRadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const CustomRadioTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      splashColor: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : Colors.grey,
                width: 2,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primaryColor : Colors.transparent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
