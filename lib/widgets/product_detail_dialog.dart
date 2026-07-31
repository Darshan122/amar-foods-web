import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../utils/liquid_ui.dart';
import 'quote_dialog.dart';

class ProductModel {
  final String id;
  final String title;
  final String category;
  final String tag;
  final String tagline;
  final String origin;
  final List<String> images;
  final String purity;
  final String moisture;
  final String shelfLife;
  final String description;
  final List<String> keyFeatures;
  final List<String> applications;
  final Map<String, String> specs;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.tag,
    required this.tagline,
    required this.origin,
    required this.images,
    required this.purity,
    required this.moisture,
    required this.shelfLife,
    required this.description,
    required this.keyFeatures,
    required this.applications,
    required this.specs,
  });
}

void showProductDetailModal(BuildContext context, ProductModel product) {
  showDialog(
    context: context,
    builder: (context) => ProductDetailDialog(product: product),
  );
}

class ProductDetailDialog extends StatefulWidget {
  final ProductModel product;

  const ProductDetailDialog({super.key, required this.product});

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  late String _activeModalImage;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _activeModalImage = widget.product.images.first;
  }

  void _showQuoteDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);

    return Dialog(
      backgroundColor: const Color(0xFF1E0A19),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 24,
        vertical: isMobile ? 12 : 24,
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400, maxHeight: 900),
        child: Column(
          children: [
            // Modal Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.product.tag,
                                style: GoogleFonts.outfit(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.title,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),

            // Scrollable Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 2-Column Responsive Layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final imageGallery = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 1.3,
                                child: Image.asset(
                                  _activeModalImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF260B1E),
                                      child: const Icon(Icons.image_not_supported_rounded, color: Colors.white38, size: 48),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.product.images.map((img) {
                                final bool isActive = _activeModalImage == img;
                                return GestureDetector(
                                  onTap: () => setState(() => _activeModalImage = img),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isActive ? AppColors.secondary : Colors.white24,
                                        width: isActive ? 2.5 : 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        img,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.black26),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // Export Quality Guarantee Box
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        'EXPORT QUALITY GUARANTEE',
                                        style: GoogleFonts.outfit(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '• Origin: Mahuva, Gujarat, India\n'
                                    '• Process: Multi-stage Optical Sorting & Metal Detector\n'
                                    '• Safety: 100% Natural, Pesticide & Pathogen Free\n'
                                    '• Custom Cuts: Kibbled, Minced, Granules, Powder',
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12,
                                      height: 1.65,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );

                        final detailsPanel = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quality Metric Pills
                            Row(
                              children: [
                                _buildMetricCard('PURITY', widget.product.purity),
                                const SizedBox(width: 10),
                                _buildMetricCard('MOISTURE', widget.product.moisture),
                                const SizedBox(width: 10),
                                _buildMetricCard('SHELF LIFE', widget.product.shelfLife),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Accreditations Row
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                _AccreditationChip('FSSAI'),
                                _AccreditationChip('APEDA'),
                                _AccreditationChip('ISO 22000'),
                                _AccreditationChip('HACCP'),
                                _AccreditationChip('HALAL'),
                              ],
                            ),
                            const SizedBox(height: 22),

                            // Action CTA Buttons
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _showQuoteDialog(context),
                                icon: const Icon(Icons.chat_rounded, size: 18),
                                label: Text(
                                  'Inquire on WhatsApp →',
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF25D366),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tabs Bar
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white12)),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildModalTab(0, 'Description'),
                                    _buildModalTab(1, 'Key Features'),
                                    _buildModalTab(2, 'Applications'),
                                    _buildModalTab(3, 'Specifications'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Dynamic Tab View Content
                            if (_selectedTab == 0)
                              Text(
                                widget.product.description,
                                style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.6),
                              )
                            else if (_selectedTab == 1)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.product.keyFeatures
                                    .map((feat) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 18),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  feat,
                                                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              )
                            else if (_selectedTab == 2)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.product.applications
                                    .map((app) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.arrow_right_rounded, color: AppColors.secondary, size: 22),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  app,
                                                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              )
                            else if (_selectedTab == 3)
                              Table(
                                border: TableBorder.all(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                                children: widget.product.specs.entries.map((e) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          e.key,
                                          style: GoogleFonts.outfit(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          e.value,
                                          style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                          ],
                        );

                        if (constraints.maxWidth > 900) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: imageGallery),
                              const SizedBox(width: 32),
                              Expanded(flex: 7, child: detailsPanel),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              imageGallery,
                              const SizedBox(height: 24),
                              detailsPanel,
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.outfit(color: AppColors.secondary, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalTab(int index, String label) {
    final bool isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.secondary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? AppColors.secondary : Colors.white60,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _AccreditationChip extends StatelessWidget {
  final String label;
  const _AccreditationChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        '✓ $label',
        style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
