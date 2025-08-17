import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class GenderDropdown extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const GenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    const genders = ["Male", "Female", "Other"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender"),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          enabled: enabled,
          selectedItem: selectedGender,
          items: (String? filter, _) async {
            return genders
                .where(
                  (g) => g.toLowerCase().contains(filter?.toLowerCase() ?? ""),
                )
                .toList();
          },
          onChanged: onChanged,

          // 🔹 Compare selected item properly
          compareFn: (item, selected) =>
              item.toLowerCase() == (selected.toLowerCase()),

          popupProps: PopupProps.menu(
            showSearchBox: false,
            constraints: const BoxConstraints(maxHeight: 200),
            menuProps: const MenuProps(
              elevation: 2,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),

          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: "Select gender",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
        ),
      ],
    );
  }
}
