import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_profile_details.dart';
import 'rose_fab.dart';
import 'status_chip.dart';

class ProfileDetailContent extends StatelessWidget {
  const ProfileDetailContent({
    super.key,
    required this.user,
    this.onRose,
  });

  final UserEntity user;
  final VoidCallback? onRose;

  @override
  Widget build(BuildContext context) {
    final d = user.details;

    return ColoredBox(
      color: AppColors.surfaceCream,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusChip(
                    label: '${user.matchPercent}% Match',
                    dotColor: AppColors.match,
                    style: StatusChipStyle.light,
                  ),
                  const SizedBox(width: 6),
                  StatusChip(
                    label: '${user.trustPercent}% Trust',
                    dotColor: AppColors.trust,
                    style: StatusChipStyle.light,
                  ),
                  const SizedBox(width: 6),
                  StatusChip(
                    label: '${user.replyTime} Replies',
                    dotColor: AppColors.reply,
                    style: StatusChipStyle.light,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const _SectionLabel('ABOUT'),
            const SizedBox(height: 8),
            Text(
              d.about,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            const _SectionLabel('THE BASICS'),
            const SizedBox(height: 10),
            _WhiteCard(
              children: [
                InfoRow(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: '${user.age} years old',
                  subtitle: d.birthDateLabel,
                ),
                InfoRow(
                  icon: Icons.straighten_rounded,
                  label: 'Height',
                  value: d.heightWithCm,
                ),
                InfoRow(
                  icon: Icons.location_city_outlined,
                  label: 'Lives in',
                  value: d.neighborhood.isNotEmpty
                      ? d.neighborhood
                      : user.city,
                  subtitle: d.locationRegion.isNotEmpty
                      ? d.locationRegion
                      : null,
                ),
                InfoRow(
                  icon: Icons.favorite_border_rounded,
                  label: 'Love language',
                  value: d.loveLanguage,
                  subtitle: d.loveLanguageDetail,
                ),
                InfoRow(
                  icon: Icons.account_balance_outlined,
                  label: 'Religion',
                  value: d.religion,
                ),
                InfoRow(
                  icon: Icons.favorite_outline_rounded,
                  label: 'Interested in',
                  value: d.interestedIn,
                ),
                InfoRow(
                  icon: Icons.nightlight_round,
                  label: 'Zodiac',
                  value: d.zodiac,
                  subtitle: d.zodiacTraits,
                ),
                InfoRow(
                  icon: Icons.translate_rounded,
                  label: 'Mother tongue',
                  value: d.motherTongue,
                ),
                InfoRow(
                  icon: Icons.phone_in_talk_outlined,
                  label: 'Communication style',
                  value: d.communicationStyle,
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: RoseFab.mini(onTap: onRose),
            ),
            const SizedBox(height: 8),
            _VideoIntroCard(
              imageUrl: user.imageUrl,
              duration: d.videoDuration,
              name: user.displayName,
            ),
            const SizedBox(height: 14),
            _PromptCard(prompt: d.prompts[0], onRose: onRose),
            const SizedBox(height: 22),
            const _SectionLabel('CAREER & AMBITION'),
            const SizedBox(height: 10),
            _WhiteCard(
              children: [
                InfoRow(
                  icon: Icons.school_outlined,
                  label: 'Education',
                  value: d.education,
                  subtitle: d.educationDetail,
                ),
                InfoRow(
                  icon: Icons.work_outline_rounded,
                  label: 'Work as',
                  value: d.workTitle,
                  subtitle: d.workDetail,
                ),
                InfoRow(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Work style',
                  value: d.workStyle,
                ),
                InfoRow(
                  icon: Icons.trending_up_rounded,
                  label: 'Ambition level',
                  value: d.ambitionLevel,
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _SectionLabel(user.bigDreamTitle),
            const SizedBox(height: 8),
            Text(
              d.bigDream,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: RoseFab.mini(onTap: onRose),
            ),
            const SizedBox(height: 8),
            _RoundedPhoto(url: user.imageUrl, name: user.displayName),
            const SizedBox(height: 14),
            _PromptCard(prompt: d.prompts[1], onRose: onRose),
            const SizedBox(height: 14),
            _DatingGoalCard(details: d),
            const SizedBox(height: 14),
            _LifestylePill(
              icon: Icons.nightlight_outlined,
              label: 'Sleep',
              value: d.sleepSchedule,
            ),
            const SizedBox(height: 14),
            _PromptCard(prompt: d.prompts[2], onRose: onRose),
            const SizedBox(height: 22),
            const _SectionLabel('INTERESTS & HOBBIES'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: d.interests
                  .map((interest) => _InterestChip(interest: interest))
                  .toList(),
            ),
            const SizedBox(height: 22),
            const _SectionLabel('LIFESTYLE'),
            const SizedBox(height: 10),
            _WhiteCard(
              children: [
                InfoRow(
                  icon: Icons.restaurant_outlined,
                  label: 'Diet',
                  value: d.diet,
                ),
                InfoRow(
                  icon: Icons.local_bar_outlined,
                  label: 'Drinking',
                  value: d.drinking,
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.sectionLabel,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.prompt, this.onRose});

  final ProfilePrompt prompt;
  final VoidCallback? onRose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prompt.title,
                style: const TextStyle(
                  color: AppColors.sectionLabel,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                prompt.answer,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.local_florist_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: 10,
          child: RoseFab.mini(onTap: onRose),
        ),
      ],
    );
  }
}

class _VideoIntroCard extends StatelessWidget {
  const _VideoIntroCard({
    required this.imageUrl,
    required this.duration,
    required this.name,
  });

  final String imageUrl;
  final String duration;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
            else
              Container(color: AppColors.surfaceDark),
            Container(color: Colors.black.withValues(alpha: 0.18)),
            const Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.textPrimary,
                  size: 34,
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Video intro · $duration',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatingGoalCard extends StatelessWidget {
  const _DatingGoalCard({required this.details});

  final UserProfileDetails details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATING GOAL',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            details.datingGoal,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            details.datingGoalDetail,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _LifestylePill extends StatelessWidget {
  const _LifestylePill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.sectionLabel, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.interest});

  final InterestTag interest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconFor(interest.icon),
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            interest.label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'flight':
        return Icons.flight_rounded;
      case 'coffee':
        return Icons.coffee_rounded;
      case 'terrain':
        return Icons.terrain_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      case 'music_note':
        return Icons.music_note_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'photo_camera':
        return Icons.photo_camera_outlined;
      case 'palette':
        return Icons.palette_outlined;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'movie':
        return Icons.movie_outlined;
      case 'nightlife':
        return Icons.music_note_rounded;
      default:
        return Icons.favorite_border_rounded;
    }
  }
}

class _RoundedPhoto extends StatelessWidget {
  const _RoundedPhoto({required this.url, required this.name});

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: url.isEmpty
            ? Container(
                color: AppColors.surfaceDark,
                alignment: Alignment.center,
                child: Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: const TextStyle(color: Colors.white54, fontSize: 48),
                ),
              )
            : CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
      ),
    );
  }
}
