import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../utils/enums.dart';
import '../../../../../utils/util.dart';


class ReactionIcon extends StatelessWidget {
  final ReactionType? reaction;
  final double size;
  final bool outlinedWhenNull;

  const ReactionIcon({
    super.key,
    this.reaction,
    this.size = 24,
    this.outlinedWhenNull = true,
  });

  @override
  Widget build(BuildContext context) {
    if (reaction == null) {
      return Icon(
        outlinedWhenNull
            ? Icons.thumb_up_alt_outlined
            : Icons.thumb_up_alt,
        size: size,
      );
    }

    final item = reactions.firstWhere(
          (r) => r.type == reaction,
    );

    return Lottie.asset(
      item.asset,
      width: size,
      height: size,
      animate: false,
      repeat: false,
    );
  }
}
