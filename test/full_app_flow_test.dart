import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tashaapp/features/home/presentation/pages/HomePage.dart';
import 'package:tashaapp/main.dart';

// Import pages to verify finding them
import 'package:tashaapp/features/auth/presentation/pages/splash_page.dart';
import 'package:tashaapp/features/auth/presentation/pages/onboarding_page.dart';
import 'package:tashaapp/features/auth/presentation/pages/user_type_page.dart';
import 'package:tashaapp/features/auth/presentation/pages/login_page.dart';
import 'package:tashaapp/features/home/presentation/pages/trip_preference_page.dart';
import 'package:tashaapp/features/home/presentation/pages/duration_selection_page.dart';
import 'package:tashaapp/features/trip_planner/presentation/pages/trip_summary_page.dart';

void main() {
  testWidgets('Full App Navigation Flow Test', (WidgetTester tester) async {
    // Set a realistic screen size for the test (iPhone 14 Pro Max ish)
    // Width: 1290 / 3 = 430 logical pixels. This helps avoid overflows on tighter screens.
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3.0;

    // Reset view after test
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Load the App
    await tester.pumpWidget(const TashahApp());

    // --- Splash Page ---
    expect(find.byType(SplashPage), findsOneWidget);

    // Splash has a 3-second delay. Pump frames to advance time.
    // Sometimes a single pump isn't enough for Future.delayed in tests.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1)); // Extra second
    await tester.pumpAndSettle(); // Allow navigation animation to finish

    // --- Onboarding Page ---
    expect(find.byType(OnboardingPage), findsOneWidget);

    // Tap "Skip" if available (it might be hidden on last page, but let's try finding it)
    // Tap "Skip" if available
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
    } else {
      // If skip not found, maybe we are already at end or need to scroll?
      // Or maybe text is slightly different?
      // Try swiping to last page just in case
      await tester.drag(
        find.byType(PageView),
        const Offset(-600, 0),
      ); // Swipe left
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(PageView),
        const Offset(-600, 0),
      ); // Swipe left again
      await tester.pumpAndSettle();
    }

    // Scroll down to find the button if needed (now using CustomScrollView)
    try {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
    } catch (e) {
      // Ignore if scrolling fails or not needed
    }
    // Find "Get Started" and tap
    final getStartedBtn = find.widgetWithText(ElevatedButton, 'Get Started');

    // Ensure one widget is found before tapping
    expect(getStartedBtn, findsOneWidget);

    await tester.tap(getStartedBtn);
    await tester.pumpAndSettle();

    // --- User Type Page ---
    expect(find.byType(UserTypePage), findsOneWidget);

    // Select "I am a Tourist"
    await tester.tap(find.text('I am a Tourist'));
    await tester.pump(); // Rebuild for state change

    // Tap "Continue"
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // --- Login Page ---
    expect(find.byType(LoginPage), findsOneWidget);

    // Tap "Login" (We skip entering text as it's not validated yet in previous code, just navigation)
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // --- Home Page ---
    expect(find.byType(HomePage), findsOneWidget);

    // Tap "New Trip" on CustomFloatingNavBar
    await tester.tap(find.text('New Trip'));
    await tester.pumpAndSettle();

    // --- Trip Preference Page ---
    expect(find.byType(TripPreferencePage), findsOneWidget);

    // Select "Nature" (It's likely the first one or visible)
    await tester.tap(find.text('Nature'));
    await tester.pump();

    // Tap "Continue"
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // --- Duration Selection Page ---
    expect(find.byType(DurationSelectionPage), findsOneWidget);

    // Select duration (Scroll list wheel? Or just use default and confirm)
    // Default is 3. Let's just tap Confirm.
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // --- Trip Summary Page ---
    expect(find.byType(TripSummaryPage), findsOneWidget);

    // Verify details
    expect(find.text('Trip Preferences'), findsOneWidget);
    // Note: The summary page might show "Trip Duration: 3" or similar.
    // Let's check for the number.
    expect(find.textContaining('3'), findsOneWidget);
    // Category check
    expect(find.textContaining('Nature'), findsOneWidget);
  });
}
