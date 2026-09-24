import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Recipe A Standardized Interactive Card System for Amar Foods
/// Implements:
/// - Floating Lift (-6px to -8px) with smooth Curves.easeOutCubic
/// - Illuminating Brand Border Glow (Plum & Foods Green)
/// - Multi-layered Depth Shadow (Ambient + Brand Glow Halo)
/// - Optional Specular Frosted Glass Sheen traversal on hover
/// - Child or `builder(context, isHovered)` for smooth inner image zoom & micro-interactions
class AmarHoverCard extends StatefulWidget {
  final Widget? child;
  final Widget Function(BuildContext context, bool isHovered)? builder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color backgroundColor;
  final Color? hoverBackgroundColor;
  final Color borderColor;
  final Color? hoverBorderColor;
  final double liftDistance;
  final bool isDarkSurface;
  final bool showGlow;
  final bool showSheen;
  final Clip clipBehavior;

  const AmarHoverCard({
    super.key,
    this.child,
    this.builder,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 22,
    this.backgroundColor = Colors.white,
    this.hoverBackgroundColor,
    this.borderColor = AppColors.borderGlass,
    this.hoverBorderColor,
    this.liftDistance = 7.0,
    this.isDarkSurface = false,
    this.showGlow = true,
    this.showSheen = false,
    this.clipBehavior = Clip.antiAlias,
  }) : assert(child != null || builder != null, 'Either child or builder must be provided');

  @override
  State<AmarHoverCard> createState() => _AmarHoverCardState();
}

class _AmarHoverCardState extends State<AmarHoverCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _sheenController;
  late Animation<double> _sheenAnimation;

  @override
  void initState() {
    super.initState();
    _sheenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _sheenAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _sheenController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sheenController.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _isHovered = true);
    if (widget.showSheen) {
      _sheenController.forward(from: 0.0);
    }
  }

  void _onExit() {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHoverBorder = widget.hoverBorderColor ??
        (widget.isDarkSurface
            ? AppColors.secondary.withValues(alpha: 0.55)
            : AppColors.primary.withValues(alpha: 0.45));

    final effectiveHoverBg = widget.hoverBackgroundColor ??
        (widget.isDarkSurface
            ? const Color(0xFF222434)
            : widget.backgroundColor);

    final List<BoxShadow> shadows;
    if (widget.isDarkSurface) {
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isHovered ? 0.45 : 0.25),
          blurRadius: _isHovered ? 26 : 14,
          offset: Offset(0, _isHovered ? 12 : 5),
        ),
        if (_isHovered && widget.showGlow)
          BoxShadow(
            color: AppColors.secondaryGlow.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 4),
          ),
      ];
    } else {
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isHovered ? 0.09 : 0.04),
          blurRadius: _isHovered ? 28 : 16,
          offset: Offset(0, _isHovered ? 12 : 5),
        ),
        if (_isHovered && widget.showGlow)
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.16),
            blurRadius: 22,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
      ];
    }

    final content = widget.builder != null
        ? widget.builder!(context, _isHovered)
        : widget.child!;

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          margin: widget.margin,
          transform: Matrix4.translationValues(
            0,
            _isHovered ? -widget.liftDistance : 0.0,
            0,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? effectiveHoverBg : widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered ? effectiveHoverBorder : widget.borderColor,
              width: _isHovered ? 1.7 : 1.2,
            ),
            boxShadow: shadows,
          ),
          clipBehavior: widget.clipBehavior,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: widget.padding ?? EdgeInsets.zero,
                child: content,
              ),

              // Specular light sheen highlight if enabled
              if (widget.showSheen)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _sheenAnimation,
                      builder: (context, _) {
                        if (!_isHovered && _sheenController.isDismissed) {
                          return const SizedBox.shrink();
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: FractionallySizedBox(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: ShaderMask(
                              shaderCallback: (bounds) {
                                final double shift = _sheenAnimation.value;
                                return LinearGradient(
                                  begin: Alignment(-1.5 + shift, -1.0),
                                  end: Alignment(-0.5 + shift, 1.0),
                                  stops: const [0.0, 0.45, 0.55, 1.0],
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.20),
                                    Colors.white.withValues(alpha: 0.20),
                                    Colors.transparent,
                                  ],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcOver,
                              child: Container(color: Colors.transparent),
                            ),
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
    );
  }
}

/// Smooth Ken-Burns Image Zoom Helper for Product/Expo/Photo Cards
class AmarCardImageZoom extends StatelessWidget {
  final Widget child;
  final bool isHovered;
  final double scale;
  final Duration duration;

  const AmarCardImageZoom({
    super.key,
    required this.child,
    required this.isHovered,
    this.scale = 1.06,
    this.duration = const Duration(milliseconds: 320),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isHovered ? scale : 1.0,
      duration: duration,
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}

/// Animated popping/scale icon for cards
class AmarCardIconPop extends StatelessWidget {
  final Widget child;
  final bool isHovered;
  final double scale;

  const AmarCardIconPop({
    super.key,
    required this.child,
    required this.isHovered,
    this.scale = 1.10,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isHovered ? scale : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      child: child,
    );
  }
}
