import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/products_page.dart';
import 'pages/contact_page.dart';
import 'pages/gallery_page.dart';
import 'theme/app_theme.dart';
import 'services/language_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LanguageItem>(
      valueListenable: LanguageService.instance.currentLanguage,
      builder: (context, lang, _) {
        return MaterialApp(
          key: ValueKey(lang.code),
          title: 'Amar Foods | Dehydrated Onion & Garlic Manufacturer in Mahuva, Gujarat',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          builder: (context, child) {
            return Directionality(
              textDirection: lang.isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/about': (context) => const AboutPage(),
            '/products': (context) => const ProductsPage(),
            '/gallery': (context) => const GalleryPage(),
            '/contact': (context) => const ContactPage(),
            '/quality': (context) => const QualityPage(),
            '/shipments': (context) => const ShipmentsPage(),
          },
        );
      },
    );
  }
}

