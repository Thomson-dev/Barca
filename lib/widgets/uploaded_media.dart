import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

import 'video_controller_factory_web.dart'
    if (dart.library.io) 'video_controller_factory_io.dart'
    as video_factory;

/// Displays media selected from the device. Videos play when [playVideo] is true.
class UploadedMedia extends StatelessWidget {
  const UploadedMedia({
    super.key,
    required this.file,
    required this.isVideo,
    this.fit = BoxFit.cover,
    this.playVideo = false,
  });

  final XFile file;
  final bool isVideo;
  final BoxFit fit;
  final bool playVideo;

  @override
  Widget build(BuildContext context) {
    if (isVideo) {
      if (playVideo &&
          (kIsWeb ||
              defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        return _PlayableVideo(file: file);
      }
      return const ColoredBox(
        color: Color(0xFF17273D),
        child: Center(
          child: Icon(Iconsax.video_play, color: Colors.white, size: 36),
        ),
      );
    }
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Icon(Iconsax.image, color: Colors.grey));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        return Image.memory(
          snapshot.data!,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}

class _PlayableVideo extends StatefulWidget {
  const _PlayableVideo({required this.file});

  final XFile file;

  @override
  State<_PlayableVideo> createState() => _PlayableVideoState();
}

class _PlayableVideoState extends State<_PlayableVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initialize;

  @override
  void initState() {
    super.initState();
    _setFile();
  }

  void _setFile() {
    _controller = video_factory.controllerForPickedVideo(widget.file);
    _initialize = _controller.initialize();
  }

  @override
  void didUpdateWidget(covariant _PlayableVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _controller.dispose();
      _setFile();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _initialize,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const ColoredBox(
          color: Color(0xFF17273D),
          child: Center(child: Icon(Iconsax.video_play, color: Colors.white)),
        );
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const ColoredBox(
          color: Color(0xFF17273D),
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      }
      return Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          Center(
            child: IconButton.filled(
              tooltip: _controller.value.isPlaying
                  ? 'Pause video'
                  : 'Play video',
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: const Color(0x99000000),
              ),
              icon: Icon(
                _controller.value.isPlaying ? Iconsax.pause : Iconsax.play,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}
