import 'package:flutter/material.dart';
import 'package:jnt_app/app_theme.dart';

/// Shared labeled TextFormField widget
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

/// Shared DropdownButtonFormField with label
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

/// Shared section title
Widget buildSectionTitle(String title) {
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
