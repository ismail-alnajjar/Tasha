import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_utils.dart';

class PlaceModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final String location;
  final double rating;
  final String category;
  final String? price;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.location,
    required this.rating,
    required this.category,
    this.price,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final String? rawImage = _parseRaw(
        json['imageUrl'] ?? 
        json['ImageUrl'] ?? 
        json['image'] ?? 
        json['Image'] ?? 
        json['photoUrl'] ?? 
        json['PhotoUrl'] ??
        json['photos'] ??
        json['Photos']
      );
      
      final dynamic idValue = json['id'] ?? json['Id'] ?? 0;
      final int id = idValue is int ? idValue : int.tryParse(idValue.toString()) ?? 0;
      
      final dynamic ratingValue = json['rating'] ?? json['Rating'] ?? 0.0;
      final double rating = ratingValue is num ? ratingValue.toDouble() : double.tryParse(ratingValue.toString()) ?? 0.0;
      
      return PlaceModel(
        id: id,
        name: (json['name'] ?? json['Name'] ?? json['title'] ?? json['Title'] ?? 'No Name').toString(),
        description: (json['description'] ?? json['Description'] ?? 'No Description').toString(),
        imageUrl: ImageUrlUtils.normalize(rawImage),
        location: (json['location'] ?? json['Location'] ?? json['city'] ?? json['City'] ?? 'Location N/A').toString(),
        rating: rating,
        category: (json['category'] ?? json['Category'] ?? '').toString(),
        price: (json['price'] ?? json['Price'] ?? json['cost'] ?? json['Cost'])?.toString(),
      );
  }

  static String? _parseRaw(dynamic field) {
    if (field == null) return null;
    if (field is List && field.isNotEmpty) return field.first.toString();
    if (field is String && field.isNotEmpty) {
      if (field.contains(';')) return field.split(';').first.trim();
      return field;
    }
    return field.toString();
  }

  @override
  List<Object?> get props => [id, name, description, imageUrl, location, rating, category, price];
}
