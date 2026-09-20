class Post {
  final String id;
  final String userId;
  final String? caption;
  final String? mediaUrl;
  final String? mediaType;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    this.caption,
    this.mediaUrl,
    this.mediaType,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      caption: json['caption'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
