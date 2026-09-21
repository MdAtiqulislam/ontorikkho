import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

/// ================= SINGLE NOTIFICATION ITEM =================
class NotificationItem extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded( // ✅ Auto width in Row
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final radius = AppDimensions.borderRadius.r;
            return Stack(
              children: [
                /// Card body
                Container(
                  width: constraints.maxWidth, // full width in Expanded
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius),
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
                      Icon(icon,
                          color:
                          isSelected ? Colors.blue : Colors.grey.shade600),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color:
                          isSelected ? Colors.blue : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
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
                      clipper: DiagonalClipper(radius: radius),
                      child: Container(
                        height: radius * 5.5, // proportional to radius
                        width: radius * 5.5,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                /// Check icon
                if (isSelected)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Icon(Icons.check, size: 18, color: Colors.white),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ================= DIAGONAL CLIPPER =================
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
