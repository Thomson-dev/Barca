import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../data/for_you_mock_data.dart';

/// Tall media card with a gradient-scrimmed thumbnail, an optional "NEW"
/// badge, and a sponsor credit line.
///
/// TODO: swap the placeholder background image for the real thumbnail and
/// wire tap-to-play once video content is available.
class FeaturedVideoCard extends StatelessWidget {
  const FeaturedVideoCard({super.key, required this.item});

  final FeaturedVideoItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('lib/assets/images/raphinha.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0, 0.35, 1],
                ),
              ),
            ),
            if (item.isNew)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            const Positioned(
              top: 12,
              right: 12,
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'PRESENTED BY',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 10),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.sponsor,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                      ),
                    ],
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
