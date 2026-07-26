import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/quote_dialog.dart';
import '../widgets/product_detail_dialog.dart';



class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedCategory = 'ALL';

  final List<ProductModel> _allProducts = const [
    // --- RED ONION RANGE ---
    ProductModel(
      id: 'red_onion_flakes',
      title: 'Dehydrated Red Onion Flakes (Kibbled)',
      category: 'RED ONION',
      tag: '8-15 MM FLAKES',
      tagline: 'Rich natural pungency, 8-15 mm uniform kibbled cut.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productRedOnionFlakes,
        AppImages.productRedOnionFlakes2,
        AppImages.productRedOnionFlakes3,
        AppImages.productRedOnionFlakes4,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Our Dehydrated Red Onion Flakes (Kibbled) are processed from fresh, premium Mahuva red onions under hygienic multi-stage conveyor drying. Free from artificial colors, preservatives, and extraneous matter, delivering intense aroma and rich reddish-brown hue.',
      keyFeatures: [
        '100% pure Mahuva red onion origin',
        '8-15 mm uniform kibbled size',
        'High natural essential oil and pungency',
        'Zero chemical pesticide residues',
      ],
      applications: [
        'Canned food and ready-to-eat meal processing',
        'Industrial spice grinding and seasoning mixes',
        'Hotel, restaurant, and catering (HoReCa) supply chains',
        'Bakery, soup, sauce, and pickle manufacturing',
      ],
      specs: {
        'Size / Mesh': '8 - 15 mm (Kibbled Flakes)',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli: Negative / Salmonella: Absent',
      },
    ),
    ProductModel(
      id: 'red_onion_chopped',
      title: 'Dehydrated Red Onion Chopped',
      category: 'RED ONION',
      tag: '3-5 MM CHOPPED',
      tagline: 'Uniform 3-5 mm chopped cut, fast rehydration.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productRedOnionFlakes2,
        AppImages.productRedOnionFlakes3,
        AppImages.productRedOnionFlakes4,
        AppImages.productRedOnionFlakes5,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated Red Onion Chopped is cut to precise 3-5 mm pieces, ideal for food applications requiring visible red onion bits and quick reconstitution.',
      keyFeatures: [
        '3-5 mm uniform machine cut',
        'Deep natural red-purple color',
        'Instant rehydration in warm liquids',
        'Export packed in multi-wall foil barrier bags',
      ],
      applications: [
        'Instant noodles and dehydrated soup mixes',
        'Frozen pizza toppings and ready meals',
        'Meat processing, patties, and sausages',
        'Pickles, relishes, and canned condiments',
      ],
      specs: {
        'Size / Mesh': '3 - 5 mm Chopped',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'Microbial Load < 100,000 CFU/g',
      },
    ),
    ProductModel(
      id: 'red_onion_minced',
      title: 'Dehydrated Red Onion Minced',
      category: 'RED ONION',
      tag: '1-3 MM MINCED',
      tagline: 'Fine 1-3 mm minced bits for sauces and gravies.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productRedOnionFlakes3,
        AppImages.productRedOnionFlakes4,
        AppImages.productRedOnionFlakes5,
        AppImages.productRedOnionFlakes,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated Red Onion Minced consists of 1-3 mm finely chopped bits providing rich texture and pungency in salad dressings, dry spice rubs, and dips.',
      keyFeatures: [
        '1-3 mm minced cut',
        'Rich aroma and essential pungency',
        'Optical color sorted',
        'APEDA & FSSAI certified export quality',
      ],
      applications: [
        'Salad dressings, dips, and marinades',
        'Dry spice blends and seasoning rubs',
        'Curry pastes and canned gravies',
        'Snack food manufacturing',
      ],
      specs: {
        'Size / Mesh': '1 - 3 mm Minced',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli & Salmonella Negative',
      },
    ),
    ProductModel(
      id: 'red_onion_powder',
      title: 'Dehydrated Red Onion Powder',
      category: 'RED ONION',
      tag: '80-100 MESH POWDER',
      tagline: '80-100 mesh fine free-flowing powder.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productRedOnionFlakes5,
        AppImages.productRedOnionFlakes,
        AppImages.productRedOnionFlakes2,
        AppImages.productWhiteOnionPowder,
      ],
      purity: '99.5% min',
      moisture: '≤ 5.0%',
      shelfLife: '24 Months',
      description:
          'Free-flowing 80-100 mesh Red Onion Powder pulverized from dehydrated red onion flakes. Soluble and potent for instant flavor release in dry seasoning mixes.',
      keyFeatures: [
        '80-100 mesh fine dry powder',
        'Zero anti-caking additives or fillers',
        'Strong pungent flavor profile',
        'HALAL & Kosher certified',
      ],
      applications: [
        'Potato chips and extruded snack seasonings',
        'Dehydrated broth and soup powders',
        'Meat marinades and barbecue rubs',
        'Industrial food formulations',
      ],
      specs: {
        'Size / Mesh': '80 - 100 Mesh Fine Powder',
        'Moisture Content': 'Max 5.0%',
        'Total Ash': 'Max 4.0%',
        'Acid Insoluble Ash': 'Max 0.4%',
        'Microbiological': 'Microbial Count < 50,000 CFU/g',
      },
    ),

    // --- WHITE ONION RANGE ---
    ProductModel(
      id: 'white_onion_flakes',
      title: 'Dehydrated White Onion Flakes (Kibbled)',
      category: 'WHITE ONION',
      tag: '8-15 MM FLAKES',
      tagline: 'Crisp white kibbled flakes, clean sweet aroma.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productWhiteOnionPowder,
        AppImages.productRedOnionFlakes,
        AppImages.aboutProducts,
        AppImages.productPinkOnionGranules,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated White Onion Flakes (Kibbled) offer 8-15 mm size with bright white appearance. Essential for food processors requiring non-staining onion flavor.',
      keyFeatures: [
        '8-15 mm large white kibbled flakes',
        'Clean white to ivory natural color',
        'Mahuva white onion cultivar',
        'Optical color sorted for purity',
      ],
      applications: [
        'White sauces, mayonnaise, and creamy soups',
        'Canned vegetables and meat products',
        'European and American food processing',
        'HoReCa bulk kitchens',
      ],
      specs: {
        'Size / Mesh': '8 - 15 mm Kibbled Flakes',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli: Negative / Salmonella: Absent',
      },
    ),
    ProductModel(
      id: 'white_onion_chopped',
      title: 'Dehydrated White Onion Chopped',
      category: 'WHITE ONION',
      tag: '3-5 MM CHOPPED',
      tagline: '3-5 mm white chopped bits for ready meals.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productWhiteOnionPowder,
        AppImages.aboutProducts,
        AppImages.productRedOnionFlakes,
        AppImages.productPinkOnionGranules,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated White Onion Chopped features 3-5 mm cut white onion bits, fast reconstituting for soups, canned foods, and dry food mixes.',
      keyFeatures: [
        '3-5 mm chopped uniform cut',
        'Bright ivory white appearance',
        'High natural pungency',
        'Sealed in poly-lined export cartons',
      ],
      applications: [
        'Instant soup cups and noodle seasoning packets',
        'Pizza toppings and prepared meals',
        'Sauce and gravy manufacturing',
        'Cereal and savory snack inclusions',
      ],
      specs: {
        'Size / Mesh': '3 - 5 mm Chopped',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'Microbial Count < 100,000 CFU/g',
      },
    ),
    ProductModel(
      id: 'white_onion_powder',
      title: 'Dehydrated White Onion Powder',
      category: 'WHITE ONION',
      tag: '80-100 MESH POWDER',
      tagline: '80-100 mesh free-flowing white powder, instant flavor release.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productWhiteOnionPowder,
        AppImages.aboutProducts,
        AppImages.productRedOnionFlakes,
        AppImages.productPinkOnionGranules,
      ],
      purity: '99.5% min',
      moisture: '≤ 5.0%',
      shelfLife: '24 Months',
      description:
          'Milled from premium white onions harvested in Mahuva, our White Onion Powder offers 80-100 mesh fine texture with instant solubility. Ideal for dry seasoning rubs, snack flavorings, instant noodle tastemakers, and liquid sauces.',
      keyFeatures: [
        'Free-flowing fine powder without anti-caking additives',
        'Clean white to pale cream natural color',
        'Instant solubility in thermal and cold formulations',
        'ISO 22000 & HACCP laboratory certified',
      ],
      applications: [
        'Snack seasonings, potato chips, and extruded foods',
        'Instant noodles, soups, and dehydrated broth mixes',
        'Meat processing, sausages, and marinade rubs',
        'Retail private label spice and condiment brands',
      ],
      specs: {
        'Size / Mesh': '80 - 100 Mesh Fine Powder',
        'Moisture Content': 'Max 5.0%',
        'Total Ash': 'Max 4.0%',
        'Acid Insoluble Ash': 'Max 0.4%',
        'Microbiological': 'Microbial Load < 100,000 CFU/g',
      },
    ),

    // --- PINK ONION RANGE ---
    ProductModel(
      id: 'pink_onion_flakes',
      title: 'Dehydrated Pink Onion Flakes (Kibbled)',
      category: 'PINK ONION',
      tag: '8-15 MM FLAKES',
      tagline: 'Mild sweet pungency, 8-15 mm kibbled pink flakes.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productPinkOnionGranules,
        AppImages.productPinkOnionGranules2,
        AppImages.productPinkOnionGranules5,
        AppImages.productPinkOnionGranules3,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated Pink Onion Flakes (Kibbled) combine sweet flavor with mild pungency. Perfect for food processing requiring balanced taste profiles.',
      keyFeatures: [
        '8-15 mm pink kibbled cut',
        'Delicate pinkish natural hue',
        'High natural sugar content',
        'Hygienically dehydrated under ISO standards',
      ],
      applications: [
        'Ready-to-eat meals and frozen casseroles',
        'Salad mixes and seasoning blends',
        'Curry pastes and stews',
        'Processed meat and burger patties',
      ],
      specs: {
        'Size / Mesh': '8 - 15 mm Kibbled Flakes',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli & Salmonella Negative',
      },
    ),
    ProductModel(
      id: 'pink_onion_granules',
      title: 'Pink Onion Minced & Granules',
      category: 'PINK ONION',
      tag: '1-3 MM GRANULES',
      tagline: '1-3 mm chopped granules, balanced sweetness & aroma.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productPinkOnionGranules,
        AppImages.productPinkOnionGranules2,
        AppImages.productPinkOnionGranules3,
        AppImages.productPinkOnionGranules4,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Pink Onion Granules are mechanically chopped to 1-3 mm size, preserving the characteristic sweetness and warm aroma of Gujarat pink onions. Excellent for texture-sensitive food recipes where visible onion bits are desired.',
      keyFeatures: [
        '1-3 mm chopped minced uniform granules',
        'Pleasant pinkish-cream natural hue',
        'Quick rehydration in warm water',
        'Sealed in poly-lined barrier bags for export',
      ],
      applications: [
        'Sausages, burgers, and processed meats',
        'Prepared frozen meals and pizza toppings',
        'Salad dressings, dips, and gourmet sauces',
        'Custom spice blending and dry rubs',
      ],
      specs: {
        'Size / Mesh': '1 - 3 mm Minced Granules',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.5%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli & Salmonella Negative',
      },
    ),
    ProductModel(
      id: 'pink_onion_powder',
      title: 'Dehydrated Pink Onion Powder',
      category: 'PINK ONION',
      tag: '80-100 MESH POWDER',
      tagline: '80-100 mesh pink onion powder.',
      origin: 'MAHUVA, GUJARAT, INDIA',
      images: [
        AppImages.productPinkOnionGranules3,
        AppImages.productPinkOnionGranules4,
        AppImages.productPinkOnionGranules,
        AppImages.productWhiteOnionPowder,
      ],
      purity: '99.5% min',
      moisture: '≤ 5.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated Pink Onion Powder offers 80-100 mesh fine grind with sweet aromatic notes, suitable for seasonings and soup bases.',
      keyFeatures: [
        '80-100 mesh fine powder',
        'Natural pinkish cream tone',
        '100% pure without additives',
        'APEDA approved export specification',
      ],
      applications: [
        'Snack flavorings and seasoning dusts',
        'Instant soup powders and broths',
        'Sauce, dip, and gravy premixes',
        'Industrial spice blending',
      ],
      specs: {
        'Size / Mesh': '80 - 100 Mesh Fine Powder',
        'Moisture Content': 'Max 5.0%',
        'Total Ash': 'Max 4.0%',
        'Acid Insoluble Ash': 'Max 0.4%',
        'Microbiological': 'Microbial Count < 50,000 CFU/g',
      },
    ),

    // --- GARLIC RANGE ---
    ProductModel(
      id: 'garlic_flakes',
      title: 'Dehydrated Garlic Flakes (Slices)',
      category: 'GARLIC',
      tag: '10-15 MM SLICES',
      tagline: 'Pungent sliced garlic cloves with natural yellowish luster.',
      origin: 'GUJARAT & MADHYA PRADESH, INDIA',
      images: [
        AppImages.productGarlicFlakes,
        AppImages.productGarlicFlakes2,
        AppImages.productGarlicMinced,
        AppImages.productGarlicGranules,
      ],
      purity: '99.5% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Our Dehydrated Garlic Flakes are processed from fresh, sound garlic cloves peeled, washed, and gently dried to preserve essential Allicin oils. Provides intense garlic flavor without the labor of fresh garlic peeling.',
      keyFeatures: [
        'High Allicin content for rich garlic aroma',
        'Clean sliced flakes with natural yellowish tint',
        'Zero sulphur additives or chemical bleaching',
        'Optical color sorted for 100% purity',
      ],
      applications: [
        'Garlic bread, pizza, and Italian cuisine',
        'Canned pickles, curries, and gravies',
        'Pharmaceutical and herbal health formulations',
        'Industrial spice grinding and extracts',
      ],
      specs: {
        'Size / Mesh': 'Sliced Flakes (10 - 15 mm)',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.0%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'FSSAI & APEDA Export Approved',
      },
    ),
    ProductModel(
      id: 'garlic_chopped',
      title: 'Dehydrated Garlic Chopped',
      category: 'GARLIC',
      tag: '3-5 MM CHOPPED',
      tagline: '3-5 mm chopped garlic bits for heavy cooking.',
      origin: 'GUJARAT, INDIA',
      images: [
        AppImages.productGarlicMinced2,
        AppImages.productGarlicMinced4,
        AppImages.productGarlicMinced5,
        AppImages.productGarlicFlakes,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated Garlic Chopped consists of 3-5 mm pieces cut from dehydrated cloves. Excellent for stir-fries, stews, and canned sauces.',
      keyFeatures: [
        '3-5 mm chopped uniform cut',
        'Potent Allicin garlic pungency',
        'Thermal stability in long cooking',
        'Metal detector & optical color sorted',
      ],
      applications: [
        'Pasta sauces, stir-fries, and stews',
        'Canned soups and frozen meals',
        'Commercial catering supply',
        'Pickles and marinades',
      ],
      specs: {
        'Size / Mesh': '3 - 5 mm Chopped',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.2%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli & Salmonella Negative',
      },
    ),
    ProductModel(
      id: 'garlic_minced',
      title: 'Dehydrated Garlic Minced',
      category: 'GARLIC',
      tag: '1-3 MM MINCED',
      tagline: '1-3 mm minced garlic bits for visible culinary texture.',
      origin: 'GUJARAT, INDIA',
      images: [
        AppImages.productGarlicMinced,
        AppImages.productGarlicMinced2,
        AppImages.productGarlicMinced3,
        AppImages.productGarlicMinced4,
      ],
      purity: '99% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Precision-chopped 1-3 mm garlic bits engineered for food applications requiring visual garlic pieces. Fast rehydration and intense flavor release when cooked in soups, stews, and stir-fries.',
      keyFeatures: [
        '1-3 mm uniform minced granules',
        'High thermal stability during cooking',
        'Cleanroom magnetic metal trap checked',
        'Customized packaging in 20kg / 25kg cartons',
      ],
      applications: [
        'Ready-to-cook meal kits and frozen foods',
        'Stir-fry seasonings and pasta sauces',
        'Commercial HoReCa kitchen preparation',
        'Bulk food processing export orders',
      ],
      specs: {
        'Size / Mesh': '1 - 3 mm Minced Granules',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.2%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli Nil / Salmonella Negative',
      },
    ),
    ProductModel(
      id: 'garlic_granules',
      title: 'Dehydrated Garlic Granules',
      category: 'GARLIC',
      tag: '0.5-1 MM GRANULES',
      tagline: 'Golden-amber 0.5-1 mm coarse garlic granules for seasonings & rubs.',
      origin: 'GUJARAT, INDIA',
      images: [
        AppImages.productGarlicGranules,
        AppImages.productGarlicGranules2,
        AppImages.productGarlicGranules3,
        AppImages.productGarlicGranules4,
      ],
      purity: '99.5% min',
      moisture: '≤ 6.0%',
      shelfLife: '24 Months',
      description:
          'Dehydrated Garlic Granules offer uniform 0.5 to 1 mm particle cut with warm golden-amber luster. Ideal for dry seasoning rubs, spice blends, and processed meats requiring even dispersion.',
      keyFeatures: [
        '0.5 - 1 mm coarse granular mesh cut',
        'Rich Allicin oil flavor and intense aroma',
        'Free-flowing without artificial anti-caking agents',
        'Export-grade optical color sorted and metal trap checked',
      ],
      applications: [
        'Dry spice seasonings, rubs, and condiment blends',
        'Processed meat, sausages, and poultry marinades',
        'Snack seasoning dusts and pizza top blends',
        'HoReCa and food manufacturing export supply',
      ],
      specs: {
        'Size / Mesh': '0.5 - 1 mm Granules',
        'Moisture Content': 'Max 6.0%',
        'Total Ash': 'Max 4.0%',
        'Acid Insoluble Ash': 'Max 0.5%',
        'Microbiological': 'E.Coli Nil / Salmonella Negative',
      },
    ),
    ProductModel(
      id: 'garlic_powder',
      title: 'Dehydrated Garlic Powder',
      category: 'GARLIC',
      tag: '80-100 MESH POWDER',
      tagline: 'Fine 80-100 mesh pure garlic powder with intense bite.',
      origin: 'GUJARAT, INDIA',
      images: [
        AppImages.productGarlicPowder,
        AppImages.productGarlicPowder2,
        AppImages.productGarlicPowder3,
        AppImages.productGarlicPowder4,
      ],
      purity: '99.5% min',
      moisture: '≤ 5.5%',
      shelfLife: '24 Months',
      description:
          'Pure 100% Garlic Powder ground from dehydrated garlic cloves. Disperses evenly in dry and wet formulations, imparting robust pungent flavor to dry seasoning rubs, snack coatings, and liquid sauces.',
      keyFeatures: [
        '80-100 mesh fine dry powder',
        'Uniform creamish-yellow color',
        'Zero anti-caking or fillers added',
        'HALAL & Kosher compliant export processing',
      ],
      applications: [
        'Snack seasonings and potato chip flavors',
        'Garlic butter mixes and bakery seasonings',
        'Process cheese, mayonnaise, and dips',
        'Processed meat, poultry, and fish marinades',
      ],
      specs: {
        'Size / Mesh': '80 - 100 Mesh Fine Powder',
        'Moisture Content': 'Max 5.5%',
        'Total Ash': 'Max 4.0%',
        'Acid Insoluble Ash': 'Max 0.4%',
        'Microbiological': 'Microbial Count < 50,000 CFU/g',
      },
    ),
  ];

  void _showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuoteDialog(),
    );
  }

  void _showProductDetailModal(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double paddingV = LiquidUI.fluid(context, minVal: 50, maxVal: 80);
    final double headingSize = LiquidUI.fluid(context, minVal: 30, maxVal: 48);

    final filteredProducts = _selectedCategory == 'ALL'
        ? _allProducts
        : _allProducts.where((p) => p.category == _selectedCategory).toList();

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
                            text: 'EXPORT-GRADE DEHYDRATED PRODUCTS & SPICES',
                            icon: Icons.verified_rounded,
                            backgroundColor: AppColors.secondary.withOpacity(0.2),
                            textColor: AppColors.secondary,
                            fontSize: 11,
                          ),
                          const SizedBox(height: 20),

                          LiquidUI.gradientText(
                            'Our Complete Product Range',
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
                          const SizedBox(height: 14),

                          Text(
                            'Discover Mahuva\'s finest dehydrated red, white, and pink onions alongside high-pungency garlic flakes, granules, and powders.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.grey.shade300,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Category Filter Bar
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildFilterPill('ALL', 'ALL PRODUCTS (${_allProducts.length})'),
                              _buildFilterPill('RED ONION', 'RED ONION'),
                              _buildFilterPill('WHITE ONION', 'WHITE ONION'),
                              _buildFilterPill('PINK ONION', 'PINK ONION'),
                              _buildFilterPill('GARLIC', 'GARLIC'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product Cards Showcase Grid
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
              child: Center(
                child: Container(
                  constraints: LiquidUI.pageConstraints(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (isMobile) {
                        return Column(
                          children: filteredProducts
                              .map((product) => Padding(
                                    padding: const EdgeInsets.only(bottom: 28.0),
                                    child: _buildProductCard(context, product),
                                  ))
                              .toList(),
                        );
                      } else {
                        return Wrap(
                          spacing: 24,
                          runSpacing: 32,
                          children: filteredProducts
                              .map((product) => SizedBox(
                                    width: (constraints.maxWidth - 24) / 2 > 340
                                        ? (constraints.maxWidth - 48) / 3
                                        : (constraints.maxWidth - 24) / 2,
                                    child: _buildProductCard(context, product),
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),

            // Bottom CTA Section
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
                        'Require Custom Mesh Sizes or Private Label Packaging?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We customize particle mesh sizes (kibbled, minced, granules, powder) and bulk barrier packaging (10kg - 25kg) for global export.',
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
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          'Request Custom Specification Quote',
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

  Widget _buildFilterPill(String categoryKey, String label) {
    final bool isSelected = _selectedCategory == categoryKey;

    return InkWell(
      onTap: () => setState(() => _selectedCategory = categoryKey),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondaryGlow.withOpacity(0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Product Card Matching Reference Image Layout
  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return _ProductCardWidget(
      product: product,
      onViewDetails: () => _showProductDetailModal(context, product),
      onQuoteRequest: () => _showQuoteDialog(context),
    );
  }
}

// Stateful Product Card Component with Interactive Thumbnail Selector
class _ProductCardWidget extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onViewDetails;
  final VoidCallback onQuoteRequest;

  const _ProductCardWidget({
    required this.product,
    required this.onViewDetails,
    required this.onQuoteRequest,
  });

  @override
  State<_ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<_ProductCardWidget> {
  late String _activeImage;

  @override
  void initState() {
    super.initState();
    _activeImage = widget.product.images.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Image Stack with Category Tag Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.asset(
                    _activeImage,
                    fit: BoxFit.cover,
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
                    widget.product.tag,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title in Playfair Display
                Text(
                  widget.product.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  widget.product.tagline,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                // Origin Tag Line
                Text(
                  'ORIGIN • ${widget.product.origin}',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),

                // 4 Interactive Thumbnail Images Gallery (Matching Reference Image)
                Row(
                  children: widget.product.images.take(4).map((img) {
                    final bool isActive = _activeImage == img;
                    return GestureDetector(
                      onTap: () => setState(() => _activeImage = img),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isActive ? AppColors.secondary : AppColors.border,
                            width: isActive ? 2 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(img, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Action Row: View Details & WhatsApp Inquire Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 4,
                          shadowColor: AppColors.secondaryGlow,
                        ),
                        child: Text(
                          'View Details',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
                        onPressed: widget.onQuoteRequest,
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
}

