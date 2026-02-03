import 'package:flutter/material.dart';

class CitizenFloatingNavBar extends StatefulWidget {
  const CitizenFloatingNavBar({super.key});

  @override
  State<CitizenFloatingNavBar> createState() => _CitizenFloatingNavBarState();
}

class _CitizenFloatingNavBarState extends State<CitizenFloatingNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF134E4A);
    const Color accentColor = Color(0xFFF97316);

    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 350, // Max width from design
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home, accentColor),
              _buildNavItem(1, Icons.explore, accentColor),
              _buildNavItem(2, Icons.favorite, accentColor),
              _buildNavItem(3, Icons.person, accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, Color accentColor) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Handle Navigation Here if needed
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            size: 28,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4, // size-1 equivalent
              height: 4,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
