import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Modern Flutter Web APIs — compatible with iOS Safari, CanvasKit & HTML renderer
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class VideoBackground extends StatefulWidget {
  final String videoPath;
  const VideoBackground({super.key, required this.videoPath});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'hero-video-bg-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      // Register native HTML5 video element using package:web (iOS-safe)
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) {
          final video = web.document.createElement('video') as web.HTMLVideoElement;

          // iOS Safari requires these attributes for inline autoplay
          video.autoplay = true;
          video.loop = true;
          video.muted = true;
          video.setAttribute('playsinline', 'true');
          video.setAttribute('webkit-playsinline', 'true'); // older iOS Safari
          video.style.width = '100%';
          video.style.height = '100%';
          video.style.objectFit = 'cover';
          video.style.pointerEvents = 'none';

          // Fallback sources to guarantee asset path resolution on Flutter Web
          final filename = widget.videoPath.split('/').last;

          final s1 = web.document.createElement('source') as web.HTMLSourceElement;
          s1.src = 'assets/${widget.videoPath}';
          video.appendChild(s1);

          final s2 = web.document.createElement('source') as web.HTMLSourceElement;
          s2.src = widget.videoPath;
          video.appendChild(s2);

          final s3 = web.document.createElement('source') as web.HTMLSourceElement;
          s3.src = 'assets/images/$filename';
          video.appendChild(s3);

          final s4 = web.document.createElement('source') as web.HTMLSourceElement;
          s4.src = filename;
          video.appendChild(s4);

          // Fire-and-forget autoplay; browser handles autoplay policy
          video.play().toDart.ignore();

          return video;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlElementView(viewType: _viewId);
    }

    // Fallback dark container for non-web environments
    return Container(
      color: const Color(0xFF16161D),
    );
  }
}
