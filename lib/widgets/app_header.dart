import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../theme/app_theme.dart';
import '../utils/liquid_ui.dart';
import 'quote_dialog.dart';

/// Product catalog shown in the header dropdown & mobile drawer.
/// Centralized here so both surfaces always stay in sync.
class _HeaderProduct {
  final String name;
  final String tagline;
  const _HeaderProduct(this.name, this.tagline);
}

const List<_HeaderProduct> _kProducts = [
  _HeaderProduct('Dehydrated Onion', 'Golden flakes, granules & powder'),
  _HeaderProduct('Dehydrated Garlic', 'Intense aroma, minced or powdered'),
  _HeaderProduct('Fried Onion', 'Crisp, golden, ready to use'),
  _HeaderProduct('Spice Blends', 'Export-grade whole & ground spices'),
];

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(95.0);

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobileHeader = constraints.maxWidth < 960;
        final double outerMarginH = LiquidUI.fluid(context, minVal: 8, maxVal: 32);
        final double outerMarginV = LiquidUI.fluid(context, minVal: 6, maxVal: 16);
        final double innerPaddingH = LiquidUI.fluid(context, minVal: 12, maxVal: 28);
        final double logoHeight = LiquidUI.fluid(context, minVal: 32, maxVal: 46);

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
                  color: AppColors.primaryGlow.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: innerPaddingH, vertical: 8),
            child: isMobileHeader ? _buildMobileRow(context, logoHeight) : _buildDesktopRow(context, logoHeight),
          ),
        );
      },
    );
  }

  // Desktop: logo | nav (true-centered) | CTA — three equal Expanded slots so the
  // nav is centered on the header itself, not just "space between" the other two.
  Widget _buildDesktopRow(BuildContext context, double logoHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildLogo(context, logoHeight),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavLink(context, 'Home', '/'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 16, maxVal: 28)),
                  _buildNavLink(context, 'About', '/about'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 16, maxVal: 28)),
                  _buildNavLink(context, 'Products', '/products'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 16, maxVal: 28)),
                  _buildNavLink(context, 'Gallery', '/gallery'),
                  SizedBox(width: LiquidUI.fluid(context, minVal: 16, maxVal: 28)),
                  _buildNavLink(context, 'Contact', '/contact'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _buildQuoteButton(context),
          ),
        ),
      ],
    );
  }

  // Mobile: logo left, quick quote button & hamburger menu right
  Widget _buildMobileRow(BuildContext context, double logoHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogo(context, logoHeight),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _showQuoteDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 2,
              ),
              child: Text(
                'Quote',
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Builder(
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu_rounded, color: AppColors.primary, size: 26),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: 'Open Mobile Menu',
                  ),
                );
              },
            ),
          ],
        ),
      ],
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

  // Request Quote CTA — 30px radius, LiquidUI fluid padding/font, text ONLY (no icon)
  Widget _buildQuoteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showQuoteDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        padding: LiquidUI.fluidPaddingSymmetric(
          context,
          minHorizontal: 20,
          maxHorizontal: 28,
          minVertical: 12,
          maxVertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // 30px radius, matches header
        ),
        elevation: 4,
        shadowColor: AppColors.secondaryGlow,
      ),
      child: Text(
        'Request Quote',
        style: TextStyle(
          fontFamily: AppTheme.outfitFont,
          fontWeight: FontWeight.bold,
          fontSize: LiquidUI.fluid(context, minVal: 13, maxVal: 15),
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

  // Products dropdown — icon-free trigger + a proper catalog panel:
  // two-line entries (name + what it actually is), a divider, and a
  // "View all products" link instead of a bare product list.
  Widget _buildProductsDropdown(BuildContext context) {
    final double textFontSize = LiquidUI.fluid(context, minVal: 13, maxVal: 15);
    final double titleFontSize = LiquidUI.fluid(context, minVal: 13, maxVal: 14.5);
    final double taglineFontSize = LiquidUI.fluid(context, minVal: 11, maxVal: 12);
    final double panelWidth = LiquidUI.fluid(context, minVal: 240, maxVal: 280);

    return PopupMenuButton<String>(
      tooltip: '',
      offset: const Offset(0, 46),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      onSelected: (value) {
        if (value == 'all') {
          _navigateTo(context, '/products');
        } else {
          _showQuoteDialog(context);
        }
      },
      child: _HoverRegion(
        builder: (hovering) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: LiquidUI.fluid(context, minVal: 4, maxVal: 6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        color: hovering ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: textFontSize,
                      ),
                    ),
                    SizedBox(width: LiquidUI.fluid(context, minVal: 3, maxVal: 5)),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: hovering ? AppColors.primary : AppColors.textPrimary,
                      size: LiquidUI.fluid(context, minVal: 16, maxVal: 19),
                    ),
                  ],
                ),
                SizedBox(height: LiquidUI.fluid(context, minVal: 3, maxVal: 5)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: 2,
                  width: hovering ? textFontSize * 1.5 : 0,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        for (int i = 0; i < _kProducts.length; i++) ...[
          PopupMenuItem<String>(
            value: 'product_$i',
            padding: EdgeInsets.symmetric(
              horizontal: LiquidUI.fluid(context, minVal: 16, maxVal: 20),
              vertical: LiquidUI.fluid(context, minVal: 8, maxVal: 10),
            ),
            child: SizedBox(
              width: panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _kProducts[i].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: LiquidUI.fluid(context, minVal: 2, maxVal: 3)),
                  Text(
                    _kProducts[i].tagline,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: taglineFontSize,
                      color: AppColors.textPrimary.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != _kProducts.length - 1)
            const PopupMenuDivider(height: 1),
        ],
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'all',
          padding: EdgeInsets.symmetric(
            horizontal: LiquidUI.fluid(context, minVal: 16, maxVal: 20),
            vertical: LiquidUI.fluid(context, minVal: 8, maxVal: 10),
          ),
          child: SizedBox(
            width: panelWidth,
            child: Text(
              'View all products  \u2192',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: taglineFontSize + 1,
                color: AppColors.secondary,
              ),
            ),
          ),
        ),
      ],
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
            // Dark Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 48, 16, 24),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppImages.logo,
                        height: 44,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'Amar Foods',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: 'Close Menu',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: AppColors.secondaryLight, size: 12),
                        const SizedBox(width: 6),
                        Text(
                          'EXPORT DEHYDRATED SPICES',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildDrawerItem(
                    context,
                    title: 'Home',
                    icon: Icons.home_rounded,
                    routeName: '/',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'About Us',
                    icon: Icons.business_rounded,
                    routeName: '/about',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Products Portfolio',
                    icon: Icons.grid_view_rounded,
                    routeName: '/products',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Facility Gallery',
                    icon: Icons.photo_library_rounded,
                    routeName: '/gallery',
                    currentRoute: currentRoute,
                  ),
                  _buildDrawerItem(
                    context,
                    title: 'Contact & Export Inquiry',
                    icon: Icons.contact_mail_rounded,
                    routeName: '/contact',
                    currentRoute: currentRoute,
                  ),
                ],
              ),
            ),

            // Footer Section inside Drawer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFD),
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _showQuoteDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        shadowColor: AppColors.secondaryGlow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Request Export Quote',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '📍 Mahuva - 364290, Gujarat, India',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          tileColor: isSelected ? AppColors.primaryLight : Colors.transparent,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 18,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontSize: 14,
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