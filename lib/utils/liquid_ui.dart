import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

import '../theme/app_theme.dart';

/// A utility class implementing custom "Liquid UI" in Flutter without external libraries.
/// Fluid calculations smoothly scale sizes, margins, padding, and typography continuously 
/// relative to the viewport width.
class LiquidUI {
  /// Returns the screen width.
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  /// Returns the screen height.
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  /// Viewport Breakpoints (Updated to 900px for flawless mobile responsiveness)
  static bool isMobile(BuildContext context) => width(context) < 900;
  static bool isTablet(BuildContext context) => width(context) >= 900 && width(context) < 1100;
  static bool isDesktop(BuildContext context) => width(context) >= 1100;

  /// Dynamically scales a value based on the screen width.
  static double fluid(
    BuildContext context, {
    required double minVal,
    required double maxVal,
    double minWidth = 375,
    double maxWidth = 1440,
  }) {
    final double w = width(context);
    if (w <= minWidth) return minVal;
    if (w >= maxWidth) return maxVal;
    return minVal + (maxVal - minVal) * ((w - minWidth) / (maxWidth - minWidth));
  }

  /// Convenience method for fluid EdgeInsets.all
  static EdgeInsets fluidPaddingAll(BuildContext context, double minVal, double maxVal) {
    final val = fluid(context, minVal: minVal, maxVal: maxVal);
    return EdgeInsets.all(val);
  }

  /// Convenience method for fluid symmetric padding
  static EdgeInsets fluidPaddingSymmetric(
    BuildContext context, {
    double minHorizontal = 0,
    double maxHorizontal = 0,
    double minVertical = 0,
    double maxVertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: fluid(context, minVal: minHorizontal, maxVal: maxHorizontal),
      vertical: fluid(context, minVal: minVertical, maxVal: maxVertical),
    );
  }

  /// Maximum constraints wrapper for responsive web layouts.
  static BoxConstraints pageConstraints() {
    return const BoxConstraints(maxWidth: 1200);
  }

  /// Creates a gradient text widget.
  static Widget gradientText(
    String text, {
    required Gradient gradient,
    required TextStyle style,
    TextAlign textAlign = TextAlign.left,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: textAlign,
        style: style,
      ),
    );
  }

  /// Creates a glassmorphic styled card container.
  static Widget glassCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    Color backgroundColor = AppColors.surfaceGlass,
    Color borderColor = AppColors.border,
    List<BoxShadow>? shadows,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: shadows ?? [
          BoxShadow(
            color: AppColors.primaryGlow.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Creates a styled pill badge widget.
  static Widget badgePill({
    required String text,
    IconData? icon,
    Color backgroundColor = AppColors.secondaryLight,
    Color textColor = AppColors.secondary,
    double fontSize = 13,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: textColor.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: fontSize + 2),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTheme.outfitFont,
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Interactive Hover Glass Card with smooth scale & elevation shift
  static Widget interactiveGlassCard({
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 20,
    Color backgroundColor = Colors.white,
    Color borderColor = AppColors.border,
  }) {
    return _InteractiveCardWrapper(
      onTap: onTap,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: child,
    );
  }
}

class _InteractiveCardWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;

  const _InteractiveCardWrapper({
    required this.child,
    required this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColors.border,
  });

  @override
  State<_InteractiveCardWrapper> createState() => _InteractiveCardWrapperState();
}

class _InteractiveCardWrapperState extends State<_InteractiveCardWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(24),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -6, 0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered
                  ? AppColors.secondary.withOpacity(0.6)
                  : widget.borderColor,
              width: _isHovered ? 1.8 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.secondaryGlow.withOpacity(0.2)
                    : AppColors.primaryGlow.withOpacity(0.06),
                blurRadius: _isHovered ? 28 : 16,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
