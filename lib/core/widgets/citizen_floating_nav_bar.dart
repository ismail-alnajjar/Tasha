import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class CitizenFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const CitizenFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF134E4A);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final appLocalizations = AppLocalizations.of(context)!;

    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: (screenWidth * 0.9).clamp(300, 400),
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
              _buildNavItem(0, Icons.home_rounded, appLocalizations.translate('home')),
              _buildNavItem(1, Icons.explore_rounded, appLocalizations.translate('explore')),
              _buildNavItem(2, Icons.bookmark_rounded, appLocalizations.translate('saved')),
              _buildNavItem(3, Icons.person_rounded, appLocalizations.translate('profile')),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    const Color accentColor = Color(0xFFF97316);

    return GestureDetector(
      onTap: () => onIndexChanged(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

}

