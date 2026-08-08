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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0x99000000),
        borderRadius: BorderRadius.circular(20),
        border: isLight
            ? Border.all(color: AppColors.divider.withValues(alpha: 0.8))
            : null,
        boxShadow: isLight
            ? const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
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
              color: isLight ? AppColors.textPrimary : Colors.white,
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
