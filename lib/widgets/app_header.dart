import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../theme/app_theme.dart';
import '../utils/liquid_ui.dart';
import 'language_selector.dart';
import 'quote_dialog.dart';
import '../services/language_service.dart';

/// Product catalog shown in the header dropdown & mobile drawer.
/// Centralized here so both surfaces always stay in sync.


class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(88.0);

  static Future<void> openBrochure() async {
    final Uri url = Uri.parse('/amar_foods_brochure.pdf');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }

  void _navigateTo(BuildContext context, String routeName) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    Navigator.pushNamed(context, routeName);
  }

  void _showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LanguageItem>(
      valueListenable: LanguageService.instance.currentLanguage,
      builder: (context, _, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobileHeader = constraints.maxWidth < 1040;
            final bool isCompactMobile = constraints.maxWidth < 680;
            final double outerMarginH = isCompactMobile
                ? 10.0
                : LiquidUI.fluid(context, minVal: 12, maxVal: 32);
            final double outerMarginV = isCompactMobile
                ? 6.0
                : LiquidUI.fluid(context, minVal: 8, maxVal: 16);
            final double innerPaddingH = isCompactMobile
                ? 10.0
                : LiquidUI.fluid(context, minVal: 14, maxVal: 28);
            final double logoHeight = isCompactMobile
                ? 34.0
                : LiquidUI.fluid(context, minVal: 36, maxVal: 46);

            return Container(
              color: Colors.transparent, // outer breathing room around the floating pill
              padding: EdgeInsets.symmetric(horizontal: outerMarginH, vertical: outerMarginV),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlass,
                  borderRadius: BorderRadius.circular(30), // 30px on both corners
                  border: Border.all(color: AppColors.borderGlass, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGlow.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: innerPaddingH,
                  vertical: isCompactMobile ? 6 : 8,
                ),
                child: isMobileHeader
                    ? _buildMobileRow(context, logoHeight, constraints)
                    : _buildDesktopRow(context, logoHeight),
              ),
            );
          },
        );
      },
    );
  }

  // Desktop: logo | nav (flex-centered) | CTA — cleanly bounded without right-side clipping
  Widget _buildDesktopRow(BuildContext context, double logoHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogo(context, logoHeight),
        const SizedBox(width: 14),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavLink(context, LanguageService.instance.tr('nav_home'), '/'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 12, maxVal: 22)),
                  _buildNavLink(context, LanguageService.instance.tr('nav_about'), '/about'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 12, maxVal: 22)),
                  _buildNavLink(context, LanguageService.instance.tr('nav_products'), '/products'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 12, maxVal: 22)),
                  _buildNavLink(context, LanguageService.instance.tr('nav_gallery'), '/gallery'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 12, maxVal: 22)),
                  _buildNavLink(context, LanguageService.instance.tr('nav_contact'), '/contact'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LanguageSelectorButton(isMobile: false),
            const SizedBox(width: 8),
            _buildBrochureButton(context),
            const SizedBox(width: 8),
            _buildQuoteButton(context),
          ],
        ),
      ],
    );
  }

  // Mobile / Tablet Row: perfectly responsive without horizontal overflow
  Widget _buildMobileRow(BuildContext context, double logoHeight, BoxConstraints constraints) {
    final double availWidth = constraints.maxWidth;
    final bool isTablet = availWidth >= 680;
    final bool showFullQuote = availWidth >= 370;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: _buildLogo(context, logoHeight),
        ),
        const SizedBox(width: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LanguageSelectorButton(isMobile: true),
            if (isTablet) ...[
              const SizedBox(width: 8),
              _buildBrochureButtonMobile(context),
            ],
            const SizedBox(width: 6),
            _buildQuoteButtonMobile(context, showFullText: showFullQuote),
            const SizedBox(width: 6),
            _buildMobileMenuButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteButtonMobile(BuildContext context, {required bool showFullText}) {
    return ElevatedButton(
      onPressed: () => _showQuoteDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: showFullText ? 11 : 8,
          vertical: 7,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        shadowColor: AppColors.secondaryGlow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 14, color: Colors.white),
          if (showFullText) ...[
            const SizedBox(width: 3),
            Text(
              LanguageService.instance.tr('btn_quote_short'),
              style: GoogleFonts.outfit(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBrochureButtonMobile(BuildContext context) {
    return ElevatedButton(
      onPressed: openBrochure,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.file_download_outlined, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            LanguageService.instance.tr('btn_brochure'),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            borderRadius: BorderRadius.circular(12),
            splashColor: AppColors.primary.withValues(alpha: 0.15),
            highlightColor: AppColors.primary.withValues(alpha: 0.08),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.22),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildLogo(BuildContext context, double logoHeight) {
    return GestureDetector(
      onTap: () => _navigateTo(context, '/'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Image.asset(
          AppImages.logo,
          height: logoHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return LiquidUI.gradientText(
              'Amar Foods',
              gradient: AppColors.primaryGradient,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrochureButton(BuildContext context) {
    return ElevatedButton(
      onPressed: openBrochure,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: LiquidUI.fluidPaddingSymmetric(
          context,
          minHorizontal: 12,
          maxHorizontal: 18,
          minVertical: 10,
          maxVertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // 30px radius, matching header & quote button
        ),
        elevation: 4,
        shadowColor: AppColors.primaryGlow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.file_download_outlined,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            LanguageService.instance.tr('btn_brochure'),
            style: TextStyle(
              fontFamily: AppTheme.outfitFont,
              fontWeight: FontWeight.bold,
              fontSize: LiquidUI.fluid(context, minVal: 12.5, maxVal: 14),
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // Request Quote CTA — 30px radius, LiquidUI fluid padding/font, text ONLY (no icon)
  Widget _buildQuoteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showQuoteDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        padding: LiquidUI.fluidPaddingSymmetric(
          context,
          minHorizontal: 16,
          maxHorizontal: 22,
          minVertical: 10,
          maxVertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // 30px radius, matches header
        ),
        elevation: 4,
        shadowColor: AppColors.secondaryGlow,
      ),
      child: Text(
        LanguageService.instance.tr('btn_quote'),
        style: TextStyle(
          fontFamily: AppTheme.outfitFont,
          fontWeight: FontWeight.bold,
          fontSize: LiquidUI.fluid(context, minVal: 12.5, maxVal: 14),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // Nav link with a hover/active underline accent instead of a filled pill —
  // reads calmer against the glass header and is the one motion moment in the bar.
  Widget _buildNavLink(BuildContext context, String title, String routeName) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final bool isActive = currentRoute == routeName;
    final double textFontSize = LiquidUI.fluid(context, minVal: 13, maxVal: 15);

    return _HoverRegion(
      builder: (hovering) {
        final bool showAccent = isActive || hovering;
        return GestureDetector(
          onTap: () => _navigateTo(context, routeName),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: LiquidUI.fluid(context, minVal: 4, maxVal: 6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTheme.outfitFont,
                    color: showAccent ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: textFontSize,
                  ),
                ),
                SizedBox(height: LiquidUI.fluid(context, minVal: 3, maxVal: 5)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: 2,
                  width: showAccent ? textFontSize * 1.5 : 0,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}

// Tracks hover state and hands it to the builder — shared by nav links and
// the Products trigger so the underline accent behaves identically for both.
class _HoverRegion extends StatefulWidget {
  final Widget Function(bool hovering) builder;
  const _HoverRegion({required this.builder});

  @override
  State<_HoverRegion> createState() => _HoverRegionState();
}

class _HoverRegionState extends State<_HoverRegion> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: widget.builder(_hovering),
    );
  }
}

// Drawer Widget for Mobile (Slides out smoothly from the Right Side)
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    Navigator.pushNamed(context, routeName);
  }

  void _showQuoteDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      width: 310,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Clean High-Contrast Header Section inside Drawer
            Container(
              padding: const EdgeInsets.fromLTRB(20, 44, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24)),
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withOpacity(0.12)),
                        ),
                        child: Image.asset(
                          AppImages.logo,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return LiquidUI.gradientText(
                              'Amar Foods',
                              gradient: AppColors.primaryGradient,
                              style: GoogleFonts.playfairDisplay(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: AppColors.primary, size: 22),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: 'Close Menu',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'EXPORT DEHYDRATED SPICES',
                          style: GoogleFonts.outfit(
                            color: AppColors.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Drawer Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    title: LanguageService.instance.tr('nav_home'),
                    subtitle: 'Amar Foods Mahuva',
                    icon: Icons.home_rounded,
                    routeName: '/',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: LanguageService.instance.tr('nav_about'),
                    subtitle: 'Plant & Heritage',
                    icon: Icons.factory_rounded,
                    routeName: '/about',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: LanguageService.instance.tr('nav_products'),
                    subtitle: 'Dehydrated Onion & Garlic',
                    icon: Icons.eco_rounded,
                    routeName: '/products',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: LanguageService.instance.tr('nav_gallery'),
                    subtitle: 'Facility & Processing',
                    icon: Icons.photo_library_rounded,
                    routeName: '/gallery',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: LanguageService.instance.tr('nav_contact'),
                    subtitle: 'Direct Export Desk',
                    icon: Icons.support_agent_rounded,
                    routeName: '/contact',
                    currentRoute: currentRoute,
                  ),
                ],
              ),
            ),

            // Footer Section inside Drawer
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFD),
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                children: [
                  // Download Brochure
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: AppHeader.openBrochure,
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 17, color: AppColors.primary),
                      label: Text(
                        LanguageService.instance.tr('btn_brochure'),
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.35), width: 1.3),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Request Quote
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () => _showQuoteDialog(context),
                      icon: const Icon(Icons.request_quote_rounded, size: 18),
                      label: Text(
                        LanguageService.instance.tr('btn_quote'),
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        shadowColor: AppColors.secondaryGlow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Direct Quick Contact Strip (WhatsApp & Phone)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchExternal('https://wa.me/917284088737'),
                          icon: const Icon(Icons.chat_bubble_rounded, size: 14, color: Color(0xFF25D366)),
                          label: Text(
                            'WhatsApp',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E7E34),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F8EE),
                            side: const BorderSide(color: Color(0xFF8CE3A7), width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchExternal('tel:+917284088737'),
                          icon: const Icon(Icons.phone_in_talk_rounded, size: 14, color: AppColors.primary),
                          label: Text(
                            'Call Direct',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.25), width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 13, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Mahuva - 364290, Gujarat, India',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchExternal(String urlStr) async {
    final Uri url = Uri.parse(urlStr);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String routeName,
    required String? currentRoute,
  }) {
    final bool isSelected = currentRoute == routeName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          tileColor: isSelected ? AppColors.primaryLight : Colors.transparent,
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontSize: 14.5,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isSelected ? AppColors.primary.withValues(alpha: 0.8) : AppColors.textSecondary,
            ),
          ),
          trailing: isSelected
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                )
              : const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textSecondary),
          onTap: () => _navigateTo(context, routeName),
        ),
      ),
    );
  }

}