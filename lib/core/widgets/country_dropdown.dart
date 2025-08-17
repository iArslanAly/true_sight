import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/countries.dart';

class CountryDropdown extends StatelessWidget {
  final String? selectedCountry;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const CountryDropdown({
    super.key,
    required this.selectedCountry,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Country"),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          enabled: enabled,

          // ✅ Firestore value will appear correctly here
          selectedItem: selectedCountry,

          // ✅ Always provide the full countries list
          items: (String? filter, LoadProps? loadProps) async {
            if (filter == null || filter.isEmpty) {
              return countries; // full list
            }
            return countries
                .where((c) => c.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },

          onChanged: onChanged,

          // Dropdown list popup
          popupProps: PopupProps.menu(
            showSearchBox: true,
            constraints: const BoxConstraints(maxHeight: 400),
            menuProps: const MenuProps(
              elevation: 2,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search country...",
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),

          // Main input field
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              
              hintText: "Select your country",
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
