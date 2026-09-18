import '../constants/app_images.dart';

class ExhibitionItem {
  final String id;
  final String title;
  final String tag; // 'International' | 'Domestic'
  final String edition;
  final String venue;
  final String location;
  final String dates;
  final String description;
  final String mainImage;
  final List<String> galleryImages;
  final List<String> highlights;
  final List<String> focusProducts;
  final String? boothNumber;
  final bool isFeatured;

  const ExhibitionItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.edition,
    required this.venue,
    required this.location,
    required this.dates,
    required this.description,
    required this.mainImage,
    required this.galleryImages,
    required this.highlights,
    required this.focusProducts,
    this.boothNumber,
    this.isFeatured = false,
  });
}

class ExhibitionsData {
  static const List<ExhibitionItem> allExhibitions = [
    ExhibitionItem(
      id: 'gulfood-2026',
      title: 'Gulfood 2026',
      tag: 'International',
      edition: '31st Record-Breaking Edition',
      venue: 'Dubai World Trade Centre (DWTC) & Dubai Exhibition Centre',
      location: 'Dubai, United Arab Emirates (UAE)',
      dates: 'January 26 – 30, 2026',
      description:
          'Amar Foods attended Gulfood in Dubai as a premier agro-export delegate, connecting with global food importers, commercial spice blenders, and multinational food manufacturers to showcase Mahuva\'s world-renowned dehydrated onion flakes, garlic powder, and export-grade whole spices.',
      mainImage: AppImages.expoGulfood2026,
      galleryImages: [
        AppImages.expoGulfood2026,
        AppImages.expoGulfoodSouthHalls,
      ],
      highlights: [
        'Connected with 150+ international food buyers and global procurement heads',
        'Gained deep insights into Middle Eastern, North African & European import regulations',
        'Discussed customized cuts, moisture parameters, and private label bulk packaging',
        'Finalized multi-container annual supply frameworks for dehydrated alliums',
      ],
      focusProducts: [
        'Dehydrated White Onion Flakes',
        'Dehydrated Red Onion Chopped',
        'Garlic Powder & Granules',
        'Whole & Ground Cumin (Jeera)',
      ],
      boothNumber: 'Global Agro Hall',
      isFeatured: true,
    ),
    ExhibitionItem(
      id: 'indusfood-2026',
      title: 'Indusfood 2026',
      tag: 'Domestic',
      edition: 'South Asia\'s Premier F&B Trade Platform',
      venue: 'India Expo Centre & Mart',
      location: 'Greater Noida, Delhi NCR, India',
      dates: 'January 8 – 10, 2026',
      description:
          'Attending Indusfood in Greater Noida, our export desk engaged with leading domestic conglomerates, overseas visiting delegations, and institutional buyers, highlighting the natural pungency, extended shelf life, and audit-ready traceability of Saurashtra\'s dehydrated crops.',
      mainImage: AppImages.expoIndusfood2026,
      galleryImages: [
        AppImages.expoIndusfood2026,
      ],
      highlights: [
        'Engaged with leading FMCG manufacturers and domestic ready-to-eat brands',
        'Demonstrated optical sorting purity and zero-adulteration standards',
        'Negotiated scheduled direct shipments through Pipavav and Mundra ports',
        'Showcased value-added toasted onion flakes (Birista) and kibbled garlic',
      ],
      focusProducts: [
        'Crispy Fried Onion (Birista)',
        'Dehydrated Pink Onion Minced',
        'Garlic Flakes & Chopped',
        'Turmeric Finger & Powder',
      ],
      boothNumber: 'Hall 1 & 2',
      isFeatured: true,
    ),
    ExhibitionItem(
      id: 'sial-2025',
      title: 'SIAL Food Forum (APEDA Pavilion)',
      tag: 'International',
      edition: 'Global Food Innovation Showcase',
      venue: 'Jio World Convention Centre, BKC',
      location: 'Mumbai, India & Paris Nord Villepinte',
      dates: 'August 28 – 30, 2025',
      description:
          'Representing under the APEDA (Agricultural and Processed Food Products Export Development Authority) banner, Amar Foods presented certified export lots of dehydrated white and red onions, discussing EU microbial benchmarks and sustainable farm sourcing directly from Mahuva.',
      mainImage: AppImages.expoSial2024,
      galleryImages: [
        AppImages.expoSial2024,
      ],
      highlights: [
        'Promoted India\'s agricultural export dominance under the APEDA pavilion',
        'Verified compliance parameters for ISO 22000, HACCP, HALAL & KOSHER',
        'Connected with European seasoning formulators and sauce manufacturers',
        'Explored cold-chain logistics and air-tight vacuum packaging solutions',
      ],
      focusProducts: [
        'Dehydrated White Onion Powder',
        'Dehydrated Garlic Flakes',
        'Natural & Hulled Sesame Seeds (Til)',
        'Coriander Powder (Dhania)',
      ],
      boothNumber: 'APEDA India Pavilion',
      isFeatured: false,
    ),
    ExhibitionItem(
      id: 'fi-india-2026',
      title: 'FI India',
      tag: 'Domestic',
      edition: 'Food Ingredients India',
      venue: 'Bombay Exhibition Center (BEC)',
      location: 'Goregaon East, Mumbai, India',
      dates: 'August 26 – 28, 2026',
      description:
          'At Asia\'s leading exhibition & conference for food ingredients and health ingredients, Amar Foods held technical roundtables with industrial food processors, exploring custom particle sizes, color retention, and aromatic potency in dehydrated ingredients.',
      mainImage: AppImages.expoFiIndiaHall,
      galleryImages: [
        AppImages.expoFiIndiaHall,
        AppImages.expoFiIndia1,
        AppImages.expoFiIndia2,
        AppImages.expoFiIndia3,
        AppImages.expoFiIndia4,
      ],
      highlights: [
        'Exhibited full dehydration spectrum across flake, granule, and micro-powder grades',
        'Consulted with instant noodle and seasoning blend product formulators',
        'Showcased automated clean-room handling and magnetic metal separation',
        'Strengthened relationships with pan-India food ingredient distributors',
      ],
      focusProducts: [
        'Dehydrated Onion Flakes & Powder',
        'Dehydrated Garlic Granules',
        'Pure Dehydrated Spices',
        'Custom Industrial Mesh Cuts',
      ],
      boothNumber: 'BEC Hall 1',
      isFeatured: false,
    ),
  ];
}
