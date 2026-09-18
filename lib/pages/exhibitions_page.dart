import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../data/exhibitions_data.dart';
import '../services/language_service.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/brochure_dialog.dart';
import '../widgets/whatsapp_floating_button.dart';

class ExhibitionsPage extends StatefulWidget {
  const ExhibitionsPage({super.key});

  @override
  State<ExhibitionsPage> createState() => _ExhibitionsPageState();
}

class _ExhibitionsPageState extends State<ExhibitionsPage> {
  String _selectedFilter = 'All'; // 'All' | 'International' | 'Domestic'
  late String _selectedExhibitionId;
  int _activeGalleryIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _showcaseKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedExhibitionId = ExhibitionsData.allExhibitions.first.id;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ExhibitionItem get _currentExhibition {
    return ExhibitionsData.allExhibitions.firstWhere(
      (e) => e.id == _selectedExhibitionId,
      orElse: () => ExhibitionsData.allExhibitions.first,
    );
  }

  List<ExhibitionItem> get _filteredExhibitions {
    if (_selectedFilter == 'International') {
      return ExhibitionsData.allExhibitions.where((e) => e.tag == 'International').toList();
    } else if (_selectedFilter == 'Domestic') {
      return ExhibitionsData.allExhibitions.where((e) => e.tag == 'Domestic').toList();
    }
    return ExhibitionsData.allExhibitions;
  }

