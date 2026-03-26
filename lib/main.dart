import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'core/cubit/theme_cubit.dart';
import 'core/cubit/locale_cubit.dart';
import 'features/home/cubit/report_cubit.dart';
import 'features/home/cubit/notification_cubit.dart';
import 'features/home/cubit/hidden_gem_cubit.dart';
import 'features/home/cubit/local_host_cubit.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Global Firebase Service (Clean Implementation)
  final firebaseService = FirebaseService();
  await firebaseService.initialize();

  runApp(const TashahApp());
}

class TashahApp extends StatefulWidget {
  const TashahApp({super.key});

  @override
  State<TashahApp> createState() => _TashahAppState();
}

class _TashahAppState extends State<TashahApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh notifications when app is back to foreground
      // Note: We need the original context or a reference to reload
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()),
        BlocProvider<ReportCubit>(create: (context) => ReportCubit()),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit(),
        ),
        BlocProvider<HiddenGemCubit>(create: (context) => HiddenGemCubit()),
        BlocProvider<LocalHostCubit>(create: (context) => LocalHostCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is AuthAuthenticated) {
                debugPrint(
                  '🔍 Auth state detected! UserType: ${state.userType}',
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && state.userType == 'citizen') {
                  // Start Firestore listening
                  context.read<NotificationCubit>().startListening(user.uid);

                  // Ensure subscription to citizen topic
                  await FirebaseService().subscribeToUserTopic(user.uid);
                  // Also subscribe to a general 'citizens' topic for testing
                  await FirebaseMessaging.instance.subscribeToTopic(
                    'all_citizens',
                  );
                }
              } else if (state is AuthUnauthenticated) {
                debugPrint('🔍 Auth state: Unauthenticated');
                context.read<NotificationCubit>().stopListening();

                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseService().unsubscribeFromUserTopic(user.uid);
                }
              }
            },
          ),
          // Listener to handle background refresh
        ],
        child: Builder(
          builder: (context) {
            // Trigger auth check ONLY once after the listener is ready
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AuthCubit>().checkAuthStatus();
            });
            return _buildMaterialApp(context);
          },
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Widget _buildMaterialApp(BuildContext context) {
    // Pass the navigator key if available or use the builder below
    final themeMode = context.watch<ThemeCubit>().state;
    final locale = context.watch<LocaleCubit>().state;

    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      builder: (context, child) {
        // Setup listener using a context that is UNDER the MultiBlocProvider but stable
        FirebaseService().setupForegroundListener(context, _messengerKey);
        return child!;
      },
      title: 'Tashah | طَشّة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
