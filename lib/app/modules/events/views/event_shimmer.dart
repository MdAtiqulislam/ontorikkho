import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EventShimmerView extends StatelessWidget {
  const EventShimmerView({super.key});

  Widget buildShimmerBox({
    double height = 20,
    double width = double.infinity,
    BorderRadius? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome & Membership ID
              buildShimmerBox(height: 20, width: 150),
              const SizedBox(height: 20),

              // Membership Card
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade400, Colors.amber.shade700],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 30),Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade400, Colors.amber.shade700],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Events section
              buildShimmerBox(height: 20, width: 100),
              const SizedBox(height: 16),

              // Event Cards
              GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 20,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(

                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 200,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
