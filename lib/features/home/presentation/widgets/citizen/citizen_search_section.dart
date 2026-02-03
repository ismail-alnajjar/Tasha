import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenSearchSection extends StatelessWidget {
  const CitizenSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF134E4A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8), // Padding inside the container
        child: TextField(
          decoration: InputDecoration(
            hintText: "Find your next local adventure...",
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(Icons.search, color: primaryColor),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          style: GoogleFonts.plusJakartaSans(
            color: primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
