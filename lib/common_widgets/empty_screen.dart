import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyScreen extends StatelessWidget {
  final String? animationPath; // optional Lottie file
  final IconData? icon;
  final String? title; // optional
  final String message; // required
  final Color? iconColor;
  final double iconSize;
  final Widget? extraWidget;

  const EmptyScreen({
    super.key,
    this.animationPath,
    this.icon,
    this.title, // optional
    required this.message, // required
    this.iconColor,
    this.iconSize = 80,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (animationPath != null)
                Lottie.asset(
                  animationPath!,
                  height: 180,
                  repeat: true,
                )
              else if (icon != null)
                Container(
                  height: iconSize + 40,
                  width: iconSize + 40,
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.blue).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: iconColor ?? Colors.blue,
                  ),
                ),
              const SizedBox(height: 20),
              if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (extraWidget != null) ...[
                const SizedBox(height: 20),
                extraWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
