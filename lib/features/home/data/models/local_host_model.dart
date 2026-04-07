class LocalHostModel {
  final int id;
  final String title;
  final String description;
  final String city;
  final String activities;
  final String citizenPhone;
  final String citizenName;
  final String citizenUserId;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String status;
  final String? adminReply;

  LocalHostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.activities,
    required this.citizenPhone,
    required this.citizenName,
    required this.citizenUserId,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.status,
    this.adminReply,
  });

  factory LocalHostModel.fromJson(Map<String, dynamic> json) {
    return LocalHostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      activities: json['activities'] ?? '',
      citizenPhone: json['citizenPhone'] ?? '',
      citizenName: json['citizenName'] ?? '',
      citizenUserId: json['citizenUserId'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      status: json['status'] ?? json['Status'] ?? ([true, 1, 'true', '1'].contains(json['isApproved']) ? 'Approved' : 'Pending'),
      adminReply: json['adminReply'] ?? json['AdminReply'],
    );
  }
}
