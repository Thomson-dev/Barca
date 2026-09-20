import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post_model.dart';

class PostRepository {
  final SupabaseClient supabase;

  PostRepository(this.supabase);

  Future<Post> createPost({
    String? caption,
    String? mediaUrl,
    String? mediaType,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('You must be signed in to create a post.');
    }

    final data = await supabase
        .from('posts')
        .insert({
          'user_id': user.id,
          'caption': caption,
          'media_url': mediaUrl,
          'media_type': mediaType,
        })
        .select()
        .single();

    return Post.fromJson(data);
  }

  Future<List<Post>> getPosts() async {
    final data = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return data
        .map((json) => Post.fromJson(json))
        .toList();
  }

  Future<void> deletePost(String postId) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    await supabase
        .from('posts')
        .delete()
        .eq('id', postId)
        .eq('user_id', user.id);
  }
}
