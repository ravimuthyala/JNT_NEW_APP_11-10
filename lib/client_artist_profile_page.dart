import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jnt_app/app_theme.dart';

// If you moved PaymentType & kPink into shared files:
import 'shared/payment_type.dart';     // enum PaymentType { applePay, ... }
import 'form_helpers.dart';
import 'constants/location_constants.dart';
import 'constants/nail_constants.dart';
import 'payment_helpers.dart';

// If you didn’t make app_theme.dart and payment_type.dart yet,
// you can temporarily just define kPink & PaymentType here
// (but shared files are cleaner).

class ClientArtistProfilePage extends StatefulWidget {
  const ClientArtistProfilePage({super.key});

  @override
  State<ClientArtistProfilePage> createState() =>
      _ClientArtistProfilePageState();
}

class _ClientArtistProfilePageState extends State<ClientArtistProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // List to store saved payment methods
  final List<String> _savedPaymentMethods = [];

  // 1) BASIC INFO CONTROLLERS (reuse Artist's set)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // 2) ADDRESS CONTROLLERS (reuse Client’s pattern)
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  String? _selectedState;
  String? _selectedCountry;
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
// ─── Address selection ─────────────────────────────

// ─── Nail dimension controllers (copy from client page if not already) ───
final Map<String, TextEditingController> _leftHand = {
  'Thumb': TextEditingController(),
  'Index': TextEditingController(),
  'Middle': TextEditingController(),
  'Ring': TextEditingController(),
  'Pinky': TextEditingController(),
};

final Map<String, TextEditingController> _rightHand = {
  'Thumb': TextEditingController(),
  'Index': TextEditingController(),
  'Middle': TextEditingController(),
  'Ring': TextEditingController(),
  'Pinky': TextEditingController(),
};

// ─── Nail shape & length selection ────────────────
String? _selectedNailShape;
String? _selectedNailLength;

// ─── Certification fields ─────────────────────────
bool _registeredNailTech = true;

final TextEditingController _licenseNumberController =
    TextEditingController();
final TextEditingController _jurisdictionController =
    TextEditingController();

// If you use image_picker:
XFile? _previousProjectRegistered;
XFile? _previousProjectStudent;

// ─── Budget range ─────────────────────────────────
RangeValues _budgetRange = const RangeValues(50, 200);

// ─── Experience level ─────────────────────────────
double _experienceLevel = 0.5; // 0 = beginner, 1 = advanced

// ─── Payment preference for "How you would like to be paid" ─────────────

// ─── Payment method section (client-style) ──────────────────────────────
PaymentType _selectedPaymentType = PaymentType.creditCard;

// (If you have text controllers for card number, name, etc, declare them here too)
final TextEditingController _cardNumberController = TextEditingController();
final TextEditingController _cardNameController = TextEditingController();
final TextEditingController _cardExpiryController = TextEditingController();
final TextEditingController _cardCvvController = TextEditingController();

final TextEditingController _paypalEmailController = TextEditingController();
final TextEditingController _venmoHandleController = TextEditingController();

final TextEditingController _applePayEmailController = TextEditingController();
  // 3) NAIL SIZING, SHAPE, LENGTH (from Client page)
  // 4) PROFESSIONAL CERTIFICATION, BUDGET, EXPERIENCE, PAYMENT PREF, PAYMENT METHOD (from Artist page)
  // 5) NAIL MATERIAL BUNDLES (from Artist page)

  // Profile picture
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    // dispose all controllers you create in this page
    _nameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _bioController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _paypalEmailController.dispose();
    _venmoHandleController.dispose();
    _applePayEmailController.dispose(); 
   // plus any others you add (payment, certification, etc.)

    super.dispose();
  }
  Future<void> _pickPreviousProjectForRegistered() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _previousProjectRegistered = picked;
      });
    }
  }
  void _savePaymentMethod() {
    final description = _paymentTypeLabel(_selectedPaymentType);

    setState(() {
      _savedPaymentMethods.add(description);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment method saved: $description')),
    );
  }

  String _paymentTypeLabel(PaymentType type) {
    switch (type) {
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.venmo:
        return 'Venmo';
    }
  }

  Future<void> _pickPreviousProjectForStudent() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _previousProjectStudent = picked;
      });
    }
  }
  Future<void> _saveCertificationToDb() async {
    // TODO: replace with your real API / Firestore call
    // For now just show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certification details saved (simulated).'),
      ),
    );
  }

  Future<void> _pickProfilePicture() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }
