import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

class AdmirersPage extends StatefulWidget {
  const AdmirersPage({super.key});

  @override
  State<AdmirersPage> createState() => _AdmirersPageState();
}

class _AdmirersPageState extends State<AdmirersPage> {
  final _liked = <String>{};

  final _admirers = const [
    ('Neha', 'Liked your photo', '2h'),
    ('Sana', 'Sent you a rose', '5h'),
    ('Isha', 'Viewed your profile', '1d'),
    ('Pooja', 'Liked your bio', '1d'),
    ('Tara', 'Sent you a rose', '2d'),
    ('Diya', 'Liked your photo', '3d'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admirers',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'People who liked you',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_admirers.length} new',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: _admirers.length,
            itemBuilder: (context, index) {
              final item = _admirers[index];
              final liked = _liked.contains(item.$1);
              return _AdmirerCard(
                name: item.$1,
                subtitle: item.$2,
                time: item.$3,
                liked: liked,
                onLike: () {
                  setState(() {
                    if (liked) {
                      _liked.remove(item.$1);
                    } else {
                      _liked.add(item.$1);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AdmirerCard extends StatelessWidget {
  const _AdmirerCard({
    required this.name,
    required this.subtitle,
    required this.time,
    required this.liked,
    required this.onLike,
  });

  final String name;
  final String subtitle;
  final String time;
  final bool liked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: AppColors.primarySoft,
              alignment: Alignment.center,
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: liked ? 'Liked' : 'Like back',
                  height: 36,
                  variant: liked
                      ? AppButtonVariant.secondary
                      : AppButtonVariant.primary,
                  onPressed: onLike,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
