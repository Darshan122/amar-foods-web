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
import '../widgets/whatsapp_floating_button.dart';
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
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const WhatsAppFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [


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

            // 6. GLOBAL EXPORT & SEAPORT LOGISTICS HUB
            _buildExportLogisticsSection(context, isMobile, paddingH),

            // 7. BOTTOM CTA
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
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, color: AppColors.secondary, size: isMobile ? 13 : 14),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'GLOBAL EXPORT PACKAGING & SAMPLE DESK',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: AppColors.secondary,
                          fontSize: isMobile ? 10 : 11.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: isMobile ? 0.4 : 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Export Packaging, Seaport Logistics & Free Sample Kits',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 26 : 46,
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
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 18 : 32),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          padding: EdgeInsets.all(isMobile ? 14 : 18),
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
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: isMobile ? 22 : 28),
              ),
              SizedBox(width: isMobile ? 12 : 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Text(
                          '14 kg Net Weight Standard for All Flakes',
                          style: GoogleFonts.outfit(
                            fontSize: isMobile ? 15 : 18.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF14532D),
                          ),
                        ),
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
                              fontSize: 9.5,
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
                        fontSize: isMobile ? 12.5 : 13.5,
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
                          isMobile: isMobile,
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
                          isMobile: isMobile,
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
                          isMobile: isMobile,
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
                          isMobile: isMobile,
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
    required bool isMobile,
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
                  aspectRatio: isMobile ? 1.7 : 1.9,
                  child: AmarCardImageZoom(
                    isHovered: isHovered,
                    scale: 1.06,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      cacheWidth: 600,
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
            padding: EdgeInsets.all(isMobile ? 16 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isMobile ? 18.5 : 20,
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
                            fontSize: isMobile ? 11 : 12,
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
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 36 : 64),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 18 : 36),
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
                      const SizedBox(height: 24),
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
          cacheWidth: 600,
        ),
      ),
    );
  }

  Widget _buildSampleKitContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary, width: 1.2),
          ),
          child: Text(
            'FREE FOR REGISTERED COMMERCIAL BUYERS',
            style: GoogleFonts.outfit(
              color: AppColors.secondary,
              fontSize: isMobile ? 9.5 : 11,
              fontWeight: FontWeight.bold,
              letterSpacing: isMobile ? 0.3 : 0.6,
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
            fontSize: isMobile ? 13 : 14,
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
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 26,
                vertical: isMobile ? 12 : 14,
              ),
              fontSize: isMobile ? 12.5 : 13.5,
            ),
            AmarSecondaryButton(
              onPressed: () => _openWhatsAppSampleRequest(context),
              label: 'WhatsApp Sample Desk',
              icon: Icons.chat_bubble_outline_rounded,
              customAccent: const Color(0xFF25D366),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 20,
                vertical: isMobile ? 12 : 14,
              ),
              fontSize: isMobile ? 12.5 : 13.5,
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
                  fontSize: isMobile ? 22 : 34,
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
                  style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: isMobile ? 13.5 : 14.5),
                ),
              ),
              const SizedBox(height: 24),

              if (isMobile) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.swipe_rounded, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Swipe table horizontally to view all container metrics',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

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
                      horizontalMargin: isMobile ? 14 : 20,
                      columnSpacing: isMobile ? 16 : 24,
                      headingTextStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: isMobile ? 12 : 13,
                        color: AppColors.primary,
                      ),
                      dataTextStyle: GoogleFonts.inter(
                        fontSize: isMobile ? 12 : 13,
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

  // ==================== 6. GLOBAL EXPORT & SEAPORT LOGISTICS HUB ====================
  Widget _buildExportLogisticsSection(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 48 : 80),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge
              LiquidUI.badgePill(
                text: 'GLOBAL SEAPORT LOGISTICS & TRADE CORRIDORS',
                icon: Icons.directions_boat_rounded,
                backgroundColor: AppColors.primaryLight,
                textColor: AppColors.primary,
                fontSize: isMobile ? 10.5 : 11.5,
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                'Connecting Mahuva Directly to 50+ Global Seaports',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 24 : 38,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Text(
                  'Situated just ~40 km from APM Terminals Pipavav and directly linked to Mundra Port, Amar Foods delivers moisture-barrier container shipments worldwide with ultra-low inland haulage, guaranteed weekly vessel sailings, and transparent Incoterms.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 13.5 : 15,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 38),

              // 1. Strategic Seaport Gateways Feature Card (Pipavav & Mundra)
              _buildSeaportGatewaysCard(context, isMobile),

              const SizedBox(height: 36),

              // 2. Ocean Transit Times Matrix (5 Corridors)
              _buildTransitTimesGrid(context, isMobile),

              const SizedBox(height: 36),

              // 3. Incoterms & International Payment Security (2 Columns)
              _buildTradeTermsSection(context, isMobile),

              const SizedBox(height: 36),

              // 4. Statutory Export Documentation & Fumigation Protocol
              _buildExportDocumentationGrid(context, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeaportGatewaysCard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: isMobile
          ? Column(
              children: [
                _buildSeaportImage(height: 220),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: _buildSeaportDetails(isMobile: true),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildSeaportImage(height: 330),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: _buildSeaportDetails(isMobile: false),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSeaportImage({required double height}) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: Image.asset(
            AppImages.seaportLogistics,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF1E293B),
                child: const Center(
                  child: Icon(Icons.directions_boat_rounded, color: Colors.white54, size: 48),
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
              color: Colors.black.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.anchor_rounded, color: AppColors.secondary, size: 14),
                const SizedBox(width: 6),
                Text(
                  'DEEPWATER EXPORT TERMINAL',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 14,
          left: 14,
          right: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.near_me_rounded, color: AppColors.secondary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Mahuva Plant to APM Terminals Pipavav: ~40 km (Under 1 hour transit)',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeaportDetails({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Dual Gateway Seaport Strategy',
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 18 : 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _buildPortPoint(
          icon: Icons.hub_rounded,
          title: 'APM Terminals Pipavav (~40 km distance)',
          desc: 'Primary export gateway with zero highway bottlenecks, lowest inland haulage expenses, and direct container rail connectivity.',
        ),
        const SizedBox(height: 10),

        _buildPortPoint(
          icon: Icons.directions_boat_filled_rounded,
          title: 'Adani Ports Mundra & Nhava Sheva (JNPT)',
          desc: 'Direct mainline high-speed weekly sailings connecting directly to European, North American, Mediterranean, and East Asian deepwater berths.',
        ),
        const SizedBox(height: 10),

        _buildPortPoint(
          icon: Icons.shield_rounded,
          title: 'Export Container Lining & Desiccants',
          desc: 'Every container is lined with food-grade multi-layer moisture barriers and 20+ silica/clay desiccant Dry-Bags to prevent condensation during ocean transit.',
        ),
      ],
    );
  }

  Widget _buildPortPoint({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransitTimesGrid(BuildContext context, bool isMobile) {
    final List<Map<String, dynamic>> corridors = [
      {
        'region': 'Middle East & GCC',
        'icon': Icons.near_me_rounded,
        'countries': ['UAE', 'Saudi Arabia', 'Oman'],
        'ports': 'Jebel Ali, Dammam, Sohar',
        'days': '4 - 6 Days',
        'freq': 'Daily / Weekly Sailings',
        'accent': const Color(0xFF0284C7),
      },
      {
        'region': 'Europe & UK',
        'icon': Icons.euro_symbol_rounded,
        'countries': ['Netherlands', 'Germany', 'UK'],
        'ports': 'Rotterdam, Hamburg, Felixstowe',
        'days': '22 - 26 Days',
        'freq': 'Direct Mainline Weekly',
        'accent': const Color(0xFF16A34A),
      },
      {
        'region': 'North America',
        'icon': Icons.flight_takeoff_rounded,
        'countries': ['USA', 'Canada', 'Mexico'],
        'ports': 'New York, Savannah, Long Beach',
        'days': '28 - 34 Days',
        'freq': 'Fast Trans-Atlantic / Pacific',
        'accent': const Color(0xFF9333EA),
      },
      {
        'region': 'Southeast Asia',
        'icon': Icons.hub_rounded,
        'countries': ['Singapore', 'Malaysia', 'Indonesia'],
        'ports': 'Singapore, Port Klang, Jakarta',
        'days': '12 - 16 Days',
        'freq': 'Regular Direct Feeders',
        'accent': const Color(0xFFD97706),
      },
      {
        'region': 'Far East & Oceania',
        'icon': Icons.public_rounded,
        'countries': ['Japan', 'South Korea', 'Australia'],
        'ports': 'Tokyo, Busan, Melbourne',
        'days': '18 - 24 Days',
        'freq': 'Scheduled Weekly Calls',
        'accent': const Color(0xFFE11D48),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.public_rounded, color: AppColors.secondary, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Major Maritime Trade Corridors & Port-to-Port Transit',
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Average container voyage timelines departing from Pipavav / Mundra deepwater ports to major international container terminals:',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final double maxW = constraints.maxWidth;
            final double cardWidth;
            if (maxW < 650) {
              cardWidth = maxW;
            } else if (maxW < 1050) {
              cardWidth = (maxW - 14) / 2;
            } else {
              cardWidth = (maxW - (14 * 4)) / 5;
            }

            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: corridors.map((c) {
                final Color accentColor = c['accent'] as Color;
                final List<String> countries = c['countries'] as List<String>;

                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.28),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Icon Left, Days Badge Right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              c['icon'] as IconData,
                              size: 16,
                              color: accentColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              c['days'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Region Title
                      Text(
                        c['region'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Country Tag Chips
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: countries.map((country) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2F6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              country,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),

                      // Ports
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.anchor_rounded, size: 13, color: AppColors.textSecondary.withValues(alpha: 0.8)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              c['ports'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Frequency
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 12, color: accentColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              c['freq'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTradeTermsSection(BuildContext context, bool isMobile) {
    final card1 = Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.handshake_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Supported Incoterms 2020',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildIncotermBadge('FOB Pipavav / Mundra', isPrimary: true),
              _buildIncotermBadge('CIF Destination Port', isPrimary: true),
              _buildIncotermBadge('CFR (Cost & Freight)'),
              _buildIncotermBadge('EXW Mahuva Plant'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Currencies Accepted: USD, EUR, GBP, AED, INR. Guaranteed container freight quotation response within 12 - 24 business hours.',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );

    final card2 = Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield_rounded, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Payment Terms (Strictly No Credit)',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildPaymentPoint(
            'T/T (Telegraphic Wire Transfer)',
            '50% advance deposit with order confirmation + 50% balance upon scanned copy of original Bill of Lading (B/L).',
          ),
          const SizedBox(height: 10),
          _buildPaymentPoint(
            '100% Irrevocable Letter of Credit (L/C at Sight)',
            'Confirmed Letter of Credit payable 100% at sight through prime international banks (No usance credit).',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFFDC2626), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Strict Policy: We operate strictly on upfront secured terms. We do not provide open credit, usance credit, or post-dispatch credit under any circumstances.',
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF991B1B),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return isMobile
        ? Column(
            children: [
              card1,
              const SizedBox(height: 16),
              card2,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: card1),
              const SizedBox(width: 20),
              Expanded(child: card2),
            ],
          );
  }

  Widget _buildExportDocumentationGrid(BuildContext context, bool isMobile) {
    final docs = [
      {'title': 'Bill of Lading (B/L)', 'desc': 'Clean on-board marine bill of lading with container seal numbers.', 'icon': Icons.description_rounded},
      {'title': 'Commercial Invoice & Packing List', 'desc': 'Certified itemized packing list with gross/net weights and batch lots.', 'icon': Icons.receipt_long_rounded},
      {'title': 'Certificate of Origin (COO)', 'desc': 'Issued by Chamber of Commerce / Indian Trade Authority for tariff clearance.', 'icon': Icons.workspace_premium_rounded},
      {'title': 'Phytosanitary Certificate', 'desc': 'Statutory plant health clearance issued by Govt. of India Plant Quarantine.', 'icon': Icons.spa_rounded},
      {'title': 'Certified Fumigation', 'desc': 'Aluminium Phosphide or Methyl Bromide container treatment with certificate.', 'icon': Icons.sanitizer_rounded},
      {'title': 'Certificate of Analysis (COA)', 'desc': 'Independent third-party lab testing (SGS / Eurofins / Geo-Chem) on request.', 'icon': Icons.science_rounded},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fact_check_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Standard Export Documentation Package (Provided with Every FCL Dispatch)',
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 16 : 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: docs.map((d) {
              final double itemWidth = isMobile
                  ? double.infinity
                  : 320;
              return Container(
                width: itemWidth,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(d['icon'] as IconData, color: AppColors.primary, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['title'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            d['desc'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIncotermBadge(String text, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrimary ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
          color: isPrimary ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPaymentPoint(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF166534),
                ),
              ),
              Text(
                desc,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== 7. BOTTOM CTA ====================
  Widget _buildBottomCta(BuildContext context, bool isMobile, double paddingH) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: isMobile ? 36 : 56),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              Text(
                'Need Custom Packaging or Private Label OEM?',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 22 : 32,
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
                    fontSize: isMobile ? 13.5 : 14.5,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  AmarPrimaryButton(
                    onPressed: () => _showSampleQuoteDialog(context),
                    label: 'Inquire Custom Packaging',
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 32, vertical: isMobile ? 13 : 16),
                    fontSize: isMobile ? 13 : 14.5,
                  ),
                  AmarSecondaryButton(
                    onPressed: () => _openWhatsAppSampleRequest(context),
                    label: 'Chat With Packaging Desk',
                    icon: Icons.chat_bubble_outline_rounded,
                    customAccent: const Color(0xFF25D366),
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 18 : 24, vertical: isMobile ? 13 : 16),
                    fontSize: isMobile ? 13 : 14.5,
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
