import 'package:flutter/material.dart';

const Color kPink = Color(0xFFE91E63);
// ---------- SECTION TITLE ----------
Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF333333),
      ),
    ),
  );
}

// ---------- NAIL DIMENSION ----------
class NailDimensionSection extends StatelessWidget {
  final List<TextEditingController> leftHandControllers;
  final List<TextEditingController> rightHandControllers;
  final bool requiredField;

  const NailDimensionSection({
    super.key,
    required this.leftHandControllers,
    required this.rightHandControllers,
    this.requiredField = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget nailRow(String label, List<TextEditingController> controllers) {
      const fingerLabels = ['Thumb', 'Index', 'Middle', 'Ring', 'Pinky'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (i) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  child: TextFormField(
                    controller: controllers[i],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: fingerLabels[i],
                      hintText: 'mm',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: requiredField
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }
                        : null,
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          'Nail Dimension (in mm)${requiredField ? ' *' : ''}',
        ),
        const SizedBox(height: 8),
        nailRow('Left Hand', leftHandControllers),
        const SizedBox(height: 16),
        nailRow('Right Hand', rightHandControllers),
      ],
    );
  }
}

// ---------- NAIL SHAPE ----------
class NailShapeSection extends StatelessWidget {
  final List<String> nailShapes;
  final String? selectedShape;
  final ValueChanged<String> onChanged;
  final bool requiredField;

  const NailShapeSection({
    super.key,
    required this.nailShapes,
    required this.selectedShape,
    required this.onChanged,
    this.requiredField = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          'Choose your Nail shape${requiredField ? ' *' : ''}',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: nailShapes.map((shapeName) {
            final isSelected = selectedShape == shapeName;
            return ChoiceChip(
              label: Text(shapeName),
              selected: isSelected,
              selectedColor: kPink.withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected ? kPink : const Color(0xFF333333),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => onChanged(shapeName),
            );
          }).toList(),
        ),
        if (requiredField && (selectedShape == null || selectedShape!.isEmpty))
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Please select a nail shape',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

// ---------- NAIL LENGTH ----------
class NailLengthSection extends StatelessWidget {
  final List<String> nailLengths;
  final String? selectedLength;
  final ValueChanged<String> onChanged;
  final bool requiredField;

  const NailLengthSection({
    super.key,
    required this.nailLengths,
    required this.selectedLength,
    required this.onChanged,
    this.requiredField = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          'Choose your Nail length${requiredField ? ' *' : ''}',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: nailLengths.map((name) {
            final isSelected = selectedLength == name;
            return ChoiceChip(
              label: Text(name),
              selected: isSelected,
              selectedColor: kPink.withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected ? kPink : const Color(0xFF333333),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => onChanged(name),
            );
          }).toList(),
        ),
        if (requiredField &&
            (selectedLength == null || selectedLength!.isEmpty))
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Please select a nail length',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}