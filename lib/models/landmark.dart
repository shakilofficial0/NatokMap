/// Model: Landmark
/// Represents a landmark entity with all required fields
class Landmark {
  final int? id;
  final String title;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final String? localImagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;

  Landmark({
    this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.localImagePath,
    this.createdAt,
    this.updatedAt,
    this.isSynced = true,
  });

  /// Create Landmark from JSON
  factory Landmark.fromJson(Map<String, dynamic> json) {
    // Convert relative image URL to absolute URL
    String? imageUrl;
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      final imagePath = json['image'].toString();
      if (!imagePath.startsWith('http')) {
        // Relative path - prepend base URL
        imageUrl = 'https://labs.anontech.info/cse489/t3/$imagePath';
      } else {
        // Already absolute URL
        imageUrl = imagePath;
      }
    }

    return Landmark(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      title: json['title'] ?? '',
      latitude: _parseDouble(json['lat']),
      longitude: _parseDouble(json['lon']),
      imageUrl: imageUrl,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      isSynced: json['is_synced'] ?? true,
    );
  }

  /// Convert Landmark to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lat': latitude,
      'lon': longitude,
      'image': imageUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  /// Convert to database map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'local_image_path': localImagePath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  /// Create from database map
  factory Landmark.fromDbMap(Map<String, dynamic> map) {
    return Landmark(
      id: map['id'],
      title: map['title'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imageUrl: map['image_url'],
      localImagePath: map['local_image_path'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
      isSynced: map['is_synced'] == 1,
    );
  }

  /// Copy with method for updating properties
  Landmark copyWith({
    int? id,
    String? title,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? localImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Landmark(
      id: id ?? this.id,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() {
    return 'Landmark(id: $id, title: $title, lat: $latitude, lon: $longitude)';
  }
}
