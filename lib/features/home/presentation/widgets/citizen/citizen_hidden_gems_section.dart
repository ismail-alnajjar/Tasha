import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenHiddenGemsSection extends StatelessWidget {
  const CitizenHiddenGemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primaryColor = isDark ? Colors.white : const Color(0xFF134E4A);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Local Hidden Gems",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                "See all",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF97316),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75, // Aspect ratio for card (width/height)
            children: [
              _buildGemCard(
                context,
                title: "Secret Garden Cafe",
                distance: "0.4 miles away",
                rating: "4.9",
                imageUrl:
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCajld-drnI8cIAZYQi3QCziQj-cqNqKteqKvojDcCwgPWYu7D96Gs9aYrlI2pGUw9VxechX4CsSY-WDRafEaSTvtbeBPQsX_WYoigrFYQkw2BNRCtIoBUqucDo-mRy3zH0kkr60Zf_e4itZRGIpkEpPcz5He8w_FF9EIE3un9xRbnbhi7xFTfeKS2CaMs1xrcAzvUHxri3PgI91MLlrUuXPavBKNkVsRpRLAhwqENjWy_sZNSOkSn8moJxaT7mVqU-izM2R3PtdzZZ",
              ),
              _buildGemCard(
                context,
                title: "Riverside Trail",
                distance: "1.2 miles away",
                rating: "4.7",
                imageUrl:
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuBBZ3yIjVWZfSEUaQxV4Uw6OB9E1j3Uf3tSql6FS1KYFlNLT4zp6DxVvbkFw8JL_pfxavzOWjcWKVQb3kD6qiE5FrF0iUU3rRwmAanxnG20aw3tb-e5k396jbvDkDOGUHTCDFHTq1xrSYX6qR49RZpIfYcCVFOnyfZHD629Ij1P07b7pHR2GL-UfZt2IoaV1xC9ohKj6lDKCeaTl0TPFO0mWKoCfiEuOhyf9RmtTJvJ_w4zMP7r5IFxbuT5AEMH6GBJ_FlzOVeizTSH",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGemCard(
    BuildContext context, {
    required String title,
    required String distance,
    required String rating,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primaryColor = isDark ? Colors.white : const Color(0xFF134E4A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "LOCAL FAVORITE",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          distance,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
