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
          // Language Switcher
          ListTile(
            title: Text(
              appLocalizations.translate('language'),
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
            trailing: Switch(
              value: locale.languageCode == 'ar',
              onChanged: (value) {
                context.read<LocaleCubit>().switchLanguage();
              },
              activeThumbColor: primaryColor,
            ),
            onTap: () {
              context.read<LocaleCubit>().switchLanguage();
            },
          ),
          const Divider(),
          // Theme Switcher
          ListTile(
            title: Text(
              appLocalizations.translate('dark_mode'),
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(themeMode == ThemeMode.dark ? 'On' : 'Off'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme();
              },
              activeThumbColor: primaryColor,
            ),
            onTap: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
