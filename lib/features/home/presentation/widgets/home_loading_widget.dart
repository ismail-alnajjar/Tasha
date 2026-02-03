import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use dark/light shimmer colors based on theme, or force dark if desired
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SingleChildScrollView(
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling during loading
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Bar Spacer matching HomePage
            SizedBox(height: MediaQuery.of(context).padding.top + 8),

            // Top App Bar Skeleton
            Row(
              children: [
                const _CircleSkeleton(size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _SkeletonBar(width: 100, height: 12),
                      SizedBox(height: 8),
                      _SkeletonBar(width: 150, height: 18),
                    ],
                  ),
                ),
                const _CircleSkeleton(size: 40),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar Skeleton
            const _SkeletonBar(width: double.infinity, height: 56, radius: 16),
            const SizedBox(height: 16),

            // Categories Skeleton
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    const _SkeletonBar(width: 90, height: 44, radius: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Section Header Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _SkeletonBar(width: 180, height: 24),
                _SkeletonBar(width: 60, height: 14),
              ],
            ),
            const SizedBox(height: 16),

            // Destination Cards Skeleton
            const _DestinationCardSkeleton(),
            const SizedBox(height: 16),
            const _DestinationCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBar({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _CircleSkeleton extends StatelessWidget {
  final double size;
  const _CircleSkeleton({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DestinationCardSkeleton extends StatelessWidget {
  const _DestinationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        const SizedBox(height: 12),
        // Title placeholder
        const _SkeletonBar(width: 200, height: 20),
        const SizedBox(height: 8),
        // Subtitle placeholder
        const _SkeletonBar(width: 150, height: 14),
      ],
    );
  }
}
