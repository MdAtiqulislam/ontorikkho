import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/reaction_icon.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';

import '../../models/posts_model.dart';
import '../../../../../utils/util.dart';

class ReactionSummary extends StatelessWidget {
  final ReactionCounts counts;
  final double iconSize;
  final double overlap;


  const ReactionSummary({
    super.key,
    required this.counts,
    this.iconSize = 20,
    this.overlap = 0.7, // 50% overlap
  });

  @override
  Widget build(BuildContext context) {
    final activeReactions = _getActiveReactions(counts);

    final overlapWidth = iconSize * overlap;
    final stackWidth =
    activeReactions.length == 1
        ? iconSize
        : iconSize + (activeReactions.length - 1) * overlapWidth;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: iconSize.sp,
          width: stackWidth.sp,
          child: Stack(
            children: List.generate(activeReactions.length, (index) {
              return Positioned(
                left: (index * overlapWidth).sp,
                child: ReactionIcon(
                  reaction: activeReactions[index].toString().toLowerCase().toReactionType(),
                  size: iconSize,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  List<String> _getActiveReactions(ReactionCounts counts) {
    final map = {
      "like": counts.like,
      "love": counts.love,
      "haha": counts.haha,
      "wow": counts.wow,
      "sad": counts.sad,
      "angry": counts.angry,
    };

    return map.entries
        .where((e) => (e.value ?? 0) > 0)
        .map((e) => e.key)
        .toList();
  }
}



