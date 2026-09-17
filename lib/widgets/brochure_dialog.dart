import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../services/firebase_service.dart';
import '../services/location_service.dart';
import '../utils/liquid_ui.dart';

class BrochureDialog extends StatefulWidget {
  const BrochureDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const BrochureDialog(),
    );
  }

  @override
  State<BrochureDialog> createState() => _BrochureDialogState();
}

class _BrochureDialogState extends State<BrochureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCountry;

  List<CountryData> _countries = [];
  bool _isLoadingCountries = true;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  bool get _isFormValid {
    final name = _nameController.text.trim();
    final company = _companyController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final country = _selectedCountry?.trim() ?? '';

    return name.isNotEmpty &&
        company.isNotEmpty &&
        email.isNotEmpty &&
        email.contains('@') &&
        email.contains('.') &&
        phone.isNotEmpty &&
        phone.length >= 6 &&
        country.isNotEmpty;
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _companyController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _loadCountries();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _companyController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final list = await LocationService.instance.getCountriesAndStates();
    if (mounted) {
      setState(() {
        _countries = list;
        _isLoadingCountries = false;
        if (_selectedCountry == null) {
          final hasIndia = list.any((c) => c.name.toLowerCase() == 'india');
          if (hasIndia) {
            _selectedCountry = 'India';
          }
        }
      });
    }
  }

  static Future<void> _triggerPdfDownload() async {
    final Uri url = Uri.parse('/amar_foods_brochure.pdf');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCountry == null || _selectedCountry!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Country')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // 1. Save lead to database
    await FirebaseService.submitBrochureLead(
      fullName: _nameController.text.trim(),
      companyName: _companyController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      country: _selectedCountry!,
    );

    // 2. Trigger browser download immediately
    await _triggerPdfDownload();

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double dialogWidth = isMobile ? LiquidUI.width(context) * 0.94 : 520;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.25), width: 1.5),
      ),
      elevation: 24,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      child: Container(
        width: dialogWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 36,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 28),
                child: _isSubmitted ? _buildSuccessView(context) : _buildFormView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'OFFICIAL CATALOGUE',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Download Product Brochure',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Complete dehydrated onion & garlic technical specifications (PDF).',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  // ==================== FORM VIEW ====================
  Widget _buildFormView(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name
          _buildTextField(
            label: 'Full Name',
            controller: _nameController,
            hint: 'e.g. John Doe / Rajesh Patel',
            required: true,
            prefixIcon: Icons.person_outline_rounded,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: 14),

          // Company Name
          _buildTextField(
            label: 'Company Name',
            controller: _companyController,
            hint: 'e.g. Global Foods Trading LLC',
            required: true,
            prefixIcon: Icons.business_rounded,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Company name is required' : null,
          ),
          const SizedBox(height: 14),

          // Email & Mobile in Row (or stacked on mobile)
          _buildTextField(
            label: 'Business Email',
            controller: _emailController,
            hint: 'name@company.com',
            required: true,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@') || !v.contains('.')) return 'Enter valid email';
              return null;
            },
          ),
          const SizedBox(height: 14),

          _buildTextField(
            label: 'WhatsApp / Mobile Number',
            controller: _phoneController,
            hint: '+1 234 567 8900',
            required: true,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone number is required' : null,
          ),
          const SizedBox(height: 14),

          // Country Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Country',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              _isLoadingCountries
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 10),
                          Text('Loading countries...', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    )
                  : DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      hint: Text(
                        '-- Select Country --',
                        style: GoogleFonts.outfit(color: const Color(0xFFA0A5B1), fontSize: 13),
                      ),
                      isExpanded: true,
                      validator: (v) => v == null ? 'Country is required' : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFAFBFE),
                        prefixIcon: const Icon(Icons.public_rounded, size: 20, color: Color(0xFF7A808C)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
                        ),
                      ),
                      items: _countries.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.name,
                          child: Text(c.name, style: GoogleFonts.outfit(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCountry = val),
                    ),
            ],
          ),
          const SizedBox(height: 22),

          // Submit & Download Button
          Builder(
            builder: (context) {
              final bool canSubmit = _isFormValid && !_isSubmitting;
              return SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    gradient: canSubmit
                        ? const LinearGradient(
                            colors: [Color(0xFF009846), Color(0xFF006B31)],
                          )
                        : null,
                    color: canSubmit ? null : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: canSubmit
                        ? [
                            BoxShadow(
                              color: const Color(0xFF009846).withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: ElevatedButton(
                    onPressed: canSubmit ? _submitForm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      disabledForegroundColor: const Color(0xFF94A3B8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                              Icon(
                                canSubmit ? Icons.file_download_outlined : Icons.lock_outline_rounded,
                                size: 19,
                                color: canSubmit ? Colors.white : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                canSubmit ? 'Download Brochure PDF' : 'Fill All Details to Download',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                  color: canSubmit ? Colors.white : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              '🔒 Your information is confidential & strictly used for export quotes.',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SUCCESS VIEW ====================
  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 42),
        ),
        const SizedBox(height: 16),
        Text(
          'Your Download Has Started! 🎉',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Thank you for your interest in Amar Foods! If the download did not begin automatically, tap the button below.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _triggerPdfDownload,
              icon: const Icon(Icons.download_rounded, size: 16),
              label: Text('Re-download PDF', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final phone = _phoneController.text.trim();
                final name = _nameController.text.trim();
                final msg = Uri.encodeComponent(
                  'Hello Amar Foods, I am $name ($phone). I just downloaded your product brochure and would like to request live container pricing.',
                );
                final whatsappUrl = Uri.parse('https://wa.me/917284088737?text=$msg');
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.white),
              label: Text('Chat on WhatsApp', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = false,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.outfit(fontSize: 13.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(color: const Color(0xFFA0A5B1), fontSize: 13),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: const Color(0xFF7A808C)) : null,
            filled: true,
            fillColor: const Color(0xFFFAFBFE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
