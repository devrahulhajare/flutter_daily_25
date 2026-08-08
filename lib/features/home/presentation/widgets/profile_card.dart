import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import 'profile_detail_content.dart';
import 'rose_fab.dart';
import 'status_chip.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.user,
    this.scrollController,
    this.onUndo,
    this.onMore,
    this.onRose,
    this.onSectionRose,
    this.enableDetails = true,
    this.onScrollProgress,
  });

  final UserEntity user;
  final ScrollController? scrollController;
  final VoidCallback? onUndo;
  final VoidCallback? onMore;
  final VoidCallback? onRose;
  final VoidCallback? onSectionRose;
  final bool enableDetails;
  final ValueChanged<double>? onScrollProgress;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  ScrollController? _ownedController;
  ScrollController get _controller =>
      widget.scrollController ?? _ownedController!;

  double _progress = 0;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _ownedController = ScrollController();
    }
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _ownedController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final hero = context.size?.height ?? 1;
    final next = (_controller.offset / hero).clamp(0.0, 1.0);
    if ((next - _progress).abs() < 0.004) return;
    setState(() => _progress = next);
    widget.onScrollProgress?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight = constraints.maxHeight;

            if (!widget.enableDetails) {
              return _HeroPhoto(
                user: widget.user,
                height: heroHeight,
                onUndo: widget.onUndo,
                onMore: widget.onMore,
                onRose: widget.onRose,
              );
            }

            final summaryOpacity = (1 - (_progress * 1.35)).clamp(0.0, 1.0);
            final detailsLift = Curves.easeOutCubic.transform(_progress);

            return ColoredBox(
              color: AppColors.surfaceCream,
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollUpdateNotification) _onScroll();
                  return false;
                },
                child: CustomScrollView(
                  controller: _controller,
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: Offset(0, -_progress * 28),
                        child: Transform.scale(
                          scale: 1 - (_progress * 0.04),
                          alignment: Alignment.topCenter,
                          child: Opacity(
                            opacity: lerpDouble(1, 0.88, _progress)!,
                            child: _HeroPhoto(
                              user: widget.user,
                              height: heroHeight,
                              summaryOpacity: summaryOpacity,
                              onUndo: widget.onUndo,
                              onMore: widget.onMore,
                              onRose: widget.onRose,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: Offset(0, lerpDouble(18, -12, detailsLift)!),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCream,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.08 * detailsLift,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            child: ProfileDetailContent(
                              user: widget.user,
                              onRose: widget.onSectionRose ?? widget.onRose,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({
    required this.user,
    required this.height,
    this.summaryOpacity = 1,
    this.onUndo,
    this.onMore,
    this.onRose,
  });

  final UserEntity user;
  final double height;
  final double summaryOpacity;
  final VoidCallback? onUndo;
  final VoidCallback? onMore;
  final VoidCallback? onRose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _ProfileImage(url: user.imageUrl, name: user.displayName),
          const _BottomGradient(),
          Positioned(
            top: 16,
            left: 16,
            child: _OverlayCircleButton(
              icon: Icons.refresh_rounded,
              onTap: onUndo,
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _OverlayCircleButton(
              icon: Icons.more_vert_rounded,
              onTap: onMore,
            ),
          ),
          Positioned(
            left: 20,
            right: 16,
            bottom: 22,
            child: Opacity(
              opacity: summaryOpacity,
              child: Transform.translate(
                offset: Offset(0, (1 - summaryOpacity) * 16),
                child: _ProfileSummary(user: user, onRose: onRose),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.url, required this.name});

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _Placeholder(name: name);
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.surfaceDark,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primary,
        ),
      ),
      errorWidget: (context, url, error) => _Placeholder(name: name),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceDark,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 72,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.45),
              Colors.black.withValues(alpha: 0.78),
            ],
            stops: const [0.42, 0.55, 0.75, 1.0],
          ),
        ),
      ),
    );
  }
}

class _OverlayCircleButton extends StatelessWidget {
  const _OverlayCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.user, this.onRose});

  final UserEntity user;
  final VoidCallback? onRose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChip(
                    label: '${user.matchPercent}% Match',
                    dotColor: AppColors.match,
                  ),
                  StatusChip(
                    label: '${user.trustPercent}% Trust',
                    dotColor: AppColors.trust,
                  ),
                  StatusChip(
                    label: '${user.replyTime} Reply',
                    dotColor: AppColors.reply,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (user.isOnline) ...[
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: AppColors.online,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      user.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                        letterSpacing: -0.6,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${user.age}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      height: 1.05,
                    ),
                  ),
                  if (user.isVerified) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: user.locationLine,
              ),
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.work_outline_rounded,
                text: user.workLine,
              ),
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.favorite_border_rounded,
                text: user.intention,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: RoseFab(onTap: onRose),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.95), size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
