import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../utils/liquid_ui.dart';
import '../widgets/amar_card.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';

class PackagingPage extends StatelessWidget {
  const PackagingPage({super.key});

  void _openWhatsAppSampleRequest(BuildContext context) async {
    const phone = '919426228723';
    const msg = 'Hello Amar Foods, I would like to request an Export Sample Kit and packaging details for international export.';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSampleQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const QuoteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1100;
    final double paddingH = isMobile ? 18.0 : (isTablet ? 36.0 : 64.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),

            // 1. HERO BANNER
            _buildHeroBanner(context, isMobile, paddingH),

            // 2. 14 KG FLAKES SPECIAL PACKING NOTICE
            _buildFlakesSpecialNotice(context, isMobile, paddingH),

            // 3. PACKAGING MODES GRID (5 CORE TYPES WITH REAL STUDIO PHOTOS)
            _buildPackagingGrid(context, isMobile, paddingH),

            // 4. FREE EXPORT SAMPLE KIT SHOWCASE
            _buildSampleKitSection(context, isMobile, paddingH),

            // 5. CONTAINER LOADABILITY & PALLETIZATION TABLE
            _buildLoadabilityTable(context, isMobile, paddingH),

            // 6. BOTTOM CTA
            _buildBottomCta(context, isMobile, paddingH),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ==================== 1. HERO BANNER ====================
  Widget _buildHeroBanner(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF260B1E),
            Color(0xFF4A1235),
            Color(0xFF1E0717),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 48 : 72),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'GLOBAL EXPORT PACKAGING & SAMPLE DESK',
                      style: GoogleFonts.outfit(
                        color: AppColors.secondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Export Packaging & Free Sample Kits',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 28 : 46,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Text(
                  'Engineered to safeguard freshness, intense aroma, and zero-moisture ingress across 30 to 45 days of ocean transit. From specialized 14 kg flakes packaging to private label retail pouches and DHL/FedEx sample kits.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 14 : 16.5,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Buttons
              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: [
                  AmarPrimaryButton(
                    onPressed: () => _showSampleQuoteDialog(context),
                    label: 'Request Free Sample Kit',
                    icon: Icons.inventory_2_outlined,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                    fontSize: 14,
                  ),
                  AmarSecondaryButton(
                    onPressed: () => _openWhatsAppSampleRequest(context),
                    label: 'Chat on WhatsApp',
                    icon: Icons.chat_bubble_outline_rounded,
                    customAccent: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    fontSize: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 2. 14 KG FLAKES SPECIAL PACKING NOTICE ====================
  Widget _buildFlakesSpecialNotice(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 32),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF86EFAC), width: 1.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '14 kg Net Weight Standard for All Flakes Range',
                          style: GoogleFonts.outfit(
                            fontSize: isMobile ? 16 : 18.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF14532D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'INDUSTRY STANDARD',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Due to natural high volume and lower bulk density, all Dehydrated Onion Flakes (White, Red, Pink Kibbled) and Chilli Flakes are standardly packed in 14 kg Net Weight Multi-wall Kraft Paper Bags or 14 kg Corrugated Master Cartons. This preserves whole flake structure, eliminates breakage during transit, and provides optimal container cube filling.',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        color: const Color(0xFF166534),
                        height: 1.5,
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
  }

  // ==================== 3. 5 PACKAGING MODES GRID ====================
  Widget _buildPackagingGrid(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 56),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'EXPORT PACKAGING MODES',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Commercial Export Packaging Standards',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 24 : 34,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'Multi-barrier protection preventing moisture reabsorption, essential oil evaporation, and transit damage.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14.5),
                ),
              ),
              const SizedBox(height: 42),

              // Responsive Grid of 4 Core Packaging Modes
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = isMobile
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 28) / 2;

                  return Wrap(
                    spacing: 28,
                    runSpacing: 28,
                    children: [
                      // Card 1: Multi-Wall Kraft Paper Bag
                      SizedBox(
                        width: cardWidth,
                        child: _buildPackagingCard(
                          image: AppImages.packagingKraftPaperBag,
                          badge: 'PRIMARY EXPORT BULK',
                          badgeColor: AppColors.primary,
                          title: 'Multi-Wall Kraft Paper Bags',
                          netWeights: '14 kg (Flakes) | 20 kg / 25 kg (Powders & Minced)',
                          description:
                              'Constructed with 2-to-3 ply natural virgin Kraft paper exterior and a thick, heat-sealed food-grade polyethylene (PE) inner liner. Provides robust gas/moisture barrier and puncture resistance.',
                          specs: [
                            'Inner Liner: 50–70 micron virgin food-grade PE',
                            'Closure: Heavy machine chain stitching with crepe tape',
                            'Suitable for: Onion Flakes (14kg), Powders & Minced (20/25kg)',
                            'Certified: BRCGS, ISO 22000, US FDA Compliant',
                          ],
                        ),
                      ),

                      // Card 2: 5-Ply Corrugated Master Cartons
                      SizedBox(
                        width: cardWidth,
                        child: _buildPackagingCard(
                          image: AppImages.packagingCorrugatedBox,
                          badge: 'HIGH STACKING STRENGTH',
                          badgeColor: const Color(0xFFB45309),
                          title: '5-Ply Corrugated Master Cartons',
                          netWeights: '14 kg (Flakes) | 20 kg (Powders & Granules)',
                          description:
                              'Heavy-duty 5-ply export-grade corrugated boxes reinforced for extreme pallet stacking. Fitted with double-sealed inner poly liner bags and sealed with heavy industrial tamper-evident tape.',
                          specs: [
                            'Fluting: Heavy-duty BC Flute, 200–250 PSI burst test',
                            'Protection: Double food-grade blue/clear PE poly liner',
                            'Markings: Barcode, Batch, Production Date, Net Weight',
                            'Suitable for: Premium buyers, supermarkets, HoReCa',
                          ],
                        ),
                      ),

                      // Card 3: PP Woven Bags for Whole Spices
                      SizedBox(
                        width: cardWidth,
                        child: _buildPackagingCard(
                          image: AppImages.packagingPpWovenBag,
                          badge: 'WHOLE SEEDS & SPICES',
                          badgeColor: const Color(0xFF047857),
                          title: 'High-Tenacity PP Woven Sacks',
                          netWeights: '25 kg / 50 kg Net Weight',
                          description:
                              'Made from high-density woven polypropylene (PP) fabric with anti-slip micro-perforations or inner PE liner. Extremely tear-resistant and breathable for raw agricultural seeds and whole spices.',
                          specs: [
                            'Fabric: 80–110 GSM circular woven polypropylene',
                            'Stitching: Double bottom stitch, machine chain top',
                            'Suitable for: Cumin Seeds (Jeera), Fennel (Saunf), Star Anise',
                            'Handling: Excellent pallet stability and sling lifting',
                          ],
                        ),
                      ),

                      // Card 4: Private Label & Retail Stand-Up Pouches
                      SizedBox(
                        width: cardWidth,
                        child: _buildPackagingCard(
                          image: AppImages.packagingRetailPouches,
                          badge: 'RETAIL PRIVATE LABEL (OEM)',
                          badgeColor: const Color(0xFF7C3AED),
                          title: 'Stand-Up Zipper Barrier Pouches',
                          netWeights: '100g, 250g, 500g, 1 kg, to 5 kg',
                          description:
                              'Multi-layer barrier pouches (Kraft with transparent window, matte foil, or clear PET/PE) equipped with resealable zip-lock and tear notch. Fully customized with your brand logo, GS1 barcodes, and nutrition facts.',
                          specs: [
                            'Barrier: High oxygen and water-vapor barrier (WVTR < 1.0)',
                            'Features: Resealable zip-lock, tear notch, oval window',
                            'Branding: High-definition rotogravure / digital printing',
                            'Suitable for: Supermarket shelves, e-commerce, private labels',
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackagingCard({
    required String image,
    required String badge,
    required Color badgeColor,
    required String title,
    required String netWeights,
    required String description,
    required List<String> specs,
  }) {
    return AmarHoverCard(
      borderRadius: 18,
      padding: EdgeInsets.zero,
      builder: (context, isHovered) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: AspectRatio(
                  aspectRatio: 1.9,
                  child: AmarCardImageZoom(
                    isHovered: isHovered,
                    scale: 1.06,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
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
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
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
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),

                // Net Weight Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.scale_rounded, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          netWeights,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 14),

                // Specs bullets
                ...specs.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: const Color(0xFF334155),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 4. FREE EXPORT SAMPLE KIT SECTION ====================
  Widget _buildSampleKitSection(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 64),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 22 : 36),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF260B1E), Color(0xFF3D0E2B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.3),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    children: [
                      _buildSampleKitImage(),
                      const SizedBox(height: 28),
                      _buildSampleKitContent(context, isMobile),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _buildSampleKitImage()),
                      const SizedBox(width: 38),
                      Expanded(flex: 6, child: _buildSampleKitContent(context, isMobile)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSampleKitImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Image.asset(
          AppImages.packagingSampleKit,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSampleKitContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary, width: 1.2),
          ),
          child: Text(
            'FREE FOR REGISTERED COMMERCIAL BUYERS',
            style: GoogleFonts.outfit(
              color: AppColors.secondary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
        ),
        const SizedBox(height: 14),

        Text(
          'Official Export Sample Kit',
          style: GoogleFonts.playfairDisplay(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        Text(
          'Evaluate sensory quality, microbial purity, mesh cut, and aroma before placing a container order. We ship presentation sample boxes with vacuum-sealed clear pouches directly to your office or facility.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.88),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),

        // 4 Value Highlights
        _buildSampleBullet('Vacuum-Sealed Clear Pouches', '100g to 250g per product, protected against humidity.'),
        _buildSampleBullet('COA Certificate Included', 'Physical, chemical & microbiological parameters sheet in box.'),
        _buildSampleBullet('Express Courier Worldwide', 'Shipped via DHL Express / FedEx with tracking code.'),
        _buildSampleBullet('Complimentary Material', 'Free sample product for verified food processors & importers.'),

        const SizedBox(height: 26),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AmarPrimaryButton(
              onPressed: () => _showSampleQuoteDialog(context),
              label: 'Order Free Sample Kit',
              icon: Icons.mark_email_read_outlined,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              fontSize: 13.5,
            ),
            AmarSecondaryButton(
              onPressed: () => _openWhatsAppSampleRequest(context),
              label: 'WhatsApp Sample Desk',
              icon: Icons.chat_bubble_outline_rounded,
              customAccent: const Color(0xFF25D366),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              fontSize: 13.5,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSampleBullet(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13, height: 1.4, color: Colors.white),
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.82))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 5. CONTAINER LOADABILITY TABLE ====================
  Widget _buildLoadabilityTable(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 60),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'LOGISTICS & PALLETIZATION',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Container Loadability & Pallet Matrix',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 24 : 34,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'Standard ocean container capacities for full container load (FCL) shipments originating from Mahuva / Mundra Port / Pipavav Port, Gujarat, India.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14.5),
                ),
              ),
              const SizedBox(height: 36),

              // Table Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x06000000), blurRadius: 16, offset: Offset(0, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                      dataRowColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.hovered) ? const Color(0xFFF8FAFC) : Colors.white),
                      horizontalMargin: 20,
                      columnSpacing: 24,
                      headingTextStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                      dataTextStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF1E293B),
                      ),
                      columns: const [
                        DataColumn(label: Text('Product Range')),
                        DataColumn(label: Text('Export Packaging')),
                        DataColumn(label: Text('Net Weight')),
                        DataColumn(label: Text('20\' FCL Capacity')),
                        DataColumn(label: Text('40\' FCL High Cube')),
                        DataColumn(label: Text('Palletization')),
                      ],
                      rows: [
                        _buildDataRow(
                          'All Flakes (White, Red, Pink, Chilli)',
                          'Multi-Wall Kraft / Carton',
                          '14 kg Net',
                          '~7.5 – 8.0 MT (~550 bags)',
                          '~16.5 – 17.5 MT (~1,220 bags)',
                          'ISPM-15 Heat-treated',
                          isHighlight: true,
                        ),
                        _buildDataRow(
                          'Chopped & Minced (3-5mm / 1-3mm)',
                          'Kraft Paper Bag / Carton',
                          '20 kg / 25 kg Net',
                          '~13.5 – 14.5 MT',
                          '~24.0 – 25.0 MT',
                          'ISPM-15 Heat-treated',
                        ),
                        _buildDataRow(
                          'Granules & Fine Powders (80-100 Mesh)',
                          'Multi-Wall Kraft Bag + PE',
                          '20 kg / 25 kg Net',
                          '~14.0 – 15.0 MT',
                          '~25.0 – 26.0 MT',
                          'Stretch-film wrapped',
                        ),
                        _buildDataRow(
                          'Cumin Seeds (Jeera Machine Clean)',
                          'PP Woven Sacks',
                          '25 kg / 50 kg Net',
                          '~13.0 – 14.0 MT',
                          '~26.0 – 27.0 MT',
                          'Bag-in-container / Pallet',
                        ),
                        _buildDataRow(
                          'Fennel Seeds & Star Anise',
                          'PP Woven Sacks / Jute',
                          '25 kg / 50 kg Net',
                          '~12.5 – 13.5 MT',
                          '~25.0 – 26.0 MT',
                          'Bag-in-container / Pallet',
                        ),
                        _buildDataRow(
                          'Private Label Stand-Up Pouches',
                          'Outer Master Carton',
                          '100g to 5kg',
                          'Custom load plan',
                          'Custom load plan',
                          'Shrink wrapped & corner guards',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    String col1,
    String col2,
    String col3,
    String col4,
    String col5,
    String col6, {
    bool isHighlight = false,
  }) {
    return DataRow(
      color: isHighlight ? WidgetStateProperty.all(const Color(0xFFF0FDF4)) : null,
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isHighlight) ...[
                const Icon(Icons.star_rounded, color: AppColors.secondary, size: 16),
                const SizedBox(width: 6),
              ],
              Text(
                col1,
                style: TextStyle(
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                  color: isHighlight ? const Color(0xFF166534) : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(col2)),
        DataCell(Text(col3, style: TextStyle(fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal))),
        DataCell(Text(col4)),
        DataCell(Text(col5)),
        DataCell(Text(col6)),
      ],
    );
  }

  // ==================== 6. BOTTOM CTA ====================
  Widget _buildBottomCta(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 56),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              Text(
                'Need Custom Packaging or Private Label OEM?',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'Our export packaging division offers tailored bag dimensions, nitrogen flushing, customized buyer artwork printing, barcode integration, and multi-language nutrition labeling.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: [
                  AmarPrimaryButton(
                    onPressed: () => _showSampleQuoteDialog(context),
                    label: 'Inquire Custom Packaging',
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    fontSize: 14.5,
                  ),
                  AmarSecondaryButton(
                    onPressed: () => _openWhatsAppSampleRequest(context),
                    label: 'Chat With Packaging Desk',
                    icon: Icons.chat_bubble_outline_rounded,
                    customAccent: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    fontSize: 14.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
