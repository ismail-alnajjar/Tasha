import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.sizeOf(context).width / 375;
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          'Promotions and Discounts for Citizens',
          style: GoogleFonts.plusJakartaSans(fontSize: 16 * scale),
        ),
      ),
    );
  }
}
