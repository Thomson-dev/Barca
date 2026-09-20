import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/story_highlight_model.dart';
import '../models/story_model.dart';

class StoryController {
  final SupabaseClient _client;

  StoryController(this._client);

  Future<List<StoryHighlightItem>> getStoryHighlights() async {
    try {
      final response = await _client.from('story_highlights').select();
      final rawData = List<Map<String, dynamic>>.from(response as List);
      if (rawData.isEmpty) return mockStoryHighlights;
      return rawData
          .map((json) => StoryModel.fromJson(json).toEntity())
          .toList();
    } catch (_) {
      return mockStoryHighlights;
    }
  }
}

final storyControllerProvider = FutureProvider<List<StoryHighlightItem>>((
  ref,
) async {
  try {
    final controller = StoryController(Supabase.instance.client);
    return await controller.getStoryHighlights();
  } catch (_) {
    return mockStoryHighlights;
  }
});
