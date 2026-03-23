import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubit/theme_cubit.dart';
import '../../../../core/cubit/locale_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final locale = context.watch<LocaleCubit>().state;
    final appLocalizations = AppLocalizations.of(context)!;
    final primaryColor = const Color(0xFF14b8b8);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.translate('settings'),
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Text(
            appLocalizations.translate('language'),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLanguageCard(
                context,
                label: 'English',
                code: 'en',
                isSelected: locale.languageCode == 'en',
                icon: Icons.language,
                primaryColor: primaryColor,
              ),
              const SizedBox(width: 16),
              _buildLanguageCard(
                context,
                label: 'العربية',
                code: 'ar',
                isSelected: locale.languageCode == 'ar',
                icon: Icons.translate,
                primaryColor: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Theme Switcher
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(
                themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                color: primaryColor,
              ),
              title: Text(
                appLocalizations.translate('dark_mode'),
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
                activeTrackColor: primaryColor.withOpacity(0.5),
                activeColor: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context, {
    required String label,
    required String code,
    required bool isSelected,
    required IconData icon,
    required Color primaryColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<LocaleCubit>().setLanguage(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
