import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated rose FAB with soft pink glow, matching the design.
class RoseFab extends StatefulWidget {
  const RoseFab({
    super.key,
    this.onTap,
    this.size = 60,
    this.iconSize = 28,
    this.showGlow = true,
  });

  const RoseFab.mini({super.key, this.onTap})
      : size = 36,
        iconSize = 18,
        showGlow = false;

  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final bool showGlow;

  @override
  State<RoseFab> createState() => _RoseFabState();
}

class _RoseFabState extends State<RoseFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.showGlow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget get _roseEmoji => Text(
        '🌹',
        style: TextStyle(
          fontSize: widget.iconSize.toDouble(),
          height: 1,
        ),
        textAlign: TextAlign.center,
      );

  @override
  Widget build(BuildContext context) {
    if (!widget.showGlow) {
      return GestureDetector(
        onTap: widget.onTap,
        child: _buildButton(),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        final glow = 10 + (t * 8);
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35 + t * 0.2),
                  blurRadius: glow,
                  spreadRadius: 1 + t * 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: _buildButton(innerOnly: true),
    );
  }

  Widget _buildButton({bool innerOnly = false}) {
    final button = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.showGlow ? Colors.white : const Color(0xFFFFF0F2),
        shape: BoxShape.circle,
        boxShadow: widget.showGlow
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: _roseEmoji,
    );
    if (innerOnly) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: _roseEmoji,
      );
    }
    return button;
  }
}
