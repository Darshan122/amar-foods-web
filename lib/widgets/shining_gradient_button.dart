import 'package:flutter/material.dart';

/// A button that displays a linear gradient background, customizable border radius
/// (defaults to 5 as requested), hover elevation/scale, and a diagonal shining
/// light-sheen sweep animation across the surface.
class ShiningGradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool enableShine;
  final Color shineColor;
  final List<BoxShadow>? shadows;
  final Border? border;

  const ShiningGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Color(0xFFA64787), Color(0xFF009846)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    this.enableShine = true,
    this.shineColor = Colors.white,
    this.shadows,
    this.border,
  });

  @override
  State<ShiningGradientButton> createState() => _ShiningGradientButtonState();
}

class _ShiningGradientButtonState extends State<ShiningGradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    if (widget.enableShine) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShiningGradientButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableShine != oldWidget.enableShine) {
      if (widget.enableShine) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> defaultShadows = widget.shadows ??
        [
          BoxShadow(
            color: const Color(0xFFA64787).withValues(alpha: _isHovered ? 0.35 : 0.18),
            blurRadius: _isHovered ? 12 : 6,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: const Color(0xFF009846).withValues(alpha: _isHovered ? 0.30 : 0.15),
            blurRadius: _isHovered ? 12 : 6,
            offset: const Offset(1, 2),
          ),
        ];

    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered && widget.onPressed != null ? 1.035 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: defaultShadows,
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: widget.borderRadius,
                border: widget.border ??
                    Border.all(
                      color: Colors.white.withValues(alpha: _isHovered ? 0.40 : 0.22),
                      width: 1.0,
                    ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: widget.borderRadius,
                  splashColor: Colors.white.withValues(alpha: 0.18),
                  highlightColor: Colors.white.withValues(alpha: 0.08),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: widget.padding,
                        child: widget.child,
                      ),
                      if (widget.enableShine)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, _) {
                                final double t = _controller.value;
                                double sweepProgress = 2.0; // default off-screen (idle)

                                // 0.0 to 0.40 is the active shine sweep (~1.28s)
                                // 0.40 to 1.0 is idle pause (~1.92s)
                                if (t <= 0.40) {
                                  final double norm = t / 0.40;
                                  sweepProgress = Curves.easeInOutCubic.transform(norm);
                                }

                                return CustomPaint(
                                  painter: _ShinePainter(
                                    progress: sweepProgress,
                                    borderRadius: widget.borderRadius,
                                    shineColor: widget.shineColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShinePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 when active, > 1.0 when idle/off-screen
  final BorderRadius borderRadius;
  final Color shineColor;

  _ShinePainter({
    required this.progress,
    required this.borderRadius,
    required this.shineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.0 || progress > 1.0) return;

    final RRect rrect = borderRadius.toRRect(Offset.zero & size);
    canvas.save();
    canvas.clipRRect(rrect);

    // Diagonal angle: ~0.35 radians (~20 degrees tilt) matching reference image
    const double angle = 0.35;
    const double barWidth = 36.0;
    final double barHeight = size.height * 3.5;

    // Sweep from left off-screen to right off-screen
    const double startX = -barWidth * 1.6;
    final double endX = size.width + (barWidth * 1.6);
    final double currentX = startX + (endX - startX) * progress;

    canvas.translate(currentX, size.height / 2);
    canvas.rotate(angle);

    final Rect barRect = Rect.fromCenter(
      center: Offset.zero,
      width: barWidth,
      height: barHeight,
    );

    final Paint shinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          shineColor.withValues(alpha: 0.0),
          shineColor.withValues(alpha: 0.20),
          shineColor.withValues(alpha: 0.60),
          shineColor.withValues(alpha: 0.20),
          shineColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.30, 0.50, 0.70, 1.0],
      ).createShader(barRect)
      ..blendMode = BlendMode.screen;

    canvas.drawRect(barRect, shinePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
