import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';

final postsProvider =
    AsyncNotifierProvider<PostsNotifier, List<Post>>(PostsNotifier.new);

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    return _dummyPosts;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(_dummyPosts);
  }
}

final _dummyPosts = <Post>[
  Post(
    id: 'dummy-1',
    userId: 'dummy-user-1',
    caption: 'Matchday energy. Visca Barca!',
    mediaUrl: 'https://images.unsplash.com/photo-1579952363873-27f3b960be0d?auto=format&fit=crop&w=1200&q=85',
    mediaType: 'image',
    createdAt: DateTime(2026, 9, 19, 10),
  ),
  Post(
    id: 'dummy-2',
    userId: 'dummy-user-2',
    caption: 'The colours, the history, the feeling. Forca Barca.',
    mediaUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?auto=format&fit=crop&w=1200&q=85',
    mediaType: 'image',
    createdAt: DateTime(2026, 9, 18, 18),
  ),
  Post(
    id: 'dummy-3',
    userId: 'dummy-user-3',
    caption: 'A football club unlike any other.',
    mediaUrl: 'https://images.unsplash.com/photo-1553778263-73a83bab9b0c?auto=format&fit=crop&w=1200&q=85',
    mediaType: 'image',
    createdAt: DateTime(2026, 9, 17, 14),
  ),
  Post(
    id: 'dummy-4',
    userId: 'dummy-user-4',
    caption: 'Every game. Every generation. One beautiful identity.',
    mediaType: 'text',
    createdAt: DateTime(2026, 9, 16, 9),
  ),
];