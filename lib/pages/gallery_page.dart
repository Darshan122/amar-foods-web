import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';
import '../widgets/product_detail_dialog.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _selectedCategory = 'ALL';

  void _showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double paddingV = LiquidUI.fluid(context, minVal: 40, maxVal: 80);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 42);

    final galleryItems = [
      // --- EXPOS & EVENTS (5 EVENT PHOTOS) ---
      {
        'title': 'Fi India 2026 - Premier Food Ingredients Event',
        'category': 'EXPOS & EVENTS',
        'image': AppImages.expoFiIndiaHall,
        'desc': 'Fi India 2026 20th Anniversary Edition at Bombay Exhibition Center (BEC), Mumbai (26-28 Aug 2026).',
        'venue': 'Bombay Exhibition Center (BEC), Mumbai, India',
        'date': '26 - 28 August 2026',
      },
      {
        'title': 'Amar Foods Leadership at Fi India 2026',
        'category': 'EXPOS & EVENTS',
        'image': AppImages.expoFiIndia1,
        'desc': 'Showcasing high-grade dehydrated onion & garlic products to international food processing brands.',
        'venue': 'Bombay Exhibition Center (BEC), Mumbai, India',
        'date': '26 - 28 August 2026',
      },
      {
        'title': 'Global B2B Strategic Partnerships & Networking',
        'category': 'EXPOS & EVENTS',
        'image': AppImages.expoFiIndia2,
        'desc': 'Business discussions with global ingredient distributors, spice importers, and contract packaging buyers.',
        'venue': 'Bombay Exhibition Center (BEC), Mumbai, India',
        'date': '26 - 28 August 2026',
      },
      {
        'title': 'Agri Crop Innovation & Ingredient Sourcing',
        'category': 'EXPOS & EVENTS',
        'image': AppImages.expoFiIndia3,
        'desc': 'Presenting Mahuva\'s rich agricultural origin, high dry matter, and natural flavor retention.',
        'venue': 'Bombay Exhibition Center (BEC), Mumbai, India',
        'date': '26 - 28 August 2026',
      },
      {
        'title': 'Quality Assurance & Sustainability Wall',
        'category': 'EXPOS & EVENTS',
        'image': AppImages.expoFiIndia4,
        'desc': 'Highlighting 100% natural, farm-traceable dehydrated products delivering goodness you can trust.',
        'venue': 'Bombay Exhibition Center (BEC), Mumbai, India',
        'date': '26 - 28 August 2026',
      },

      // --- RED ONION RANGE (5 PRODUCTS) ---
      {
        'title': 'Dehydrated Red Onion Flakes',
        'category': 'RED ONION',
        'image': AppImages.productRedOnionFlakes1,
        'desc': '8-15 mm kibbled red onion flakes processed under hygienic multi-stage conveyor drying.',
      },
      {
        'title': 'Dehydrated Red Onion Chopped',
        'category': 'RED ONION',
        'image': AppImages.productRedOnionChopped1,
        'desc': '3-5 mm chopped red onion bits with deep natural red-purple color and fast rehydration.',
      },
      {
        'title': 'Dehydrated Red Onion Minced',
        'category': 'RED ONION',
        'image': AppImages.productRedOnionMinced1,
        'desc': '1-3 mm minced red onion bits providing rich texture and pungency.',
      },
      {
        'title': 'Dehydrated Red Onion Granules',
        'category': 'RED ONION',
        'image': AppImages.productRedOnionGranules1,
        'desc': '0.5-1 mm coarse red onion granules with free-flowing high density.',
      },
      {
        'title': 'Dehydrated Red Onion Powder',
        'category': 'RED ONION',
        'image': AppImages.productRedOnionPowder1,
        'desc': '80-100 mesh fine free-flowing red onion powder for instant flavor release.',
      },

      // --- WHITE ONION RANGE (5 PRODUCTS) ---
      {
        'title': 'Dehydrated White Onion Flakes',
        'category': 'WHITE ONION',
        'image': AppImages.productWhiteOnionFlakes1,
        'desc': '8-15 mm white kibbled flakes with bright white color and clean sweet aroma.',
      },
      {
        'title': 'Dehydrated White Onion Chopped',
        'category': 'WHITE ONION',
        'image': AppImages.productWhiteOnionChopped1,
        'desc': '3-5 mm chopped white onion bits for instant soups and prepared meals.',
      },
      {
        'title': 'Dehydrated White Onion Minced',
        'category': 'WHITE ONION',
        'image': AppImages.productWhiteOnionMinced1,
        'desc': '1-3 mm minced white onion bits for spice seasonings and meat processing.',
      },
      {
        'title': 'Dehydrated White Onion Granules',
        'category': 'WHITE ONION',
        'image': AppImages.productWhiteOnionGranules1,
        'desc': '0.5-1 mm coarse white onion granules for uniform spice rubs and dry mixes.',
      },
      {
        'title': 'Dehydrated White Onion Powder',
        'category': 'WHITE ONION',
        'image': AppImages.productWhiteOnionPowder1,
        'desc': '80-100 mesh fine free-flowing white onion powder with instant solubility.',
      },

      // --- PINK ONION RANGE (5 PRODUCTS) ---
      {
        'title': 'Dehydrated Pink Onion Flakes',
        'category': 'PINK ONION',
        'image': AppImages.productPinkOnionFlakes1,
        'desc': '8-15 mm kibbled pink onion flakes with mild sweet aroma.',
      },
      {
        'title': 'Dehydrated Pink Onion Chopped',
        'category': 'PINK ONION',
        'image': AppImages.productPinkOnionChopped1,
        'desc': '3-5 mm chopped pink onion pieces for stews and prepared dishes.',
      },
      {
        'title': 'Dehydrated Pink Onion Minced',
        'category': 'PINK ONION',
        'image': AppImages.productPinkOnionMinced1,
        'desc': '1-3 mm minced pink onion bits for dressings, marinades, and seasonings.',
      },
      {
        'title': 'Pink Onion Minced & Granules',
        'category': 'PINK ONION',
        'image': AppImages.productPinkOnionGranules1,
        'desc': '0.5-1 mm coarse granules with balanced sweetness and warm aroma.',
      },
      {
        'title': 'Dehydrated Pink Onion Powder',
        'category': 'PINK ONION',
        'image': AppImages.productPinkOnionPowder1,
        'desc': '80-100 mesh fine pink onion powder for snack dustings and seasonings.',
      },

      // --- GARLIC RANGE (5 PRODUCTS) ---
      {
        'title': 'Dehydrated Garlic Flakes',
        'category': 'GARLIC',
        'image': AppImages.productGarlicFlakes1,
        'desc': '10-15 mm crisp sliced garlic cloves with natural yellowish luster and Allicin potency.',
      },
      {
        'title': 'Dehydrated Garlic Chopped',
        'category': 'GARLIC',
        'image': AppImages.productGarlicChopped1,
        'desc': '3-5 mm chopped garlic bits with intense aroma for canned and prepared foods.',
      },
      {
        'title': 'Dehydrated Garlic Minced',
        'category': 'GARLIC',
        'image': AppImages.productGarlicMinced1,
        'desc': '1-3 mm minced garlic bits for sausage seasonings, sauces, and dips.',
      },
      {
        'title': 'Dehydrated Garlic Granules',
        'category': 'GARLIC',
        'image': AppImages.productGarlicGranules1,
        'desc': '0.5-1 mm golden coarse garlic granules with free-flowing texture.',
      },
      {
        'title': 'Dehydrated Garlic Powder',
        'category': 'GARLIC',
        'image': AppImages.productGarlicPowder1,
        'desc': '80-100 mesh fine garlic powder without anti-caking additives.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Header Section with Rich Photo Vignette & Glass Overlay
            Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppImages.heroBackground,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFF0F172A));
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF0F172A).withOpacity(0.90),
                          const Color(0xFF260B1E).withOpacity(0.95),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
                  child: Center(
                    child: Container(
                      constraints: LiquidUI.pageConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(0.18)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          LiquidUI.badgePill(
                            text: 'MEDIA & INFRASTRUCTURE GALLERY',
                            icon: Icons.photo_library_rounded,
                            backgroundColor: AppColors.secondary.withOpacity(0.2),
                            textColor: AppColors.secondary,
                            fontSize: 11,
                          ),
                          const SizedBox(height: 20),

                          LiquidUI.gradientText(
                            'Photos Gallery',
                            gradient: const LinearGradient(
                              colors: [Colors.white, Color(0xFFF5E6F0)],
                            ),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: headingSize,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Explore our export product lineup, Mahuva factory facilities, and agricultural processing quality.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 28),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Gallery Content Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
              child: Center(
                child: Container(
                  constraints: LiquidUI.pageConstraints(),
                  child: Column(
                    children: [
                      // Category Filter Bar
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterTab('ALL', 'All Media', galleryItems.length),
                            const SizedBox(width: 10),
                            _buildFilterTab('EXPOS & EVENTS', 'Fi India 2026 Expo', galleryItems.where((i) => i['category'] == 'EXPOS & EVENTS').length),
                            const SizedBox(width: 10),
                            _buildFilterTab('RED ONION', 'Red Onion', galleryItems.where((i) => i['category'] == 'RED ONION').length),
                            const SizedBox(width: 10),
                            _buildFilterTab('WHITE ONION', 'White Onion', galleryItems.where((i) => i['category'] == 'WHITE ONION').length),
                            const SizedBox(width: 10),
                            _buildFilterTab('PINK ONION', 'Pink Onion', galleryItems.where((i) => i['category'] == 'PINK ONION').length),
                            const SizedBox(width: 10),
                            _buildFilterTab('GARLIC', 'Garlic', galleryItems.where((i) => i['category'] == 'GARLIC').length),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Gallery Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final displayedItems = _selectedCategory == 'ALL'
                              ? galleryItems
                              : galleryItems.where((item) => item['category'] == _selectedCategory).toList();

                          if (displayedItems.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                'No items found for this category.',
                                style: GoogleFonts.inter(color: AppColors.textSecondary),
                              ),
                            );
                          }

                          if (isMobile) {
                            return Column(
                              children: displayedItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: _buildGalleryCard(context, item),
                              )).toList(),
                            );
                          } else {
                            return Wrap(
                              spacing: 24,
                              runSpacing: 28,
                              children: displayedItems.map((item) => SizedBox(
                                width: (constraints.maxWidth - 24) / 2 > 340
                                    ? (constraints.maxWidth - 48) / 3
                                    : (constraints.maxWidth - 24) / 2,
                                child: _buildGalleryCard(context, item),
                              )).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom CTA Banner
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Center(
                child: Container(
                  constraints: LiquidUI.pageConstraints(),
                  child: Column(
                    children: [
                      Text(
                        'Need High-Resolution Product Specifications or Samples?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Contact our export team for laboratory analysis reports, COA certificates, and sample dispatch.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _showQuoteDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          'Request Product Samples',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String catKey, String label, int count) {
    final bool isSelected = _selectedCategory == catKey;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = catKey;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.15),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, Map<String, String> item) {
    final String title = item['title'] ?? 'Amar Foods Media';
    final String category = item['category'] ?? 'PRODUCTS';
    final String image = item['image'] ?? AppImages.aboutProducts;
    final String desc = item['desc'] ?? 'Export-grade dehydrated onion & garlic product processed under hygienic heat-controlled dehydration.';
    final bool isExpo = category == 'EXPOS & EVENTS';

    return LiquidUI.interactiveGlassCard(
      onTap: () {
        if (isExpo) {
          _showExpoLightbox(context, item);
        } else {
          final product = ProductModel(
            id: title.toLowerCase().replaceAll(' ', '_'),
            title: title,
            category: category,
            tag: 'EXPORT GRADE',
            tagline: 'Pure 100% natural dehydrated crop origin Mahuva, Gujarat.',
            origin: 'MAHUVA, GUJARAT, INDIA',
            images: [image, AppImages.productRedOnionFlakes, AppImages.productGarlicFlakes, AppImages.productWhiteOnionPowder],
            purity: '99.5% min',
            moisture: '≤ 6.0%',
            shelfLife: '24 Months',
            description: desc,
            keyFeatures: const [
              '100% pure Mahuva Gujarat agricultural origin',
              'Multi-stage optical sorting and metal detection',
              'Zero sulfur bleaching or artificial additives',
              'ISO 22000, HACCP, FSSAI & HALAL certified',
            ],
            applications: const [
              'Spice grinding, dry seasonings, and rub mixes',
              'Ready-to-eat meals, soups, and noodle mixes',
              'HoReCa hotel, restaurant, and catering supply',
              'Bakery, pickle, sauce, and snack manufacturing',
            ],
            specs: const {
              'Origin': 'Mahuva, Gujarat, India',
              'Moisture Content': 'Max 6.0%',
              'Total Ash': 'Max 4.5%',
              'Acid Insoluble Ash': 'Max 0.5%',
              'Microbiological': 'E.Coli: Negative / Salmonella: Absent',
            },
          );
          showProductDetailModal(context, product);
        }
      },
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
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    cacheWidth: 600,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: Icon(Icons.image_outlined, size: 48, color: AppColors.primary),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isExpo ? AppColors.secondary : AppColors.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              if (isExpo)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.zoom_in_rounded, size: 16, color: Colors.white),
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExpoLightbox(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 30, offset: Offset(0, 10)),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: Image.asset(
                          item['image']!,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'FI INDIA 2026 • MUMBAI',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['title']!,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['desc']!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (item['venue'] != null)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.event_available_rounded, color: AppColors.primary, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['venue']!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      if (item['date'] != null)
                                        Text(
                                          item['date']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Backward Compatibility Class Alias
class ShipmentsPage extends StatelessWidget {
  const ShipmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GalleryPage();
  }
}
