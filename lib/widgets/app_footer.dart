import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../theme/app_theme.dart';
import '../utils/liquid_ui.dart';
import '../services/language_service.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  void _navigateTo(BuildContext context, String routeName) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LanguageItem>(
      valueListenable: LanguageService.instance.currentLanguage,
      builder: (context, _, child) {
        final bool isMobile = LiquidUI.isMobile(context);
        final double verticalPadding = LiquidUI.fluid(context, minVal: 40, maxVal: 64);
        final double horizontalPadding = LiquidUI.fluid(context, minVal: 20, maxVal: 48);

        return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF16161D),
        border: Border(top: BorderSide(color: Color(0xFF2A2A35), width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Center(
        child: Container(
          constraints: LiquidUI.pageConstraints(),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCompanyInfo(context),
                        const SizedBox(height: 36),
                        _buildQuickLinks(context),
                        const SizedBox(height: 36),
                        _buildContactInfo(context),
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 3, child: _buildCompanyInfo(context)),
                        SizedBox(width: LiquidUI.fluid(context, minVal: 24, maxVal: 48)),
                        Expanded(flex: 2, child: _buildQuickLinks(context)),
                        SizedBox(width: LiquidUI.fluid(context, minVal: 24, maxVal: 48)),
                        Expanded(flex: 3, child: _buildContactInfo(context)),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 40),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1, thickness: 1),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  Text(
                    LanguageService.instance.tr('footer_rights'),
                    style: TextStyle(
                      fontFamily: AppTheme.interFont,
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSocialIcon(
                        assetPath: AppImages.socialWhatsapp,
                        url: 'https://wa.me/917284088737?text=Hello%20Amar%20Foods%20Export%20Desk',
                        tooltip: 'WhatsApp Hotline: +91 7284088737',
                      ),
                      const SizedBox(width: 14),
                      _buildSocialIcon(
                        assetPath: AppImages.socialInstagram,
                        url: 'https://www.instagram.com/amarfoodsmahuva?igsh=MTR4NHF3bXh4ZW1pcg==',
                        tooltip: 'Instagram: @amarfoodsmahuva',
                      ),
                      const SizedBox(width: 14),
                      _buildSocialIcon(
                        assetPath: AppImages.socialLinkedin,
                        url: 'https://www.linkedin.com/in/amar-foods-247236425',
                        tooltip: 'LinkedIn: Amar Foods',
                      ),
                      const SizedBox(width: 14),
                      _buildSocialIcon(
                        assetPath: AppImages.socialFacebook,
                        url: 'https://www.facebook.com/profile.php?viewas=100000686899395&id=61592459882888',
                        tooltip: 'Facebook: Amar Foods',
                      ),
                      const SizedBox(width: 14),
                      _buildSocialIcon(
                        assetPath: AppImages.socialViber,
                        url: 'viber://chat?number=%2B917284088737',
                        tooltip: 'Viber Chat: +91 7284088737',
                        fallbackIcon: Icons.phone_in_talk_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.logo,
              height: 48,
              color: Colors.white,
              colorBlendMode: BlendMode.modulate,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Amar Foods',
                  style: TextStyle(
                    fontFamily: AppTheme.playfairFont,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
              ),
              child: const Text(
                'EXPORTER',
                style: TextStyle(
                  fontFamily: AppTheme.outfitFont,
                  color: AppColors.secondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Excellent Dry to Try!',
          style: TextStyle(
            fontFamily: AppTheme.outfitFont,
            color: AppColors.secondary,
            fontSize: LiquidUI.fluid(context, minVal: 14, maxVal: 16),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          LanguageService.instance.tr('footer_desc'),
          style: TextStyle(
            fontFamily: AppTheme.interFont,
            color: Colors.grey.shade400,
            fontSize: LiquidUI.fluid(context, minVal: 13, maxVal: 14),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageService.instance.tr('footer_quick_links'),
          style: const TextStyle(
            fontFamily: AppTheme.outfitFont,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        _buildFooterLink(context, LanguageService.instance.tr('nav_home'), '/'),
        _buildFooterLink(context, LanguageService.instance.tr('nav_about'), '/about'),
        _buildFooterLink(context, LanguageService.instance.tr('nav_products'), '/products'),
        _buildFooterLink(context, LanguageService.instance.tr('nav_gallery'), '/gallery'),
        _buildFooterLink(context, LanguageService.instance.tr('nav_contact'), '/contact'),
        _buildFooterDocLink(context, '📥 ${LanguageService.instance.tr('btn_brochure')} (PDF)', '/amar_foods_brochure.pdf'),
      ],
    );
  }

  Widget _buildFooterDocLink(BuildContext context, String text, String urlPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            final Uri uri = Uri.parse(urlPath);
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                await launchUrl(uri, mode: LaunchMode.platformDefault);
              }
            } catch (_) {
              await launchUrl(uri, mode: LaunchMode.platformDefault);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: AppColors.secondary, size: 15),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppTheme.outfitFont,
                  color: AppColors.secondaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, String routeName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _navigateTo(context, routeName),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_right_alt_rounded, color: AppColors.secondary, size: 16),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppTheme.outfitFont,
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final double textFontSize = LiquidUI.fluid(context, minVal: 12, maxVal: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageService.instance.tr('footer_contact'),
          style: const TextStyle(
            fontFamily: AppTheme.outfitFont,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: () async {
            final uri = Uri.parse('https://maps.app.goo.gl/h6m7NWwtvi6GykRZ9');
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                await launchUrl(uri, mode: LaunchMode.platformDefault);
              }
            } catch (_) {
              await launchUrl(uri, mode: LaunchMode.platformDefault);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Survey No. - 217, Savarkundla Rd, Bhadara, Mahuva, Gujarat 364290',
                      style: TextStyle(
                        fontFamily: AppTheme.interFont,
                        color: Colors.grey.shade300,
                        fontSize: textFontSize,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'View on Google Maps ↗',
                          style: TextStyle(
                            fontFamily: AppTheme.interFont,
                            color: AppColors.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final uri = Uri.parse('tel:+917284088737');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: AppColors.secondary, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                '+91 7284088737',
                style: TextStyle(
                  fontFamily: AppTheme.interFont,
                  color: Colors.grey.shade300,
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final uri = Uri.parse('mailto:export@amarfoods.in');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.email, color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'export@amarfoods.in',
                style: TextStyle(fontFamily: AppTheme.interFont, color: Colors.grey.shade300, fontSize: textFontSize),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required String assetPath,
    required String url,
    required String tooltip,
    IconData? fallbackIcon,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          try {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              await launchUrl(uri);
            }
          } catch (_) {}
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(fallbackIcon ?? Icons.link_rounded, color: Colors.white, size: 18);
              },
            ),
          ),
        ),
      ),
    );
  }
}
