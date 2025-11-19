import 'package:flutter/material.dart';
import 'package:jnt_app/app_theme.dart';
import 'main.dart';     // for ProfileEntryPage
const Color kPink = Color(0xFFE91E63);

class RequestCustomDesignPage extends StatefulWidget {
  /// If true, show company-only fields (client selector + nail dimension).
  final bool isCompany;

  /// If true, show the "Create an Account" popup when the page opens.
  final bool showRegisterPrompt;

  const RequestCustomDesignPage({
    super.key,
    this.isCompany = false,
    this.showRegisterPrompt = true,
  });

  @override
  State<RequestCustomDesignPage> createState() =>
      _RequestCustomDesignPageState();
}

class _RequestCustomDesignPageState extends State<RequestCustomDesignPage> {
  final _formKey = GlobalKey<FormState>();

  // Basic design request fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _inspirationLinkController =
      TextEditingController();

  // --- COMPANY-ONLY: specific clients multi-select -----------------------

  /// TODO: Replace this with clients from your DB.
  final List<String> _allClients = const [
    'Ravi Kumar',
    'Emma Lopez',
    'Sarah M.',
    'David P.',
  ];

  final List<String> _selectedClients = [];

  // --- COMPANY-ONLY: nail dimension simple fields -----------------------

  // keep it simple: 5 fingers left + 5 right
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

  @override
  void initState() {
    super.initState();

    // Show the “register” popup when this page is opened (if enabled)
    if (widget.showRegisterPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRegisterDialog();
      });
    }
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Create an Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'You’ll need a JustNailTips account to submit a custom design '
            'request and chat with artists.\n\n'
            'It takes less than a minute ✨',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
                // Go to the account-type / registration flow
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfileEntryPage(),
                  ),
                );
              },
              child: const Text('Create Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _inspirationLinkController.dispose();

    for (final c in _leftHand.values) {
      c.dispose();
    }
    for (final c in _rightHand.values) {
      c.dispose();
    }
    super.dispose();
  }

  // -----------------------------------------------------------------------
  //  BASIC HELPERS
  // -----------------------------------------------------------------------
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    int maxLines = 1,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
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

  // -----------------------------------------------------------------------
  //  COMPANY-ONLY: CLIENT MULTI-SELECT
  // -----------------------------------------------------------------------
  Future<void> _openClientMultiSelectDialog() async {
    final tempSelected = Set<String>.from(_selectedClients);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Request for Specific Client(s)'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: _allClients.map((client) {
                final isSelected = tempSelected.contains(client);
                return CheckboxListTile(
                  value: isSelected,
                  title: Text(client),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        tempSelected.add(client);
                      } else {
                        tempSelected.remove(client);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedClients
                    ..clear()
                    ..addAll(tempSelected);
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClientMultiSelectField() {
    return FormField<List<String>>(
      validator: (value) {
        if (widget.isCompany && _selectedClients.isEmpty) {
          return 'Please select at least one client.';
        }
        return null;
      },
      builder: (state) {
        final hasError = state.hasError;
        final text = _selectedClients.isEmpty
            ? 'Select client(s)'
            : _selectedClients.join(', ');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                text: 'Request for Specific Client',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _openClientMultiSelectDialog,
              child: InputDecorator(
                isEmpty: _selectedClients.isEmpty,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          hasError ? Colors.red : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          hasError ? Colors.red : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: kPink, width: 1.5),
                  ),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedClients.isEmpty
                        ? const Color(0xFFBDBDBD)
                        : const Color(0xFF333333),
                  ),
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 4),
              Text(
                state.errorText!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // -----------------------------------------------------------------------
  //  COMPANY-ONLY: NAIL DIMENSION SECTION
  // -----------------------------------------------------------------------
  Widget _buildNailDimensionSection() {
    Widget buildHandRow(Map<String, TextEditingController> hand) {
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
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Nail Dimension (in mm)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              children: [
                TextSpan(
                  text: '  (optional)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Left Hand',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          buildHandRow(_leftHand),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Right Hand',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          buildHandRow(_rightHand),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------
  //  SUBMIT
  // -----------------------------------------------------------------------
  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (widget.isCompany && _selectedClients.isEmpty) {
      // extra safety – should already fail validator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one client.'),
        ),
      );
      return;
    }

    // TODO: send data to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom design request submitted (simulated).'),
      ),
    );
  }

  // -----------------------------------------------------------------------
  //  BUILD
  // -----------------------------------------------------------------------
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
                _buildTextField(
                  label: 'Design Title',
                  controller: _titleController,
                  requiredField: true,
                  hintText: 'e.g. Nude almond with gold foil tips',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Design Description',
                  controller: _descriptionController,
                  requiredField: true,
                  maxLines: 4,
                  hintText:
                      'Share colors, shapes, length, finishes, inspo details…',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Inspiration Link (optional)',
                  controller: _inspirationLinkController,
                  hintText: 'Pinterest / Instagram / photo URL',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),

                // COMPANY-ONLY FIELDS
                if (widget.isCompany) ...[
                  _buildClientMultiSelectField(),
                  const SizedBox(height: 20),
                  _buildNailDimensionSection(),
                  const SizedBox(height: 24),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Request',
                      style: TextStyle(fontWeight: FontWeight.bold),
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