import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tashaapp/core/services/api_service.dart';
import 'package:tashaapp/features/home/cubit/offer_cubit.dart';
import 'package:tashaapp/features/home/cubit/offer_state.dart';
import 'package:tashaapp/features/home/data/models/offer_model.dart';
import 'package:tashaapp/features/home/data/repositories/offer_repository.dart';

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
  final Color primaryColor = const Color(0xFF006948);
  final Color primaryContainer = const Color(0xFF00855d);
  final Color surfaceColor = const Color(0xFFf9f9f9);
  final Color onSurfaceVariant = const Color(0xFF3d4a42);
  final Color errorColor = const Color(0xFFba1a1a);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = screenWidth / 375;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : primaryColor),
        ),
        title: Text(
          'Exclusive Offers',
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : primaryColor,
          ),
        ),
        centerTitle: true,
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: state.offers.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildHeader(isDark);
                  return _buildOfferCard(state.offers[index - 1], isDark, scale);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
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
          const SizedBox(height: 8),
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
    );
  }

  String? _buildImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    String sanitized = raw.replaceAll('\\', '/');
    
    // اكتشاف الـ IP النشط حالياً من ApiService
    final String apiBase = ApiService().dio.options.baseUrl.replaceAll('/api', '');
    final Uri apiUri = Uri.parse(apiBase);
    final String activeHost = apiUri.host;
    // القاعدة: الـ IP النشط + منفذ الصور 5010 قسراً
    final String forcedBase = 'http://$activeHost:5010';
    
    if (sanitized.startsWith('http')) {
      final Uri uri = Uri.parse(sanitized);
      sanitized = '$forcedBase${uri.path}';
    } else {
      sanitized = '$forcedBase${sanitized.startsWith('/') ? '' : '/'}$sanitized';
    }
    return sanitized;
  }

  Widget _buildOfferCard(OfferModel offer, bool isDark, double scale) {
    final imageUrl = _buildImageUrl(offer.imageUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200]!,
                        highlightColor: isDark ? const Color(0xFF3D3D3D) : Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stack) => _buildPlaceholder(),
                  )
                else
                  _buildPlaceholder(),
                
                // Overlay Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: offer.discountPercentage > 0 
                    ? _buildBadge('${offer.discountPercentage.toInt()}% OFF', errorColor)
                    : const SizedBox.shrink(),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildBadge(
                    offer.isActive ? 'ACTIVE' : 'EXPIRED', 
                    offer.isActive ? primaryColor.withOpacity(0.9) : Colors.grey.withOpacity(0.9)
                  ),
                ),
              ],
            ),
          ),
          
          // Details Section
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
                const SizedBox(height: 6),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (offer.originalPrice > offer.priceAfterDiscount)
                          Text(
                            'JOD ${offer.originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
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
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        elevation: 4,
                      ),
                      child: Text('Book Now', style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.image_outlined, size: 40, color: Colors.grey)),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 300,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(child: Text('No offers available at the moment.'));
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          TextButton(
            onPressed: () => context.read<OfferCubit>().fetchOffers(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
