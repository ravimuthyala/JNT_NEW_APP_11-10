import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'company_home_page.dart';
import 'shared/payment_method_section.dart';
import 'shared/payment_type.dart';

// You can keep kPink here or move it to a shared constants file
const Color kPink = Color(0xFFE91E63);

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // profile / logo
  File? _logoImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogoImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _logoImage = File(picked.path);
      });
    }
  }

  // Basic info
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Address
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  String? _selectedState;
  String? _selectedCountry;

  // Budget
  RangeValues _budgetRange = const RangeValues(100, 500);

  // Preferred payment methods

  final List<String> _usStates = const [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  final List<String> _countries = const [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Brazil',
    'Mexico',
    'Japan',
    'China',
  ];

// nail dimension controllers
  final List<TextEditingController> _leftHandControllers =
      List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> _rightHandControllers =
      List.generate(5, (_) => TextEditingController());

  // nail shape / length
  final List<String> _nailShapes = [
    'Square',
    'Round',
    'Oval',
    'Almond',
    'Stiletto',
    'Coffin',
    'Ballerina',
    'Squoval',
    'Mountain',
    'Lipstick',
    'Flare',
    'Edge',
    'Arrow',
    'Pipe',
    'Pointed',
    'Hexagon',
  ];
  final List<_NailLengthInfo> _nailLengths = const [
    _NailLengthInfo(
      name: 'Short',
      subtitle: 'Just Past Fingertip',
    ),
    _NailLengthInfo(
      name: 'Medium',
      subtitle: 'Classic Length',
    ),
    _NailLengthInfo(
      name: 'Long',
      subtitle: 'Extended Length',
    ),
    _NailLengthInfo(
      name: 'Extra Long',
      subtitle: 'Statement Length',
    ),
    _NailLengthInfo(
      name: 'Maximum',
      subtitle: 'Maximum Length',
    ),
  ];
  String? _selectedNailShape;
  String? _selectedNailLength;

  // payment method
  PaymentType _selectedPaymentType = PaymentType.creditCard;
  final List<String> _savedPaymentMethods = [];

    void _savePaymentMethod(String description) {
      setState(() {
        _savedPaymentMethods.add(description);
      });

      // 🔹 TODO: persist to your backend / database here
      // e.g. call your API / Firebase service

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment method saved')),
      );
}

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _bioController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    for (final c in _leftHandControllers) {
      c.dispose();
    }
    for (final c in _rightHandControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitCompanyProfile() {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  if (_selectedState == null || _selectedCountry == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select State and Country.')),
    );
    return;
  }

  // Get the company name (fallback if empty)
  final companyName = _companyNameController.text.trim().isEmpty
      ? 'Company'
      : _companyNameController.text.trim();

  // TODO: send data to your backend / DB here

  // Optional: quick confirmation (you can delete this if you want)
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Company profile created (simulated).')),
  );

  // 👉 Navigate to CompanyHomePage
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => CompanyHomePage(companyName: companyName),
    ),
  );
}


  // ---------- small UI helpers ----------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            children: requiredField
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: kPink),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: requiredField
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter $label',
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: kPink, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

    Widget _buildDropdown<T>({
    required String label,
    required bool requiredField,
    required T? value,
    required List<T>? items,        // <- note the ?
    required ValueChanged<T?> onChanged,
  }) {
    // 👇 avoid calling .map on null in Flutter web
    final List<T> safeItems = items ?? <T>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            children: requiredField
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: kPink),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: safeItems
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: requiredField
              ? (val) {
                  if (val == null) return 'This field is required';
                  return null;
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: kPink, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- sections ----------

  Widget _buildBasicInformationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Company Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fill in your details to create your company account',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 16),

          // logo / profile
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: _logoImage != null
                            ? Image.file(
                                _logoImage!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.apartment_rounded,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: InkWell(
                        onTap: _pickLogoImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: kPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.upload_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload Company Logo',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _buildTextField(
            label: 'Company Name',
            controller: _companyNameController,
            requiredField: true,
            hint: 'e.g. Glamour Nails Studio',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Primary Contact Name',
            controller: _contactNameController,
            requiredField: true,
            hint: 'Person we should contact for orders',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Contact Email',
            controller: _emailController,
            requiredField: true,
            keyboardType: TextInputType.emailAddress,
            hint: 'We’ll send notifications here',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Contact Phone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            hint: 'Optional phone number for urgent questions',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Website',
            controller: _websiteController,
            hint: 'Your salon or brand website (optional)',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Instagram',
            controller: _instagramController,
            hint: '@yourbusiness',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'TikTok',
            controller: _tiktokController,
            hint: '@yourbusiness',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'About your company',
            controller: _bioController,
            maxLines: 4,
            hint: 'Tell artists about your style, clientele, and services.',
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Business Address'),
        const SizedBox(height: 4),
        const Text(
          'This address will be used for shipping and invoices.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Street Address',
          controller: _streetController,
          requiredField: true,
          hint: 'Building, street, suite or unit number',
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'City',
          controller: _cityController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        _buildDropdown<String>(
          label: 'State',
          requiredField: true,
          value: _selectedState,
          items: _usStates,
          onChanged: (value) {
            setState(() => _selectedState = value);
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Zip Code',
          controller: _zipController,
          requiredField: true,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildDropdown<String>(
          label: 'Country',
          requiredField: true,
          value: _selectedCountry,
          items: _countries,
          onChanged: (value) {
            setState(() => _selectedCountry = value);
          },
        ),
      ],
    );
  }

  Widget _buildNailDimensionSection() {
    const fingerLabels = ['Thumb', 'Index', 'Middle', 'Ring', 'Pinky'];

    final leftHand = Map<String, TextEditingController>.fromIterables(
      fingerLabels,
      _leftHandControllers,
    );
    final rightHand = Map<String, TextEditingController>.fromIterables(
      fingerLabels,
      _rightHandControllers,
    );

    Widget nailRow(Map<String, TextEditingController> hand) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: hand.entries.map((entry) {
          final finger = entry.key;
          final controller = entry.value;
          return Expanded(
            child: Column(
              children: [
                Text(
                  finger,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0E8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kPink, width: 1.5),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0.0',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 13,
                      ),
                      suffixText: 'mm',
                      suffixStyle: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF666666),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Nail Dimension (in mm)'),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Left Hand',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 12),
        nailRow(leftHand),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Right Hand',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 12),
        nailRow(rightHand),
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildBudgetSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Set your typical budget range for custom nail designs.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_budgetRange.start.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                '\$${_budgetRange.end.toStringAsFixed(0)}+',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _budgetRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: kPink,
            labels: RangeLabels(
              '\$${_budgetRange.start.toStringAsFixed(0)}',
              '\$${_budgetRange.end.toStringAsFixed(0)}',
            ),
            onChanged: (values) {
              setState(() {
                _budgetRange = values;
              });
            },
          ),
        ],
      ),
    );
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // back arrow to previous page
        ),
        title: const Text(
          'Company Profile',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInformationSection(),
                const SizedBox(height: 20),
                _buildAddressSection(),
                const SizedBox(height: 24),
                _buildNailDimensionSection(),

                // 🔹 SIZE REFERENCE + MEASUREMENT TIPS
                const SizedBox(height: 24),
                Text(
                  'Size Reference',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: const [
                              Text(
                                'Small',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '8–12mm',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: const [
                              Text(
                                'Medium',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '12–16mm',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: const [
                              Text(
                                'Large',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '16–20mm',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFFFFF0F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.female, color: kPink),
                            SizedBox(width: 8),
                            Text(
                              'Measurement Tips',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text('• Measure at the widest part of your nail bed'),
                        Text('• Use the tape method for most accurate results'),
                        Text('• Round to the nearest 0.5mm'),
                        Text('• Each finger is different – measure all 10!'),
                        Text('• Left and right hands often have different sizes'),
                      ],
                    ),
                  ),
                ),

                // 🔹 CHOOSE NAIL SHAPE
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    text: 'Choose Your Nail Shape ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    children: const [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select from 16 available shapes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _nailShapes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final shapeName = _nailShapes[index];
                      final bool isSelected = _selectedNailShape == shapeName;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedNailShape = shapeName;
                          });
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: isSelected ? kPink.withOpacity(0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? kPink : const Color(0xFFE0E0E0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        color: kPink,
                                        width: 1.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                shapeName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? kPink : const Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                                // 🔹 CHOOSE NAIL LENGTH
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    text: 'Choose Your Nail Length ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    children: const [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick how long you like your nails to be',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _nailLengths.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = _nailLengths[index];
                      final bool isSelected = _selectedNailLength == item.name;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedNailLength = item.name;
                          });
                        },
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isSelected ? kPink : const Color(0xFFE0E0E0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 3 / 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: kPink,
                                          width: 1.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? kPink
                                      : const Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔹 BUDGET RANGE — now right after nail length
                const SizedBox(height: 24),
                _buildBudgetSection(),

                // 🔹 PAYMENT METHODS — SAME shared widget as Client page
                const SizedBox(height: 24),
                PaymentMethodSection(
                  selectedType: _selectedPaymentType,
                  onTypeChanged: (type) {
                    setState(() => _selectedPaymentType = type);
                  },
                  onSave: _savePaymentMethod,
                  savedMethods: _savedPaymentMethods,
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitCompanyProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Company Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NailLengthInfo {
  final String name;
  final String subtitle;
  const _NailLengthInfo({required this.name, required this.subtitle});
}
