// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tashaapp/features/home/presentation/pages/tourist/HomePage.dart';
import 'package:tashaapp/features/profile/presentation/pages/profile_page.dart';
import 'package:tashaapp/features/trip_planner/presentation/pages/trip_planner_page.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/user_type_page.dart';
import '../../features/home/presentation/pages/duration_selection_page.dart';
import '../../features/home/presentation/pages/tourist/trip_preference_page.dart';
import '../../features/trip_planner/presentation/pages/trip_summary_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/citizen/explore_page.dart';
import '../../features/home/presentation/pages/citizen/saved_page.dart';
import '../../features/profile/presentation/pages/my_bookings_page.dart';
import '../../features/profile/presentation/pages/payment_methods_page.dart';
import '../../features/profile/presentation/pages/collaborative_groups_page.dart';
import '../../features/home/presentation/pages/citizen/offers_page.dart';
import '../../features/home/presentation/pages/citizen/report_page.dart';
import '../../features/home/presentation/pages/citizen/add_place_page.dart';
import '../../features/home/presentation/pages/citizen/host_tourist_page.dart';

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
  static const String forgotPassword = '/forgot_password';

  // Citizen Pages
  static const String explore = '/explore';
  static const String saved = '/saved';
  static const String myBookings = '/my_bookings';
  static const String paymentMethods = '/payment_methods';
  static const String collaborativeGroups = '/collaborative_groups';
  static const String offers = '/offers';
  static const String report = '/report';
  static const String addPlace = '/add_place';
  static const String hostTourist = '/host_tourist';

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
        categories: args['categories'],
        duration: args['duration'],
      );
    },
    profile: (context) => const ProfilePage(),
    forgotPassword: (context) => const ForgotPasswordPage(),

    // Citizen & Extra Routes
    explore: (context) => const ExplorePage(),
    saved: (context) => const SavedPage(),
    myBookings: (context) => const MyBookingsPage(),
    paymentMethods: (context) => const PaymentMethodsPage(),
    collaborativeGroups: (context) => const CollaborativeGroupsPage(),
    offers: (context) => const OffersPage(),
    report: (context) => const ReportPage(),
    addPlace: (context) => const AddPlacePage(),
    hostTourist: (context) => const HostTouristPage(),
  };
}
