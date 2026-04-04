import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenCategoriesSection extends StatefulWidget {
  final Function(String) onCategorySelected;
  final String initialCategory;

  const CitizenCategoriesSection({
    super.key,
    required this.onCategorySelected,
    this.initialCategory = 'Events',
  });

  @override
  State<CitizenCategoriesSection> createState() =>
      _CitizenCategoriesSectionState();
}

class _CitizenCategoriesSectionState extends State<CitizenCategoriesSection> {
  late String _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.confirmation_number_outlined, 'label': 'Events'},
    {'icon': Icons.hiking, 'label': 'Activities'},
    {'icon': Icons.restaurant_menu, 'label': 'Dining'},
    {'icon': Icons.palette_outlined, 'label': 'Workshops'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primaryColor = isDark ? Colors.white : const Color(0xFF134E4A);
    final Color backgroundColor = isDark ? theme.cardColor : Colors.white;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['label'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category['label'];
              });
              widget.onCategorySelected(_selectedCategory);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : backgroundColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    category['icon'],
                    color: isSelected ? (isDark ? Colors.black : Colors.white) : primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category['label'],
                    style: GoogleFonts.plusJakartaSans(
                      color: isSelected ? (isDark ? Colors.black : Colors.white) : primaryColor,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
