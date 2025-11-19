import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jnt_app/app_theme.dart';
import 'shared/payment_type.dart';
import 'artist_home_page.dart' show ArtistHomePage; // avoid kPink conflict

///================================
/// ARTIST PROFILE PAGE
///================================

class ArtistProfilePage extends StatefulWidget {
  const ArtistProfilePage({super.key});

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  // ✅ MAIN PROFILE FORM (Save Artist Profile button)
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();

  // ✅ PAYMENT FORM (Save Payment Method button)
  final GlobalKey<FormState> _paymentFormKey = GlobalKey<FormState>();

  // Basic info controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Address controllers (same pattern as client)
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String? _selectedState;
  String? _selectedCountry;

  // You can reuse the same state & country lists as in ClientProfilePage
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

  // Profile picture
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePicture() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  // Professional Certification
  bool _registeredNailTech = true;

  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _jurisdictionController =
      TextEditingController();

  XFile? _previousProjectRegistered;
  XFile? _previousProjectStudent;

  Future<void> _pickPreviousProjectForRegistered() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _previousProjectRegistered = picked;
      });
    }
  }

  Future<void> _pickPreviousProjectForStudent() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _previousProjectStudent = picked;
      });
    }
  }

  // Budget Range
  RangeValues _budgetRange = const RangeValues(50, 150);

  // Level of Experience
  double _experienceLevel = 0.5; // 0 = Beginner, 1 = Advanced

  // Payment preferences (ACH / Venmo)
  String _paymentPreference = 'ACH'; // or 'Venmo'

  // Payment Method (same concept as client page)
  PaymentType _selectedPaymentType = PaymentType.creditCard;

  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _paymentAccountController =
      TextEditingController();

  final List<String> _savedPaymentMethods = [];

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _bioController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();

    _licenseNumberController.dispose();
    _jurisdictionController.dispose();

    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _paymentAccountController.dispose();

    super.dispose();
  }

  // Shared helpers
  Widget buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    int? maxLength,
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
          maxLength: maxLength,
          validator: requiredField
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText ?? 'Enter $label',
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

  Widget buildLabeledDropdown<T>({
    required String label,
    required bool requiredField,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
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
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items
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
                  if (val == null) {
                    return 'This field is required';
                  }
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

  // Basic Information section
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
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tell clients who you are and how to reach you.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 16),

          // Profile picture
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
            label: 'Company Name',
            controller: _companyNameController,
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
          items: _usStates,
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

  // Professional Certification
  void _saveCertificationToDb() {
    // TODO: Replace with real API call / DB write.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _registeredNailTech
              ? 'Registered nail tech certification saved (simulated).'
              : 'Student/unlicensed info saved (simulated).',
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
  Widget _buildPaymentPreferenceSection() {
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
            'How would you like to be paid?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ChoiceChip(
                label: const Text('ACH'),
                selected: _paymentPreference == 'ACH',
                selectedColor: kPink.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: _paymentPreference == 'ACH'
                      ? kPink
                      : const Color(0xFF333333),
                  fontWeight: _paymentPreference == 'ACH'
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
                onSelected: (_) {
                  setState(() {
                    _paymentPreference = 'ACH';
                  });
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Venmo'),
                selected: _paymentPreference == 'Venmo',
                selectedColor: kPink.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: _paymentPreference == 'Venmo'
                      ? kPink
                      : const Color(0xFF333333),
                  fontWeight: _paymentPreference == 'Venmo'
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
                onSelected: (_) {
                  setState(() {
                    _paymentPreference = 'Venmo';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Payment method (same as client registration style)
  String paymentTypeLabel(PaymentType type) {
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

  void _savePaymentMethod() {
  // ✅ validate only the payment section, not the whole page
  if (!(_paymentFormKey.currentState?.validate() ?? false)) {
    return;
  }

  String description = '';

  switch (_selectedPaymentType) {
    case PaymentType.creditCard:
      final raw =
          _cardNumberController.text.replaceAll(' ', '').replaceAll('-', '');
      final last4 = raw.length >= 4 ? raw.substring(raw.length - 4) : raw;
      description =
          'Credit Card •••• $last4 (${_cardNameController.text.trim()})';
      break;
    case PaymentType.applePay:
      description = 'Apple Pay (${_paymentAccountController.text.trim()})';
      break;
    case PaymentType.paypal:
      description = 'PayPal (${_paymentAccountController.text.trim()})';
      break;
    case PaymentType.venmo:
      description = 'Venmo (${_paymentAccountController.text.trim()})';
      break;
  }

  setState(() {
    _savedPaymentMethods.add(description);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Payment method saved: $description (simulated DB write)',
      ),
    ),
  );

  // clear fields
  _cardNameController.clear();
  _cardNumberController.clear();
  _cardExpiryController.clear();
  _cardCvvController.clear();
  _paymentAccountController.clear();

  // ✅ clear any lingering error text on the payment fields
  _paymentFormKey.currentState?.reset();
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
              hintText: '•••• •••• •••• ••••',
              maxLength: 19,
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
                    hintText: '08/27',
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildLabeledTextField(
                    label: 'CVV',
                    controller: _cardCvvController,
                    requiredField: true,
                    keyboardType: TextInputType.number,
                    hintText: '123',
                    maxLength: 4,
                  ),
                ),
              ],
            ),
          ],
        );
      case PaymentType.applePay:
        return buildLabeledTextField(
          label: 'Apple ID / Email',
          controller: _paymentAccountController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
          hintText: 'your-apple-id@example.com',
        );
      case PaymentType.paypal:
        return buildLabeledTextField(
          label: 'PayPal Email',
          controller: _paymentAccountController,
          requiredField: true,
          keyboardType: TextInputType.emailAddress,
          hintText: 'your-paypal-email@example.com',
        );
      case PaymentType.venmo:
        return buildLabeledTextField(
          label: 'Venmo Username or Phone',
          controller: _paymentAccountController,
          requiredField: true,
          hintText: '@username or phone number',
        );
    }
  }

  Widget _buildSavedPaymentMethodsList() {
    if (_savedPaymentMethods.isEmpty) {
      return const Text(
        'No payment methods saved yet.',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFF777777),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _savedPaymentMethods.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final method = _savedPaymentMethods[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.payment, color: kPink),
          title: Text(
            method,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _savedPaymentMethods.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSection() {
  return Form(
    key: _paymentFormKey,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add how you want to receive payments from clients.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PaymentType.values.map((type) {
              final isSelected = _selectedPaymentType == type;
              return ChoiceChip(
                label: Text(paymentTypeLabel(type)),
                selected: isSelected,
                selectedColor: kPink.withOpacity(0.15),
                labelStyle: TextStyle(
                  color: isSelected ? kPink : const Color(0xFF333333),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

  void _submitArtistProfile() {
    if (!(_profileFormKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_selectedState == null || _selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select State and Country.'),
        ),
      );
      return;
    }

    // TODO: Save whole artist profile to DB here.
    final artistName = _nameController.text.trim().isEmpty
        ? 'Artist'
        : _nameController.text.trim();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ArtistHomePage(artistName: artistName),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Artist Profile',
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
          key: _profileFormKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInformationSection(),
                const SizedBox(height: 20),
                _buildAddressSection(),
                const SizedBox(height: 20),
                _buildProfessionalCertificationSection(),
                const SizedBox(height: 20),
                _buildBudgetRangeSection(),
                const SizedBox(height: 20),
                _buildExperienceSection(),
                const SizedBox(height: 20),
                _buildPaymentPreferenceSection(),
                const SizedBox(height: 20),
                _buildPaymentMethodSection(),
                const SizedBox(height: 20),
                _buildProductBundlesSection(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitArtistProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
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