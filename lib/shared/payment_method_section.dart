import 'package:flutter/material.dart';
import 'payment_type.dart';

const Color kPink = Color(0xFFE91E63);

class PaymentMethodSection extends StatefulWidget {
  final PaymentType selectedType;
  final ValueChanged<PaymentType> onTypeChanged;

  /// Called when the user taps "Save Payment Method".
  /// We pass back a human-readable description (e.g. "Credit Card •••• 4242").
  final ValueChanged<String> onSave;

  /// List of previously saved methods to display.
  final List<String> savedMethods;

  const PaymentMethodSection({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onSave,
    required this.savedMethods,
  });

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  final _formKey = GlobalKey<FormState>();

  // Apple Pay
  final TextEditingController _applePayEmailController =
      TextEditingController();

  // PayPal
  final TextEditingController _paypalEmailController = TextEditingController();

  // Credit Card
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // Venmo
  final TextEditingController _venmoHandleController = TextEditingController();

  @override
  void dispose() {
    _applePayEmailController.dispose();
    _paypalEmailController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _venmoHandleController.dispose();
    super.dispose();
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

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      children: PaymentType.values.map((type) {
        final selected = widget.selectedType == type;
        return ChoiceChip(
          label: Text(
            _paymentTypeLabel(type),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF333333),
            ),
          ),
          selected: selected,
          selectedColor: kPink,
          side: BorderSide(
            color: selected ? kPink : Colors.grey.shade300,
          ),
          onSelected: (_) => widget.onTypeChanged(type),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = true,
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
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
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
            hintText: hint,
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

  Widget _buildFieldsForSelectedType() {
    switch (widget.selectedType) {
      case PaymentType.applePay:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Apple ID Email',
              controller: _applePayEmailController,
              keyboardType: TextInputType.emailAddress,
              hint: 'Email linked to your Apple Pay',
            ),
          ],
        );
      case PaymentType.paypal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'PayPal Email',
              controller: _paypalEmailController,
              keyboardType: TextInputType.emailAddress,
              hint: 'Email for your PayPal account',
            ),
          ],
        );
      case PaymentType.creditCard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Name on Card',
              controller: _cardNameController,
              hint: 'Enter name on card',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Card Number',
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              hint: '•••• •••• •••• ••••',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Expiry (MM/YY)',
                    controller: _expiryController,
                    keyboardType: TextInputType.datetime,
                    hint: '08/27',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'CVV',
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    hint: '123',
                  ),
                ),
              ],
            ),
          ],
        );
      case PaymentType.venmo:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Venmo Handle',
              controller: _venmoHandleController,
              hint: '@username',
            ),
          ],
        );
    }
  }

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    String description;

    switch (widget.selectedType) {
      case PaymentType.applePay:
        description = 'Apple Pay • ${_applePayEmailController.text.trim()}';
        break;
      case PaymentType.paypal:
        description = 'PayPal • ${_paypalEmailController.text.trim()}';
        break;
      case PaymentType.creditCard:
        final number = _cardNumberController.text.replaceAll(' ', '');
        final last4 = number.length >= 4 ? number.substring(number.length - 4) : '****';
        description = 'Credit Card •••• $last4';
        break;
      case PaymentType.venmo:
        description = 'Venmo • ${_venmoHandleController.text.trim()}';
        break;
    }

    // 🔹 Let the parent store/persist this
    widget.onSave(description);

    // Optional: clear fields after save
    _applePayEmailController.clear();
    _paypalEmailController.clear();
    _cardNameController.clear();
    _cardNumberController.clear();
    _expiryController.clear();
    _cvvController.clear();
    _venmoHandleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 18,
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
            ),
          ),
          const SizedBox(height: 16),

          // Payment type chips
          _buildTypeSelector(),
          const SizedBox(height: 16),

          // Dynamic fields
          Form(
            key: _formKey,
            child: _buildFieldsForSelectedType(),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Saved Payment Methods',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.savedMethods.isEmpty)
            const Text(
              'No payment methods saved yet.',
              style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
            )
          else
            Column(
              children: widget.savedMethods
                  .map(
                    (m) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.payment, size: 20),
                      title: Text(
                        m,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}