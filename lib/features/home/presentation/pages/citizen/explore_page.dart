import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/localization/app_localizations.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.translate('explore_gems'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28 * scale,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF134E4A),
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                appLocalizations.translate('onboarding_desc_2'), // Reusing similar string or add new
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14 * scale,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 32 * scale),
              // Search Bar Placeholder
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16 * scale),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 24 * scale),
                    SizedBox(width: 12 * scale),
                    Text(
                      'Search places, events...',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 14 * scale,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32 * scale),
              _buildModernCard(
                context,
                scale: scale,
                title: 'Upcoming Festivals',
                subtitle: 'Join the local celebrations this weekend',
                imageUrl: 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=1000&auto=format&fit=crop',
              ),
              SizedBox(height: 24 * scale),
              _buildModernCard(
                context,
                scale: scale,
                title: 'Hidden Waterfalls',
                subtitle: 'A local secret just 20 mins away',
                imageUrl: 'https://images.unsplash.com/photo-1433086966358-54859d0ee716?q=80&w=1000&auto=format&fit=crop',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, {required double scale, required String title, required String subtitle, required String imageUrl}) {
    return Container(
      width: double.infinity,
      height: 250 * scale,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24 * scale),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24 * scale),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        padding: EdgeInsets.all(20 * scale),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 20 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4 * scale),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
