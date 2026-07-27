import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../services/firebase_service.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedProduct = 'Dehydrated Red Onion Flakes';
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Save live data to Firebase Realtime Database
      final success = await FirebaseService.submitContactInquiry(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        country: _countryController.text.trim(),
        product: _selectedProduct,
        message: _messageController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        _isSubmitted = true;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9), // Replacement for hypothetical secondaryLight
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Inquiry Saved to Firebase!',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thank you ${_nameController.text}! Your export inquiry for $_selectedProduct has been saved to Firebase Realtime Database.',
                style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Export Desk Hotline: +91 7284088737\nEmail: export@amarfoods.in',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _nameController.clear();
                _emailController.clear();
                _phoneController.clear();
                _countryController.clear();
                _messageController.clear();
                setState(() => _isSubmitted = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('OK Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double paddingV = LiquidUI.fluid(context, minVal: 40, maxVal: 80);
    final double headingSize = LiquidUI.fluid(context, minVal: 28, maxVal: 42);

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
                            text: 'EXPORT TRADE INQUIRIES & CONTACT',
                            icon: Icons.contact_mail_rounded,
                            backgroundColor: AppColors.secondary.withOpacity(0.2),
                            textColor: AppColors.secondary,
                            fontSize: 11,
                          ),
                          const SizedBox(height: 20),

                          LiquidUI.gradientText(
                            'Get in Touch With Us',
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
                            'Connect directly with our export management team in Mahuva, Gujarat for container quotes, custom mesh sizing, and trade inquiries.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.grey.shade300,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Contact Form & Info Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: paddingV),
              child: Center(
                child: Container(
                  constraints: LiquidUI.pageConstraints(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final infoColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Corporate Headquarters & Plant',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'We welcome trade partners and international buyers to visit our facility in Mahuva, India.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          _buildContactCard(
                            Icons.location_on_rounded,
                            'Factory & Office Address',
                            'Survey No. - 217, Savarkundla Rd,\nBhadara, Mahuva, Gujarat 364290',
                          ),
                          const SizedBox(height: 18),

                          _buildContactCard(
                            Icons.phone_in_talk_rounded,
                            'Phone & WhatsApp Export Hotline',
                            '+91 7284088737 (Export & Sales Desk)',
                          ),
                          const SizedBox(height: 18),

                          _buildContactCard(
                            Icons.mark_email_read_rounded,
                            'Official Trade Email',
                            'export@amarfoods.in\ninfo@amarfoods.in',
                          ),
                          const SizedBox(height: 18),

                          _buildContactCard(
                            Icons.access_time_filled_rounded,
                            'Factory Operating Hours',
                            'Monday – Saturday: 9:00 AM – 7:00 PM IST\nSunday: Closed (Inquiries via Email)',
                          ),
                        ],
                      );

                      final formColumn = LiquidUI.glassCard(
                        borderRadius: 24,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(isMobile ? 24 : 36),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Send Export Inquiry',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Fill in your specifications and destination port for an immediate FOB/CIF quote.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildTextField(
                                controller: _nameController,
                                label: 'Full Name / Company Name',
                                icon: Icons.person_outline_rounded,
                                validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                              ),
                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _emailController,
                                label: 'Corporate Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) => val == null || !val.contains('@') ? 'Please enter a valid email' : null,
                              ),
                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _phoneController,
                                label: 'Phone / WhatsApp Number',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (val) => val == null || val.isEmpty ? 'Please enter your phone number' : null,
                              ),
                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _countryController,
                                label: 'Destination Country & Port',
                                icon: Icons.public_rounded,
                                validator: (val) => val == null || val.isEmpty ? 'Please enter destination country' : null,
                              ),
                              const SizedBox(height: 16),

                              DropdownButtonFormField<String>(
                                value: _selectedProduct,
                                decoration: InputDecoration(
                                  labelText: 'Product Interest',
                                  prefixIcon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Dehydrated Red Onion Flakes', child: Text('Dehydrated Red Onion Flakes')),
                                  DropdownMenuItem(value: 'Dehydrated White Onion Powder', child: Text('Dehydrated White Onion Powder')),
                                  DropdownMenuItem(value: 'Pink Onion Minced & Granules', child: Text('Pink Onion Minced & Granules')),
                                  DropdownMenuItem(value: 'Dehydrated Garlic Flakes', child: Text('Dehydrated Garlic Flakes')),
                                  DropdownMenuItem(value: 'Dehydrated Garlic Powder', child: Text('Dehydrated Garlic Powder')),
                                  DropdownMenuItem(value: 'Dehydrated Garlic Minced', child: Text('Dehydrated Garlic Minced')),
                                  DropdownMenuItem(value: 'Custom Private Label Packaging', child: Text('Custom Private Label Packaging')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedProduct = val);
                                },
                              ),
                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _messageController,
                                label: 'Inquiry Details & Quantity (MT)',
                                icon: Icons.notes_rounded,
                                maxLines: 4,
                                validator: (val) => val == null || val.isEmpty ? 'Please enter your inquiry details' : null,
                              ),
                              const SizedBox(height: 28),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 4,
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Submit Export Inquiry',
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.send_rounded, size: 18),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (isMobile) {
                        return Column(
                          children: [
                            infoColumn,
                            const SizedBox(height: 48),
                            formColumn,
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: infoColumn),
                            const SizedBox(width: 48),
                            Expanded(flex: 6, child: formColumn),
                          ],
                        );
                      }
                    },
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

  Widget _buildContactCard(IconData icon, String title, String content) {
    return LiquidUI.glassCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      borderRadius: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// Backward Compatibility Class Alias
class QualityPage extends StatelessWidget {
  const QualityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContactPage();
  }
}
