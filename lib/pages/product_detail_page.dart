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
import '../widgets/app_buttons.dart';
import '../widgets/amar_card.dart';
import '../services/firebase_service.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
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
    final double paddingH = isMobile ? 16 : 36;

    final relatedProducts = ProductsData.allProducts
        .where((p) =>
            p.id != widget.product.id &&
            (p.category == widget.product.category ||
                (p.category.contains('ONION') && widget.product.category.contains('ONION'))))
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const WhatsAppFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. BREADCRUMBS & HERO HEADER (Rich Brand Banner)
            _buildHeroBanner(context, isMobile),

            // 2. MAIN SHOWCASE (Image + Overview + Key Metrics)
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 28 : 48),
                child: _buildShowcaseSection(context, isMobile),
              ),
            ),

            // 3. TECHNICAL SPECIFICATIONS TABLE (Clean High-Contrast Export Table)
            _buildSpecsSection(context, isMobile, paddingH),

            // 4. KEY FEATURES & ADVANTAGES
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 48),
                child: _buildFeaturesSection(context, isMobile),
              ),
            ),

            // 5. PACKAGING & CONTAINER SHIPPING SPECS
            _buildPackagingShippingSection(context, isMobile, paddingH),

            // 6. CULINARY & INDUSTRIAL APPLICATIONS
            _buildApplicationsSection(context, isMobile, paddingH),

            // 8. DIRECT CONTAINER INQUIRY FORM
            Center(
              child: Container(
                constraints: LiquidUI.pageConstraints(),
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 48),
                child: _buildInquiryFormSection(context, isMobile),
              ),
            ),

            // 9. RELATED PRODUCTS
            if (relatedProducts.isNotEmpty)
              _buildRelatedProductsSection(context, relatedProducts, isMobile, paddingH),

            // FOOTER
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 1: HERO BANNER (Rich Brand Banner)
  // ===========================================================================
  Widget _buildHeroBanner(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF260B1E), // Deep Amar Foods Plum
            Color(0xFF4A1235), // Rich Logo Plum
            Color(0xFF1E0A19),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 40,
        vertical: isMobile ? 28 : 44,
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
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 16),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/products'),
                    child: Text(
                      'Products',
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      widget.product.category,
                      style: GoogleFonts.outfit(color: const Color(0xFF6EE7B7), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Title and Badges
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB703).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFB703).withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: Color(0xFFFFB703), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.product.tag} • EXPORT GRADE A',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFFFB703),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.title,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: isMobile ? 26 : 40,
                      fontWeight: FontWeight.bold,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.tagline,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isMobile ? 14 : 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _buildHeroBadge(Icons.location_on_outlined, 'Origin: ${widget.product.origin}'),
                      _buildHeroBadge(Icons.science_outlined, 'Botanical: ${widget.product.botanicalName}'),
                      _buildHeroBadge(Icons.tag_rounded, 'HS Code: ${widget.product.hsCode}'),
                    ],
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
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF6EE7B7), size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 2: SHOWCASE (IMAGE & OVERVIEW) - CRISP LIGHT THEME
  // ===========================================================================
  Widget _buildShowcaseSection(BuildContext context, bool isMobile) {
    final imageWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Image Frame with light card styling
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
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
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: Icon(Icons.inventory_2_outlined, color: AppColors.secondary, size: 64),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco_rounded, color: Color(0xFF4ADE80), size: 13),
                      const SizedBox(width: 5),
                      Text(
                        '100% PURE & NATURAL',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Direct Farm Sourced',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Quality Assurance Box (Clean light card)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 18),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'PRODUCT OVERVIEW',
            style: GoogleFonts.outfit(
              color: AppColors.secondary,
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.description,
          style: GoogleFonts.inter(
            color: const Color(0xFF334155), // Crisp readable slate dark
            fontSize: 15.5,
            height: 1.7,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 26),

        // Key Metric Grid Cards
        Text(
          'Export Grade Analytical Highlights',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0F172A), // Clear dark header
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
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
        const SizedBox(height: 30),

        // Dual Action Buttons
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            AmarPrimaryButton(
              onPressed: () => _showQuoteDialog(context),
              icon: Icons.description_outlined,
              label: 'Request Container Quote',
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              fontSize: 14,
            ),
            AmarSecondaryButton(
              onPressed: _openWhatsAppInquiry,
              icon: Icons.chat_rounded,
              label: 'Chat on WhatsApp',
              customAccent: const Color(0xFF15803D),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              fontSize: 14,
            ),
          ],
        ),
      ],
    );

    if (isMobile) {
      return Column(
        children: [
          imageWidget,
          const SizedBox(height: 32),
          detailsWidget,
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: imageWidget),
          const SizedBox(width: 44),
          Expanded(flex: 7, child: detailsWidget),
        ],
      );
    }
  }

  Widget _buildHighlightCard(String title, String value, IconData icon) {
    return Container(
      width: 145,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondary, size: 16),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.outfit(
                  color: const Color(0xFF64748B),
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: const Color(0xFF0F172A), // Crisp black
              fontSize: 14.5,
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
          const Text('• ', style: TextStyle(color: AppColors.secondary, fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 3: TECHNICAL SPECIFICATIONS TABLE (MATCHING BENCHMARK SITE)
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
      color: Colors.white,
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
                        color: AppColors.secondary.withValues(alpha: 0.12),
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
                        color: const Color(0xFF0F172A),
                        fontSize: isMobile ? 22 : 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complying with FSSAI, US FDA, EU ASTA, ISO 22000, and International Food Safety Standards',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Specifications Table (High contrast & clean)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF260B1E),
                            Color(0xFF4A1235),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'PARAMETER / TEST',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFFFB703),
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
                          color: isEven ? Colors.white : const Color(0xFFF8FAFC),
                          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                entry.key,
                                style: GoogleFonts.outfit(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                entry.value,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF1E293B),
                                  fontSize: 13.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
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
                  color: const Color(0xFF0F172A),
                  fontSize: isMobile ? 22 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Why leading international food manufacturers source from Amar Foods',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        feat,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1E293B),
                          fontSize: 14,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
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
      color: const Color(0xFFF1F5F9),
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
                  color: const Color(0xFF0F172A),
                  fontSize: isMobile ? 22 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Safeguarding freshness, aroma, and microbiological integrity across sea transit',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
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

              // Container Loadability Highlight Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF260B1E),
                      Color(0xFF4A1235),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'CONTAINER LOADABILITY & PORTS OF DISPATCH',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFFFB703),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 18),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            detail,
            style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 13, height: 1.5),
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
          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.bold),
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
  // SECTION 6: APPLICATIONS
  // ===========================================================================
  Widget _buildApplicationsSection(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: Colors.white,
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
                  color: const Color(0xFF0F172A),
                  fontSize: isMobile ? 22 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Engineered for clean reconstitution, strong aroma release, and industrial batch stability',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
              ),
              const SizedBox(height: 32),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: widget.product.applications.map((app) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant_menu_rounded, color: AppColors.secondary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          app,
                          style: GoogleFonts.inter(color: const Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w500),
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
  // SECTION 8: INLINE INQUIRY / QUOTE FORM (Clean Light Card)
  // ===========================================================================
  Widget _buildInquiryFormSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 22 : 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
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
                    color: AppColors.secondary.withValues(alpha: 0.12),
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
                          color: const Color(0xFF0F172A),
                          fontSize: isMobile ? 18 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Get live FOB Mundra / CIF destination container pricing within 24 hours',
                        style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
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
                  elevation: 3,
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
      style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.secondary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
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
      color: const Color(0xFFF8FAFC),
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
                  color: const Color(0xFF0F172A),
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Explore other farm-fresh dehydrated ingredients from our Mahuva processing facility',
                style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
              ),
              const SizedBox(height: 28),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: relatedProducts.map((rel) {
                  return SizedBox(
                    width: isMobile ? double.infinity : 350,
                    child: AmarHoverCard(
                      borderRadius: 16,
                      padding: EdgeInsets.zero,
                      builder: (context, isHovered) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.6,
                            child: AmarCardImageZoom(
                              isHovered: isHovered,
                              scale: 1.06,
                              child: Image.asset(
                                rel.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFF1F5F9)),
                              ),
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
                                  style: GoogleFonts.playfairDisplay(color: const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  rel.tagline,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 12.5),
                                ),
                                const SizedBox(height: 14),
                                AmarSecondaryButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailPage(product: rel),
                                      ),
                                    );
                                  },
                                  label: 'View Details',
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  fontSize: 13,
                                  customAccent: AppColors.secondary,
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
