import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/match_center_model.dart';
import 'countdown_timer.dart';
import 'match_card_colors.dart';

class MatchCenterCard extends StatelessWidget {
  const MatchCenterCard({super.key, required this.match});

  final UpcomingMatch match;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ColoredBox(
              color: MatchCardColors.cardBackground,
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 140),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MatchCardColors.blaugranaBlue,
                          MatchCardColors.garnetMaroon,
                        ],
                        stops: [0.5, 0.5],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _TeamCrest(
                                  name: match.homeTeam,
                                  crestPath: match.homeCrestPath,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: CountdownTimer(target: match.kickoff),
                              ),
                              Expanded(
                                child: _TeamCrest(
                                  name: match.awayTeam,
                                  crestPath: match.awayCrestPath,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Match Center is coming soon',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MatchCardColors.yellowAccent,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'MATCH CENTER',
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        _StatColumn(
                          top: match.kickoff.day.toString().padLeft(2, '0'),
                          bottom: _months[match.kickoff.month - 1],
                        ),
                        const _Divider(),
                        _StatColumn(
                          top:
                              '${match.kickoff.hour.toString().padLeft(2, '0')}:'
                              '${match.kickoff.minute.toString().padLeft(2, '0')}',
                          bottom: 'GMT+1',
                        ),
                        const _Divider(),
                        _StatColumn(
                          top: 'PRESENTED BY',
                          bottom: match.sponsor,
                          topBold: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
}

class _TeamCrest extends StatelessWidget {
  const _TeamCrest({required this.name, required this.crestPath});

  final String name;
  final String crestPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 60,
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            crestPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Iconsax.shield, size: 36, color: Colors.amber),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name.toUpperCase(),
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.top,
    required this.bottom,
    this.topBold = true,
  });

  final String top;
  final String bottom;
  final bool topBold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          style: GoogleFonts.oswald(
            fontSize: topBold ? 15 : 9,
            fontWeight: topBold ? FontWeight.w800 : FontWeight.w600,
            color: topBold
                ? MatchCardColors.textDark
                : MatchCardColors.textMuted,
            letterSpacing: topBold ? 0 : 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          bottom,
          style: GoogleFonts.oswald(
            fontSize: topBold ? 14 : 13,
            fontWeight: topBold ? FontWeight.w600 : FontWeight.w800,
            color: topBold
                ? MatchCardColors.textMuted
                : MatchCardColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: Colors.grey.shade300,
    );
  }
}
