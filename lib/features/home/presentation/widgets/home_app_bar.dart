import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/circular_icon_button.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    this.onMenu,
    this.onBoost,
    this.onFilter,
    this.onNotifications,
  });

  final VoidCallback? onMenu;
  final VoidCallback? onBoost;
  final VoidCallback? onFilter;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
        child: Row(
          children: [
            CircularIconButton(
              icon: Icons.menu_rounded,
              size: 42,
              iconSize: 22,
              backgroundColor: Colors.white,
              onTap: onMenu,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LiveDot(),
                  SizedBox(width: 8),
                  Text(
                    'Daily 25',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CircularIconButton(
              icon: Icons.bolt_rounded,
              size: 42,
              iconSize: 22,
              backgroundColor: Colors.white,
              onTap: onBoost,
            ),
            const SizedBox(width: 8),
            CircularIconButton(
              icon: Icons.tune_rounded,
              size: 42,
              iconSize: 20,
              backgroundColor: Colors.white,
              onTap: onFilter,
            ),
            const SizedBox(width: 8),
            CircularIconButton(
              icon: Icons.notifications_none_rounded,
              size: 42,
              iconSize: 22,
              backgroundColor: Colors.white,
              onTap: onNotifications,
              showBadge: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.55 + (_controller.value * 0.45),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