void _submitCombinedProfile() {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  // Example: if you also track state/country here
  if (_selectedState == null || _selectedCountry == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select State and Country.'),
      ),
    );
    return;
  }

  // ✅ Require all nail dimensions
  final bool leftComplete =
      _leftHand.values.every((c) => c.text.trim().isNotEmpty);
  final bool rightComplete =
      _rightHand.values.every((c) => c.text.trim().isNotEmpty);

  if (!leftComplete || !rightComplete) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter nail dimensions for all 10 fingers.'),
      ),
    );
    return;
  }

  // ✅ Require nail shape
  if (_selectedNailShape == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a nail shape.'),
      ),
    );
    return;
  }

  // ✅ Require nail length
  if (_selectedNailLength == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a nail length.'),
      ),
    );
    return;
  }

  // ✅ All good – save to DB or simulate
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Client/Artist profile saved (simulated).'),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client & Artist Profile',
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
                // 👉 1. Basic information (Artist style)
                _buildBasicInformationSection(),

                const SizedBox(height: 20),

                // 👉 2. Address information (same as client)
                _buildAddressSection(),

                const SizedBox(height: 20),

                // 👉 3. Client sections (nail dimensions, sizing kit, etc.)
                _buildClientSections(),

                const SizedBox(height: 20),

                // 👉 4. Artist sections (certification, budget, experience, payment prefs)
                _buildArtistSections(),

                const SizedBox(height: 20),

                // 👉 5. Payment Method (one shared section)
                _buildPaymentMethodSection(),

                const SizedBox(height: 20),

                // 👉 6. Nail material bundles
                _buildProductBundlesSection(),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitCombinedProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Client & Artist Profile',
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

  // You’ll implement the methods below by copying/adapting from existing pages:
  // _buildBasicInformationSection
  Widget _buildBasicInformationSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF5FA),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Fill in your details to create your client account',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 16),

        // Profile picture block like the screenshot
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Circular placeholder (dotted-like border)
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
                      child: _profileImage != null
                          ? Image.file(
                              _profileImage!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.photo_camera_outlined,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                    ),
                  ),
                  // Pink upload FAB
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: _pickProfilePicture,
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
                'Upload Profile Picture',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        buildLabeledTextField(
          label: 'Name',
          controller: _nameController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        buildLabeledTextField(
          label: 'Email',
          controller: _emailController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        buildLabeledTextField(
          label: 'Instagram',
          controller: _instagramController,
        ),
        const SizedBox(height: 12),
        buildLabeledTextField(
          label: 'TikTok',
          controller: _tiktokController,
        ),
        const SizedBox(height: 12),
        buildLabeledTextField(
          label: 'Bio',
          controller: _bioController,
          maxLines: 4,
        ),
      ],
    ),
  );
  }
  // Address section (same as client)
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        buildLabeledTextField(
          label: 'Street Address',
          controller: _streetController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        buildLabeledTextField(
          label: 'City',
          controller: _cityController,
          requiredField: true,
        ),
        const SizedBox(height: 12),
        buildLabeledDropdown<String>(
          label: 'State',
          requiredField: true,
          value: _selectedState,
          items: usStates,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
            });
          },
        ),
        const SizedBox(height: 12),
        buildLabeledTextField(
          label: 'Zip Code',
          controller: _zipController,
          requiredField: true,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        buildLabeledDropdown<String>(
          label: 'Country',
          requiredField: true,
          value: _selectedCountry,
          items: _countries,
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
          },
        ),
      ],
    );
  }
    Widget _buildNailDimensionSection() {
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
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
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
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
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
      children: <Widget>[
        buildSectionTitle('Nail Dimension (in mm)'),
        Text.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: kPink),
            ),
          ],
        ),
      ),
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
        nailRow(_leftHand),
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
        nailRow(_rightHand),
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildSizeReferenceSection() {
    Widget sizeCard(String label, String range) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                range,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const Text(
          'Size Reference',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            sizeCard('Small', '8–12mm'),
            const SizedBox(width: 10),
            sizeCard('Medium', '12–16mm'),
            const SizedBox(width: 10),
            sizeCard('Large', '16–20mm'),
          ],
        ),
      ],
    );
  }

  Widget _buildMeasurementTipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                color: kPink,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Measurement Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '• Measure at the widest part of your nail bed',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Use the tape method for most accurate results',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Round the nearest 0.5mm',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Each figure is different - measure all 10!',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
          SizedBox(height: 6),
          Text(
            '• Left and right hands often have different sizes',
            style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
  Widget _buildNailShapeCard(String shapeName) {
    final bool isSelected = _selectedNailShape == shapeName;

    // We visually distinguish shapes by slightly varying the border radius/size
    BorderRadius radius;
    switch (shapeName) {
      case 'Square':
        radius = BorderRadius.circular(4);
        break;
      case 'Round':
        radius = BorderRadius.circular(30);
        break;
      case 'Oval':
        radius = BorderRadius.circular(40);
        break;
      case 'Almond':
        radius = BorderRadius.circular(32);
        break;
      case 'Stiletto':
      case 'Arrow':
      case 'Pointed':
        radius = const BorderRadius.vertical(
          top: Radius.circular(40),
          bottom: Radius.circular(8),
        );
        break;
      case 'Coffin':
      case 'Ballerina':
        radius = BorderRadius.circular(12);
        break;
      case 'Squoval':
        radius = BorderRadius.circular(20);
        break;
      case 'Mountain Peak':
        radius = const BorderRadius.vertical(
          top: Radius.circular(38),
          bottom: Radius.circular(10),
        );
        break;
      case 'Lipstick':
        radius = BorderRadius.circular(18);
        break;
      case 'Flare':
        radius = BorderRadius.circular(24);
        break;
      case 'Edge':
      case 'Pipe':
        radius = BorderRadius.circular(16);
        break;
      case 'Hexagon':
        radius = BorderRadius.circular(10);
        break;
      default:
        radius = BorderRadius.circular(20);
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNailShape = shapeName;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPink : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0EC),
                borderRadius: radius,
                border: Border.all(color: kPink, width: 1.2),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              shapeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildNailShapeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
            text: 'Choose Your Nail Shape',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: kPink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select from 16 available shapes',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: nailShapes.length,
            itemBuilder: (context, index) {
              final shapeName = nailShapes[index];
              return _buildNailShapeCard(shapeName);
            }
          ),
        ),
      ],
    );
  }

    Widget _buildNailLengthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
          text: 'Choose Your Nail Length',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: kPink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pick how long you like your nails to be',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: nailLengths.length,
            itemBuilder: (context, index) {
              final item = nailLengths[index];
              return _buildNailLengthCard(
                item['name']!,
                item['subtitle']!,
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildNailLengthCard(String name, String subtitle) {
    final bool isSelected = _selectedNailLength == name;

    // A simple visual: bigger height when length is longer
    double height;
    switch (name) {
      case 'Short':
        height = 40;
        break;
      case 'Medium':
        height = 55;
        break;
      case 'Long':
        height = 70;
        break;
      case 'Extra Long':
        height = 85;
        break;
      case 'XL Long':
        height = 100;
        break;
      default:
        height = 55;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNailLength = name;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPink : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Length visual
            Container(
              width: 32,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0EC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPink, width: 1.2),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF777777),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProfessionalCertificationSection() {
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
            'Professional Certification',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Let clients know if you\'re licensed or currently a student.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 12),

          // Radio buttons
          RadioListTile<bool>(
            value: true,
            groupValue: _registeredNailTech,
            activeColor: kPink,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Registered Nail Technician',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (val) {
              setState(() {
                _registeredNailTech = true;
              });
            },
          ),
          RadioListTile<bool>(
            value: false,
            groupValue: _registeredNailTech,
            activeColor: kPink,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Student or Unlicensed Nail Technician',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (val) {
              setState(() {
                _registeredNailTech = false;
              });
            },
          ),

          const SizedBox(height: 8),

          if (_registeredNailTech) ...[
            buildLabeledTextField(
              label: 'License Number',
              controller: _licenseNumberController,
              requiredField: true,
            ),
            const SizedBox(height: 12),
            buildLabeledTextField(
              label: 'Jurisdiction',
              controller: _jurisdictionController,
              requiredField: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _previousProjectRegistered != null
                        ? 'Previous project: ${_previousProjectRegistered!.name}'
                        : 'Previous project (required)',
                    style: TextStyle(
                      fontSize: 12,
                      color: _previousProjectRegistered != null
                          ? const Color(0xFF333333)
                          : const Color(0xFF777777),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _pickPreviousProjectForRegistered,
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: const Text('Upload'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_licenseNumberController.text.trim().isEmpty ||
                      _jurisdictionController.text.trim().isEmpty ||
                      _previousProjectRegistered == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill License, Jurisdiction and upload a previous project.',
                        ),
                      ),
                    );
                    return;
                  }
                  _saveCertificationToDb();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    _previousProjectStudent != null
                        ? 'Previous project: ${_previousProjectStudent!.name}'
                        : 'Previous project (if applicable)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _pickPreviousProjectForStudent,
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: const Text('Upload'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCertificationToDb,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Budget Range section
  Widget _buildBudgetRangeSection() {
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
            'Set your preferred budget range for nail designs.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_budgetRange.start.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${_budgetRange.end.toStringAsFixed(0)}+',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _budgetRange,
            min: 0,
            max: 500,
            divisions: 50,
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

  // Level of Experience section
  Widget _buildExperienceSection() {
    String label;
    if (_experienceLevel < 0.33) {
      label = 'Beginner';
    } else if (_experienceLevel < 0.66) {
      label = 'Intermediate';
    } else {
      label = 'Advanced';
    }

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
            'Level of Experience',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Slide to indicate your experience from beginner to advanced.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Beginner',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'Advanced',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Slider(
            value: _experienceLevel,
            onChanged: (value) {
              setState(() {
                _experienceLevel = value;
              });
            },
            min: 0,
            max: 1,
            activeColor: kPink,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Payment preference (ACH / Venmo)
  Widget _buildSizingKitSectionWithContext(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/nail_sizing_kit.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Nail Sizing Kit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Get a reusable sizing kit to measure each nail accurately at home.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$3.00',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kPink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // mock cart action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added Nail Sizing Kit to cart (simulated).'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
// Product bundles section
  Widget _buildProductBundlesSection() {
    Widget bundleCard({
      required String title,
      required String priceLabel,
      required String assetPath,
    }) {
      return Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                assetPath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                priceLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: kPink,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: hook to real cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $title to cart (simulated).'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nail Material Bundles',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Starter bundles for gel, tips, tools and more.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              bundleCard(
                title: 'Starter Material Bundle',
                priceLabel: '\$50',
                assetPath: 'assets/images/nail_bundle_50.png',
              ),
              bundleCard(
                title: 'Pro Material Bundle',
                priceLabel: '\$100',
                assetPath: 'assets/images/nail_bundle_100.png',
              ),
              bundleCard(
                title: 'Studio Material Bundle',
                priceLabel: '\$150',
                assetPath: 'assets/images/nail_bundle_150.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
    Widget _buildFieldsForSelectedPaymentType() {
    switch (_selectedPaymentType) {
      case PaymentType.creditCard:
        return Column(
          children: [
            buildLabeledTextField(
              label: 'Name on Card',
              controller: _cardNameController,
              requiredField: true,
            ),
            const SizedBox(height: 12),
            buildLabeledTextField(
              label: 'Card Number',
              controller: _cardNumberController,
              requiredField: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: buildLabeledTextField(
                    label: 'Expiry (MM/YY)',
                    controller: _cardExpiryController,
                    requiredField: true,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildLabeledTextField(
                    label: 'CVV',
                    controller: _cardCvvController,
                    requiredField: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        );

      case PaymentType.applePay:
        return buildLabeledTextField(
          label: 'Apple Pay Email',
          controller: _applePayEmailController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
        );

      case PaymentType.paypal:
        return buildLabeledTextField(
          label: 'PayPal Email',
          controller: _paypalEmailController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
        );

      case PaymentType.venmo:
        return buildLabeledTextField(
          label: 'Venmo Handle',
          controller: _venmoHandleController,
          requiredField: true,
        );
    }
  }

    Widget _buildSavedPaymentMethodsList() {
    if (_savedPaymentMethods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'No payment methods saved yet.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF777777),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Text(
            'Saved payment methods',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        ..._savedPaymentMethods.map(
          (method) => Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              leading: const Icon(Icons.payment),
              title: Text(
                method,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }
   Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Save a preferred payment method to use for future orders.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Payment type chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PaymentType.values.map((type) {
              final isSelected = _selectedPaymentType == type;
              return ChoiceChip(
                label: Text(_paymentTypeLabel(type)),
                selected: isSelected,
                selectedColor: kPink.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: isSelected ? kPink : const Color(0xFF333333),
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                onSelected: (_) {
                  setState(() {
                    _selectedPaymentType = type;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          _buildFieldsForSelectedPaymentType(),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savePaymentMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Saved Payment Methods',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          _buildSavedPaymentMethodsList(),
        ],
      ),
    );
  }
  // _buildClientSections
  Widget _buildClientSections() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildBudgetRangeSection(),
      const SizedBox(height: 20),
      _buildNailDimensionSection(),   // copy from Client page
      const SizedBox(height: 20),
      _buildSizeReferenceSection(),   // copy from Client page
      const SizedBox(height: 20),
      _buildMeasurementTipsSection(), // copy from Client page
      const SizedBox(height: 20),
      _buildNailShapeSection(),       // copy from Client page
      const SizedBox(height: 20),
      _buildNailLengthSection(),      // copy from Client page
      // plus your Nail Sizing Kit section if you had one
    ],
  );
}
  // _buildArtistSections
  Widget _buildArtistSections() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildProfessionalCertificationSection(),
      const SizedBox(height: 20),
      _buildExperienceSection(),
    ],
  );
}
  // _buildPaymentMethodSection
  // _buildProductBundlesSection
  // _submitCombinedProfile
}
