import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tashaapp/features/auth/cubit/auth_cubit.dart';

class UserTypePage extends StatefulWidget {
  const UserTypePage({super.key});

  @override
  State<UserTypePage> createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
  // 'tourist' is default selected in the HTML ("checked" attribute)
  // We'll stick to 'tourist' or 'citizen' as strings.
  String _selectedType = 'tourist';

  @override
  Widget build(BuildContext context) {
    // HTML primary color is #1152d4 (Royal Blue).
    // The previous design used orange, but the user requested converting the HTML which has Blue.
    // However, for consistency with Tasha app branding (Yellow/Orange), I will try to adapt the HTML layout
    // but keep the App's primary color OR strictly follow the HTML.
    // The HTML specifically has `colors: { "primary": "#1152d4" }`.
    // Let's use the HTML's blue to be faithful to the "Convert HTML to Flutter" request.
    final Color primaryColor = const Color(0xFF1152D4);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Static Background (Extracted to prevent rebuilds)
          const _UserTypeBackground(),

          // 3. Status Bar Mock (Skipped, using SAFE AREA)
          // 4. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // To push content down and make space, or justify-between like HTML
                  // HTML says: justify-between h-full max-h-[85vh]
                  const SizedBox(height: 48), // pt-12 approx
                  // Headline
                  Column(
                    children: [
                      Text(
                        'Explore Jordan\nas a...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          height: 1.1, // leading-tight
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tailored experiences for your journey',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Spacer to push bottom section down
                  const Spacer(),

                  // Role Description (Contextual)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_selectedType == 'tourist' ? 'TOURIST' : 'CITIZEN'} MODE',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0, // tracking-widest
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text(
                          _selectedType == 'tourist'
                              ? 'Discover ancient landmarks, guided tours, and the historical wonders of the Hashemite Kingdom.'
                              : 'Access local services, community events, and everyday utilities tailored for residents.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.6, // leading-relaxed
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Interaction Area
                  Column(
                    children: [
                      // Toggle
                      Container(
                        width: 340,
                        height: 60,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF101622,
                          ).withOpacity(0.4), // glass-panel base
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    // Animated Background (The white pill)
                                    AnimatedAlign(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                      alignment: _selectedType == 'citizen'
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Container(
                                        width: (constraints.maxWidth / 2),
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Labels
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => setState(
                                              () => _selectedType = 'citizen',
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Citizen',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          _selectedType ==
                                                              'citizen'
                                                          ? const Color(
                                                              0xFF101622,
                                                            )
                                                          : const Color(
                                                              0xFF9DA6B9,
                                                            ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => setState(
                                              () => _selectedType = 'tourist',
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Tourist',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          _selectedType ==
                                                              'tourist'
                                                          ? const Color(
                                                              0xFF101622,
                                                            )
                                                          : const Color(
                                                              0xFF9DA6B9,
                                                            ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Button
                      SizedBox(
                        width: 340,
                        height: 56, // h-14
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isOnboardingDone', true);

                            if (context.mounted) {
                              context.read<AuthCubit>().selectUserType(
                                _selectedType,
                              );
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                            }
                          },
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                shadowColor: primaryColor.withOpacity(
                                  0.4,
                                ), // shadow-2xl shadow-primary/40
                              ).copyWith(
                                elevation: WidgetStateProperty.all(
                                  8,
                                ), // simplified shadow
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's Go",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Footer Link
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Terms of Service & Privacy Policy',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Bottom padding
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating Decorative Element (Abstract location pin)
          // "bottom-1/2 right-10 z-0 opacity-20 transform translate-y-12"
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            right: 40,
            child: Transform.translate(
              offset: const Offset(0, 48), // translate-y-12 (12 * 4)
              child: Opacity(
                opacity: 0.2,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white, // assuming white based on context
                  size: 180,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserTypeBackground extends StatelessWidget {
  const _UserTypeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Immersive Background (Petra)
        Image.asset(
          'assets/albatraa.png', // Using the Petra asset we have
          fit: BoxFit.cover,
        ),

        // 2. Gradients Overlays
        // Top Gradient: black/60 to transparent
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
        ),
        // Bottom Gradient: black/80 via black/20 to transparent
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.sizeOf(context).height * 0.66, // h-2/3
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
