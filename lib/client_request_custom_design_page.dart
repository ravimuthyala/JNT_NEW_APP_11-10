import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// If you already have kPink defined in a constants file, import that instead
/// and remove this line.
const Color kPink = Color(0xFFE91E63);

/// Simple enum for type of order
enum OrderType {
  single,
  group,
}

class ClientRequestCustomDesignPage extends StatefulWidget {
  const ClientRequestCustomDesignPage({
    super.key,
    this.isCompany = false,
    this.showRegisterPrompt = true,
  });

  final bool isCompany;
  final bool showRegisterPrompt;

  @override
  State<ClientRequestCustomDesignPage> createState() =>
      _RequestCustomDesignPageState();
}

class _RequestCustomDesignPageState extends State<ClientRequestCustomDesignPage> {
  final _formKey = GlobalKey<FormState>();

  // ─────────────────────────────
  // Request Details fields
  // ─────────────────────────────
  final TextEditingController _needByDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _needByDate;
  // ─────────────────────────────
  // Inspiration photos
  // ─────────────────────────────
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _inspirationPhotos = [];

  // ─────────────────────────────
  // Non-licensed checkbox
  // ─────────────────────────────
  bool _allowNonLicensedTech = false;

  // ─────────────────────────────
  // Budget Range
  // ─────────────────────────────
  RangeValues _budgetRange = const RangeValues(50, 200);

  // ─────────────────────────────
  // Type of Order (Single / Group)
  // ─────────────────────────────
  OrderType _orderType = OrderType.single;
  final List<TextEditingController> _groupClientControllers = [
    TextEditingController(),
  ];
  static const int _maxGroupClients = 5;

  // ─────────────────────────────
  // Request specific artist + pool
  // ─────────────────────────────
  String? _selectedArtistId;
  bool _sendToPoolIfArtistUnavailable = true;

  /// TODO: Replace with real list loaded from DB
  final List<String> _artists = const [
    'Any Artist',
    'Ava Nails Studio',
    'Bella Artistry',
    'Chloe Custom Designs',
  ];

  // ─────────────────────────────
  // Nail dimensions + shape/length
  // Pre-populated from client profile (pass via constructor or service)
  // ─────────────────────────────
  // In a real app, you would get these from the logged-in client's profile.
  // For now we simulate with example values.
  final Map<String, String> _leftHandDimensions = {
    'Thumb': '14.0',
    'Index': '12.0',
    'Middle': '13.0',
    'Ring': '12.5',
    'Pinky': '10.0',
  };

  final Map<String, String> _rightHandDimensions = {
    'Thumb': '14.0',
    'Index': '12.5',
    'Middle': '13.0',
    'Ring': '12.0',
    'Pinky': '10.0',
  };

  final List<String> _nailShapes = const [
    'Square',
    'Round',
    'Oval',
    'Almond',
    'Stiletto',
    'Coffin',
    'Ballerina',
    'Squoval',
  ];
  final List<String> _nailLengths = const [
    'Short',
    'Medium',
    'Long',
    'Extra Long',
  ];

  String? _selectedNailShape;
  String? _selectedNailLength;

  // ─────────────────────────────
  // Shipping address
  // ─────────────────────────────
  bool _useDifferentShipping = false;

  final TextEditingController _shippingStreetController =
      TextEditingController();
  final TextEditingController _shippingCityController =
      TextEditingController();
  final TextEditingController _shippingZipController = TextEditingController();
  String? _shippingState;
  String? _shippingCountry;

