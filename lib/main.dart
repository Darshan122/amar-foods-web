import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/products_page.dart';
import 'pages/contact_page.dart';
import 'pages/gallery_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amar Foods',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
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
  }
}
