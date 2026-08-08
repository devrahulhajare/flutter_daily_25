import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = const [
      _Event(
        title: 'Sunset Rooftop Mixer',
        location: 'Pune',
        when: 'Sat 7:00 PM',
        going: '12 going',
        icon: Icons.wb_twilight_rounded,
        color: Color(0xFFFF8A65),
      ),
      _Event(
        title: 'Coffee & Conversations',
        location: 'Koregaon Park',
        when: 'Sun 11:00 AM',
        going: '8 going',
        icon: Icons.coffee_rounded,
        color: Color(0xFF8D6E63),
      ),
      _Event(
        title: 'Art Gallery Walk',
        location: 'FC Road',
        when: 'Fri 6:30 PM',
        going: '15 going',
        icon: Icons.palette_outlined,
        color: Color(0xFF7E57C2),
      ),
      _Event(
        title: 'Weekend Brunch Club',
        location: 'Baner',
        when: 'Sat 12:00 PM',
        going: '20 going',
        icon: Icons.brunch_dining_outlined,
        color: Color(0xFF26A69A),
      ),
    ];

    return ColoredBox(
      color: AppColors.surfaceCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Meet matches at curated local events',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final e = events[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 120,
                        color: e.color.withValues(alpha: 0.18),
                        child: Icon(e.icon, size: 48, color: e.color),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${e.location} • ${e.when}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  e.going,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 96,
                                  child: AppButton(
                                    label: 'Join',
                                    height: 36,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Joined ${e.title}'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Event {
  const _Event({
    required this.title,
    required this.location,
    required this.when,
    required this.going,
    required this.icon,
    required this.color,
  });

  final String title;
  final String location;
  final String when;
  final String going;
  final IconData icon;
  final Color color;
}
