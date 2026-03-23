import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/cubit/auth_cubit.dart';
import '../../../../auth/cubit/auth_state.dart';
import '../citizen/citizen_home_page.dart';
import 'tourist_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.userType == 'citizen') {
            return const CitizenHomePage();
          } else {
            return const TouristHomePage();
          }
        }
        // Fallback for development or unauthenticated state
        // If we are developing and hot reload/restart, we might be in Initial state.
        // Default to TouristHomePage as it was the original.
        return const TouristHomePage();
      },
    );
  }
}
