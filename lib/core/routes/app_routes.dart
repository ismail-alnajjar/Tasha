// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tashaapp/features/home/presentation/pages/HomePage.dart';
import 'package:tashaapp/features/profile/presentation/pages/profile_page.dart';
import 'package:tashaapp/features/trip_planner/presentation/pages/trip_planner_page.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/user_type_page.dart';
import '../../features/home/presentation/pages/duration_selection_page.dart';
import '../../features/home/presentation/pages/trip_preference_page.dart';
import '../../features/trip_planner/presentation/pages/trip_summary_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String Typeuser = '/user_type';
  static const String home = '/home';
  static const String tripPreference = '/trip_preference';
  static const String durationSelection = '/duration_selection';
  static const String tripSummary = '/trip_summary';
  static const String tripPlanner = '/trip_Planner';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashPage(),
    onboarding: (context) => const OnboardingPage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    Typeuser: (context) => const UserTypePage(),
    home: (context) => const HomePage(),
    tripPlanner: (context) => const TripPlannerPage(),
    tripPreference: (context) => const TripPreferencePage(),
    durationSelection: (context) => const DurationSelectionPage(),
    tripSummary: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return TripSummaryPage(
        category: args['category'],
        duration: args['duration'],
      );
    },
    profile: (context) => const ProfilePage(),
  };
}
