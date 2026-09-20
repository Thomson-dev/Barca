import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/repository_providers.dart';

final createPostControllerProvider =
    AsyncNotifierProvider<CreatePostController, void>(CreatePostController.new);

class CreatePostController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createPost({
    String? caption,
    XFile? media,
    String? mediaType,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      String? mediaUrl;

      if (media != null) {
        final user = ref.read(supabaseProvider).auth.currentUser;

        if (user == null) {
          throw Exception('User is not authenticated');
        }

        final bytes = await media.readAsBytes();

        mediaUrl = await ref
            .read(storageRepositoryProvider)
            .uploadPostMedia(
              userId: user.id,
              filePath: media.name,
              bytes: bytes,
              extension: media.name.split('.').last,
            );
      }

      await ref
          .read(postRepositoryProvider)
          .createPost(
            caption: caption,
            mediaUrl: mediaUrl,
            mediaType: mediaType,
          );
    });
  }
}
