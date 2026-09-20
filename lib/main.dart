import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'controllers/story_controller.dart';
import 'services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pickerPlatform = ImagePickerPlatform.instance;
  if (pickerPlatform is ImagePickerAndroid) {
    pickerPlatform.useAndroidPhotoPicker = true;
  }
  final sharedPreferences = await SharedPreferences.getInstance();

  const supabaseUrl = 'https://fdkxfmnpgodxphlmzzub.supabase.co';
  const supabaseAnonKey = 'sb_publishable_GzjBslDRSBs5uqEZUwRl-g_G9bdepu_';

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        persistSession: true,
        autoRefreshToken: true,
      ),
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );

  unawaited(_logStoryHighlights());
}

Future<void> _logStoryHighlights() async {
  try {
    final controller = StoryController(Supabase.instance.client);
    final response = await controller.getStoryHighlights();
    debugPrint('story_highlights response: $response');
  } catch (error, stackTrace) {
    debugPrint('story_highlights query failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
