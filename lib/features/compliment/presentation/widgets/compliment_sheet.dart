import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../chat/presentation/pages/chat_detail_page.dart';
import '../../../home/domain/entities/user_entity.dart';
import '../bloc/compliment_bloc.dart';
import '../pages/compliment_ideas_page.dart';

Future<void> showComplimentSheet({
  required BuildContext context,
  required UserEntity user,
  String targetLabel = 'About',
}) {
  return showAppBottomSheet<void>(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (_) => ComplimentBloc(),
        child: ComplimentSheet(user: user, targetLabel: targetLabel),
      );
    },
  );
}

class ComplimentSheet extends StatelessWidget {
  const ComplimentSheet({
    super.key,
    required this.user,
    this.targetLabel = 'About',
  });

  final UserEntity user;
  final String targetLabel;

  Future<void> _openIdeas(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const ComplimentIdeasPage(initialCategory: 'Flirty'),
      ),
    );
    if (result != null && context.mounted) {
      context.read<ComplimentBloc>().add(ComplimentIdeaApplied(result));
    }
  }

  void _send(BuildContext context, ComplimentState state) {
    context.read<ComplimentBloc>().add(const ComplimentSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<ComplimentBloc, ComplimentState>(
      listenWhen: (p, c) =>
          p.status != c.status && c.status == ComplimentStatus.success,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        final nav = Navigator.of(context);
        final name = user.displayName;
        final imageUrl = user.imageUrl;
        final text = state.text.trim();
        final rose = state.roseSelected;

        nav.pop();
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                rose
                    ? '🌹 Rose + 💬 Comment sent! ✨ Opening chat...'
                    : '💬 Compliment sent! ✨ Opening chat...',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.surfaceDark,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

        Future<void>.delayed(const Duration(milliseconds: 700), () {
          nav.push(
            MaterialPageRoute<void>(
              builder: (_) => ChatDetailPage(
                name: name,
                imageUrl: imageUrl,
                initialCompliment: text,
                roseSent: rose,
              ),
            ),
          );
        });
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'COMPLIMENTING',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    targetLabel,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatPill(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: '3 comments',
                      ),
                      _StatPill(
                        icon: Icons.local_florist_rounded,
                        label: '2 roses',
                      ),
                      _StatPill(
                        icon: Icons.monetization_on_rounded,
                        label: '5,258 balance',
                        iconColor: Color(0xFFE6A817),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ComplimentInput(
                    text: state.text,
                    maxLength: state.maxLength,
                    onChanged: (v) => context
                        .read<ComplimentBloc>()
                        .add(ComplimentTextChanged(v)),
                    onTry: () => _openIdeas(context),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${state.text.characters.length}/${state.maxLength}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _GiftToggle(
                          selected: state.roseSelected,
                          label: 'Rose',
                          emoji: '🌹',
                          onTap: () => context
                              .read<ComplimentBloc>()
                              .add(const ComplimentRoseToggled()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _GiftToggle(
                          selected: false,
                          label: 'Select Gift',
                          emoji: '🎁',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gift picker coming soon'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () => context
                              .read<ComplimentBloc>()
                              .add(const ComplimentLikedToggled()),
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primary
                                    .withValues(alpha: 0.45),
                              ),
                              color: state.liked
                                  ? AppColors.primarySoft
                                  : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state.liked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Like',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: state.roseSelected
                              ? 'Send  🌹  +  💬'
                              : 'Send Compliment',
                          height: 64,
                          isLoading:
                              state.status == ComplimentStatus.sending,
                          onPressed: state.canSend
                              ? () => _send(context, state)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ComplimentInput extends StatefulWidget {
  const _ComplimentInput({
    required this.text,
    required this.maxLength,
    required this.onChanged,
    required this.onTry,
  });

  final String text;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final VoidCallback onTry;

  @override
  State<_ComplimentInput> createState() => _ComplimentInputState();
}

class _ComplimentInputState extends State<_ComplimentInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant _ComplimentInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.text,
        selection: TextSelection.collapsed(offset: widget.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Stack(
        children: [
          TextField(
            controller: _controller,
            maxLength: widget.maxLength,
            maxLines: 4,
            minLines: 3,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              hintText: 'Write a sweet compliment...',
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.fromLTRB(14, 14, 14, 44),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: 1,
              child: InkWell(
                onTap: widget.onTry,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('💡', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Text(
                        'Try',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GiftToggle extends StatelessWidget {
  const _GiftToggle({
    required this.selected,
    required this.label,
    required this.emoji,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : Colors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
