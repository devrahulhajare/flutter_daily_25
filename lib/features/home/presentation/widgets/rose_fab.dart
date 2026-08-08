import 'dart:math' as math;

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
        iconSize = 16,
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
      child: _RoseIcon(size: widget.iconSize),
    );
    if (innerOnly) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: _RoseIcon(size: widget.iconSize),
      );
    }
    return button;
  }
}

class _RoseIcon extends StatelessWidget {
  const _RoseIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _RosePainter(),
    );
  }
}

class _RosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 1;
    final petalPaint = Paint()
      ..color = const Color(0xFFE5394B)
      ..style = PaintingStyle.fill;

    final darkPetal = Paint()
      ..color = const Color(0xFFC62828)
      ..style = PaintingStyle.fill;

    // Outer petals
    for (var i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) - math.pi / 2;
      final px = cx + math.cos(angle) * size.width * 0.22;
      final py = cy + math.sin(angle) * size.height * 0.18;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(px, py),
          width: size.width * 0.38,
          height: size.height * 0.42,
        ),
        i.isEven ? petalPaint : darkPetal,
      );
    }

    // Inner petals
    final inner = Paint()..color = const Color(0xFFFF6B7A);
    canvas.drawCircle(Offset(cx, cy), size.width * 0.18, inner);
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.08,
      Paint()..color = const Color(0xFFB71C1C),
    );

    // Stem hint
    final stem = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy + size.height * 0.22),
      Offset(cx - 1, cy + size.height * 0.42),
      stem,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