  // Simple US states + countries (you can move to constants file)
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
    'Germany',
    'France',
    'Italy',
    'Spain',
  ];

  @override
  void initState() {
    super.initState();

    // Example of pre-populating shape/length from "profile"
    _selectedNailShape = _nailShapes.first;
    _selectedNailLength = _nailLengths[1]; // Medium
  }

  @override
  void dispose() {
    _needByDateController.dispose();
    _descriptionController.dispose();

    for (final c in _groupClientControllers) {
      c.dispose();
    }

    _shippingStreetController.dispose();
    _shippingCityController.dispose();
    _shippingZipController.dispose();

    super.dispose();
  }

  // ─────────────────────────────
  // Helpers
  // ─────────────────────────────

  Future<void> _pickNeedByDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _needByDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _needByDate = picked;
        _needByDateController.text =
            '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  Future<void> _pickInspirationPhoto(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (file != null) {
        setState(() {
          _inspirationPhotos.add(file);
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to pick image.'),
        ),
      );
    }
  }

  void _addGroupClientField() {
    if (_groupClientControllers.length >= _maxGroupClients) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can add up to 5 clients only.'),
        ),
      );
      return;
    }
    setState(() {
      _groupClientControllers.add(TextEditingController());
    });
  }

  void _removeGroupClientField(int index) {
    if (_groupClientControllers.length == 1) return;
    setState(() {
      _groupClientControllers[index].dispose();
      _groupClientControllers.removeAt(index);
    });
  }

  // These simulate DB + notifications. Replace with your real services.
  Future<void> _saveRequestToDb() async {
    // TODO: implement real DB call
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _notifyArtistsAndAdmin() async {
    // TODO: implement push/email/notification to all artists + admin
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _sendConfirmationEmailToClient() async {
    // TODO: integrate with your email service using client email
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  void _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Need by date required
    if (_needByDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a "Need By" date.'),
        ),
      );
      return;
    }

    // If group order, at least one client with value
    if (_orderType == OrderType.group) {
      final hasAtLeastOneName = _groupClientControllers
          .any((c) => c.text.trim().isNotEmpty);
      if (!hasAtLeastOneName) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter at least one client name.'),
          ),
        );
        return;
      }
    }

    // Shipping validation if different address
    if (_useDifferentShipping) {
      if (_shippingStreetController.text.trim().isEmpty ||
          _shippingCityController.text.trim().isEmpty ||
          _shippingZipController.text.trim().isEmpty ||
          _shippingState == null ||
          _shippingCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Please complete all Shipping Address fields.'),
          ),
        );
        return;
      }
    }

    // ── Simulate DB + notifications + email ──
    await _saveRequestToDb();
    await _notifyArtistsAndAdmin();
    await _sendConfirmationEmailToClient();

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RequestConfirmationPage(),
      ),
    );
  }

  // ─────────────────────────────
  // UI Builders
  // ─────────────────────────────

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    bool requiredField = false,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    String? hintText,
    Widget? suffixIcon,
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
          readOnly: readOnly,
          validator: requiredField
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter $label',
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 13,
            ),
            filled: true,
            fillColor: readOnly ? const Color(0xFFF0F0F0) : Colors.white,
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPink, width: 1.5),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
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

  Widget _buildNailDimensionRow(
    String handLabel,
    Map<String, String> handData,
  ) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          handLabel,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: handData.entries.map((entry) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    entry.key,
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
                  child: TextFormField(
                    initialValue: entry.value,
                    readOnly: true, // not editable
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
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
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
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
        ),
      ],
    );
  }

  Widget _buildNailShapeCard(String shapeName) {
    final bool isSelected = _selectedNailShape == shapeName;

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
                borderRadius: BorderRadius.circular(24),
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

  Widget _buildNailLengthCard(String name) {
    final bool isSelected = _selectedNailLength == name;

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
        width: 120,
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
          children: [
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
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────
  // Build
  // ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Custom Design',
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
                // Header
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'Request Custom Design',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tell artists exactly what you\'re looking for and get custom proposals.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Request Details
                _buildSectionTitle('Request Details'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildLabeledTextField(
                        label: 'Need By Date',
                        requiredField: true,
                        controller: _needByDateController,
                        readOnly: true,
                        onTap: _pickNeedByDate,
                        hintText: 'MM/DD/YYYY',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today_outlined),
                          tooltip: 'Pick delivery date',
                          onPressed: _pickNeedByDate,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabeledTextField(
                        label: 'Description',
                        requiredField: true,
                        controller: _descriptionController,
                        maxLines: 4,
                        hintText: 'Describe your ideal design in detail...',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Inspiration Photos
                _buildSectionTitle('Inspiration Photos',
                    subtitle:
                        'Upload photos that inspire your vision (optional).'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () =>
                                _pickInspirationPhoto(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Gallery'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _pickInspirationPhoto(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Camera'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_inspirationPhotos.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _inspirationPhotos.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final file = _inspirationPhotos[index];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(file.path),
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _inspirationPhotos.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Non-licensed checkbox
                CheckboxListTile(
                  value: _allowNonLicensedTech,
                  onChanged: (val) {
                    setState(() {
                      _allowNonLicensedTech = val ?? false;
                    });
                  },
                  title: const Text(
                    'Are you willing to allow non-licensed nail technicians to work on your design?',
                    style: TextStyle(fontSize: 13),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),

                // Budget Range
                _buildSectionTitle('Budget Range',
                    subtitle:
                        'Set your preferred budget range for nail designs.'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${_budgetRange.start.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_budgetRange.end.toStringAsFixed(0)}+',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: _budgetRange,
                        min: 20,
                        max: 500,
                        divisions: 48,
                        labels: RangeLabels(
                          '\$${_budgetRange.start.toStringAsFixed(0)}',
                          '\$${_budgetRange.end.toStringAsFixed(0)}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _budgetRange = values;
                          });
                        },
                        activeColor: kPink,
                        inactiveColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Type of Order
                _buildSectionTitle('Type of Order'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<OrderType>(
                              value: OrderType.single,
                              groupValue: _orderType,
                              onChanged: (val) {
                                setState(() {
                                  _orderType = val ?? OrderType.single;
                                });
                              },
                              title: const Text('Single Order'),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<OrderType>(
                              value: OrderType.group,
                              groupValue: _orderType,
                              onChanged: (val) {
                                setState(() {
                                  _orderType = val ?? OrderType.single;
                                });
                              },
                              title: const Text('Group Order'),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      if (_orderType == OrderType.group) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Enter client names (up to 5):',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _groupClientControllers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _groupClientControllers[index],
                                    decoration: InputDecoration(
                                      hintText: 'Client name',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () =>
                                      _removeGroupClientField(index),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _addGroupClientField,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Another Client'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Request specific artist
                _buildSectionTitle('Request a Specific Artist'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdown<String>(
                        label: 'Artist',
                        requiredField: false,
                        value: _selectedArtistId,
                        items: _artists,
                        onChanged: (value) {
                          setState(() {
                            _selectedArtistId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'If the artist cannot complete the request, do you want the request to go into the request pool for other artists?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Yes'),
                            selected: _sendToPoolIfArtistUnavailable,
                            onSelected: (_) {
                              setState(() {
                                _sendToPoolIfArtistUnavailable = true;
                              });
                            },
                            selectedColor: kPink.withOpacity(0.15),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('No'),
                            selected: !_sendToPoolIfArtistUnavailable,
                            onSelected: (_) {
                              setState(() {
                                _sendToPoolIfArtistUnavailable = false;
                              });
                            },
                            selectedColor: kPink.withOpacity(0.15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Nail Dimensions from profile (readonly)
                _buildSectionTitle('Nail Dimension (in mm)'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildNailDimensionRow(
                          'Left Hand', _leftHandDimensions),
                      _buildNailDimensionRow(
                          'Right Hand', _rightHandDimensions),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Nail Shape editable
                _buildSectionTitle('Choose Your Nail Shape',
                    subtitle: 'Select from 16 available shapes'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _nailShapes.length,
                    itemBuilder: (context, index) =>
                        _buildNailShapeCard(_nailShapes[index]),
                  ),
                ),
                const SizedBox(height: 18),

                // Nail Length editable
                _buildSectionTitle('Choose Your Nail Length',
                    subtitle: 'Pick how long you like your nails to be'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _nailLengths.length,
                    itemBuilder: (context, index) =>
                        _buildNailLengthCard(_nailLengths[index]),
                  ),
                ),
                const SizedBox(height: 18),

                // Shipping address different checkbox
                CheckboxListTile(
                  value: _useDifferentShipping,
                  onChanged: (val) {
                    setState(() {
                      _useDifferentShipping = val ?? false;
                    });
                  },
                  title: const Text(
                    'Shipping address different from profile address?',
                    style: TextStyle(fontSize: 13),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),

                if (_useDifferentShipping) ...[
                  _buildSectionTitle('Shipping Address Information'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildLabeledTextField(
                          label: 'Street Address',
                          requiredField: true,
                          controller: _shippingStreetController,
                        ),
                        const SizedBox(height: 12),
                        _buildLabeledTextField(
                          label: 'City',
                          requiredField: true,
                          controller: _shippingCityController,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown<String>(
                          label: 'State',
                          requiredField: true,
                          value: _shippingState,
                          items: _usStates,
                          onChanged: (value) {
                            setState(() {
                              _shippingState = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildLabeledTextField(
                          label: 'Zip Code',
                          requiredField: true,
                          controller: _shippingZipController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown<String>(
                          label: 'Country',
                          requiredField: true,
                          value: _shippingCountry,
                          items: _countries,
                          onChanged: (value) {
                            setState(() {
                              _shippingCountry = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Request',
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

/// Simple confirmation page after submit
class RequestConfirmationPage extends StatelessWidget {
  const RequestConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Submitted',
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.check_circle_outline,
                size: 60,
                color: kPink,
              ),
              SizedBox(height: 16),
              Text(
                'Your request has been submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We\'ve notified artists and our team. You\'ll receive an email confirmation and proposals soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}