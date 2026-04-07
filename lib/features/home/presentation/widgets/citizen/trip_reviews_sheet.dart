import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/features/home/cubit/review_cubit.dart';
import 'package:tashaapp/features/home/cubit/review_state.dart';
import 'package:tashaapp/features/home/data/models/review_model.dart';
import 'package:tashaapp/features/home/data/repositories/review_repository.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripReviewsSheet extends StatelessWidget {
  final int tripId;

  const TripReviewsSheet({super.key, required this.tripId});

  static void show(BuildContext context, int tripId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TripReviewsSheet(tripId: tripId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewCubit(ReviewRepository())..fetchReviews(tripId),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: _ReviewsContent(tripId: tripId),
        ),
      ),
    );
  }
}

class _ReviewsContent extends StatefulWidget {
  final int tripId;
  const _ReviewsContent({required this.tripId});

  @override
  State<_ReviewsContent> createState() => _ReviewsContentState();
}

class _ReviewsContentState extends State<_ReviewsContent> {
  int _selectedRating = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment.')),
      );
      return;
    }

    final cubit = context.read<ReviewCubit>();
    
    final user = FirebaseAuth.instance.currentUser;
    cubit.submitReview(
      tripId: widget.tripId,
      rating: _selectedRating,
      comment: _commentController.text.trim(),
      reviewerName: user?.displayName ?? 'Citizen', 
      firebaseUid: user?.uid ?? 'anonymous',
    );
    _commentController.clear();
    setState(() {
      _selectedRating = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : const Color(0xFF134E4A);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(),

        // Reviews List
        Expanded(
          child: BlocConsumer<ReviewCubit, ReviewState>(
            listener: (context, state) {
              if (state is ReviewSubmitted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ReviewSubmitError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            buildWhen: (previous, current) => current is ReviewLoading || current is ReviewLoaded || current is ReviewError,
            builder: (context, state) {
              if (state is ReviewLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReviewError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.message),
                      TextButton(
                        onPressed: () {
                          context.read<ReviewCubit>().fetchReviews(widget.tripId);
                        },
                        child: const Text('Try Again'),
                      )
                    ],
                  ),
                );
              } else if (state is ReviewLoaded) {
                if (state.reviews.isEmpty) {
                  return Center(
                    child: Text(
                      "No reviews yet. Be the first to review!",
                      style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: state.reviews.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return _buildReviewItem(review, theme, isDark);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),

        // Write a review section
        _buildWriteReviewSection(theme, isDark),
      ],
    );
  }

  Widget _buildReviewItem(ReviewModel review, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.reviewerName,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          if (review.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              DateFormat.yMMMd().format(review.createdAt!),
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReviewSection(ThemeData theme, bool isDark) {
    final primaryColor = isDark ? Colors.white : const Color(0xFF134E4A);
    final isSubmitting = context.watch<ReviewCubit>().state is ReviewSubmitting;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white12 : Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Rate your experience",
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    size: 28,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Write your review...",
                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark ? theme.cardColor : Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: isSubmitting ? null : _submitReview,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: isDark ? Colors.black : Colors.white,
                          size: 20,
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
