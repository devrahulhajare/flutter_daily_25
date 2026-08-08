import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum StatusChipStyle { dark, light }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.dotColor,
    this.style = StatusChipStyle.dark,
  });

  final String label;
  final Color dotColor;
  final StatusChipStyle style;

  @override
  Widget build(BuildContext context) {
    final isLight = style == StatusChipStyle.light;
    if (isLight) {
      return _ChipBody(
        label: label,
        dotColor: dotColor,
        foreground: AppColors.textPrimary,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
      );
    }

    // Glassy chip on photo cards (frosted dark glass).
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: _ChipBody(
          label: label,
          dotColor: dotColor,
          foreground: Colors.white,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 0.7,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.20),
                Colors.black.withValues(alpha: 0.38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipBody extends StatelessWidget {
  const _ChipBody({
    required this.label,
    required this.dotColor,
    required this.foreground,
    required this.decoration,
  });

  final String label;
  final Color dotColor;
  final Color foreground;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
