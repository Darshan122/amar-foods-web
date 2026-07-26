import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../utils/liquid_ui.dart';

class QuoteDialog extends StatefulWidget {
  const QuoteDialog({super.key});

  @override
  State<QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedProduct = 'Dehydrated Red Onion Flakes';
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  final List<String> _products = const [
    'Dehydrated Red Onion Flakes',
    'Dehydrated White Onion Powder',
    'Pink Onion Minced & Granules',
    'Dehydrated Garlic Flakes',
    'Dehydrated Garlic Powder',
    'Dehydrated Garlic Minced',
    'Custom Private Label Packaging',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _isSubmitted = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);
    final double dialogWidth = isMobile ? LiquidUI.width(context) * 0.94 : 580;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
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
              color: AppColors.primaryGlow.withOpacity(0.25),
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
              // Premium Dark Header Bar with Logo Plum Background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded, color: AppColors.secondaryLight, size: 12),
                                const SizedBox(width: 6),
                                Text(
                                  'DIRECT EXPORT INQUIRY',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Request Export Quotation',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Receive immediate FOB/CIF pricing & technical COA specs from Mahuva, India.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Sleek Close Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                    ),
                  ],
                ),
              ),

              // Modal Form Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isSubmitted ? _buildSuccessState(context) : _buildFormState(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          TextFormField(
            controller: _nameController,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: _buildInputDecoration(
              label: 'Full Name / Company Name *',
              icon: Icons.person_outline_rounded,
            ),
            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your name or company' : null,
          ),
          const SizedBox(height: 14),

          // Email & Phone Dual Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 420) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        style: GoogleFonts.inter(fontSize: 14),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          label: 'Corporate Email *',
                          icon: Icons.email_outlined,
                        ),
                        validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        style: GoogleFonts.inter(fontSize: 14),
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          label: 'Phone / WhatsApp *',
                          icon: Icons.phone_outlined,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: GoogleFonts.inter(fontSize: 14),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        label: 'Corporate Email *',
                        icon: Icons.email_outlined,
                      ),
                      validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneController,
                      style: GoogleFonts.inter(fontSize: 14),
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration(
                        label: 'Phone / WhatsApp Number *',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter phone' : null,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 14),

          // Destination Country & Port Field
          TextFormField(
            controller: _countryController,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: _buildInputDecoration(
              label: 'Destination Country & Seaport *',
              icon: Icons.public_rounded,
            ),
            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter destination country and port' : null,
          ),
          const SizedBox(height: 14),

          // Product Interest Dropdown
          DropdownButtonFormField<String>(
            value: _selectedProduct,
            decoration: _buildInputDecoration(
              label: 'Product of Interest',
              icon: Icons.shopping_bag_outlined,
            ),
            items: _products.map((String product) {
              return DropdownMenuItem<String>(
                value: product,
                child: Text(
                  product,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textPrimary),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedProduct = val);
            },
          ),
          const SizedBox(height: 14),

          // Message & Specs Field
          TextFormField(
            controller: _messageController,
            style: GoogleFonts.inter(fontSize: 14),
            maxLines: 3,
            decoration: _buildInputDecoration(
              label: 'Message / Required Quantity (Metric Tons)',
              icon: Icons.notes_rounded,
            ).copyWith(alignLabelWithHint: true),
          ),
          const SizedBox(height: 24),

          // Action Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 4,
                  shadowColor: AppColors.secondaryGlow,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.send_rounded, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Submit Request',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      fillColor: const Color(0xFFFAFAFD),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context) {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.secondaryLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary.withOpacity(0.4), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryGlow.withOpacity(0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.secondary,
            size: 64,
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Inquiry Submitted Successfully!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        Text(
          'Thank you, ${_nameController.text.trim()}. Your inquiry regarding $_selectedProduct has been dispatched to our export desk. Our team will contact you within 24 hours with complete FOB/CIF pricing.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 4,
          ),
          child: Text(
            'Done',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
