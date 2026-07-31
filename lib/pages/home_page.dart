import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../theme/app_theme.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';
import '../widgets/video_background.dart';
import '../widgets/product_detail_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';

  void _showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section with Video Background
            _buildVideoHeroSection(context, isMobile),

            // 2. Floating Stats Bar (Paints OVER Video Hero and About Section without clipping)
            _buildFloatingStatsSection(context, isMobile),

            // 3. "About Amar Foods" Section (Product Photo on Left, Story on Right)
            _buildAboutAmarSection(context, isMobile),

            // 4. "Our Vision" Quote Card Section (Inspired by Vision Reference)
            _buildVisionQuoteSection(context, isMobile),

            // 5. Interactive "Our Product Range" Showcase with Category Filter Tabs
            _buildProductRangeSection(context, isMobile),

            // 6. "Why Choose Amar Foods" Core Value Pillars Grid
            _buildWhyChooseUsSection(context, isMobile),

            // 7. Farm-to-Shipment Journey Process Timeline
            _buildProcessTimelineSection(context, isMobile),

            // 8. "Our Promise" Quality Control Sanctuary & Certifications
            // _buildQualityPromiseSection(context, isMobile),

            // 9. International Accreditation & Quality Certifications Section
            _buildCertificationsSection(context, isMobile),

            // 10. Global Export Footprint & Network
            // _buildGlobalFootprintSection(context, isMobile),

            // 8. Ready to Source Bottom CTA Banner
            _buildCtaBannerSection(context, isMobile),

            // Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // 1. Hero Section
  Widget _buildVideoHeroSection(BuildContext context, bool isMobile) {
    final double sectionPaddingV = LiquidUI.fluid(context, minVal: 60, maxVal: 100);
    final double sectionPaddingH = LiquidUI.fluid(context, minVal: 16, maxVal: 40);
    final double titleSize = LiquidUI.fluid(context, minVal: 36, maxVal: 62);
    final double descSize = LiquidUI.fluid(context, minVal: 14, maxVal: 17);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Video Stack
        SizedBox(
          width: double.infinity,
          height: isMobile ? 660 : 620,
          child: const Stack(
            children: [
              Positioned.fill(
                child: VideoBackground(
                  videoPath: 'assets/images/in_this_add_last_this_logo_and.mp4',
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xEE16161D),
                        Color(0xB316161D),
                        Color(0xF516161D),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hero Text Layer
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              left: sectionPaddingH,
              right: sectionPaddingH,
              top: sectionPaddingV,
              bottom: isMobile ? 40 : 80,
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _buildHeroVideoText(context, titleSize, descSize, isMobile),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroVideoText(BuildContext context, double titleSize, double descSize, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Live Pulse Badge Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.secondary.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryGlow.withOpacity(0.2),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'DIRECT FROM MAHUVA • EXPORTING TO 15+ NATIONS',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Amar Foods',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: titleSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
            letterSpacing: -0.5,
            shadows: const [
              Shadow(color: Colors.black, blurRadius: 16, offset: Offset(0, 4)),
            ],
          ),
        ),
        const SizedBox(height: 8),

        LiquidUI.gradientText(
          'Premium Dehydrated Foods & Spices',
          gradient: const LinearGradient(
            colors: [Color(0xFF81C784), Color(0xFFA5D6A7), Color(0xFFC8E6C9)],
          ),
          style: GoogleFonts.outfit(
            fontSize: titleSize * 0.48,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),

        Text(
          '6+ years of processing expertise. 100% pure & natural dehydrated onion and garlic. Zero artificial chemicals. International certifications. Built for global trade direct from Mahuva, India.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: descSize,
            color: Colors.white.withOpacity(0.95),
            height: 1.65,
            shadows: const [
              Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: LiquidUI.fluidPaddingSymmetric(
                  context,
                  minHorizontal: 22, maxHorizontal: 34,
                  minVertical: 14, maxVertical: 20,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 8,
                shadowColor: AppColors.secondaryGlow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Products',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _showQuoteDialog(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                padding: LiquidUI.fluidPaddingSymmetric(
                  context,
                  minHorizontal: 22, maxHorizontal: 32,
                  minVertical: 14, maxVertical: 20,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mail_outline_rounded, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Get in Touch',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Floating Stats Bar Section (Paints cleanly above About section)
  Widget _buildFloatingStatsSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          transform: Matrix4.translationValues(0, isMobile ? -30 : -50, 0),
          child: _buildFloatingStatsBar(context, isMobile),
        ),
      ),
    );
  }

  Widget _buildFloatingStatsBar(BuildContext context, bool isMobile) {
    if (isMobile) {
      return LiquidUI.glassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        backgroundColor: Colors.white,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatBarItem(context, '6+', 'Years Experience')),
                Container(height: 30, width: 1, color: AppColors.border),
                Expanded(child: _buildStatBarItem(context, '15+', 'Countries Exported')),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.border, height: 1),
            ),
            Row(
              children: [
                Expanded(child: _buildStatBarItem(context, '5000+', 'Tons Capacity')),
                Container(height: 30, width: 1, color: AppColors.border),
                Expanded(child: _buildStatBarItem(context, '100%', 'Pure & Natural')),
              ],
            ),
          ],
        ),
      );
    }

    return LiquidUI.glassCard(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
      backgroundColor: Colors.white,
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatBarItem(context, '6+', 'Years Experience'),
          _buildStatDivider(),
          _buildStatBarItem(context, '15+', 'Countries Exported'),
          _buildStatDivider(),
          _buildStatBarItem(context, '5000+', 'Tons Annual Capacity'),
          _buildStatDivider(),
          _buildStatBarItem(context, '100%', 'Pure & Natural'),
        ],
      ),
    );
  }

  Widget _buildStatBarItem(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LiquidUI.gradientText(
          value,
          gradient: AppColors.secondaryGradient,
          style: GoogleFonts.outfit(
            fontSize: LiquidUI.fluid(context, minVal: 22, maxVal: 30),
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 38,
      width: 1.2,
      color: AppColors.border,
    );
  }

  // 2. "About Amar Foods" Section (Stretched Image Matching Section Height on Desktop)
  Widget _buildAboutAmarSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 60, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 40);

    Widget buildImageCard() {
      return Stack(
        clipBehavior: Clip.none,
        fit: isMobile ? StackFit.loose : StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppImages.aboutProducts,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primaryLight,
                    child: const Center(
                      child: Icon(Icons.eco_rounded, size: 64, color: AppColors.primary),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: isMobile ? 12 : 20,
            right: isMobile ? 12 : 20,
            left: isMobile ? 12 : null,
            child: LiquidUI.glassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              backgroundColor: Colors.white.withOpacity(0.95),
              borderColor: AppColors.secondary.withOpacity(0.3),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '100% Pure & Natural',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Direct from Mahuva, India',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? paddingV : paddingV + 30,
        bottom: paddingV,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final textContent = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LiquidUI.badgePill(
                    text: 'ESTABLISHED 2020 • MAHUVA, GUJARAT',
                    icon: Icons.domain,
                    backgroundColor: AppColors.primaryLight,
                    textColor: AppColors.primary,
                    fontSize: 11,
                  ),
                  const SizedBox(height: 16),

                  LiquidUI.gradientText(
                    'About Amar Foods',
                    gradient: AppColors.primaryGradient,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Premier Exporter of High-Grade Dehydrated Onion & Garlic',
                    style: GoogleFonts.outfit(
                      fontSize: headingSize * 0.48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Located in Mahuva, Gujarat—India\'s premier onion processing hub—Amar Foods is a leading manufacturer and exporter of dehydrated red, white, and pink onions as well as high-potency garlic products. We bring together regional agricultural richness with advanced hygienic processing to serve global food manufacturers, spice blenders, and culinary brands.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildAboutFeaturePoint(
                    'Farm-to-Factory Procurement',
                    'Direct sourcing from Mahuva farmers for uncompromised raw crop purity.',
                  ),
                  const SizedBox(height: 14),
                  _buildAboutFeaturePoint(
                    'Automated Hygienic Control',
                    'Optical color sorters, metal detectors, and clean-room packaging.',
                  ),
                  const SizedBox(height: 14),
                  _buildAboutFeaturePoint(
                    'Zero Artificial Additives',
                    '100% pure, unadulterated dehydrated flakes, granules, and powders.',
                  ),
                  const SizedBox(height: 14),
                  _buildAboutFeaturePoint(
                    'Global Export Compliance',
                    'Fully ISO 22000, HACCP, FSSAI, HALAL & KOSHER accredited.',
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/about'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: LiquidUI.fluidPaddingSymmetric(
                        context,
                        minHorizontal: 24, maxHorizontal: 32,
                        minVertical: 14, maxVertical: 18,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 4,
                      shadowColor: AppColors.primaryGlow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Learn More About Us',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              );

              if (isMobile) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: buildImageCard(),
                    ),
                    const SizedBox(height: 52),
                    textContent,
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: AspectRatio(
                        aspectRatio: 4 / 3.4,
                        child: buildImageCard(),
                      ),
                    ),
                    const SizedBox(width: 54),
                    Expanded(
                      flex: 6,
                      child: textContent,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAboutFeaturePoint(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.secondaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextSpan(
                  text: description,
                  style: GoogleFonts.inter(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section: "Our Vision" Quote Card (Branded with Amar Foods Logo Colors & Deep Plum/Green Aesthetics)
  Widget _buildVisionQuoteSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 50, maxVal: 80);
    final double quoteFontSize = LiquidUI.fluid(context, minVal: 20, maxVal: 30);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1E0A19), // Deep Plum Obsidian Background derived from Logo Primary
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: EdgeInsets.all(isMobile ? 24 : 44),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF38102B), // Logo Plum Dark
                Color(0xFF200718), // Deep Dark Surface
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow.withOpacity(0.25),
                blurRadius: 36,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Logo Green Line & — OUR VISION Label (AppColors.secondary)
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 2.5,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'OUR VISION',
                    style: GoogleFonts.outfit(
                      color: AppColors.secondaryLight,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Main Vision Quote with Logo Green/Accent Highlights
              RichText(
                text: TextSpan(
                  style: GoogleFonts.playfairDisplay(
                    fontSize: quoteFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.55,
                    letterSpacing: -0.2,
                  ),
                  children: [
                    const TextSpan(text: '“To grow '),
                    TextSpan(
                      text: 'Amar Foods ',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: 'into a dependable name in '),
                    TextSpan(
                      text: 'dehydrated onion and garlic exports ',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.secondaryLight,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: '— known among global buyers not for size, but for ',
                    ),
                    TextSpan(
                      text: 'consistent grades, honest documentation, ',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.secondaryLight,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: 'and deliveries you can plan around.”',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bottom Divider & Signature Line
              Divider(color: Colors.white.withOpacity(0.14), height: 1),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'AMAR FOODS • MAHUVA, INDIA',
                  style: GoogleFonts.outfit(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Featured Products Showcase (Main 4 Flagship Categories + View More Button)
  Widget _buildProductRangeSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 60, maxVal: 90);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 38);

    // Main 4 Flagship Products matching amarfoods.in product range
    final featuredProductsData = [
      {
        'image': AppImages.productRedOnion,
        'category': 'RED ONION',
        'title': 'Red Onion',
        'desc': 'Dehydrated Red Onion range including Kibbled Flakes (8-15mm), Chopped (3-5mm), Minced (1-3mm), Granules (0.5-1mm), and Powder (80-100 mesh).',
      },
      {
        'image': AppImages.productWhiteOnion,
        'category': 'WHITE ONION',
        'title': 'White Onion',
        'desc': 'Dehydrated White Onion range including Flakes (8-15mm), Chopped (3-5mm), Minced (1-3mm), Granules (0.5-1mm), and Powder (80-100 mesh).',
      },
      {
        'image': AppImages.productPinkOnion,
        'category': 'PINK ONION',
        'title': 'Pink Onion',
        'desc': 'Dehydrated Pink Onion range including Flakes (8-15mm), Chopped (3-5mm), Minced (1-3mm), Granules (0.5-1mm), and Powder (80-100 mesh).',
      },
      {
        'image': AppImages.productGarlic,
        'category': 'GARLIC',
        'title': 'Dehydrated Garlic',
        'desc': 'Dehydrated Garlic range including Sliced Flakes (10-15mm), Chopped (3-5mm), Minced (1-3mm), Granules (0.5-1mm), and Powder (80-100 mesh).',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              LiquidUI.badgePill(
                text: 'FLAGSHIP EXPORT PRODUCTS',
                icon: Icons.star_rounded,
                backgroundColor: AppColors.secondary.withOpacity(0.15),
                textColor: AppColors.secondary,
                fontSize: 11,
              ),
              const SizedBox(height: 16),

              LiquidUI.gradientText(
                'Featured Export Product Range',
                gradient: AppColors.primaryGradient,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                'Direct farm procurement in Mahuva, Gujarat. 100% natural dehydrated red, white, pink onions, and garlic.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 44),

              // Main 4 Product Cards Grid (2x2 on desktop, 1 column on mobile)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: featuredProductsData.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: _buildProductCard(
                          context,
                          imagePath: p['image'] as String,
                          categoryTag: p['category'] as String,
                          title: p['title'] as String,
                          description: p['desc'] as String,
                          imageAlignment: (p['alignment'] as Alignment?) ?? Alignment.center,
                          imageFit: (p['fit'] as BoxFit?) ?? BoxFit.contain,
                        ),
                      )).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 28,
                      children: featuredProductsData.map((p) => SizedBox(
                        width: (constraints.maxWidth - 24) / 2,
                        child: _buildProductCard(
                          context,
                          imagePath: p['image'] as String,
                          categoryTag: p['category'] as String,
                          title: p['title'] as String,
                          description: p['desc'] as String,
                          imageAlignment: (p['alignment'] as Alignment?) ?? Alignment.center,
                          imageFit: (p['fit'] as BoxFit?) ?? BoxFit.contain,
                        ),
                      )).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 48),

              // View Complete Product Portfolio CTA Button
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isNarrow = constraints.maxWidth < 650;
                  final textCol = Column(
                    crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Explore All 15+ Dehydrated Products',
                        textAlign: isNarrow ? TextAlign.center : TextAlign.left,
                        style: GoogleFonts.outfit(
                          fontSize: isNarrow ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'View full specifications, mesh cuts, packaging options, and FOB quotes.',
                        textAlign: isNarrow ? TextAlign.center : TextAlign.left,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  );

                  final btn = ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/products'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 4,
                      shadowColor: AppColors.secondaryGlow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View All Products',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  );

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: isNarrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              textCol,
                              const SizedBox(height: 16),
                              btn,
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: textCol),
                              const SizedBox(width: 20),
                              btn,
                            ],
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterTab(String categoryKey, String label) {
    final bool isSelected = _selectedCategory == categoryKey;

    return InkWell(
      onTap: () => setState(() => _selectedCategory = categoryKey),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGlow.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required String imagePath,
    required String categoryTag,
    required String title,
    required String description,
    Alignment imageAlignment = Alignment.center,
    BoxFit imageFit = BoxFit.contain,
  }) {
    final product = ProductModel(
      id: title.toLowerCase().replaceAll(' ', '_'),
      title: title,
      category: categoryTag,
      tag: categoryTag,
      tagline: 'Export-grade dehydrated crop from Mahuva, Gujarat.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [imagePath, AppImages.productRedOnionFlakes, AppImages.productGarlicFlakes, AppImages.productWhiteOnionPowder],
      purity: '99.5% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description: description,
      keyFeatures: const [
        '100% pure Mahuva Gujarat agricultural origin',
        'Optical color sorted and metal detector checked',
        'Zero sulfur bleaching or chemical additives',
        'ISO 22000, HACCP, FSSAI & HALAL accredited',
      ],
      applications: const [
        'Industrial spice grinding and dry seasonings',
        'Ready-to-eat meals, instant soups, and noodles',
        'HoReCa hotel, restaurant, and catering supply',
        'Bakery, pickle, sauce, and snack manufacturing',
      ],
      specs: {
        'Category': categoryTag,
        'Origin': 'Mahuva, Gujarat, India',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Microbiological': 'E.Coli: Negative / Salmonella: Absent',
      },
    );

    return LiquidUI.interactiveGlassCard(
      onTap: () => showProductDetailModal(context, product),
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  color: Colors.black,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(
                      imagePath,
                      fit: imageFit,
                      alignment: imageAlignment,
                      cacheWidth: 600,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryLight,
                          child: const Center(
                            child: Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.primary),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categoryTag,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/products'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Product',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. "Why Choose Amar Foods" Core Value Pillars Section (Next-Gen Glassmorphic Redesign)
  Widget _buildWhyChooseUsSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 70, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 40);

    final List<_PillarItem> pillars = const [
      _PillarItem(
        index: '01',
        badge: 'Farm Direct',
        icon: Icons.agriculture_rounded,
        title: 'Mahuva Processing Hub',
        desc: 'Direct farm procurement in Mahuva—India\'s premier onion capital—guaranteeing peak crop freshness and unadulterated origin.',
      ),
      _PillarItem(
        index: '02',
        badge: 'ISO & HACCP',
        icon: Icons.biotech_rounded,
        title: 'Analytical Lab Control',
        desc: 'Rigorous batch testing for moisture (<6.0%), total ash, acid-insoluble ash, and zero chemical pesticide residues.',
      ),
      _PillarItem(
        index: '03',
        badge: 'Moisture Proof',
        icon: Icons.inventory_2_rounded,
        title: 'Export Barrier Packaging',
        desc: 'Multi-ply poly-lined paper bags, aluminum foil barrier bags, and corrugated cartons customized for international logistics.',
      ),
      _PillarItem(
        index: '04',
        badge: 'Fast Seaport Transit',
        icon: Icons.sailing_rounded,
        title: 'Proximity to Sea Ports',
        desc: 'Strategic location near Pipavav, Mundra & Hazira commercial seaports for rapid container stuffing and FCL dispatches.',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              LiquidUI.badgePill(
                text: 'UNMATCHED EXPORT ADVANTAGES',
                icon: Icons.workspace_premium_rounded,
                backgroundColor: AppColors.primaryLight,
                textColor: AppColors.primary,
                fontSize: 11,
              ),
              const SizedBox(height: 16),

              LiquidUI.gradientText(
                'Why Global Buyers Choose Amar Foods',
                gradient: AppColors.primaryGradient,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              Text(
                'Connecting Mahuva\'s rich agricultural soil directly to global industrial food processors with end-to-end supply reliability.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 52),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: pillars.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: _buildNewPillarCard(
                          context,
                          p.index,
                          p.badge,
                          p.icon,
                          p.title,
                          p.desc,
                        ),
                      )).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: pillars.map((p) => SizedBox(
                        width: (constraints.maxWidth - 24) / 2,
                        child: _buildNewPillarCard(
                          context,
                          p.index,
                          p.badge,
                          p.icon,
                          p.title,
                          p.desc,
                        ),
                      )).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPillarCard(
    BuildContext context,
    String index,
    String badge,
    IconData icon,
    String title,
    String desc,
  ) {
    return LiquidUI.interactiveGlassCard(
      onTap: () => _showQuoteDialog(context),
      padding: const EdgeInsets.all(28),
      backgroundColor: AppColors.background,
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 28),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                  ),
                  child: Text(
                    '#$index • $badge',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // 5. Farm-to-Shipment Process Journey Timeline (Dark Obsidian Futuristic Journey Redesign)
  Widget _buildProcessTimelineSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 70, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 40);

    final List<_TimelineItem> steps = const [
      _TimelineItem(
        step: '01',
        icon: Icons.grass_rounded,
        title: 'Farm Harvest & Selection',
        desc: 'Direct procurement of fresh, high-pungency onion and garlic bulbs from Mahuva farms.',
      ),
      _TimelineItem(
        step: '02',
        icon: Icons.water_drop_rounded,
        title: 'Triple Hydro Wash',
        desc: 'Automated multi-stage washing and mechanical peeling under strict sanitary conditions.',
      ),
      _TimelineItem(
        step: '03',
        icon: Icons.thermostat_rounded,
        title: 'Conveyor Dehydration',
        desc: 'Low-temperature continuous air drying to lock in natural flavor, essential oils, and aroma.',
      ),
      _TimelineItem(
        step: '04',
        icon: Icons.remove_red_eye_rounded,
        title: 'Optical & Metal Sort',
        desc: 'High-precision optical color sorting and magnetic traps to eliminate all foreign defects.',
      ),
      _TimelineItem(
        step: '05',
        icon: Icons.science_rounded,
        title: 'Lab Quality Certification',
        desc: 'Analytical verification for moisture (<6.0%), ash levels, and microbiological clearance.',
      ),
      _TimelineItem(
        step: '06',
        icon: Icons.local_shipping_rounded,
        title: 'FCL Container Dispatch',
        desc: 'Sealed moisture-barrier packaging and direct container loading for global seaport export.',
      ),
    ];

    return Container(
      color: AppColors.darkSurface,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      width: double.infinity,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              // Pulsating Green Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on_rounded, color: AppColors.secondary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'FARM-TO-CONTAINER PRECISION',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Text(
                'Our 6-Step Processing Journey',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                'From raw field harvesting in Mahuva to sealed container loading at the port, trace our end-to-end quality pipeline.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 52),

              // 6 Steps Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: steps.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildNewTimelineCard(
                          context,
                          s.step,
                          s.icon,
                          s.title,
                          s.desc,
                        ),
                      )).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: steps.map((s) => SizedBox(
                        width: (constraints.maxWidth - 48) / 3,
                        child: _buildNewTimelineCard(
                          context,
                          s.step,
                          s.icon,
                          s.title,
                          s.desc,
                        ),
                      )).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewTimelineCard(
    BuildContext context,
    String stepNum,
    IconData icon,
    String title,
    String desc,
  ) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  'STEP $stepNum',
                  style: GoogleFonts.outfit(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Quality Promise Section
  Widget _buildQualityPromiseSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 50, maxVal: 80);
    final double headingSize = LiquidUI.fluid(context, minVal: 26, maxVal: 36);

    return Container(
      color: AppColors.darkSurface,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      width: double.infinity,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              LiquidUI.badgePill(
                text: 'OUR PROMISE',
                icon: Icons.shield_rounded,
                backgroundColor: Colors.white.withOpacity(0.1),
                textColor: AppColors.secondary,
                fontSize: 11,
              ),
              const SizedBox(height: 16),
              Text(
                'Quality Is Not a Feature — It\'s Our Foundation',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We adhere to the strictest global standards to ensure every export batch meets your exact specifications.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 48),

              LayoutBuilder(
                builder: (context, constraints) {
                  final List<Widget> promiseCards = [
                    _buildPromiseCard(
                      context,
                      'Farm-to-Facility Traceability',
                      'Complete transparency from Mahuva crop harvesting to sealed container loading, ensuring full batch origin tracking.',
                      Icons.manage_search_rounded,
                    ),
                    _buildPromiseCard(
                      context,
                      'Analytical Lab Testing',
                      'Rigorous laboratory analysis for moisture (<6%), total ash, acid-insoluble ash, and microbiological safety.',
                      Icons.science_rounded,
                    ),
                    _buildPromiseCard(
                      context,
                      'Controlled Packaging & FIFO',
                      'Poly-lined moisture barrier paper bags and strict First-In, First-Out storage protocol for optimal freshness.',
                      Icons.ac_unit_rounded,
                    ),
                  ];

                  if (isMobile) {
                    return Column(
                      children: promiseCards.map((card) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: card,
                      )).toList(),
                    );
                  } else {
                    return Row(
                      children: promiseCards.map((card) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: card,
                        ),
                      )).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromiseCard(BuildContext context, String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 9. International Accreditation & Quality Certifications Section (Real Emblem Images & Details)
  Widget _buildCertificationsSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 70, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 40);

    final List<_CertItem> certs = const [
      _CertItem(
        title: 'US FDA Registered',
        tag: 'U.S. FOOD & DRUG ADMIN',
        image: AppImages.certFdaLogo,
        desc: 'Official US FDA facility registration for exporting dehydrated products into North American markets.',
      ),
      _CertItem(
        title: 'FSSC 22000 Certified',
        tag: 'FOOD SAFETY SYSTEM',
        image: AppImages.certFssc22000Logo,
        desc: 'FSSC 22000 (QVA) international food safety certification covering farm-to-fork hazard prevention.',
      ),
      _CertItem(
        title: 'Kosher Certified',
        tag: 'KOSHER COMPLIANCE',
        image: AppImages.certKosherLogo,
        desc: 'Kosher certified (QVA) processing line compliant with international Jewish dietary food requirements.',
      ),
      _CertItem(
        title: 'APEDA Registered',
        tag: 'EXPORT DEVELOPMENT',
        image: AppImages.certApedaLogo,
        desc: 'Government of India APEDA registration guaranteeing authentic agricultural commodity origin and quality.',
      ),
      _CertItem(
        title: 'FSSAI License',
        tag: 'FOOD SAFETY AUTHORITY',
        image: AppImages.certFssaiLogo,
        desc: 'Official licence from Food Safety and Standards Authority of India for hygienic processing & export.',
      ),
      _CertItem(
        title: 'GST Registered',
        tag: 'GOVT TAX REGISTRATION',
        image: AppImages.certGstLogo,
        desc: 'Official Government of India Goods & Services Tax (GST) registered legal commercial exporter.',
      ),
      _CertItem(
        title: 'HALAL Certified',
        tag: 'ISLAMIC DIETARY LAW',
        image: AppImages.certHalalLogo,
        desc: '100% Halal certified (QVA) processing line compliant with Islamic dietary laws for global trade.',
      ),
      _CertItem(
        title: 'IEC Export License',
        tag: 'IMPORT EXPORT CODE',
        image: AppImages.certIecLogo,
        desc: 'Directorate General of Foreign Trade (DGFT) Import Export Code certification for international commerce.',
      ),
      _CertItem(
        title: 'MSME Registered',
        tag: 'MINISTRY OF MSME',
        image: AppImages.certMsmeLogo,
        desc: 'Ministry of Micro, Small & Medium Enterprises (Udyam) government recognized enterprise.',
      ),
      _CertItem(
        title: 'APMC License',
        tag: 'MARKET COMMITTEE',
        image: AppImages.certApmcLogo,
        desc: 'Agricultural Produce Market Committee (APMC Mahuva) licensed primary agricultural processor.',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              LiquidUI.badgePill(
                text: 'GLOBAL ACCREDITATIONS & CERTIFICATIONS',
                icon: Icons.verified_rounded,
                backgroundColor: AppColors.primaryLight,
                textColor: AppColors.primary,
                fontSize: 11,
              ),
              const SizedBox(height: 16),

              LiquidUI.gradientText(
                'Certified for International Food Safety Standards',
                gradient: AppColors.primaryGradient,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                'Every batch of dehydrated onion and garlic exported by Amar Foods complies with international quality, hygiene, and sanitary regulations.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 52),

              // 5 Certifications Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: certs.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: _buildCertCard(context, c),
                      )).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 28,
                      children: certs.map((c) => SizedBox(
                        width: (constraints.maxWidth - 24) / 2 > 340
                            ? (constraints.maxWidth - 48) / 3
                            : (constraints.maxWidth - 24) / 2,
                        child: _buildCertCard(context, c),
                      )).toList(),
                    );
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertCard(BuildContext context, _CertItem c) {
    return LiquidUI.interactiveGlassCard(
      onTap: () => _showQuoteDialog(context),
      padding: const EdgeInsets.all(24),
      backgroundColor: AppColors.background,
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Real Emblem Image Header (Large & Zoomed)
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withOpacity(0.18), width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Image.asset(
                      c.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.verified_rounded, color: AppColors.primary, size: 32);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                      ),
                      child: Text(
                        c.tag,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      c.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            c.desc,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 7. Global Footprint
  Widget _buildGlobalFootprintSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 50, maxVal: 80);
    final double headingSize = LiquidUI.fluid(context, minVal: 26, maxVal: 36);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              LiquidUI.gradientText(
                'Trusted Worldwide',
                gradient: AppColors.primaryGradient,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Delivering premium quality dehydrated foods and spices to global markets with unwavering reliability.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              LiquidUI.glassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(32),
                backgroundColor: AppColors.background,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.public_rounded, color: AppColors.primary, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Export Network Across 15+ Nations',
                          style: GoogleFonts.outfit(
                            fontSize: LiquidUI.fluid(context, minVal: 16, maxVal: 20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _CountryBadge('Germany'),
                        _CountryBadge('United Kingdom'),
                        _CountryBadge('United Arab Emirates'),
                        _CountryBadge('Saudi Arabia'),
                        _CountryBadge('Singapore'),
                        _CountryBadge('Malaysia'),
                        _CountryBadge('Indonesia'),
                        _CountryBadge('Australia'),
                        _CountryBadge('Poland'),
                        _CountryBadge('Netherlands'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 8. Bottom CTA Banner
  Widget _buildCtaBannerSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 40, maxVal: 60);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              Text(
                'Ready to Source Premium Quality Dehydrates?',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Let\'s discuss how we can meet your exact specifications. Our export team is ready to assist.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _showQuoteDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      'Get in Touch',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // const SizedBox(width: 16),
                  // OutlinedButton(
                  //   onPressed: () => Navigator.pushNamed(context, '/quality'),
                  //   style: OutlinedButton.styleFrom(
                  //     side: const BorderSide(color: Colors.white, width: 2),
                  //     padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  //   ),
                  //   child: Text(
                  //     'View Quality Standards',
                  //     style: GoogleFonts.outfit(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryBadge extends StatelessWidget {
  final String name;

  const _CountryBadge(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.secondary, size: 16),
          const SizedBox(width: 6),
          Text(
            name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillarItem {
  final String index;
  final String badge;
  final IconData icon;
  final String title;
  final String desc;

  const _PillarItem({
    required this.index,
    required this.badge,
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _TimelineItem {
  final String step;
  final IconData icon;
  final String title;
  final String desc;

  const _TimelineItem({
    required this.step,
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _CertItem {
  final String title;
  final String tag;
  final String image;
  final String desc;

  const _CertItem({
    required this.title,
    required this.tag,
    required this.image,
    required this.desc,
  });
}
