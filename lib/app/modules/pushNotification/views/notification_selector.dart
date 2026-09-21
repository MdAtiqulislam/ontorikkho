import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NotificationSelector extends StatelessWidget {
  final List<NotificationOption> options;
  final String selectedId;
  final ValueChanged<String> onChanged;
  const NotificationSelector({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.sp,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: options.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final option = options[index];
          final bool isSelected = option.id == selectedId;

          return GestureDetector(
            onTap: () => onChanged(option.id),
            child: SizedBox(
             // width: (Get.width - 48.w) / options.length, // evenly spaced
              child: Stack(
                children: [
                  /// Card body
                  Container(
                   // width: Get.width,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(option.icon,
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade600),
                        const SizedBox(height: 6),
                        Text(
                          option.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Diagonal corner
                  if (isSelected)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipPath(
                        clipper: DiagonalClipper(),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                  /// Check icon
                  if (isSelected)
                    const Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.check,
                          size: 18, color: Colors.white),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class NotificationOption {
  final String id;
  final String label;
  final IconData icon;

  NotificationOption({
    required this.id,
    required this.label,
    required this.icon,
  });
}


class DiagonalClipper extends CustomClipper<Path> {
  final double radius;

  DiagonalClipper({this.radius = 16});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

