import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/routes/app_routes.dart';
import 'package:tashaapp/core/localization/app_localizations.dart';

class CitizenQuickActions extends StatelessWidget {
  const CitizenQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primaryColor = isDark ? Colors.white : const Color(0xFF134E4A);
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final appLocalizations = AppLocalizations.of(context)!;

    // Scale sizes based on screen width (standard mobile width approx 375)
    final double scale = screenWidth / 375;
    final double itemSize = 65 * scale.clamp(0.8, 1.2);
    final double iconSize = 36 * scale.clamp(0.8, 1.2);

    final List<Map<String, dynamic>> actions = [
      {
        'title': appLocalizations.translate('offers'),
        'key': 'Offers',
        'icon': Icons.local_offer_rounded,
        'color': const Color(0xFFF97316),
      },
      {
        'title': appLocalizations.translate('report'),
        'key': 'Report',
        'icon': Icons.report_problem_rounded,
        'color': const Color(0xFFEF4444),
      },
      {
        'title': appLocalizations.translate('add_place'),
        'key': 'Add Place',
        'icon': Icons.add_location_alt_rounded,
        'color': const Color(0xFF10B981),
      },
      {
        'title': appLocalizations.translate('host_tourist'),
        'key': 'Host Tourist',
        'icon': Icons.volunteer_activism_rounded,
        'color': const Color(0xFF6366F1),
      },
    ];

    return SizedBox(
      height: 120 * scale.clamp(0.9, 1.1),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return GestureDetector(
            onTap: () {
              if (action['key'] == 'Offers') {
                Navigator.pushNamed(context, AppRoutes.offers);
              } else if (action['key'] == 'Report') {
                Navigator.pushNamed(context, AppRoutes.report);
              } else if (action['key'] == 'Add Place') {
                Navigator.pushNamed(context, AppRoutes.addPlace);
              } else if (action['key'] == 'Host Tourist') {
                Navigator.pushNamed(context, AppRoutes.hostTourist);
              }
            },

            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                children: [
                  Container(
                    width: itemSize,
                    height: itemSize,
                    decoration: BoxDecoration(
                      color: action['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: action['color'].withOpacity(0.3),
                        width: 2.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        action['icon'],
                        color: action['color'],
                        size: iconSize,
                      ),
                    ),
                  ),
                  SizedBox(height: 10 * scale.clamp(0.8, 1.2)),
                  Text(
                    action['title'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14 * scale.clamp(0.9, 1.1),
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
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
