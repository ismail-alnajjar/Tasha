import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenHeaderSection extends StatelessWidget {
  final String userName;
  final String userImage;
  final int notificationCount;

  const CitizenHeaderSection({
    super.key,
    required this.userName,
    required this.userImage,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const Color primaryColor = Color(0xFF134E4A);
    const Color orangeColor = Color(0xFFF97316);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "WELCOME NEIGHBOR",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryColor.withOpacity(0.7),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                userName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: orangeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
