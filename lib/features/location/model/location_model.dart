class LocationModel {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final double radiusM;
  final bool isActive;

  LocationModel({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.radiusM,
    required this.isActive,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      locationName: json['location_name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusM: (json['radius_m'] as num).toDouble(),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'radius_m': radiusM,
      'is_active': isActive,
    };
  }

  // Backward compatibility getters
  String get name => locationName;
  double get radius => radiusM;

  LocationModel copyWith({
    String? id,
    String? locationName,
    double? latitude,
    double? longitude,
    double? radiusM,
    bool? isActive,
  }) {
    return LocationModel(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusM: radiusM ?? this.radiusM,
      isActive: isActive ?? this.isActive,
    );
  }
}
