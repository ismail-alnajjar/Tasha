import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class CustomFloatingNavBar extends StatelessWidget {
  const CustomFloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home Button
            IconButton(
              icon: const Icon(Icons.home_filled, color: Colors.white),
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                }
              },
              tooltip: 'Home',
            ),
            // New Travel Button (Center Prominent)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.tripPreference);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "New Trip",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile/Account Button
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
