import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../data/products_data.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';
import '../widgets/product_detail_dialog.dart';
import '../widgets/whatsapp_floating_button.dart';
import '../services/firebase_service.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Inline Inquiry Form State
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _qtyController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _qtyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  Future<void> _openWhatsAppInquiry() async {
    final message = Uri.encodeComponent(
      'Hello Amar Foods, I am interested in container pricing for ${widget.product.title} (${widget.product.tag}). Origin: ${widget.product.origin}. Please provide live CIF/FOB quote.',
    );
    final url = Uri.parse('https://wa.me/917284088737?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _submitInlineInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final combinedMessage = 'Quantity Required: ${_qtyController.text.trim()}\n'
        'Destination Port / Country: ${_countryController.text.trim()}\n'
        'Inquiry: ${_messageController.text.trim()}';

    final success = await FirebaseService.submitQuoteRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      country: _countryController.text.trim(),
      product: '${widget.product.title} (${widget.product.tag})',
      message: combinedMessage,
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSubmitted = success;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Thank you! Your quote request for ${widget.product.title} has been submitted. Our export desk will contact you shortly.',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.secondary,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double paddingH = isMobile ? 16 : 32;

    // Filter related products from same category
    final relatedProducts = ProductsData.allProducts
        .where((p) =>
            p.id != widget.product.id &&
            (p.category == widget.product.category ||
                (p.category.contains('ONION') && widget.product.category.contains('ONION'))))
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const WhatsAppFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================== 1. HERO BANNER & BREADCRUMBS ====================
            _buildHeroBanner(context, isMobile),

            // ==================== 2. MAIN SHOWCASE (IMAGE & OVERVIEW) ====================
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 32 : 56),
                child: _buildShowcaseSection(context, isMobile),
              ),
            ),

            // ==================== 3. TECHNICAL SPECIFICATIONS TABLE ====================
            _buildSpecsSection(context, isMobile, paddingH),

            // ==================== 4. KEY FEATURES & HIGHLIGHTS ====================
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 48),
                child: _buildFeaturesSection(context, isMobile),
              ),
            ),

            // ==================== 5. PACKAGING & CONTAINER SHIPPING ====================
            _buildPackagingShippingSection(context, isMobile, paddingH),

            // ==================== 6. EXPORT CERTIFICATIONS & DOCUMENTATION ====================
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 48),
                child: _buildDocumentationSection(context, isMobile),
              ),
            ),

            // ==================== 7. CULINARY & INDUSTRIAL APPLICATIONS ====================
            _buildApplicationsSection(context, isMobile, paddingH),

            // ==================== 8. INLINE INQUIRY / QUOTE FORM ====================
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 48),
                child: _buildInquiryFormSection(context, isMobile),
              ),
            ),

            // ==================== 9. RELATED PRODUCTS ====================
            if (relatedProducts.isNotEmpty)
              _buildRelatedProductsSection(context, relatedProducts, isMobile, paddingH),

            // ==================== FOOTER ====================
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 1: HERO BANNER
  // ===========================================================================
  Widget _buildHeroBanner(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E0A19),
            Color(0xFF260B1E),
            Color(0xFF0F172A),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 40,
        vertical: isMobile ? 32 : 54,
      ),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/'),
                    child: Text(
                      'Home',
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 16),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/products'),
                    child: Text(
                      'Products',
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.product.category,
                      style: GoogleFonts.outfit(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title and Tag
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB400).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFB400).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, color: Color(0xFFFFB400), size: 14),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.product.tag} • EXPORT GRADE A',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFFFB400),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.product.title,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: isMobile ? 26 : 42,
                            fontWeight: FontWeight.bold,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.product.tagline,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: isMobile ? 14 : 17,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _buildHeroBadge(Icons.location_on_outlined, widget.product.origin),
                            _buildHeroBadge(Icons.science_outlined, 'Botanical: ${widget.product.botanicalName}'),
                            _buildHeroBadge(Icons.tag_rounded, 'HS Code: ${widget.product.hsCode}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondary, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 2: SHOWCASE (IMAGE & OVERVIEW)
  // ===========================================================================
  Widget _buildShowcaseSection(BuildContext context, bool isMobile) {
    final imageWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Image Frame
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.25,
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.cover,
                  cacheWidth: 900,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1E0A19),
                      child: const Center(
                        child: Icon(Icons.inventory_2_outlined, color: AppColors.secondary, size: 64),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco_rounded, color: AppColors.secondary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '100% PURE & NATURAL',
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
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E0A19).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'Direct Farm Sourced',
                    style: GoogleFonts.outfit(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Quality Assurance Box
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'EXPORT QUALITY & HYGIENE GUARANTEE',
                    style: GoogleFonts.outfit(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildBulletItem('Multi-stage Optical Sortex cleaned & Rare Earth Magnet / Metal Detector passed.'),
              _buildBulletItem('Pesticide residue free & Microbiologically compliant with US FDA / EU standards.'),
              _buildBulletItem('Custom particle sizes: Kibbled, Chopped (3-5mm), Minced (1-3mm), Granules, Powder (80-100 mesh).'),
            ],
          ),
        ),
      ],
    );

    final detailsWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Overview',
          style: GoogleFonts.outfit(
            color: AppColors.secondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 15,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 28),

        // Key Metric Grid Cards
        Text(
          'Export Grade Analytical Highlights',
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildHighlightCard('Purity', widget.product.purity, Icons.check_circle_outline),
            _buildHighlightCard('Moisture', widget.product.moisture, Icons.water_drop_outlined),
            _buildHighlightCard('Shelf Life', widget.product.shelfLife, Icons.hourglass_top_rounded),
            _buildHighlightCard('Cultivar Origin', widget.product.origin.split(',')[0], Icons.terrain_rounded),
          ],
        ),
        const SizedBox(height: 32),

        // Dual Action Buttons
        Wrap(
          spacing: 16,
          runSpacing: 14,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showQuoteDialog(context),
              icon: const Icon(Icons.description_outlined, size: 18),
              label: Text(
                'Request Container Quote',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 6,
              ),
            ),
            OutlinedButton.icon(
              onPressed: _openWhatsAppInquiry,
              icon: const Icon(Icons.chat_rounded, size: 18, color: Color(0xFF25D366)),
              label: Text(
                'Chat on WhatsApp',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
                backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ],
    );

    if (isMobile) {
      return Column(
        children: [
          imageWidget,
          const SizedBox(height: 36),
          detailsWidget,
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: imageWidget),
          const SizedBox(width: 48),
          Expanded(flex: 7, child: detailsWidget),
        ],
      );
    }
  }

  Widget _buildHighlightCard(String title, String value, IconData icon) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondary, size: 15),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.secondary, fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.5, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 3: TECHNICAL SPECIFICATIONS TABLE (MATCHING REFERENCE SITE)
  // ===========================================================================
  Widget _buildSpecsSection(BuildContext context, bool isMobile, double paddingH) {
    final Map<String, String> fullSpecs = {
      'Product Name': widget.product.title,
      'Botanical Name': widget.product.botanicalName,
      'Harmonized System (HS Code)': widget.product.hsCode,
      'Origin / Growing Region': widget.product.origin,
      'Physical Form / Granulation': widget.product.tag,
      'Purity': widget.product.purity,
      'Moisture Content': widget.product.moisture,
      'Shelf Life': '${widget.product.shelfLife} under recommended storage',
      'Foreign Organic Matter': 'Nil (Multi-Stage Sortex Cleaned)',
      'Metal Contamination': 'Passed Rare Earth Magnets & Metal Detector',
      'Storage Recommendation': 'Cool & Dry Place (< 20°C, RH < 60%), away from direct sunlight',
      ...widget.product.specs,
    };

    return Container(
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.02),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 56),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'LABORATORY TESTED & CERTIFIED',
                        style: GoogleFonts.outfit(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Technical Specifications & Quality Parameters',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: isMobile ? 22 : 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complying with FSSAI, US FDA, EU ASTA, ISO 22000, and International Food Safety Standards',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Responsive Specs Table
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                  color: const Color(0xFF1E0A19),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'PARAMETER / TEST',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFFFB400),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text(
                              'EXPORT SPECIFICATION / LIMIT',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Rows
                    ...fullSpecs.entries.toList().asMap().entries.map((item) {
                      final index = item.key;
                      final entry = item.value;
                      final isEven = index % 2 == 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: isEven ? Colors.transparent : Colors.white.withValues(alpha: 0.03),
                          border: const Border(top: BorderSide(color: Colors.white10)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                entry.key,
                                style: GoogleFonts.outfit(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                entry.value,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  height: 1.4,
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
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 4: KEY FEATURES & BENEFITS
  // ===========================================================================
  Widget _buildFeaturesSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Key Processing Highlights & Product Features',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 22 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Why leading international food manufacturers source from Amar Foods',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: widget.product.keyFeatures.map((feat) {
            return SizedBox(
              width: isMobile ? double.infinity : 360,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        feat,
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 5: PACKAGING & CONTAINER SHIPPING
  // ===========================================================================
  Widget _buildPackagingShippingSection(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF190614),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 56),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              Text(
                'Export Packaging & Global Logistics Specs',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 22 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Safeguarding freshness, aroma, and microbiological integrity across sea transit',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 36),

              // Packaging cards
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildShippingCard(
                    title: 'Kraft Paper Export Bag',
                    subtitle: '20 kg / 25 kg Net Weight',
                    detail: 'Multi-wall Kraft paper outer bag with heat-sealed food grade inner polyethylene (PE) liner.',
                    icon: Icons.inventory_2_outlined,
                    isMobile: isMobile,
                  ),
                  _buildShippingCard(
                    title: 'Corrugated Master Box',
                    subtitle: '15 kg / 20 kg Net Weight',
                    detail: 'Heavy-duty 5-ply export grade corrugated cartons with double inner poly-liner for high moisture protection.',
                    icon: Icons.all_inbox_rounded,
                    isMobile: isMobile,
                  ),
                  _buildShippingCard(
                    title: 'Private Label OEM Pouches',
                    subtitle: '100g to 5kg Stand-up Pouches',
                    detail: 'Nitrogen-flushed aluminum foil or barrier pouches with customized buyer branding and barcode printing.',
                    icon: Icons.loyalty_outlined,
                    isMobile: isMobile,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Container Loadability Highlight
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.secondary.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(
                      'CONTAINER LOADABILITY & PORTS OF DISPATCH',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFFFB400),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 30,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceAround,
                      children: [
                        _buildContainerStat('20 FT FCL CONTAINER', '12 - 14 Metric Tons', 'Approx. 550 - 600 Bags (Loose/Palletized)'),
                        _buildContainerStat('40 FT HC CONTAINER', '24 - 26 Metric Tons', 'Approx. 1,100 - 1,200 Bags (Loose/Palletized)'),
                        _buildContainerStat('LOADING SEA PORTS', 'Mundra, Pipavav & JNPT', 'Direct proximity to factory (Mahuva, Gujarat)'),
                        _buildContainerStat('ACCEPTED INCOTERMS', 'FOB, CIF, CFR, EXW', 'Fast vessel connections to GCC, EU, USA, APAC'),
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

  Widget _buildShippingCard({
    required String title,
    required String subtitle,
    required String detail,
    required IconData icon,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? double.infinity : 320,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary, size: 28),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.outfit(color: const Color(0xFFFFB400), fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            detail,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildContainerStat(String label, String value, String sub) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: GoogleFonts.inter(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 6: EXPORT CERTIFICATIONS & DOCUMENTATION
  // ===========================================================================
  Widget _buildDocumentationSection(BuildContext context, bool isMobile) {
    final docs = [
      {'title': 'Certificate of Origin (COO)', 'desc': 'Issued by Chamber of Commerce / Govt. of India for preferential tariff import.'},
      {'title': 'Phytosanitary Certificate', 'desc': 'Official Plant Quarantine inspection certificate verifying freedom from plant pests.'},
      {'title': 'Certificate of Analysis (COA)', 'desc': 'Full batch lab analysis verifying purity, moisture, microbiological and physical specs.'},
      {'title': 'Fumigation Certificate', 'desc': 'Professional sea container fumigation certificate (Methyl Bromide / Phosphine gas).'},
      {'title': 'Third-Party Lab Reports', 'desc': 'SGS / Eurofins / Geo-Chem pre-shipment inspection reports available upon buyer request.'},
      {'title': 'Halal & Kosher Compliance', 'desc': 'Officially accredited Halal and Kosher certification for religious dietary compliance.'},
    ];

    return Column(
      children: [
        Text(
          'Export Documentation Provided with Every Shipment',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: isMobile ? 22 : 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Hassle-free customs clearance with complete international export compliance papers',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
        ),
        const SizedBox(height: 32),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: docs.map((d) {
            return SizedBox(
              width: isMobile ? double.infinity : 360,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.assignment_turned_in_outlined, color: AppColors.secondary, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['title']!,
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d['desc']!,
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.5, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 7: APPLICATIONS
  // ===========================================================================
  Widget _buildApplicationsSection(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.02),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 54),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              Text(
                'Food Industry & Culinary Applications',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 22 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Engineered for clean reconstitution, strong aroma release, and industrial batch stability',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 32),

              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: widget.product.applications.map((app) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant_menu_rounded, color: AppColors.secondary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          app,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 8: INLINE INQUIRY / QUOTE FORM
  // ===========================================================================
  Widget _buildInquiryFormSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 36),
      decoration: BoxDecoration(
        color: const Color(0xFF1E0A19),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: AppColors.secondary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Container Pricing for ${widget.product.title}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: isMobile ? 18 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Get live FOB Mundra / CIF destination container pricing within 24 hours',
                        style: GoogleFonts.inter(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Form Fields
            if (isMobile) ...[
              _buildTextFormField('Your Full Name *', _nameController, Icons.person_outline),
              const SizedBox(height: 14),
              _buildTextFormField('Email Address *', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildTextFormField('Phone / WhatsApp with Country Code *', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              _buildTextFormField('Destination Country / Sea Port *', _countryController, Icons.public_outlined),
              const SizedBox(height: 14),
              _buildTextFormField('Required Quantity (e.g. 1 FCL 20ft / 14 MT) *', _qtyController, Icons.scale_outlined),
              const SizedBox(height: 14),
              _buildTextFormField('Inquiry / Packaging Requirements', _messageController, Icons.notes_outlined, maxLines: 3),
            ] else ...[
              Row(
                children: [
                  Expanded(child: _buildTextFormField('Your Full Name *', _nameController, Icons.person_outline)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextFormField('Email Address *', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextFormField('Phone / WhatsApp with Country Code *', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextFormField('Destination Country / Sea Port *', _countryController, Icons.public_outlined)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextFormField('Required Quantity (e.g. 1 FCL 20ft / 14 MT) *', _qtyController, Icons.scale_outlined),
              const SizedBox(height: 16),
              _buildTextFormField('Inquiry / Specific Packaging Requirements', _messageController, Icons.notes_outlined, maxLines: 3),
            ],
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitInlineInquiry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 6,
                ),
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        _isSubmitted ? '✓ INQUIRY SENT - OUR DESK WILL CONTACT YOU' : 'SUBMIT CONTAINER QUOTE INQUIRY',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (val) {
        if (label.contains('*') && (val == null || val.trim().isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(color: Colors.white60, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.secondary, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.secondary, width: 1.5)),
      ),
    );
  }

  // ===========================================================================
  // SECTION 9: RELATED PRODUCTS
  // ===========================================================================
  Widget _buildRelatedProductsSection(
    BuildContext context,
    List<ProductModel> relatedProducts,
    bool isMobile,
    double paddingH,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.01),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 56),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Products in Export Range',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Explore other farm-fresh dehydrated ingredients from our Mahuva processing facility',
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 28),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: relatedProducts.map((rel) {
                  return SizedBox(
                    width: isMobile ? double.infinity : 350,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E0A19),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.6,
                            child: Image.asset(
                              rel.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF260B1E)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rel.tag,
                                  style: GoogleFonts.outfit(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rel.title,
                                  style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  rel.tagline,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailPage(product: rel),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.secondary),
                                      foregroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    child: Text(
                                      'View Details',
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
