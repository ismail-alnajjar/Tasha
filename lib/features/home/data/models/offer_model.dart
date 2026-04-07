import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_utils.dart';

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
      id: _parseId(json['id'] ?? json['Id']),
      title: (json['title'] ?? json['Title'] ?? '').toString(),
      description: (json['description'] ?? json['Description'] ?? '').toString(),
      imageUrl: ImageUrlUtils.normalize(_parseImage(
        json['imageUrl'] ?? 
        json['ImageUrl'] ?? 
        json['image'] ?? 
        json['Image'] ?? 
        json['photoUrl'] ?? 
        json['PhotoUrl'] ??
        json['photos'] ??
        json['Photos']
      )),
      originalPrice: _parsePrice(json['originalPrice'] ?? json['OriginalPrice']),
      priceAfterDiscount: _parsePrice(json['priceAfterDiscount'] ?? json['PriceAfterDiscount']),
      discountCode: (json['discountCode'] ?? json['DiscountCode'] ?? '').toString(),
      discountPercentage: _parsePrice(json['discountPercentage'] ?? json['DiscountPercentage']),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'].toString()) : null,
      isActive: json['isActive'] ?? json['IsActive'] ?? false,
      tripId: json['tripId'] != null ? _parseId(json['tripId']) : null,
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String? _parseImage(dynamic field) {
    if (field == null) return null;
    if (field is List && field.isNotEmpty) return field.first.toString();
    if (field is String && field.isNotEmpty) {
      if (field.contains(';')) return field.split(';').first.trim();
      return field;
    }
    return field.toString();
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
