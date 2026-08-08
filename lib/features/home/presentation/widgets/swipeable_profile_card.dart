import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum SwipeDirection { left, right }

class SwipeableProfileCard extends StatefulWidget {
  const SwipeableProfileCard({
    super.key,
    required this.child,
    this.onSwiped,
    this.swipeThreshold = 120,
    this.enabled = true,
  });

  final Widget child;
  final void Function(SwipeDirection direction)? onSwiped;
  final double swipeThreshold;

  /// When false, horizontal swipe is ignored (e.g. details scrolled open).
  final bool enabled;

  @override
  State<SwipeableProfileCard> createState() => _SwipeableProfileCardState();
}

class _SwipeableProfileCardState extends State<SwipeableProfileCard>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  late final AnimationController _settleController;
  Animation<Offset>? _settleAnimation;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(() {
        if (_settleAnimation != null) {
          setState(() => _dragOffset = _settleAnimation!.value);
        }
      });
  }

  @override
  void dispose() {
    _settleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SwipeableProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled && !_isExiting) {
      if (_dragOffset != Offset.zero) {
        _springBack();
      }
    }
  }

  double get _rotation => (_dragOffset.dx / 320).clamp(-0.35, 0.35);

  double get _likeOpacity =>
      (_dragOffset.dx / widget.swipeThreshold).clamp(0.0, 1.0);

  double get _nopeOpacity =>
      (-_dragOffset.dx / widget.swipeThreshold).clamp(0.0, 1.0);

  void _onDragStart(DragStartDetails details) {
    if (!widget.enabled || _isExiting) return;
    _settleController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled || _isExiting) return;
    setState(() {
      _dragOffset += Offset(details.delta.dx, details.delta.dy * 0.35);
    });
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (!widget.enabled || _isExiting) return;

    final dx = _dragOffset.dx;
    final vx = details.velocity.pixelsPerSecond.dx;
    final shouldSwipeRight = dx > widget.swipeThreshold || vx > 900;
    final shouldSwipeLeft = dx < -widget.swipeThreshold || vx < -900;

    if (shouldSwipeRight) {
      await _animateOff(SwipeDirection.right);
    } else if (shouldSwipeLeft) {
      await _animateOff(SwipeDirection.left);
    } else {
      await _springBack();
    }
  }

  Future<void> _springBack() async {
    _settleAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _settleController, curve: Curves.easeOutCubic),
    );
    _settleController.duration = const Duration(milliseconds: 280);
    await _settleController.forward(from: 0);
    if (mounted) setState(() => _dragOffset = Offset.zero);
  }

  Future<void> _animateOff(SwipeDirection direction) async {
    _isExiting = true;
    final size = MediaQuery.sizeOf(context);
    final endX = direction == SwipeDirection.right
        ? size.width * 1.4
        : -size.width * 1.4;
    final endY = _dragOffset.dy + (direction == SwipeDirection.right ? -40 : 40);

    _settleAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(endX, endY),
    ).animate(
      CurvedAnimation(parent: _settleController, curve: Curves.easeInCubic),
    );
    _settleController.duration = const Duration(milliseconds: 240);
    await _settleController.forward(from: 0);

    if (!mounted) return;
    widget.onSwiped?.call(direction);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: widget.enabled ? _onDragStart : null,
      onHorizontalDragUpdate: widget.enabled ? _onDragUpdate : null,
      onHorizontalDragEnd: widget.enabled ? _onDragEnd : null,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _rotation,
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.child,
              IgnorePointer(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 28,
                      left: 22,
                      child: Opacity(
                        opacity: _nopeOpacity,
                        child: Transform.rotate(
                          angle: -math.pi / 10,
                          child: const _SwipeStamp(
                            label: 'NOPE',
                            color: AppColors.nope,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      right: 22,
                      child: Opacity(
                        opacity: _likeOpacity,
                        child: Transform.rotate(
                          angle: math.pi / 10,
                          child: const _SwipeStamp(
                            label: 'LIKE',
                            color: AppColors.like,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeStamp extends StatelessWidget {
  const _SwipeStamp({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3.5),
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          height: 1,
        ),
      ),
    );
  }
}
