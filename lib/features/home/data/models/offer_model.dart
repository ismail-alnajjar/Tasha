import 'package:equatable/equatable.dart';

class OfferModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final double originalPrice;
  final double priceAfterDiscount;
  final String discountCode;
  final double discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final int? tripId;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.originalPrice,
    required this.priceAfterDiscount,
    required this.discountCode,
    required this.discountPercentage,
    this.startDate,
    this.endDate,
    required this.isActive,
    this.tripId,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['ImageUrl']?.toString() ?? json['image']?.toString(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble() ?? 0.0,
      discountCode: json['discountCode']?.toString() ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'].toString()) : null,
      isActive: json['isActive'] ?? false,
      tripId: (json['tripId'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        originalPrice,
        priceAfterDiscount,
        discountCode,
        discountPercentage,
        startDate,
        endDate,
        isActive,
        tripId,
      ];
}
