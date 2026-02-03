import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenWeekendPlansSection extends StatelessWidget {
  const CitizenWeekendPlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF134E4A);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekend Plans",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                "Discover",
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
        SizedBox(
          height: 260,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            children: [
              _buildPlanCard(
                context,
                title: "Sunset Farmers Market",
                location: "Civic Plaza, Downtown",
                dateDay: "22",
                dateMonth: "JUL",
                tags: ["Community", "Trending"],
                imageUrl:
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuBfyimimwW7gcx15xl2DstQZF2pZVoEokDIP_KxDsJ62Dj8NjdnEc4VE3NhCsoAl5ejqxkdMhbqbc_Ot6NFF8qQhv7t3pFBB2ZIWbnBu3RgH36YM7C9C7h7vyCtUoiGkNLYEtGo77T2cJYiOmb5lvdkMXYMniKYh1EBW0_HTWpQrbaPvh_xNc50LPhVn6rePxrtEM5sP5Nl8esPjEJt1hmKywIwWSpER9VYBS7RBRHgfKksUaNvpYBw4RItlNHDap43NjJnGYrtyYVN",
              ),
              const SizedBox(width: 16),
              _buildPlanCard(
                context,
                title: "Pottery Workshop",
                location: "The Ceramic Loft",
                dateDay: "23",
                dateMonth: "JUL",
                tags: ["Art"],
                imageUrl:
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCpfvVxN8Liseb-pWGU50q9RRvHpVtsvEQYfNlXyeyrVezEsqHe7N3HwNS3YvVh5co69uKxT7RdkxCA7uPtb9rPiJcT9E8EvdHaXiHkv0ayS5d0drN69h8WWOhXn5nO7lRIMor3s3OZ9bH--lQWSdL0WOuXi_sldUxJhrARjNDkgpKHFl29FvQ2I2yyyCJGwVIBP3giVPz1el10E2eE8TP564Pt6Fwa8iYEs81SiKHogPJKOkGeynWRPeBvJIgLsjwcygYPNkXPG4n6",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String location,
    required String dateDay,
    required String dateMonth,
    required List<String> tags,
    required String imageUrl,
  }) {
    const Color primaryColor = Color(0xFF134E4A);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            dateMonth,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            dateDay,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: tags.map((tag) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tag == "Community"
                              ? primaryColor.withOpacity(0.1)
                              : const Color(0xFFF97316).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tag == "Community"
                                ? primaryColor
                                : const Color(0xFFF97316),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
