import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/localization/app_localizations.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / 375).clamp(0.8, 1.2);
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.translate('saved_places'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28 * scale,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF134E4A),
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                appLocalizations.translate('onboarding_desc_1'), // Placeholder or add new
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14 * scale,
                  color: Colors.grey,
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 80 * scale, color: Colors.grey),
                      SizedBox(height: 16 * scale),
                      Text(
                        'No saved spots yet',
                        style: TextStyle(
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8 * scale),
                      Text(
                        'Start exploring and tap the heart icon\nto save your favorite places.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14 * scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
