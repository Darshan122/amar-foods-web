import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Imports for Flutter Web HTML video rendering
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

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
      // Register native HTML5 video element for web rendering
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) {
          final video = html.VideoElement()
            ..autoplay = true
            ..loop = true
            ..muted = true
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'cover'
            ..style.pointerEvents = 'none'
            ..setAttribute('playsinline', 'true');

          // Fallback sources to guarantee asset path resolution on Flutter Web
          final filename = widget.videoPath.split('/').last;
          video.append(html.SourceElement()..src = 'assets/${widget.videoPath}');
          video.append(html.SourceElement()..src = widget.videoPath);
          video.append(html.SourceElement()..src = 'assets/images/$filename');
          video.append(html.SourceElement()..src = filename);

          video.play();
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
