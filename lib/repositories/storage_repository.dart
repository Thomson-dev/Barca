import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepository {
  final SupabaseClient supabase;

  StorageRepository(this.supabase);

  Future<String> uploadPostMedia({
    required String userId,
    required String filePath,
    required List<int> bytes,
    required String extension,
  }) async {
    final path =
        '$userId/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('post-media')
        .uploadBinary(
          path,
          Uint8List.fromList(bytes),
        );

    return supabase.storage
        .from('post-media')
        .getPublicUrl(path);
  }
}