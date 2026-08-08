import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../chat/presentation/pages/chat_detail_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _filter = 'All';

  static const _filters = [
    'All (56)',
    'Likes & roses',
    'Matches',
    'Gifts',
    'Dates',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_rounded, size: 28),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '9 new updates',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  final isAll = f.startsWith('All');
                  final active = isAll ? _filter == 'All' : _filter == f;
                  return ChoiceChip(
                    label: Text(f),
                    selected: active,
                    onSelected: (_) {
                      setState(() => _filter = isAll ? 'All' : f);
                    },
                    selectedColor: AppColors.surfaceDark,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: BorderSide(
                        color:
                            active ? AppColors.surfaceDark : AppColors.divider,
                      ),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Text(
                'TODAY',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  _NotifCard(
                    name: 'Dev, 27',
                    body: 'sent you a Rose',
                    quote: 'Thinking of you today 🌹',
                    time: '12 min ago',
                    unread: true,
                    badge: '🌹',
                    actionLabel: 'View profile',
                    onAction: () {},
                  ),
                  _NotifCard(
                    name: 'Arjun, 28',
                    body: 'complimented your About',
                    quote: 'If you’re as fun in person as your profile, I’m in.',
                    time: '28 min ago',
                    unread: true,
                    badge: '💬',
                  ),
                  _NotifCard(
                    name: 'Aanya, 25',
                    body: 'It’s a match with Aanya, 25',
                    time: '1 hr ago',
                    unread: true,
                    badge: '✓',
                    actionLabel: 'Send a message',
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ChatDetailPage(name: 'Aanya'),
                        ),
                      );
                    },
                  ),
                  _NotifCard(
                    name: 'Elena, 23',
                    body: 'sent you a message',
                    quote: "Can't wait to see you tonight",
                    time: '2 hr ago',
                    unread: false,
                    badge: '💬',
                  ),
                  _NotifCard(
                    name: 'Kabir',
                    body: 'approved your date request',
                    quote: 'Blue Tokai · Today 8:30 PM',
                    time: '3 hr ago',
                    unread: true,
                    leadingIcon: Icons.calendar_month_rounded,
                    actionLabel: 'Open chat',
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ChatDetailPage(name: 'Kabir'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.name,
    required this.body,
    required this.time,
    required this.unread,
    this.quote,
    this.badge,
    this.leadingIcon,
    this.actionLabel,
    this.onAction,
  });

  final String name;
  final String body;
  final String time;
  final bool unread;
  final String? quote;
  final String? badge;
  final IconData? leadingIcon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: leadingIcon != null
                          ? const Color(0xFFFFE4D6)
                          : AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(
                        leadingIcon != null ? 14 : 24,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: leadingIcon != null
                        ? Icon(leadingIcon, color: AppColors.primary)
                        : Text(
                            name[0],
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Text(badge!, style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.35,
                        ),
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(text: ' $body'),
                        ],
                      ),
                    ),
                    if (quote != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        quote!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
