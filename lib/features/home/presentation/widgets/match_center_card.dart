import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../data/for_you_mock_data.dart';
import 'countdown_timer.dart';

/// Split garnet/blue card showing the next fixture, kickoff countdown, and
/// a tap-to-cheer counter.
class MatchCenterCard extends StatelessWidget {
  const MatchCenterCard({super.key, required this.match});

  final UpcomingMatch match;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Row(
                    children: [
                      Expanded(child: ColoredBox(color: AppColors.blaugranaGarnet)),
                      Expanded(child: ColoredBox(color: AppColors.blaugranaBlue)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TeamCrest(name: match.homeTeam),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: CountdownTimer(target: match.kickoff),
                            ),
                            _TeamCrest(name: match.awayTeam),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Match Center is coming soon')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              'MATCH CENTER',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatKickoff(match.kickoff),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'PRESENTED BY ${match.sponsor}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                      ),
                    ],
                  ),
                  _CheerBadge(initialCount: match.cheerCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  String _formatKickoff(DateTime kickoff) {
    final day = kickoff.day.toString().padLeft(2, '0');
    final month = _months[kickoff.month - 1];
    final hour = kickoff.hour.toString().padLeft(2, '0');
    final minute = kickoff.minute.toString().padLeft(2, '0');
    return '$day $month  $hour:$minute GMT+1';
  }
}

class _TeamCrest extends StatelessWidget {
  const _TeamCrest({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.shield, color: AppColors.blaugranaBlue, size: 22),
        ),
        const SizedBox(height: 4),
        Text(
          name.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
        ),
      ],
    );
  }
}

class _CheerBadge extends StatefulWidget {
  const _CheerBadge({required this.initialCount});

  final int initialCount;

  @override
  State<_CheerBadge> createState() => _CheerBadgeState();
}

class _CheerBadgeState extends State<_CheerBadge> {
  late int _count = widget.initialCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _count++),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'FORÇA BARÇA',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(_formatCount(_count), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.senyera,
                child: const Text('👏', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    final digits = n.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
