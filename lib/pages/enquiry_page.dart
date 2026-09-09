import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../services/firebase_service.dart';
import '../services/location_service.dart';
import '../utils/liquid_ui.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/whatsapp_floating_button.dart';

class EnquiryPage extends StatefulWidget {
  const EnquiryPage({super.key});

  @override
  State<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  // Global Key for form validations
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();
  final _step5Key = GlobalKey<FormState>();

  // Step 1 Controllers
  final _fullNameController = TextEditingController();
  final _companyController = TextEditingController();
  String? _selectedRole;
  final _designationController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  final _customCityController = TextEditingController();

  // Location Data
  List<CountryData> _countries = [];
  List<String> _states = [];
  List<String> _cities = [];
  bool _isLoadingCountries = true;
  bool _isLoadingCities = false;

  // Step 2 Products
  String _selectedCategory = 'Dehydrated White Onion';
  final Set<String> _selectedProducts = {
    'Dehydrated White Onion Flakes / Kibbled (5-25mm)',
  };

  final Map<String, List<String>> _categoryProductsMap = {
    'Dehydrated White Onion': [
      'Dehydrated White Onion Flakes / Kibbled (5-25mm)',
      'Dehydrated White Onion Chopped (3-5mm)',
      'Dehydrated White Onion Minced (1-3mm)',
      'Dehydrated White Onion Granules (40-60 mesh)',
      'Dehydrated White Onion Powder (80-100 mesh)',
    ],
    'Dehydrated Red Onion': [
      'Dehydrated Red Onion Flakes / Kibbled (5-25mm)',
      'Dehydrated Red Onion Chopped (3-5mm)',
      'Dehydrated Red Onion Minced (1-3mm)',
      'Dehydrated Red Onion Granules (40-60 mesh)',
      'Dehydrated Red Onion Powder (80-100 mesh)',
    ],
    'Dehydrated Pink Onion': [
      'Dehydrated Pink Onion Flakes (5-25mm)',
      'Dehydrated Pink Onion Minced (1-3mm)',
      'Dehydrated Pink Onion Powder (80-100 mesh)',
    ],
    'Dehydrated Garlic': [
      'Dehydrated Garlic Flakes (8-10mm)',
      'Dehydrated Garlic Chopped (3-5mm)',
      'Dehydrated Garlic Minced (1-3mm)',
      'Dehydrated Garlic Granules (40-60 mesh)',
      'Dehydrated Garlic Powder (80-100 mesh)',
    ],
    'Spices & Agro Commodities': [
      'Turmeric Powder / Whole Finger',
      'Red Chilli Powder / Whole Stemless',
      'Coriander Seeds / Split Powder',
      'Cumin Seeds (Jeera Machine Cleaned)',
      'Fresh Indian Red Onion',
      'Fresh Indian White Onion',
    ],
  };

  // Step 3 Quantity & Shipping
  final _quantityController = TextEditingController();
  String _selectedUnit = 'Metric Tons (MT) - Bulk Orders';
  String _selectedShippingTerm = 'FOB (Free On Board - Mundra/Pipavav)';
  String? _destCountry;
  final _destPortController = TextEditingController();

  final List<String> _units = [
    'Metric Tons (MT) - Bulk Orders',
    'Kilograms (kg) - Sample / Trial Order',
    '20 ft Container FCL (~14 to 15 MT)',
    '40 ft Container FCL (~28 to 30 MT)',
  ];

  final List<String> _shippingTerms = [
    'FOB (Free On Board - Mundra/Pipavav)',
    'CIF (Cost, Insurance & Freight)',
    'CFR / CNF (Cost & Freight)',
    'EXW (Ex-Factory Mahuva)',
  ];

  // Step 4 Certificates
  final Set<String> _selectedCertificates = {};
  final _otherCertController = TextEditingController();

  final List<String> _certificateOptions = [
    'Certificate of Analysis (COA)',
    'Pesticide Residue Test Report',
    'Microbiological Test Report',
    'Heavy Metal Test Report',
    'US FDA Compliance Declaration',
    'Halal Certificate',
    'Kosher Certificate',
    'APEDA / Spices Board RCMC',
    'Third-Party Inspection (SGS / Bureau Veritas)',
    'Product Specification Sheet',
    'Shelf Life Declaration',
    'Traceability Report',
  ];

