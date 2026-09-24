import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'shining_gradient_button.dart';

/// ============================================================================
/// AMAR FOODS DESIGN SYSTEM — 3-TIER BUTTON ARCHITECTURE
///
/// Tier 1: AmarPrimaryButton
///         Primary high-conversion CTAs (Quote, Main Inquiry, Primary Hero).
///         Features: Logo Gradient (#A64787 -> #009846), 8px radius,
///         diagonal specular light sweep, hover elevation & glow.
///
/// Tier 2: AmarSecondaryButton
///         Supporting actions (Brochure, Contact Desk, Specs, B2B Meeting).
///         Features: Frosted Glass UI, crisp border, illuminated halo bloom
///         on hover, smooth scale lift, brand colored accent.
///
/// Tier 3: AmarFilterChip
///         Interactive filtering, quick tabs, & compact actions.
///         Features: Micro-scale hover, active brand fill, 8px radius.
/// ============================================================================

/// TIER 1: PRIMARY HERO GLASS SHINE BUTTON
class AmarPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final bool enableShine;
  final double? width;

  const AmarPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    this.fontSize = 14.5,
    this.enableShine = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: fontSize + 2.5, color: Colors.white),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );

    final btn = ShiningGradientButton(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(8),
      padding: padding,
      enableShine: enableShine,
      gradient: const LinearGradient(
        colors: [Color(0xFFA64787), Color(0xFF009846)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: content,
    );

    if (width != null) {
      return SizedBox(width: width, child: btn);
    }
    return btn;
  }
}

/// TIER 2: SECONDARY FROSTED GLASS GLOW BUTTON
class AmarSecondaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final bool isDarkSurface;
  final Color? customAccent;
  final double? width;

  const AmarSecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    this.fontSize = 14,
    this.isDarkSurface = false,
    this.customAccent,
    this.width,
  });

  @override
  State<AmarSecondaryButton> createState() => _AmarSecondaryButtonState();
}

class _AmarSecondaryButtonState extends State<AmarSecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.customAccent ??
        (widget.isDarkSurface ? Colors.white : AppColors.primary);

    final Color bgColor = widget.isDarkSurface
        ? (_isHovered
            ? Colors.white.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.10))
        : (_isHovered
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.white);

    final Color borderColor = widget.isDarkSurface
        ? (_isHovered ? Colors.white : Colors.white.withValues(alpha: 0.70))
        : (_isHovered ? AppColors.primary : const Color(0xFFCBD5E1));

    final List<BoxShadow> shadows = _isHovered
        ? [
            BoxShadow(
              color: widget.isDarkSurface
                  ? Colors.white.withValues(alpha: 0.25)
                  : accent.withValues(alpha: 0.20),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ];

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          AnimatedScale(
            scale: _isHovered ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: Icon(widget.icon, size: widget.fontSize + 2.5, color: accent),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
            color: accent,
            letterSpacing: 0.2,
          ),
        ),
        if (widget.trailing != null) ...[
          const SizedBox(width: 8),
          widget.trailing!,
        ],
      ],
    );

    Widget btn = MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered && widget.onPressed != null ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.4),
            boxShadow: shadows,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(8),
              splashColor: accent.withValues(alpha: 0.15),
              highlightColor: accent.withValues(alpha: 0.08),
              child: Padding(
                padding: widget.padding,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: btn);
    }
    return btn;
  }
}

/// TIER 3: GLASS FILTER CHIP / COMPACT ACTION BUTTON
class AmarFilterChip extends StatefulWidget {
  final bool isSelected;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? activeColor;

  const AmarFilterChip({
    super.key,
    required this.isSelected,
    required this.label,
    this.icon,
    required this.onTap,
    this.activeColor,
  });

  @override
  State<AmarFilterChip> createState() => _AmarFilterChipState();
}

class _AmarFilterChipState extends State<AmarFilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color active = widget.activeColor ?? AppColors.primary;

    Color bg;
    Color border;
    Color text;

    if (widget.isSelected) {
      bg = active;
      border = active;
      text = Colors.white;
    } else if (_isHovered) {
      bg = active.withValues(alpha: 0.10);
      border = active.withValues(alpha: 0.40);
      text = active;
    } else {
      bg = const Color(0xFFF8FAFC);
      border = const Color(0xFFE2E8F0);
      text = const Color(0xFF334155);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 1.2),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: active.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 14, color: text),
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.label,
                  style: GoogleFonts.outfit(
                    color: text,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
