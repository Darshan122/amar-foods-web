import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../data/products_data.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';
import '../widgets/product_detail_dialog.dart';
import 'product_detail_page.dart';
import '../widgets/whatsapp_floating_button.dart';
import '../services/language_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedCategory = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  static const int _pageSize = 12;

  final List<ProductModel> _allProducts = ProductsData.allProducts;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goToPage(int page, bool isMobile) {
    setState(() {
      _currentPage = page;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final double target = isMobile ? 380.0 : 420.0;
        if (_scrollController.offset > target) {
          _scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  void _showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  void _showProductDetailModal(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  Future<void> _openWhatsAppInquiry(ProductModel product) async {
    final message = Uri.encodeComponent(
      'Hello Amar Foods, I am interested in container pricing for ${product.title} (${product.tag}). Please provide live CIF/FOB quote.',
    );
    final url = Uri.parse('https://wa.me/917284088737?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double paddingV = LiquidUI.fluid(context, minVal: 40, maxVal: 65);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 44);

    final filteredProducts = _allProducts.where((p) {
      final matchesCategory = _selectedCategory == 'ALL' ||
          p.category == _selectedCategory ||
          (_selectedCategory == 'GARLIC' && (p.category == 'GARLIC' || p.category == 'BLACK GARLIC')) ||
          (_selectedCategory == 'RED & PINK ONION' && (p.category == 'RED ONION' || p.category == 'PINK ONION')) ||
          (_selectedCategory == 'CHILLI & FRUIT' && (p.category == 'VEGETABLE & CHILLI' || p.category == 'FRUIT & TANGY'));

      final matchesSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery) ||
          p.tag.toLowerCase().contains(_searchQuery) ||
          p.category.toLowerCase().contains(_searchQuery) ||
          p.description.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    final int totalProducts = filteredProducts.length;
    final int totalPages = (totalProducts / _pageSize).ceil().clamp(1, 999);
    final int validPage = _currentPage.clamp(1, totalPages);
    final int startIndex = totalProducts == 0 ? 0 : (validPage - 1) * _pageSize;
    final int endIndex = (startIndex + _pageSize).clamp(0, totalProducts);
    final paginatedProducts = totalProducts > 0
        ? filteredProducts.sublist(startIndex, endIndex)
        : <ProductModel>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const WhatsAppFloatingButton(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // ==================== HERO SECTION ====================
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
                          const Color(0xFF0F172A).withValues(alpha: 0.90),
                          const Color(0xFF260B1E).withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: paddingV),
                  child: Center(
                    child: Container(
                      constraints: LiquidUI.pageConstraints(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 18 : 32,
                        vertical: isMobile ? 26 : 38,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          LiquidUI.badgePill(
                            text: 'GLOBAL EXPORT CATALOGUE 2026',
                            icon: Icons.verified_rounded,
                            backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                            textColor: AppColors.secondary,
                            fontSize: 11,
                          ),
                          const SizedBox(height: 18),

                          LiquidUI.gradientText(
                            'Premium Dehydrated Vegetables & Botanical Powders',
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
                            'Pure farm-to-factory dehydrated onions, garlic, whole & ground spices, crispy fried onions, sesame seeds, root crops, and botanical powders from Mahuva, Gujarat.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 13.5 : 15,
                              color: Colors.grey.shade300,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Search Box
                          Container(
                            constraints: const BoxConstraints(maxWidth: 520),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                              onChanged: (val) => setState(() {
                                _searchQuery = val.trim().toLowerCase();
                                _currentPage = 1;
                              }),
                              decoration: InputDecoration(
                                hintText: 'Search products (e.g. Cumin, Birista, Sesame, Garlic, Moringa)...',
                                hintStyle: GoogleFonts.outfit(color: Colors.white60, fontSize: 13),
                                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded, color: Colors.white70, size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                            _currentPage = 1;
                                          });
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Category Filter Pills
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildFilterPill('ALL', 'All Products (${_allProducts.length})'),
                              _buildFilterPill('WHITE ONION', 'White Onion (5)'),
                              _buildFilterPill('GARLIC', 'Garlic & Black Garlic (6)'),
                              _buildFilterPill('RED & PINK ONION', 'Red & Pink Onion (10)'),
                              _buildFilterPill('SPICES', 'Whole & Ground Spices (6)'),
                              _buildFilterPill('FRIED & TOASTED', 'Fried & Toasted Onion (2)'),
                              _buildFilterPill('OILSEEDS', 'Sesame Seeds (2)'),
                              _buildFilterPill('ROOT & GINGER', 'Root & Ginger (4)'),
                              _buildFilterPill('LEAFY & HERBS', 'Leafy & Herbs (6)'),
                              _buildFilterPill('CHILLI & FRUIT', 'Chilli, Veg & Fruit (6)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ==================== PRODUCT CARDS GRID ====================
            Container(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 24, vertical: paddingV),
              child: Center(
                child: Container(
                  constraints: LiquidUI.pageConstraints(),
                  child: filteredProducts.isEmpty
                      ? _buildEmptyState()
                      : Column(
                          children: [
                            // Result stats info bar
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Showing ${startIndex + 1}–$endIndex of $totalProducts Products',
                                    style: GoogleFonts.outfit(
                                      fontSize: isMobile ? 13 : 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  if (totalPages > 1)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: Text(
                                        'Page $validPage of $totalPages',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Cards Grid (renders only 12 items for fast load)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (isMobile) {
                                  return Column(
                                    children: paginatedProducts
                                        .map((product) => Padding(
                                              padding: const EdgeInsets.only(bottom: 24.0),
                                              child: _ProductCardWidget(
                                                product: product,
                                                onViewDetails: () => _showProductDetailModal(context, product),
                                                onQuoteRequest: () => _openWhatsAppInquiry(product),
                                              ),
                                            ))
                                        .toList(),
                                  );
                                } else {
                                  return Wrap(
                                    spacing: 24,
                                    runSpacing: 30,
                                    children: paginatedProducts
                                        .map((product) => SizedBox(
                                              width: (constraints.maxWidth - 48) / 3 > 320
                                                  ? (constraints.maxWidth - 48) / 3
                                                  : (constraints.maxWidth - 24) / 2,
                                              child: _ProductCardWidget(
                                                product: product,
                                                onViewDetails: () => _showProductDetailModal(context, product),
                                                onQuoteRequest: () => _openWhatsAppInquiry(product),
                                              ),
                                            ))
                                        .toList(),
                                  );
                                }
                              },
                            ),

                            // Pagination Navigation Controls
                            if (totalPages > 1) ...[
                              const SizedBox(height: 48),
                              _buildPaginationControls(isMobile, totalPages, validPage),
                            ],
                          ],
                        ),
                ),
              ),
            ),

            // ==================== BOTTOM CTA BANNER ====================
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Center(
                child: Container(
                  constraints: LiquidUI.pageConstraints(),
                  child: Column(
                    children: [
                      Text(
                        LanguageService.instance.tr('prod_custom_title'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        LanguageService.instance.tr('prod_custom_sub'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () => _showQuoteDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          LanguageService.instance.tr('prod_custom_btn'),
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
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(bool isMobile, int totalPages, int currentPage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 10,
        children: [
          // Previous Button
          _buildPageNavButton(
            icon: Icons.chevron_left_rounded,
            label: isMobile ? null : 'Previous',
            isEnabled: currentPage > 1,
            onTap: () => _goToPage(currentPage - 1, isMobile),
          ),
          const SizedBox(width: 4),

          // Page Numbers
          ...List.generate(totalPages, (index) {
            final pageNum = index + 1;
            final bool isSelected = pageNum == currentPage;

            return InkWell(
              onTap: () => _goToPage(pageNum, isMobile),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$pageNum',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: 4),
          // Next Button
          _buildPageNavButton(
            icon: Icons.chevron_right_rounded,
            label: isMobile ? null : 'Next',
            isEnabled: currentPage < totalPages,
            onTap: () => _goToPage(currentPage + 1, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildPageNavButton({
    required IconData icon,
    String? label,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        padding: EdgeInsets.symmetric(horizontal: label != null ? 14 : 10),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon == Icons.chevron_left_rounded)
              Icon(
                icon,
                size: 20,
                color: isEnabled ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
              ),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isEnabled ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 4),
            ],
            if (icon == Icons.chevron_right_rounded)
              Icon(
                icon,
                size: 20,
                color: isEnabled ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String categoryKey, String label) {
    final bool isSelected = _selectedCategory == categoryKey;

    return InkWell(
      onTap: () => setState(() {
        _selectedCategory = categoryKey;
        _currentPage = 1;
      }),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 56, color: Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          Text(
            'No products match your search',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Try clearing your search query or choosing another category.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _selectedCategory = 'ALL';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Show All Products'),
          ),
        ],
      ),
    );
  }
}

// ==================== REDESIGNED SINGLE HERO IMAGE CARD ====================
class _ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onViewDetails;
  final VoidCallback onQuoteRequest;

  const _ProductCardWidget({
    required this.product,
    required this.onViewDetails,
    required this.onQuoteRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Single Hero Image with Tag Badge
          GestureDetector(
            onTap: onViewDetails,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: AspectRatio(
                    aspectRatio: 1.25,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      cacheWidth: 480,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return Container(
                          color: const Color(0xFFF1F5F9),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryLight,
                          child: const Center(
                            child: Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.primary),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Category Mesh Tag
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.tag,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Pure Grade Badge
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'EXPORT GRADE',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title in Playfair Display
                Text(
                  product.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  product.tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Origin
                Text(
                  'ORIGIN: ${product.origin}',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 14),

                // Quick Specs Pills Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildSpecChip('Purity: ${product.purity}'),
                    _buildSpecChip('Moisture: ${product.moisture}'),
                    _buildSpecChip('Shelf Life: ${product.shelfLife}'),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Row: View Specs & WhatsApp Inquire Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onViewDetails,
                        icon: const Icon(Icons.description_outlined, size: 16),
                        label: Text(
                          'View Specifications',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 3,
                          shadowColor: AppColors.secondaryGlow,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF25D366), // WhatsApp Green
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                        onPressed: onQuoteRequest,
                        tooltip: 'Inquire on WhatsApp',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSpecChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
