import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../data/for_you_mock_data.dart';

/// Horizontally scrollable row of gold-ringed story avatars.
///
/// TODO: swap the shared placeholder image for per-story thumbnails once
/// real content assets/URLs are available.
class StoryHighlightRow extends StatelessWidget {
  const StoryHighlightRow({super.key, required this.items});

  final List<StoryHighlightItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _StoryAvatar(item: items[index]),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.item});

  final StoryHighlightItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: AppColors.gold, width: 2)),
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('lib/assets/images/raphinha.jpg'),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
