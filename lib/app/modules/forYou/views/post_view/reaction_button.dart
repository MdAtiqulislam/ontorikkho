
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/util.dart';

// ========================
// ReactionType & Items
// ========================


class ReactionItem {
  final ReactionType type;
  final String asset;
  final String label;

  ReactionItem({
    required this.type,
    required this.asset,
    required this.label,
  });
}


// ========================
// Audio player setup
// ========================
final AudioPlayer _audioPlayer = AudioPlayer();

void playReactionSound() async {
  await _audioPlayer.play(AssetSource('sounds/reaction.mp3'));
}

// ========================
// Reaction Button
// ========================
class ReactionButton extends StatefulWidget {
  final ReactionType? selectedReaction;
  final void Function(ReactionType?)? onReactionSelected;
  final Widget child;

  const ReactionButton({
    super.key,
    required this.child,
    this.onReactionSelected,
    this.selectedReaction,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  OverlayEntry? _overlay;
  ReactionType? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedReaction;
  }

  void _showOverlay() {
    if (_overlay != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              left: position.dx - 10,
              top: position.dy - 70,
              child: Material(
                color: Colors.transparent,
                child: ReactionPanel(
                  selectedReaction: selected,
                  onSelect: (reaction) {
                    widget.onReactionSelected?.call(reaction);
                    playReactionSound();
                    _removeOverlay();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _toggleReaction() {
    setState(() {
     // selected = selected == null ? ReactionType.like : null;
    });
    widget.onReactionSelected?.call(selected);
    if (selected != null) playReactionSound();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleReaction,
      onLongPress: _showOverlay,
      child: widget.child,
    );
  }
}

// ========================
// Reaction Panel
// ========================
class ReactionPanel extends StatefulWidget {
  final Function(ReactionType) onSelect;
  final ReactionType? selectedReaction;

  const ReactionPanel({
    super.key,
    required this.onSelect,
    this.selectedReaction,
  });

  @override
  State<ReactionPanel> createState() => _ReactionPanelState();
}

class _ReactionPanelState extends State<ReactionPanel> {
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 14)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(reactions.length, (index) {
          final reaction = reactions[index];
          final isHovered = hoveredIndex == index;

          return GestureDetector(
            onTap: () {
              widget.onSelect(reaction.type);
              playReactionSound();
            },
            onPanUpdate: (_) => setState(() => hoveredIndex = index),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 120),
              scale: isHovered ? 1.4 : 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Lottie.asset(
                    reaction.asset,
                    repeat: false,
                    animate: true,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
