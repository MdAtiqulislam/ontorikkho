import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Container(
              height: 24,
              width: 150,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 16),
            ),
            // Membership Card
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 24),
            ),
            // Events Section
            Container(
              height: 24,
              width: 100,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            // Events Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Announcements Section
            Container(
              height: 24,
              width: 120,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            // Bottom Navigation Placeholder

            Container(
              height: 24,
              width: 120,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Container(
              height: 100,
              width: 120,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Container(
              height: 100,
              width: 120,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Container(
              height: 100,
              width: 120,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            // Bottom Navigation Placeholder
          ],
        ),
      ),
    );
  }
}