  void _selectExhibition(String id) {
    setState(() {
      _selectedExhibitionId = id;
      _activeGalleryIndex = 0;
    });

    // Smooth scroll to showcase
    if (_showcaseKey.currentContext != null) {
      Scrollable.ensureVisible(
        _showcaseKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _showQuoteDialog(BuildContext context) {
    Navigator.pushNamed(context, '/enquiry');
  }

  Future<void> _openWhatsApp() async {
    const String phone = '917284088737';
    final String message = Uri.encodeComponent(
      'Hello Amar Foods, I would like to schedule a B2B meeting regarding Exhibitions & Trade Shows.',
    );
    final Uri url = Uri.parse('https://wa.me/$phone?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showImageLightbox(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 900, maxHeight: 720),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF140818),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InteractiveViewer(
                    maxScale: 3.5,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LanguageItem>(
      valueListenable: LanguageService.instance.currentLanguage,
      builder: (context, currentLang, _) {
        final bool isMobile = LiquidUI.isMobile(context);
        final bool isRTL = LanguageService.instance.isRTL;

        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: const AppHeader(),
            endDrawer: const AppDrawer(),
            floatingActionButton: const WhatsAppFloatingButton(),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 1. Hero Banner
                  _buildHeroSection(context, isMobile),

                  // 2. Main Body Container
                  Center(
                    child: Container(
                      constraints: LiquidUI.pageConstraints(),
                      padding: EdgeInsets.symmetric(
                        horizontal: LiquidUI.fluid(context, minVal: 16, maxVal: 36),
                        vertical: LiquidUI.fluid(context, minVal: 36, maxVal: 60),
                      ),
                      child: Column(
                        children: [
                          // Introduction / Participation Showcase
                          _buildShowcaseIntro(context, isMobile),

                          const SizedBox(height: 32),

                          // Filter Selector (All / International / Domestic)
                          _buildFilterTabs(context, isMobile),

                          const SizedBox(height: 40),

                          // Featured Interactive Exhibition Showcase Card
                          Container(
                            key: _showcaseKey,
                            child: _buildFeaturedShowcaseCard(context, isMobile),
                          ),

                          const SizedBox(height: 64),

                          // Secondary Grid of All Trade Shows
                          _buildAllExhibitionsGrid(context, isMobile),

                          const SizedBox(height: 72),

                          // Upcoming Trade Show B2B Meeting Banner
                          _buildUpcomingBanner(context, isMobile),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  const AppFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 1. Hero Banner
  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    final double heroHeight = isMobile ? 260 : 340;

    return Container(
      width: double.infinity,
      height: heroHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF420D2C),
            Color(0xFF6A1544),
            Color(0xFFA64787),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Glow Accents
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: 20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGold.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Content
          Center(
            child: Container(
              constraints: LiquidUI.pageConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.public_rounded, size: 14, color: AppColors.accentGold),
                        const SizedBox(width: 8),
                        Text(
                          'GLOBAL FOOTPRINT & TRADE NETWORKS',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'Exhibitions & Trade Shows',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: LiquidUI.fluid(context, minVal: 28, maxVal: 48),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Text(
                      'Connecting with international buyers and trade partners at premier food forums worldwide to showcase India\'s agricultural superiority.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: LiquidUI.fluid(context, minVal: 13, maxVal: 15.5),
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Showcase Intro
  Widget _buildShowcaseIntro(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Text(
          'Our Participation Showcase',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: LiquidUI.fluid(context, minVal: 24, maxVal: 34),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            'Through our regular presence at both international and domestic food expos, Amar Foods demonstrates its dedication to quality, technology, and global partnerships. We bring high-grade dehydrated onions, garlic, peanut crops, and spices directly to international food manufacturers, packaging houses, and hospitality chains.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // 3. Filter Selector (All / International / Domestic)
  Widget _buildFilterTabs(BuildContext context, bool isMobile) {
    final int allCount = ExhibitionsData.allExhibitions.length;
    final int intlCount = ExhibitionsData.allExhibitions.where((e) => e.tag == 'International').length;
    final int domCount = ExhibitionsData.allExhibitions.where((e) => e.tag == 'Domestic').length;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EBF0),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          _buildFilterChip('All', 'All ($allCount)', Icons.apps_rounded),
          _buildFilterChip('International', 'International ($intlCount)', Icons.public_rounded),
          _buildFilterChip('Domestic', 'Domestic ($domCount)', Icons.business_rounded),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, IconData icon) {
    final bool isSelected = _selectedFilter == key;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = key;
          // If current selected item is not in the filtered list, pick the first
          final filtered = _filteredExhibitions;
          if (!filtered.any((e) => e.id == _selectedExhibitionId) && filtered.isNotEmpty) {
            _selectedExhibitionId = filtered.first.id;
            _activeGalleryIndex = 0;
          }
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Featured Exhibition Showcase Card (Inspired by reference screenshot 2 & 4)
  Widget _buildFeaturedShowcaseCard(BuildContext context, bool isMobile) {
    final expo = _currentExhibition;
    final String activeImageUrl = expo.galleryImages.isNotEmpty && _activeGalleryIndex < expo.galleryImages.length
        ? expo.galleryImages[_activeGalleryIndex]
        : expo.mainImage;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderGlass, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 18 : 28),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShowcaseImageBlock(expo, activeImageUrl, isMobile),
                const SizedBox(height: 24),
                _buildShowcaseContentBlock(expo, isMobile),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Main Image & Gallery Thumbnails (46% width)
                Expanded(
                  flex: 5,
                  child: _buildShowcaseImageBlock(expo, activeImageUrl, isMobile),
                ),
                const SizedBox(width: 32),
                // Right Column: Details, Highlights Box, CTA (54% width)
                Expanded(
                  flex: 6,
                  child: _buildShowcaseContentBlock(expo, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildShowcaseImageBlock(ExhibitionItem expo, String activeImageUrl, bool isMobile) {
    final double imageHeight = isMobile ? 280 : 380;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Preview Image with Pill Tag and Ambient Backdrop (Never cuts off portraits or posters)
        GestureDetector(
          onTap: () => _showImageLightbox(context, activeImageUrl, expo.title),
          child: MouseRegion(
            cursor: SystemMouseCursors.zoomIn,
            child: Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF16161D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient blurred fill to match the photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      activeImageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.65),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),

                  // Sharp, 100% visible uncropped foreground image!
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        activeImageUrl,
                        key: ValueKey<String>(activeImageUrl),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: imageHeight,
                            color: AppColors.primaryLight,
                            child: const Center(
                              child: Icon(Icons.image_outlined, size: 48, color: AppColors.primary),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Top-Left Tag Pill Badge (International / Domestic)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: expo.tag == 'International'
                            ? const Color(0xFF1D5A38)
                            : const Color(0xFF1E3A8A),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            expo.tag == 'International' ? Icons.public_rounded : Icons.apartment_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            expo.tag,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top-Right Edition/Booth Badge if available
                  if (expo.boothNumber != null)
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          expo.boothNumber!,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Bottom-Right Enlarge Hint Badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.zoom_in_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Click to enlarge',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Clickable Thumbnail Row beneath Main Image
        if (expo.galleryImages.length > 1) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(expo.galleryImages.length, (index) {
              final isSelected = _activeGalleryIndex == index;
              final thumbUrl = expo.galleryImages[index];

              return InkWell(
                onTap: () {
                  setState(() {
                    _activeGalleryIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.15),
                      width: isSelected ? 2.5 : 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      thumbUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildShowcaseContentBlock(ExhibitionItem expo, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          expo.title,
          style: GoogleFonts.outfit(
            fontSize: LiquidUI.fluid(context, minVal: 24, maxVal: 32),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        // Metadata: Venue with Location Pin & Date with Calendar
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Text(
                  expo.venue,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.secondary),
                const SizedBox(width: 6),
                Text(
                  expo.dates,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Narrative Description
        Text(
          expo.description,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 20),

        // Highlights & Product Focus Box (As requested in user screenshot 2 & 4)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFCF9FA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.military_tech_rounded, size: 18, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'HIGHLIGHTS & PRODUCT FOCUS',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...expo.highlights.map((highlight) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          highlight,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Focus Product Tags Row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: expo.focusProducts.map((prod) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Text(
                prod,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // CTA Buttons Row
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showQuoteDialog(context),
              icon: const Icon(Icons.handshake_rounded, size: 16),
              label: Text(
                'Schedule B2B Meeting',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 3,
                shadowColor: AppColors.primaryGlow,
              ),
            ),
            OutlinedButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.secondary),
              label: Text(
                'Chat on WhatsApp',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.secondary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.secondary, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 5. Secondary Grid of All Trade Shows (Matching user screenshot 1 with Amar Foods luxury touch)
  Widget _buildAllExhibitionsGrid(BuildContext context, bool isMobile) {
    final list = _filteredExhibitions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LiquidUI.badgePill(
                  text: 'EXPO ROSTER',
                  icon: Icons.event_note_rounded,
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
                  textColor: AppColors.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'All Exhibitions & Trade Fairs',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: LiquidUI.fluid(context, minVal: 22, maxVal: 30),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              'Showing ${list.length} Events',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = isMobile
                ? constraints.maxWidth
                : (constraints.maxWidth - 24) / 2;

            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: list.map((expo) {
                final bool isCurrent = expo.id == _selectedExhibitionId;

                return SizedBox(
                  width: cardWidth,
                  child: _buildExhibitionCard(context, expo, isCurrent),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExhibitionCard(BuildContext context, ExhibitionItem expo, bool isCurrent) {
    return InkWell(
      onTap: () => _selectExhibition(expo.id),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isCurrent ? AppColors.primary : AppColors.border,
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isCurrent ? 20 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                  child: Image.asset(
                    expo.mainImage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: Icon(Icons.image_outlined, size: 40, color: AppColors.primary),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: expo.tag == 'International'
                          ? const Color(0xFF1D5A38)
                          : const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      expo.tag,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isCurrent)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.remove_red_eye_rounded, size: 11, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Active View',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expo.title,
                    style: GoogleFonts.outfit(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 15, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          expo.venue,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        expo.dates,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    expo.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'View Highlights & Focus',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
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

  // 6. Upcoming Trade Show B2B Meeting Banner
  Widget _buildUpcomingBanner(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF280B1C),
            Color(0xFF4A0E2E),
            Color(0xFF6A1544),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerText(context),
                const SizedBox(height: 24),
                _buildBannerActions(context),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 7, child: _buildBannerText(context)),
                const SizedBox(width: 28),
                Expanded(flex: 4, child: _buildBannerActions(context)),
              ],
            ),
    );
  }

  Widget _buildBannerText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
          ),
          child: Text(
            'UPCOMING GLOBAL PARTICIPATION',
            style: GoogleFonts.outfit(
              color: AppColors.accentGold,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Meet the Amar Foods Team at Our Next Trade Show',
          style: GoogleFonts.playfairDisplay(
            fontSize: LiquidUI.fluid(context, minVal: 20, maxVal: 28),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Book a private delegation meeting to examine certified crop lots, verify custom flake and mesh specifications, and lock in seasonal container volume pricing.',
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showQuoteDialog(context),
          icon: const Icon(Icons.event_seat_rounded, size: 16),
          label: Text(
            'Book B2B Appointment',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => BrochureDialog.show(context),
          icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
          label: Text(
            'Download Product Brochure',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.white.withValues(alpha: 0.35), width: 1.2),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }
}
