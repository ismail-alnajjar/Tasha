class ReviewModel {
  final int id;
  final int tripId;
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.tripId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      tripId: json['tripId'] ?? 0,
      reviewerName: json['reviewerName'] ?? 'Unknown',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}
