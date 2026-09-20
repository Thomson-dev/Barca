import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/story_controller.dart';
import '../models/story_highlight_model.dart';

class StoryHighlightRow extends ConsumerWidget {
  const StoryHighlightRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storyControllerProvider);

    return stories.when(
      loading: () {
        return const SizedBox(
          height: 132,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) {
        return _buildList(mockStoryHighlights);
      },
      data: (items) {
        final list = items.isEmpty ? mockStoryHighlights : items;
        return _buildList(list);
      },
    );
  }

  Widget _buildList(List<StoryHighlightItem> items) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            _StoryAvatar(key: ValueKey(items[index].id), item: items[index]),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({super.key, required this.item});

  final StoryHighlightItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFFD4AF37), width: 3),
              ),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage(item.imagePath),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.oswald(
              fontSize: 13,
              height: 1,
              color: const Color(0xFF050505),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
