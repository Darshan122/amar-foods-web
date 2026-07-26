import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../theme/app_theme.dart';
import '../utils/liquid_ui.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  void _navigateTo(BuildContext context, String routeName) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
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
              Divider(color: Colors.white.withOpacity(0.1), height: 1, thickness: 1),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  Text(
                    '© 2026 Amar Foods. All rights reserved.',
                    style: TextStyle(
                      fontFamily: AppTheme.interFont,
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSocialIcon(Icons.facebook),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.business_outlined),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.email_outlined),
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
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
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
          'Premier manufacturer, supplier, and exporter of high-grade dehydrated onion and garlic products based in Mahuva, Bhavnagar, Gujarat, India.',
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
        const Text(
          'Quick Links',
          style: TextStyle(
            fontFamily: AppTheme.outfitFont,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        _buildFooterLink(context, 'Home', '/'),
        _buildFooterLink(context, 'About Us', '/about'),
        _buildFooterLink(context, 'Photo Gallery', '/gallery'),
        _buildFooterLink(context, 'Contact Us', '/contact'),
      ],
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
        const Text(
          'Contact Details',
          style: TextStyle(
            fontFamily: AppTheme.outfitFont,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: () async {
            final uri = Uri.parse('https://maps.google.com/maps?q=Amarfoods+mahuva');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
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
                  color: AppColors.secondary.withOpacity(0.2),
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
                  color: AppColors.primary.withOpacity(0.2),
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

  Widget _buildSocialIcon(IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
