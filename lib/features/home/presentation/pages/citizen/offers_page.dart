import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/features/home/cubit/offer_cubit.dart';
import 'package:tashaapp/features/home/cubit/offer_state.dart';
import 'package:tashaapp/features/home/data/models/offer_model.dart';
import 'package:tashaapp/features/home/data/repositories/offer_repository.dart';
import 'package:shimmer/shimmer.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfferCubit(OfferRepository())..fetchOffers(),
      child: const OffersView(),
    );
  }
}

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  // Theme Colors from design
  final Color primaryColor = const Color(0xFF006948);
  final Color primaryContainer = const Color(0xFF00855d);
  final Color surfaceColor = const Color(0xFFf9f9f9);
  final Color onSurfaceVariant = const Color(0xFF3d4a42);
  final Color errorColor = const Color(0xFFba1a1a);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : surfaceColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : primaryColor,
                    ),
                    style: IconButton.styleFrom(
                      hoverColor: primaryColor.withOpacity(0.05),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Exclusive Offers',
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Symmetry spacer
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<OfferCubit, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading || state is OfferInitial) {
            return _buildLoading();
          } else if (state is OfferError) {
            return _buildError(context, state.message);
          } else if (state is OfferLoaded) {
            if (state.offers.isEmpty) {
              return _buildEmpty();
            }
            return RefreshIndicator(
              onRefresh: () => context.read<OfferCubit>().fetchOffers(),
              color: primaryColor,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                children: [
                  // Section Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experience Jordan',
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Curated escapes and local dining exclusively for citizens.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // List items
                  ...state.offers.map((offer) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _buildOfferCard(offer, isDark),
                      )),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOfferCard(OfferModel offer, bool isDark) {
    String? imageUrl;
    if (offer.imageUrl != null && offer.imageUrl!.isNotEmpty) {
      String sanitized = offer.imageUrl!.replaceAll('\\', '/');
      if (!sanitized.startsWith('http')) {
        sanitized = 'http://192.168.1.27:5000${sanitized.startsWith('/') ? '' : '/'}$sanitized';
      }
      imageUrl = sanitized;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {}, // Interaction animation
        child: Column(
          children: [
            // Image Section
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImagePlaceholder(),
                        )
                      : _buildImagePlaceholder(),
                ),
                // Discount Badge
                if (offer.discountPercentage > 0)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${offer.discountPercentage.toInt()}% OFF',
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Status Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Text(
                          offer.isActive ? 'ACTIVE' : 'EXPIRED',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Text(
                        offer.endDate != null 
                          ? 'Valid until ${_formatDate(offer.endDate!)}'
                          : 'Limited time offer',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (offer.originalPrice > 0)
                            Text(
                              'JOD ${offer.originalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            'JOD ${offer.priceAfterDiscount.toStringAsFixed(2)}',
                            style: GoogleFonts.lexend(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, primaryContainer],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Text(
                            'View Details',
                            style: GoogleFonts.lexend(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image_outlined, size: 48, color: Colors.grey[400]),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFf3f3f3),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Icon(Icons.explore_off, size: 60, color: Colors.grey[300]),
                   Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [primaryColor.withOpacity(0.1), Colors.transparent],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Offers Found',
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't find any specific offers for your current location. Check back later!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<OfferCubit>().fetchOffers(),
              child: Text(
                'Refresh Listings',
                style: GoogleFonts.lexend(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: errorColor),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          TextButton(
            onPressed: () => context.read<OfferCubit>().fetchOffers(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
