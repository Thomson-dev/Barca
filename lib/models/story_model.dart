import 'story_highlight_model.dart';

class StoryModel {
  final String id;
  final String label;
  final String imagePath;

  StoryModel({required this.id, required this.label, required this.imagePath});

  /// Builds a StoryModel from a raw JSON/map coming from Supabase.
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      label: json['label'] as String,
      imagePath: json['image_url'] as String,
    );
  }

  StoryHighlightItem toEntity() {
    return StoryHighlightItem(id: id, label: label, imagePath: imagePath);
  }
}
