import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';
import '../widgets/whatsapp_floating_button.dart';
import '../services/language_service.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
      floatingActionButton: const WhatsAppFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Header Banner
            _buildHeroHeader(context, isMobile),

            // 2. Company Profile & Story (Photo Left, Text Right)
            _buildCompanyStorySection(context, isMobile),

            // 3. Core Values Grid (4 Glass Pillars)
            _buildCoreValuesSection(context, isMobile),

            // 4. Founders & Leadership Team Section (4 Founders)
            _buildFoundersSection(context, isMobile),

            // 5. Processing Infrastructure & Technology Section
            _buildInfrastructureSection(context, isMobile),

            // 6. Bottom CTA Banner
            _buildCtaBannerSection(context, isMobile),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // 1. Hero Header Banner (Next-Gen Photo Vignette & Floating Stats Ribbon)
  Widget _buildHeroHeader(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 60, maxVal: 90);
    final double titleSize = LiquidUI.fluid(context, minVal: 36, maxVal: 58);
    final double descSize = LiquidUI.fluid(context, minVal: 14, maxVal: 17);

    return Stack(
      children: [
        // Photographic Facility Background with Dark Vignette Overlay
        Positioned.fill(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.aboutProducts,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppColors.primaryDark);
                  },
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFB16161D),
                        const Color(0xD938102B),
                        const Color(0xFA16161D),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hero Content Layer with Floating Glass Card Container (Matching products_page.dart)
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
                  // Live Status Badge Pill
                  LiquidUI.badgePill(
                    text: LanguageService.instance.tr('about_hero_badge'),
                    icon: Icons.verified_rounded,
                    backgroundColor: AppColors.secondary.withOpacity(0.2),
                    textColor: AppColors.secondary,
                    fontSize: 11,
                  ),
                  const SizedBox(height: 20),

                  LiquidUI.gradientText(
                    LanguageService.instance.tr('about_hero_h1'),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFF5E6F0)],
                    ),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  LiquidUI.gradientText(
                    LanguageService.instance.tr('about_hero_h2'),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF81C784), Color(0xFFA5D6A7), Color(0xFFC8E6C9)],
                    ),
                    style: GoogleFonts.outfit(
                      fontSize: titleSize * 0.45,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),

                  Text(
                    LanguageService.instance.tr('about_hero_desc'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: descSize,
                      color: Colors.grey.shade300,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Floating Quick Stats Ribbon inside Glass Card
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildHeroStatPill(Icons.location_on_rounded, LanguageService.instance.tr('about_pill_hub')),
                      _buildHeroStatPill(Icons.speed_rounded, LanguageService.instance.tr('about_pill_capacity')),
                      _buildHeroStatPill(Icons.public_rounded, LanguageService.instance.tr('about_pill_nations')),
                      _buildHeroStatPill(Icons.verified_user_rounded, LanguageService.instance.tr('about_pill_cert')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroStatPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondary, size: 15),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Company Story & Facility Showcase (Our Heritage & Mission Section)
  Widget _buildCompanyStorySection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 70, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 26, maxVal: 36);

    Widget buildImageCard() {
      return LiquidUI.interactiveGlassCard(
        onTap: () => _showQuoteDialog(context),
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.background,
        borderRadius: 22,
        child: Stack(
          fit: isMobile ? StackFit.loose : StackFit.expand,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  AppImages.aboutHeritageMission,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primaryLight,
                      child: const Center(
                        child: Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.primary),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        LanguageService.instance.tr('about_story_card_badge'),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
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
                    text: LanguageService.instance.tr('about_story_badge'),
                    icon: Icons.history_edu_rounded,
                    backgroundColor: AppColors.primaryLight,
                    textColor: AppColors.primary,
                    fontSize: 11,
                  ),
                  const SizedBox(height: 16),

                  LiquidUI.gradientText(
                    LanguageService.instance.tr('about_story_h1'),
                    gradient: AppColors.primaryGradient,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    LanguageService.instance.tr('about_story_p1'),
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    LanguageService.instance.tr('about_story_p2'),
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildStoryPoint(LanguageService.instance.tr('about_story_pt1_t'), LanguageService.instance.tr('about_story_pt1_d')),
                  const SizedBox(height: 10),
                  _buildStoryPoint(LanguageService.instance.tr('about_story_pt2_t'), LanguageService.instance.tr('about_story_pt2_d')),
                  const SizedBox(height: 10),
                  _buildStoryPoint(LanguageService.instance.tr('about_story_pt3_t'), LanguageService.instance.tr('about_story_pt3_d')),
                ],
              );

              if (isMobile) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: buildImageCard(),
                    ),
                    const SizedBox(height: 36),
                    textContent,
                  ],
                );
              } else {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 5,
                        child: buildImageCard(),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 6,
                        child: textContent,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStoryPoint(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.secondaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 18),
        ),
        const SizedBox(width: 10),
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
                  text: desc,
                  style: GoogleFonts.inter(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 3. Core Values Grid
  Widget _buildCoreValuesSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 60, maxVal: 90);
    final double headingSize = LiquidUI.fluid(context, minVal: 26, maxVal: 36);

    final List<_ValueItem> values = [
      _ValueItem(
        index: '01',
        title: LanguageService.instance.tr('about_v1_title'),
        icon: Icons.agriculture_rounded,
        desc: LanguageService.instance.tr('about_v1_desc'),
      ),
      _ValueItem(
        index: '02',
        title: LanguageService.instance.tr('about_v2_title'),
        icon: Icons.cleaning_services_rounded,
        desc: LanguageService.instance.tr('about_v2_desc'),
      ),
      _ValueItem(
        index: '03',
        title: LanguageService.instance.tr('about_v3_title'),
        icon: Icons.biotech_rounded,
        desc: LanguageService.instance.tr('about_v3_desc'),
      ),
      _ValueItem(
        index: '04',
        title: LanguageService.instance.tr('about_v4_title'),
        icon: Icons.sailing_rounded,
        desc: LanguageService.instance.tr('about_v4_desc'),
      ),
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
                text: LanguageService.instance.tr('about_values_badge'),
                icon: Icons.shield_rounded,
                backgroundColor: AppColors.primaryLight,
                textColor: AppColors.primary,
                fontSize: 11,
              ),
              const SizedBox(height: 16),

              Text(
                LanguageService.instance.tr('about_values_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                LanguageService.instance.tr('about_values_sub'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 44),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: values.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildValueCard(v.index, v.title, v.icon, v.desc),
                      )).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: values.map((v) => SizedBox(
                        width: (constraints.maxWidth - 24) / 2,
                        child: _buildValueCard(v.index, v.title, v.icon, v.desc),
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

  Widget _buildValueCard(String index, String title, IconData icon, String desc) {
    return LiquidUI.glassCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: Colors.white,
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              Text(
                '#$index',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Founders & Leadership Team Section (Text-Only Clean UI)
  Widget _buildFoundersSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 70, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 38);

    final founders = [
      {
        'name': 'Labhesh Patel',
        'role': LanguageService.instance.tr('about_f1_role'),
        'exp': LanguageService.instance.tr('about_f_exp'),
        'expertise': 'Crop Sourcing & Dehydration Manufacturing',
        'bio': LanguageService.instance.tr('about_f1_bio'),
      },
      {
        'name': 'Hiren Patel',
        'role': LanguageService.instance.tr('about_f2_role'),
        'exp': LanguageService.instance.tr('about_f_exp'),
        'expertise': 'Factory Operations & Plant Engineering',
        'bio': LanguageService.instance.tr('about_f2_bio'),
      },
      {
        'name': 'Jagdish Patel',
        'role': LanguageService.instance.tr('about_f3_role'),
        'exp': LanguageService.instance.tr('about_f_exp'),
        'expertise': 'Quality Control & Food Safety R&D',
        'bio': LanguageService.instance.tr('about_f3_bio'),
      },
      {
        'name': 'Milan Bheda',
        'role': LanguageService.instance.tr('about_f4_role'),
        'exp': LanguageService.instance.tr('about_f_exp'),
        'expertise': 'Global Agri-Trade & Export Markets',
        'bio': LanguageService.instance.tr('about_f4_bio'),
      },
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
                text: LanguageService.instance.tr('about_founders_badge'),
                icon: Icons.groups_rounded,
                backgroundColor: AppColors.secondaryLight,
                textColor: AppColors.secondary,
                fontSize: 11,
              ),
              const SizedBox(height: 16),

              Text(
                LanguageService.instance.tr('about_founders_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LanguageService.instance.tr('about_founders_sub'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // 4 Founder Cards Grid (Clean Text UI)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: founders.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildFounderCard(context, f),
                      )).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: founders.map((f) => SizedBox(
                        width: (constraints.maxWidth - 24) / 2,
                        child: _buildFounderCard(context, f),
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

  Widget _buildFounderCard(BuildContext context, Map<String, String> f) {
    return LiquidUI.glassCard(
      padding: const EdgeInsets.all(28),
      backgroundColor: AppColors.background,
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Icon & Role Badge Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    f['role']!,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      letterSpacing: 0.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Founder Name
          Text(
            f['name']!,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // 15+ Years Experience Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 5),
                Text(
                  f['exp']!,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Subtle Accent Line
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Description Bio
          Text(
            f['bio']!,
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

  // 5. Processing Infrastructure & Technology Section
  Widget _buildInfrastructureSection(BuildContext context, bool isMobile) {
    final double paddingV = LiquidUI.fluid(context, minVal: 70, maxVal: 100);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 38);

    final List<_InfraStepItem> infraSteps = [
      _InfraStepItem(
        step: 'STEP 01',
        title: LanguageService.instance.tr('about_infra_s1_t'),
        icon: Icons.water_drop_rounded,
        desc: LanguageService.instance.tr('about_infra_s1_d'),
      ),
      _InfraStepItem(
        step: 'STEP 02',
        title: LanguageService.instance.tr('about_infra_s2_t'),
        icon: Icons.thermostat_rounded,
        desc: LanguageService.instance.tr('about_infra_s2_d'),
      ),
      _InfraStepItem(
        step: 'STEP 03',
        title: LanguageService.instance.tr('about_infra_s3_t'),
        icon: Icons.center_focus_strong_rounded,
        desc: LanguageService.instance.tr('about_infra_s3_d'),
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
                    const Icon(Icons.memory_rounded, color: AppColors.secondary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      LanguageService.instance.tr('about_infra_badge'),
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
                LanguageService.instance.tr('about_infra_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LanguageService.instance.tr('about_infra_sub'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 48),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: infraSteps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildInfraCard(step.step, step.title, step.icon, step.desc),
                      )).toList(),
                    );
                  } else {
                    return Row(
                      children: infraSteps.map((step) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: _buildInfraCard(step.step, step.title, step.icon, step.desc),
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

  Widget _buildInfraCard(String step, String title, IconData icon, String desc) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1C26),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 26),
              ),
              Text(
                step,
                style: GoogleFonts.outfit(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

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

  // 6. Bottom CTA Banner
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
                LanguageService.instance.tr('about_cta_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LanguageService.instance.tr('about_cta_sub'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: () => _showQuoteDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 6,
                ),
                child: Text(
                  LanguageService.instance.tr('about_cta_btn'),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueItem {
  final String index;
  final String title;
  final IconData icon;
  final String desc;

  const _ValueItem({
    required this.index,
    required this.title,
    required this.icon,
    required this.desc,
  });
}

class _InfraStepItem {
  final String step;
  final String title;
  final IconData icon;
  final String desc;

  const _InfraStepItem({
    required this.step,
    required this.title,
    required this.icon,
    required this.desc,
  });
}
