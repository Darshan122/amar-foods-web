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
      {
        'title': 'Dehydrated Red Onion Flakes (Scattered Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productRedOnionFlakes,
        'desc': '8-15 mm kibbled red onion flakes in wooden bowl surrounded by fresh Mahuva red onions.',
      },
      {
        'title': 'Dehydrated Red Onion Flakes (Front Close-Up)',
        'category': 'PRODUCTS',
        'image': AppImages.productRedOnionFlakes2,
        'desc': 'Front close-up view of kibbled red onion flakes in studio wooden bowl.',
      },
      {
        'title': 'Dehydrated Red Onion Flakes & Fresh Onions',
        'category': 'PRODUCTS',
        'image': AppImages.productRedOnionFlakes3,
        'desc': 'Red onion flakes bowl flanked by 2 fresh whole Mahuva red onions.',
      },
      {
        'title': 'Dehydrated Red Onion Flakes Spilling Studio',
        'category': 'PRODUCTS',
        'image': AppImages.productRedOnionFlakes4,
        'desc': 'Creative studio presentation of spilling red onion flakes and fresh bulb.',
      },
      {
        'title': 'Dehydrated Red Onion Flakes Pure Overhead',
        'category': 'PRODUCTS',
        'image': AppImages.productRedOnionFlakes5,
        'desc': 'Overhead top-down texture shot of 100% pure dehydrated red onion flakes.',
      },
      {
        'title': 'Dehydrated White Onion Powder',
        'category': 'PRODUCTS',
        'image': AppImages.productWhiteOnionPowder,
        'desc': '80-100 mesh fine free-flowing white onion powder for dry mixes and spice seasoning.',
      },
      {
        'title': 'Pink Onion Minced (Front Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productPinkOnionGranules,
        'desc': '1-3 mm chopped pink onion bits with rich natural pungency in wooden bowl.',
      },
      {
        'title': 'Pink Onion Minced (Front Angle)',
        'category': 'PRODUCTS',
        'image': AppImages.productPinkOnionGranules2,
        'desc': 'Studio presentation of Gujarat pink onion minced bits.',
      },
      {
        'title': 'Pink Onion Granules & Powder (Front Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productPinkOnionGranules3,
        'desc': 'Fine 0.5-1 mm pink onion granules with sweet aromatic flavor.',
      },
      {
        'title': 'Pink Onion Granules (Overhead Top View)',
        'category': 'PRODUCTS',
        'image': AppImages.productPinkOnionGranules4,
        'desc': 'Top-down overhead studio shot of pure pink onion granules.',
      },
      {
        'title': 'Pink Onion Minced & Chopped Pure Overhead',
        'category': 'PRODUCTS',
        'image': AppImages.productPinkOnionGranules5,
        'desc': 'High-resolution overhead texture shot of dehydrated pink onion bits.',
      },
      {
        'title': 'Dehydrated Garlic Flakes (Overhead Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicFlakes,
        'desc': 'Crisp sliced garlic cloves in studio wooden bowl (Overhead view).',
      },
      {
        'title': 'Dehydrated Garlic Flakes (Front Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicFlakes2,
        'desc': 'Pure whole peeled dehydrated garlic cloves and slices (Front studio view).',
      },
      {
        'title': 'Dehydrated Garlic Powder (Front Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicPowder,
        'desc': 'Pure 100% fine garlic powder in studio wooden bowl, free from anti-caking additives.',
      },
      {
        'title': 'Dehydrated Garlic Powder & Clove Heap',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicPowder2,
        'desc': 'Garlic powder bowl resting over a heap of fresh dehydrated garlic cloves.',
      },
      {
        'title': 'Dehydrated Garlic Powder (Overhead Top View)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicPowder3,
        'desc': 'Top-down overhead studio shot of 80-100 mesh fine garlic powder.',
      },
      {
        'title': 'Dehydrated Garlic Powder Heap Close-Up',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicPowder4,
        'desc': 'Close-up presentation of fine garlic powder bowl over sliced garlic cloves.',
      },
      {
        'title': 'Dehydrated Garlic Powder Pure Overhead',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicPowder5,
        'desc': 'High-resolution overhead texture shot of export-grade garlic powder.',
      },
      {
        'title': 'Dehydrated Garlic Granules (Front Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicGranules,
        'desc': 'Golden-amber 0.5-1 mm coarse garlic granules in wooden studio bowl.',
      },
      {
        'title': 'Dehydrated Garlic Granules over Clove Heap',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicGranules2,
        'desc': 'Garlic granules bowl resting on a heap of dehydrated garlic cloves.',
      },
      {
        'title': 'Dehydrated Garlic Granules (Overhead Top View)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicGranules3,
        'desc': 'Top-down overhead studio shot of coarse garlic granules.',
      },
      {
        'title': 'Dehydrated Garlic Granules Center Studio',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicGranules4,
        'desc': 'Center studio view of 0.5-1 mm free-flowing garlic granules.',
      },
      {
        'title': 'Dehydrated Garlic Granules Side Angle',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicGranules5,
        'desc': 'Side angle studio shot of export-grade garlic granules.',
      },
      {
        'title': 'Dehydrated Garlic Minced (Angle Studio)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicMinced,
        'desc': '1-3 mm chopped garlic bits with fresh garlic bulb in wooden bowl.',
      },
      {
        'title': 'Dehydrated Garlic Minced & Heap',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicMinced2,
        'desc': 'Garlic minced bowl over a heap of dehydrated garlic cloves.',
      },
      {
        'title': 'Dehydrated Garlic Minced (Top-Down Overhead)',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicMinced3,
        'desc': 'Overhead studio shot of 100% pure dehydrated garlic granules.',
      },
      {
        'title': 'Dehydrated Garlic Minced Studio Close-Up',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicMinced4,
        'desc': 'Front close-up view of dehydrated garlic minced and raw garlic bulbs.',
      },
      {
        'title': 'Dehydrated Garlic Minced Studio Clean Heap',
        'category': 'PRODUCTS',
        'image': AppImages.productGarlicMinced5,
        'desc': 'Clean studio presentation of garlic granules over sliced cloves.',
      },
      {
        'title': 'Mahuva Processing Facility & Harvest',
        'category': 'FACILITY',
        'image': AppImages.aboutProducts,
        'desc': 'Direct farm procurement in Mahuva, Gujarat—India\'s largest onion dehydration hub.',
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
                            'Photo & Facility Gallery',
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

                      // Gallery Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (isMobile) {
                            return Column(
                              children: galleryItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: _buildGalleryCard(context, item),
                              )).toList(),
                            );
                          } else {
                            return Wrap(
                              spacing: 24,
                              runSpacing: 28,
                              children: galleryItems.map((item) => SizedBox(
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

  Widget _buildGalleryCard(BuildContext context, Map<String, String> item) {
    final String title = item['title'] ?? 'Amar Foods Dehydrated Product';
    final String category = item['category'] ?? 'PRODUCTS';
    final String image = item['image'] ?? AppImages.aboutProducts;
    final String desc = item['desc'] ?? 'Export-grade dehydrated onion & garlic product processed under hygienic heat-controlled dehydration.';

    final product = ProductModel(
      id: title.toLowerCase().replaceAll(' ', '_'),
      title: title,
      category: category,
      tag: category == 'STUDIO COLLECTION' ? 'EXPORT STUDIO PHOTO' : 'EXPORT GRADE',
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
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    item['image']!,
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
                    color: AppColors.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['category']!,
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
                  item['title']!,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['desc']!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
