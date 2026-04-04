import 'package:flutter/material.dart';
import '../../../../../core/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/cubit/auth_cubit.dart';
import '../../../../auth/cubit/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class TripPreferencePage extends StatefulWidget {
  const TripPreferencePage({super.key});

  @override
  State<TripPreferencePage> createState() => _TripPreferencePageState();
}

class _TripPreferencePageState extends State<TripPreferencePage> {
  // Track selected categories (multiple selection)
  final Set<String> _selectedCategories = {};

  final List<Map<String, dynamic>> categories = [
    {'name': 'Popular', 'icon': Icons.local_fire_department},
    {'name': 'Museum', 'icon': Icons.museum_outlined},
    {'name': 'Nature', 'icon': Icons.landscape},
    {'name': 'Foodie', 'icon': Icons.restaurant_menu},
    {'name': 'History', 'icon': Icons.history_edu},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Check for Guest
    final authState = context.watch<AuthCubit>().state;
    final isGuest =
        authState is AuthAuthenticated && authState.userType == 'guest';

    if (isGuest) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Registration Required",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Sign in to plan and book your dream trip.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14b8b8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Login / Sign Up"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.withOpacity(isDark ? 0.2 : 0.4), // Light amber at top
              isDark ? theme.scaffoldBackgroundColor : Colors.white, // Match theme at bottom
            ],
            stops: const [0.0, 0.6], // Fades out quickly
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Spacer(flex: 1),
                const SizedBox(height: 10),
                const Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 40,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                Text(
                  "Trip Preferences",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "What should your trip be about?",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                // Use Wrap or GridView with 3 columns to match the image
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 Columns like the image
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2, // Wide aspect ratio for "Chip" look
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(
                      categories[index]['name'],
                      categories[index]['icon'],
                      isDark,
                      theme,
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to duration selection
                      if (_selectedCategories.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.durationSelection,
                          arguments: _selectedCategories.toList(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select at least one category',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.amber.withOpacity(0.8) : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, bool isDark, ThemeData theme) {
    final isSelected = _selectedCategories.contains(name);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(name);
          } else {
            _selectedCategories.add(name);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white12 : Colors.black.withOpacity(0.05))
              : (isDark ? theme.cardColor : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.brown.shade400,
            ),
            const SizedBox(width: 4), // Reduced spacing slightly
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12, // Reduced font size slightly
                  color: isSelected && isDark ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
