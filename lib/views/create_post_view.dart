import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/create_post_controller.dart';
import '../services/app_colors.dart';
import '../services/app_routes.dart';
import '../widgets/uploaded_media.dart';

class CreatePostView extends ConsumerStatefulWidget {
  const CreatePostView({super.key});

  @override
  ConsumerState<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  static const _ink = Color(0xFF17273D);
  static const _muted = Color(0xFF68778B);
  static const _line = Color(0xFFE8EDF3);
  final _textController = TextEditingController();
  final _picker = ImagePicker();
  String? _mediaAsset;
  XFile? _mediaFile;
  bool _isVideo = false;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _restoreLostMedia();
  }

  Future<void> _restoreLostMedia() async {
    try {
      final response = await _picker.retrieveLostData();
      if (!mounted || response.isEmpty) return;
      if (response.files?.isNotEmpty == true) {
        final file = response.files!.first;
        setState(() {
          _mediaAsset = null;
          _mediaFile = file;
          _isVideo = _isVideoFile(file);
        });
      }
    } catch (_) {
      // Lost-data recovery is only supported by some picker platforms.
    }
  }

  bool _isVideoFile(XFile file) {
    final name = file.name.toLowerCase();
    return name.endsWith('.mp4') ||
        name.endsWith('.mov') ||
        name.endsWith('.m4v') ||
        name.endsWith('.webm');
  }

  Future<void> _pickMedia({
    required bool video,
    ImageSource source = ImageSource.gallery,
  }) async {
    if (_picking) return;
    try {
      // Start the platform picker directly from the tap. Browser file dialogs
      // can be blocked if another UI update runs before this call.
      final Future<XFile?> selection = video
          ? _picker.pickVideo(source: source)
          : _picker.pickImage(source: source);
      _picking = true;
      final file = await selection;
      if (!mounted || file == null) return;
      setState(() {
        _mediaAsset = null;
        _mediaFile = file;
        _isVideo = video;
      });
    } on MissingPluginException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Media picker is unavailable. Fully restart the app and try again.',
            ),
          ),
        );
      }
    } on PlatformException catch (error) {
      _showPickerError(error.message ?? error.code);
    } catch (error, stackTrace) {
      debugPrint('Media picker failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showPickerError('Could not open your media. Please try again.');
    } finally {
      _picking = false;
    }
  }

  void _showPickerError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final caption = _textController.text.trim();
    if (caption.isEmpty && _mediaAsset == null && _mediaFile == null) return;
    await ref
        .read(createPostControllerProvider.notifier)
        .createPost(
          caption: caption.isEmpty ? null : caption,
          media: _mediaFile,
          mediaType: _mediaFile == null
              ? null
              : (_isVideo ? 'video' : 'image'),
        );
    if (!mounted) return;
    final result = ref.read(createPostControllerProvider);
    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not publish post: ${result.error}')),
      );
      return;
    }
    context.go(AppRoutes.feeds);
  }

  @override
  Widget build(BuildContext context) {
    final isPublishing = ref.watch(createPostControllerProvider).isLoading;
    final canPost =
        !isPublishing &&
        (_textController.text.trim().isNotEmpty ||
            _mediaAsset != null ||
            _mediaFile != null);
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _header(canPost, isPublishing),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                            'lib/assets/images/member.png',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'iam.culer',
                                style: TextStyle(
                                  color: _ink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(
                                    Iconsax.global,
                                    color: AppColors.blaugranaBlue,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Public post',
                                    style: TextStyle(
                                      color: AppColors.blaugranaBlue.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onChanged: (_) => setState(() {}),
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        maxLength: 500,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 16,
                          height: 1.45,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'What’s happening, Culer?',
                          hintStyle: TextStyle(
                            color: Color(0xFF8794A5),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_mediaAsset != null || _mediaFile != null)
                      _attachedMedia(height: keyboardOpen ? 80 : 145),
                  ],
                ),
              ),
            ),
            _mediaPicker(keyboardOpen: keyboardOpen),
            _footer(keyboardOpen),
          ],
        ),
      ),
    );
  }

  Widget _header(bool canPost, bool isPublishing) => Container(
    height: 64,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: _line)),
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Close',
          onPressed: () => context.pop(),
          icon: const Icon(Iconsax.arrow_left_3, size: 23, color: _ink),
        ),
        const SizedBox(width: 5),
        Text(
          'Create post',
          style: GoogleFonts.oswald(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 38,
          child: FilledButton(
            onPressed: canPost ? _publish : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blaugranaBlue,
              disabledBackgroundColor: const Color(0xFFB8C7D8),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 21),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isPublishing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
    ),
  );

  Widget _attachedMedia({required double height}) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: _mediaFile != null
                ? UploadedMedia(
                    file: _mediaFile!,
                    isVideo: _isVideo,
                    playVideo: _isVideo,
                  )
                : Image.asset(_mediaAsset!, fit: BoxFit.cover),
          ),
        ),
        if (_isVideo && _mediaFile == null)
          const Positioned.fill(
            child: Center(
              child: Icon(Iconsax.play_circle, color: Colors.white, size: 42),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton.filled(
            tooltip: 'Remove attachment',
            onPressed: () => setState(() {
              _mediaAsset = null;
              _mediaFile = null;
              _isVideo = false;
            }),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xB8000000),
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Iconsax.close_circle, size: 19),
          ),
        ),
      ],
    ),
  );

  Widget _mediaPicker({required bool keyboardOpen}) => Container(
    height: keyboardOpen ? 64 : 160,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: _line)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
          child: Row(
            children: [
              _pickButton(
                Iconsax.gallery,
                'Photo',
                () => _pickMedia(video: false),
              ),
              const SizedBox(width: 10),
              _pickButton(
                Iconsax.video,
                'Video',
                () => _pickMedia(video: true),
              ),
              const SizedBox(width: 10),
              if (kIsWeb ||
                  defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS)
                _pickButton(
                  Iconsax.camera,
                  'Camera',
                  () => _pickMedia(video: false, source: ImageSource.camera),
                ),
            ],
          ),
        ),
        if (!keyboardOpen)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Text(
              'Choose a photo or video from your device to attach it.',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          ),
      ],
    ),
  );

  Widget _pickButton(IconData icon, String label, VoidCallback onTap) =>
      OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blaugranaBlue,
          side: const BorderSide(color: _line),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          minimumSize: const Size(0, 34),
        ),
      );

  Widget _footer(bool keyboardOpen) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: _line)),
    ),
    child: Row(
      children: [
        const Icon(Iconsax.message, color: AppColors.blaugranaBlue, size: 17),
        const SizedBox(width: 8),
        const Text(
          'Everyone can reply',
          style: TextStyle(
            color: AppColors.blaugranaBlue,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '${_textController.text.length}/500',
          style: const TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ),
  );
}