  // Step 5 Packaging
  bool _packagingRequired = true;
  String _selectedPackagingType = 'Standard 20/25 kg Poly-lined Multiwall Kraft Paper Bags';
  final _packagingDetailsController = TextEditingController();
  final _additionalMessageController = TextEditingController();
  String _preferredContactMethod = 'Email';
  bool _agreedToContact = false;

  final List<String> _packagingTypes = [
    'Standard 20/25 kg Poly-lined Multiwall Kraft Paper Bags',
    '50 kg PP / Jute Bags',
    'Heavy-duty 5-Ply Corrugated Cartons with blue poly-liner',
    'Small Retail Packs (500g / 1kg / 5kg)',
    'Vacuum Sealed Packaging',
    'Private Label / Custom Brand Printing',
    'As per Buyer Specification',
  ];

  // Submission State
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  String _referenceNumber = '';

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyController.dispose();
    _designationController.dispose();
    _mobileController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _customCityController.dispose();
    _quantityController.dispose();
    _destPortController.dispose();
    _otherCertController.dispose();
    _packagingDetailsController.dispose();
    _additionalMessageController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingCountries = true);
    final list = await LocationService.instance.getCountriesAndStates();
    if (mounted) {
      setState(() {
        _countries = list;
        _isLoadingCountries = false;
      });
    }
  }

  void _onCountryChanged(String? countryName) {
    setState(() {
      _selectedCountry = countryName;
      _selectedState = null;
      _selectedCity = null;
      _states = [];
      _cities = [];
    });

    if (countryName == null) return;
    final match = _countries.firstWhere(
      (c) => c.name == countryName,
      orElse: () => CountryData(name: '', states: []),
    );

    setState(() {
      _states = match.states;
    });
  }

  Future<void> _onStateChanged(String? stateName) async {
    setState(() {
      _selectedState = stateName;
      _selectedCity = null;
      _cities = [];
      _isLoadingCities = true;
    });

    if (_selectedCountry != null && stateName != null) {
      final fetchedCities = await LocationService.instance.getCities(_selectedCountry!, stateName);
      if (mounted) {
        setState(() {
          _cities = fetchedCities;
          _isLoadingCities = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoadingCities = false);
      }
    }
  }

  void _goToStep(int step) {
    if (step < 1 || step > _totalSteps) return;

    // Validate current step before proceeding forward
    if (step > _currentStep) {
      if (_currentStep == 1) {
        if (!_step1Key.currentState!.validate()) return;
        if (_selectedCountry == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select your Country')),
          );
          return;
        }
      } else if (_currentStep == 2) {
        if (_selectedProducts.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least one product cut/specification')),
          );
          return;
        }
      } else if (_currentStep == 3) {
        if (!_step3Key.currentState!.validate()) return;
        if (_destCountry == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a Destination Country')),
          );
          return;
        }
      }
    }

    setState(() {
      _currentStep = step;
    });
  }

  Future<void> _submitEnquiry() async {
    if (!_agreedToContact) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to be contacted to receive your quotation.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final finalCity = _selectedCity ?? _customCityController.text.trim();
    final randomSuffix = Random().nextInt(9000) + 1000;
    _referenceNumber = 'AF-ENQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-$randomSuffix';

    final success = await FirebaseService.submitFullEnquiry(
      fullName: _fullNameController.text.trim(),
      companyName: _companyController.text.trim(),
      roleType: _selectedRole ?? 'Other',
      designation: _designationController.text.trim(),
      mobile: _mobileController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      email: _emailController.text.trim(),
      country: _selectedCountry ?? '',
      state: _selectedState,
      city: finalCity,
      productCategory: _selectedCategory,
      products: _selectedProducts.toList(),
      quantity: _quantityController.text.trim(),
      unit: _selectedUnit,
      shippingTerm: _selectedShippingTerm,
      destCountry: _destCountry ?? '',
      destPort: _destPortController.text.trim(),
      certificates: _selectedCertificates.toList(),
      otherCertificate: _otherCertController.text.trim(),
      packagingRequired: _packagingRequired,
      packagingType: _packagingRequired ? _selectedPackagingType : 'None',
      packagingDetails: _packagingDetailsController.text.trim(),
      additionalMessage: _additionalMessageController.text.trim(),
      contactMethod: _preferredContactMethod,
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSubmitted = success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = LiquidUI.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: const WhatsAppFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            _buildHeroSection(isMobile),
            _isSubmitted
                ? _buildSuccessView(isMobile)
                : _buildWizardCard(isMobile),
            const SizedBox(height: 60),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ==================== HERO SECTION ====================
  Widget _buildHeroSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 36 : 54,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF071B36),
            Color(0xFF0F325E),
            Color(0xFF163E72),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.accentGold.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: AppColors.accentGold, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Direct Factory Quotation • Mahuva, Gujarat Origin',
                      style: GoogleFonts.outfit(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Request Export Quotation',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 28 : 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome importers, distributors & commercial buyers worldwide. Share your required onion & garlic cut specifications for transparent FOB/CIF pricing.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 14 : 16,
                  color: const Color(0xFFD6E4FF),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== WIZARD CONTAINER CARD ====================
  Widget _buildWizardCard(bool isMobile) {
    final double cardWidth = isMobile ? double.infinity : 1000;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 24,
        vertical: 30,
      ),
      child: Center(
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPipeProgressBar(isMobile),
              Padding(
                padding: EdgeInsets.all(isMobile ? 18 : 36),
                child: _buildCurrentStepPanel(isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== PIPE FILLING PROGRESS BAR ====================
  Widget _buildPipeProgressBar(bool isMobile) {
    final stepsInfo = [
      {'num': 1, 'label': 'Buyer Details'},
      {'num': 2, 'label': 'Products'},
      {'num': 3, 'label': 'Quantity & Ship'},
      {'num': 4, 'label': 'Certificates'},
      {'num': 5, 'label': 'Packaging'},
    ];

    final progressRatio = (_currentStep - 1) / (_totalSteps - 1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 20 : 28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFBFE),
        border: Border(bottom: BorderSide(color: Color(0xFFEAEBED))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Background Pipe Line
              Positioned(
                top: isMobile ? 16 : 22,
                left: 20,
                right: 20,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E4E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Active Filled Pipe Line
              Positioned(
                top: isMobile ? 16 : 22,
                left: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  height: 4,
                  width: max(0.0, (totalWidth - 40) * progressRatio),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Step Circles & Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: stepsInfo.map((info) {
                  final stepNum = info['num'] as int;
                  final label = info['label'] as String;
                  final isCompleted = stepNum < _currentStep;
                  final isActive = stepNum == _currentStep;

                  return InkWell(
                    onTap: () {
                      if (stepNum < _currentStep) {
                        _goToStep(stepNum);
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isMobile ? 32 : 46,
                          height: isMobile ? 32 : 46,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.secondary
                                : isActive
                                    ? AppColors.primary
                                    : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.secondary
                                  : isActive
                                      ? AppColors.primary
                                      : const Color(0xFFD0D3D9),
                              width: 2.5,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isCompleted
                                ? Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: isMobile ? 18 : 24,
                                  )
                                : Text(
                                    '$stepNum',
                                    style: GoogleFonts.outfit(
                                      color: isActive ? Colors.white : const Color(0xFF7A808C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 13 : 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: GoogleFonts.outfit(
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
                                ? AppColors.primary
                                : isCompleted
                                    ? AppColors.secondaryDark
                                    : const Color(0xFF7A808C),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== ACTIVE STEP PANEL ROUTER ====================
  Widget _buildCurrentStepPanel(bool isMobile) {
    switch (_currentStep) {
      case 1:
        return _buildStep1BuyerDetails(isMobile);
      case 2:
        return _buildStep2ProductDetails(isMobile);
      case 3:
        return _buildStep3QuantityShipping(isMobile);
      case 4:
        return _buildStep4Certificates(isMobile);
      case 5:
        return _buildStep5Packaging(isMobile);
      default:
        return const SizedBox();
    }
  }

  // ==================== STEP 1: BUYER DETAILS ====================
  Widget _buildStep1BuyerDetails(bool isMobile) {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            stepNumber: 1,
            title: 'Buyer / Contact Details',
            subtitle: 'Provide your company and procurement contact details for correspondence.',
          ),
          const SizedBox(height: 24),

          // Name & Company
          _buildResponsiveRow(
            isMobile,
            first: _buildTextField(
              label: 'Full Name',
              controller: _fullNameController,
              hint: 'e.g. John Doe / Rajesh Patel',
              required: true,
              prefixIcon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            second: _buildTextField(
              label: 'Company Name',
              controller: _companyController,
              hint: 'e.g. Global Foods Trading Ltd',
              required: true,
              prefixIcon: Icons.business_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter company name' : null,
            ),
          ),
          const SizedBox(height: 18),

          // Role Type & Designation
          _buildResponsiveRow(
            isMobile,
            first: _buildDropdownField<String>(
              label: 'Role Type',
              required: true,
              value: _selectedRole,
              hint: '-- Select Role --',
              items: const [
                'Decision Maker (Owner / Director / CEO)',
                'Purchase / Procurement (Buyer)',
                'Operations / Logistics Manager',
                'Import / Export Manager',
                'Quality / Technical Assurance',
                'Other',
              ],
              onChanged: (val) => setState(() => _selectedRole = val),
              validator: (v) => v == null ? 'Please select your role' : null,
            ),
            second: _buildTextField(
              label: 'Designation / Title',
              controller: _designationController,
              hint: 'e.g. Managing Director',
              prefixIcon: Icons.badge_outlined,
            ),
          ),
          const SizedBox(height: 18),

          // Mobile & WhatsApp
          _buildResponsiveRow(
            isMobile,
            first: _buildTextField(
              label: 'Mobile Number',
              controller: _mobileController,
              hint: '+1 234 567 8900',
              required: true,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Mobile number is required' : null,
            ),
            second: _buildTextField(
              label: 'WhatsApp Number',
              controller: _whatsappController,
              hint: '+1 234 567 8900 (Optional)',
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.chat_bubble_outline_rounded,
            ),
          ),
          const SizedBox(height: 18),

          // Email
          _buildTextField(
            label: 'Business Email Address',
            controller: _emailController,
            hint: 'john@globalfoods.com',
            required: true,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email address is required';
              if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 18),

          // Dynamic Country -> State -> City Dropdowns
          _buildCountryStateCityFields(isMobile),

          const SizedBox(height: 36),
          _buildNavButtons(
            onNext: () => _goToStep(2),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryStateCityFields(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Dropdown
        _isLoadingCountries
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('Loading global countries...'),
                  ],
                ),
              )
            : _buildDropdownField<String>(
                label: 'Country',
                required: true,
                value: _selectedCountry,
                hint: '-- Select Country --',
                items: _countries.map((c) => c.name).toList(),
                onChanged: _onCountryChanged,
                validator: (v) => v == null ? 'Please select your country' : null,
              ),
        const SizedBox(height: 18),

        // State & City
        _buildResponsiveRow(
          isMobile,
          first: _states.isEmpty
              ? _buildTextField(
                  label: 'State / Province',
                  controller: TextEditingController(text: _selectedState ?? ''),
                  hint: _selectedCountry == null ? 'Select country first' : 'Enter state/province',
                  onChanged: (val) => _selectedState = val,
                )
              : _buildDropdownField<String>(
                  label: 'State / Province',
                  value: _selectedState,
                  hint: '-- Select State --',
                  items: _states,
                  onChanged: _onStateChanged,
                ),
          second: _isLoadingCities
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Loading cities...'),
                    ],
                  ),
                )
              : _cities.isNotEmpty
                  ? _buildDropdownField<String>(
                      label: 'City',
                      value: _selectedCity,
                      hint: '-- Select City --',
                      items: _cities,
                      onChanged: (val) => setState(() => _selectedCity = val),
                    )
                  : _buildTextField(
                      label: 'City',
                      controller: _customCityController,
                      hint: 'Enter your city',
                      prefixIcon: Icons.location_city_rounded,
                    ),
        ),
      ],
    );
  }

  // ==================== STEP 2: PRODUCT DETAILS ====================
  Widget _buildStep2ProductDetails(bool isMobile) {
    final availableProducts = _categoryProductsMap[_selectedCategory] ?? [];

    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            stepNumber: 2,
            title: 'Product / Order Details',
            subtitle: 'Select your target dehydrated product category and required cut/mesh specifications.',
          ),
          const SizedBox(height: 24),

          // Category Dropdown
          _buildDropdownField<String>(
            label: 'Product Category',
            required: true,
            value: _selectedCategory,
            hint: '-- Select Category --',
            items: _categoryProductsMap.keys.toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedCategory = val;
                  _selectedProducts.clear();
                  final first = _categoryProductsMap[val]?.first;
                  if (first != null) _selectedProducts.add(first);
                });
              }
            },
          ),
          const SizedBox(height: 24),

          // Product Checklist
          Text(
            'Select Cut Sizes / Specifications *',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFBFE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableProducts.map((p) {
                final isChecked = _selectedProducts.contains(p);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        _selectedProducts.remove(p);
                      } else {
                        _selectedProducts.add(p);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isChecked ? AppColors.primary.withOpacity(0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isChecked ? AppColors.primary : AppColors.border,
                        width: isChecked ? 1.6 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          color: isChecked ? AppColors.primary : const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            p,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
                              color: isChecked ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 36),
          _buildNavButtons(
            onBack: () => _goToStep(1),
            onNext: () => _goToStep(3),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 3: QUANTITY & SHIPPING ====================
  Widget _buildStep3QuantityShipping(bool isMobile) {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            stepNumber: 3,
            title: 'Quantity & Shipping Logistics',
            subtitle: 'Specify commercial order volume, desired incoterms, and destination port.',
          ),
          const SizedBox(height: 24),

          _buildResponsiveRow(
            isMobile,
            first: _buildTextField(
              label: 'Required Quantity',
              controller: _quantityController,
              hint: 'e.g. 15, 30, 100',
              required: true,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.scale_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter quantity' : null,
            ),
            second: _buildDropdownField<String>(
              label: 'Unit of Measure',
              required: true,
              value: _selectedUnit,
              items: _units,
              onChanged: (val) => setState(() => _selectedUnit = val!),
            ),
          ),
          const SizedBox(height: 18),

          _buildDropdownField<String>(
            label: 'Shipping Term (Incoterms)',
            required: true,
            value: _selectedShippingTerm,
            items: _shippingTerms,
            onChanged: (val) => setState(() => _selectedShippingTerm = val!),
          ),
          const SizedBox(height: 18),

          _buildResponsiveRow(
            isMobile,
            first: _buildDropdownField<String>(
              label: 'Destination Country',
              required: true,
              value: _destCountry,
              hint: '-- Select Destination Country --',
              items: _countries.map((c) => c.name).toList(),
              onChanged: (val) => setState(() => _destCountry = val),
              validator: (v) => v == null ? 'Select destination country' : null,
            ),
            second: _buildTextField(
              label: 'Destination Port',
              controller: _destPortController,
              hint: 'e.g. Jebel Ali, Rotterdam, New York',
              required: true,
              prefixIcon: Icons.anchor_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Destination port is required' : null,
            ),
          ),

          const SizedBox(height: 36),
          _buildNavButtons(
            onBack: () => _goToStep(2),
            onNext: () => _goToStep(4),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 4: CERTIFICATES ====================
  Widget _buildStep4Certificates(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          stepNumber: 4,
          title: 'Certificate Requirements',
          subtitle: 'Select any specific laboratory reports or customs clearance certifications needed.',
        ),
        const SizedBox(height: 24),

        // Standard Included Export Documents Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF071B36),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user_rounded, color: AppColors.accentGold, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standard Export Documents Included',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Every export shipment from Amar Foods includes: Phytosanitary Certificate, Fumigation Certificate, Certificate of Origin (COO), Commercial Invoice, Packing List, and Bill of Lading.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: const Color(0xFFE2EDFF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Additional Certifications / Quality Reports',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _certificateOptions.map((cert) {
            final isChecked = _selectedCertificates.contains(cert);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isChecked) {
                    _selectedCertificates.remove(cert);
                  } else {
                    _selectedCertificates.add(cert);
                  }
                });
              },
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.secondary.withOpacity(0.09) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isChecked ? AppColors.secondary : AppColors.border,
                    width: isChecked ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: isChecked ? AppColors.secondary : const Color(0xFF9E9E9E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cert,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
                        color: isChecked ? AppColors.secondaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        _buildTextField(
          label: 'Other Certificate Requirements',
          controller: _otherCertController,
          hint: 'Specify any other inspection agency or customs documentation required...',
          prefixIcon: Icons.note_add_outlined,
        ),

        const SizedBox(height: 36),
        _buildNavButtons(
          onBack: () => _goToStep(3),
          onNext: () => _goToStep(5),
        ),
      ],
    );
  }

  // ==================== STEP 5: PACKAGING & SUBMIT ====================
  Widget _buildStep5Packaging(bool isMobile) {
    return Form(
      key: _step5Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            stepNumber: 5,
            title: 'Packaging & Final Submission',
            subtitle: 'Choose packaging specifications and confirm your quote request.',
          ),
          const SizedBox(height: 24),

          // Packaging Required Radio
          Text(
            'Special Packaging Required? *',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: () => setState(() => _packagingRequired = true),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _packagingRequired ? AppColors.primary.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _packagingRequired ? AppColors.primary : AppColors.border,
                      width: _packagingRequired ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _packagingRequired ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: _packagingRequired ? AppColors.primary : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text('Yes', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              InkWell(
                onTap: () => setState(() => _packagingRequired = false),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: !_packagingRequired ? AppColors.primary.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: !_packagingRequired ? AppColors.primary : AppColors.border,
                      width: !_packagingRequired ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        !_packagingRequired ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: !_packagingRequired ? AppColors.primary : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text('No / Standard Export', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          if (_packagingRequired) ...[
            _buildDropdownField<String>(
              label: 'Packaging Type',
              value: _selectedPackagingType,
              items: _packagingTypes,
              onChanged: (val) => setState(() => _selectedPackagingType = val!),
            ),
            const SizedBox(height: 18),
            _buildTextField(
              label: 'Additional Packaging Instructions',
              controller: _packagingDetailsController,
              hint: 'e.g. Inner blue polyethylene liner, wooden pallets, custom shrink-wrap...',
              maxLines: 2,
            ),
            const SizedBox(height: 18),
          ],

          _buildTextField(
            label: 'Additional Order Instructions / Notes',
            controller: _additionalMessageController,
            hint: 'Any specific target price, delivery schedule, quality tolerances, or inquiry notes...',
            maxLines: 3,
          ),
          const SizedBox(height: 18),

          _buildDropdownField<String>(
            label: 'Preferred Contact Method',
            value: _preferredContactMethod,
            items: const ['Email', 'WhatsApp', 'Direct Phone Call'],
            onChanged: (val) => setState(() => _preferredContactMethod = val!),
          ),
          const SizedBox(height: 22),

          // Consent checkbox
          InkWell(
            onTap: () => setState(() => _agreedToContact = !_agreedToContact),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _agreedToContact ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: _agreedToContact ? AppColors.secondary : Colors.grey,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'I confirm this enquiry and agree to receive formal price quotations and product specifications from Amar Foods export department.',
                    style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),
          _buildNavButtons(
            onBack: () => _goToStep(4),
            onSubmit: _submitEnquiry,
            isSubmitting: _isSubmitting,
          ),
        ],
      ),
    );
  }

  // ==================== SUCCESS CONFIRMATION VIEW ====================
  Widget _buildSuccessView(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 40),
      child: Center(
        child: Container(
          width: isMobile ? double.infinity : 680,
          padding: EdgeInsets.all(isMobile ? 24 : 44),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.12),
                blurRadius: 36,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'Enquiry Received Successfully!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Reference No: $_referenceNumber',
                  style: GoogleFonts.spaceMono(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Thank you for your interest in Amar Foods. Our export team has received your detailed specifications and will prepare a formal FOB / CIF quotation for your destination port within 24 hours.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Return to Home', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isSubmitted = false;
                        _currentStep = 1;
                        _fullNameController.clear();
                        _companyController.clear();
                        _mobileController.clear();
                        _emailController.clear();
                        _quantityController.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Submit Another Enquiry', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== REUSABLE UI BUILDERS ====================
  Widget _buildStepHeader({required int stepNumber, required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Step $stepNumber of $_totalSteps',
            style: GoogleFonts.outfit(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? hint,
    bool required = false,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.outfit(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(color: const Color(0xFFA0A5B1), fontSize: 13),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: const Color(0xFF7A808C)) : null,
            filled: true,
            fillColor: const Color(0xFFFAFBFE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildDropdownField<T>({
    required String label,
    bool required = false,
    required T? value,
    String? hint,
    required List<T> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
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
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          hint: hint != null ? Text(hint, style: GoogleFonts.outfit(color: const Color(0xFFA0A5B1), fontSize: 13)) : null,
          isExpanded: true,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFBFE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString(),
                style: GoogleFonts.outfit(fontSize: 13.5),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildResponsiveRow(bool isMobile, {required Widget first, required Widget second}) {
    if (isMobile) {
      return Column(
        children: [
          first,
          const SizedBox(height: 18),
          second,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 20),
        Expanded(child: second),
      ],
    );
  }

  Widget _buildNavButtons({
    VoidCallback? onBack,
    VoidCallback? onNext,
    VoidCallback? onSubmit,
    bool isSubmitting = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEF2), width: 1.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (onBack != null)
            OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4A5060),
                side: const BorderSide(color: Color(0xFFD0D5DD), width: 1.5),
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF4A5060)),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF4A5060),
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(),
          if (onNext != null)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next Step',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          else if (onSubmit != null)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF009846), Color(0xFF006B31)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF009846).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Submit Enquiry',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 0.4,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send_rounded, size: 15, color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
