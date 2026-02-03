import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_floating_nav_bar.dart';
import '../../../../features/auth/cubit/auth_cubit.dart';
import '../../../../features/auth/cubit/auth_state.dart';
import 'settings_page.dart';
import '../../../../core/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appLocalizations = AppLocalizations.of(context)!;
    final authState = context.watch<AuthCubit>().state;
    final isGuest =
        authState is AuthAuthenticated && authState.userType == 'guest';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  // Top App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          appLocalizations.translate('profile'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
                          ),
                          child: !isGuest
                              ? Icon(
                                  Icons.ios_share,
                                  size: 20,
                                  color: theme.iconTheme.color,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),

                  if (isGuest) ...[
                    const SizedBox(height: 48),
                    Icon(
                      Icons.account_circle_outlined,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Guest Mode",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "Sign in to manage your trips, earn rewards, and access exclusive features.",
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
                  ] else ...[
                    // Profile Header
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glow
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xFF14b8b8,
                                  ).withOpacity(0.2), // Primary
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF14b8b8,
                                        ).withOpacity(0.4),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Avatar
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 4,
                                  ),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://lh3.googleusercontent.com/aida-public/AB6AXuC75mieeq-6b3D2utYwP5U45qhmMV1yr4DdzzF33GhWI1HGupKoe4zSLrHhEWPUEmK0HYufrr5XLRdGl4zGa1pxR5F60SUTAi4x1-FecgB43AkaKlrEcE-azCzxpqsmzq7pmrNVKHxKlGzhc-2ogHqgRNz97Ab7aKl2VUAlH0V39MPYS5ko_JA1A8HzRlWTGtJpNUQCtCeReLKgHnbh4NUvBds_MphidKrFsnolNUX8dTKnUwy4f4qXiDhr9LIbtlB6GzUq1XXr6Ug",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Badge
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14b8b8),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF0A0A0A)
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    appLocalizations
                                        .translate('pro_member')
                                        .toUpperCase(),
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Alexander Sterling",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "Elite Concierge Access",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF14b8b8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Member since March 2022",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          _buildStatItem(
                            context,
                            "42",
                            appLocalizations.translate('trips_taken'),
                          ),
                          const SizedBox(width: 16),
                          _buildStatItem(
                            context,
                            "18",
                            appLocalizations.translate('bucket_list'),
                          ),
                          const SizedBox(width: 16),
                          _buildStatItem(
                            context,
                            "124",
                            appLocalizations.translate('reviews'),
                          ),
                        ],
                      ),
                    ),

                    // Travel Management
                    _buildSectionHeader(
                      appLocalizations.translate('travel_management'),
                    ),
                    _buildListItem(
                      context,
                      icon: Icons.calendar_month,
                      title: appLocalizations.translate('my_bookings'),
                    ),
                    _buildListItem(
                      context,
                      icon: Icons.account_balance_wallet,
                      title: appLocalizations.translate('payment_methods'),
                    ),
                    _buildListItem(
                      context,
                      icon: Icons.groups_3,
                      title: appLocalizations.translate('collaborative_groups'),
                      hasNotification: true,
                    ),

                    // Preferences
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      appLocalizations.translate('preferences'),
                    ),
                    _buildListItem(
                      context,
                      icon: Icons.settings,
                      title: appLocalizations.translate('settings'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),

                    // Logout
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  appLocalizations.translate('logout'),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            appLocalizations.translate('app_version'),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Custom Navigation Bar
          if (!isGuest) const CustomFloatingNavBar(),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFF1F5F9), // slate-100 or surface-dark
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool hasNotification = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xFF14b8b8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              if (hasNotification)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
