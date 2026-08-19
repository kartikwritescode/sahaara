class GeofenceModel {
  final String id;
  final String seniorId;
  final String name;
  final double centerLat;
  final double centerLng;
  final int radiusM;
  final String zoneType; // 'home', 'safe', 'custom'

  GeofenceModel({
    required this.id,
    required this.seniorId,
    required this.name,
    required this.centerLat,
    required this.centerLng,
    required this.radiusM,
    required this.zoneType,
  });

  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    return GeofenceModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      name: json['name'] as String,
      centerLat: (json['center_lat'] as num).toDouble(),
      centerLng: (json['center_lng'] as num).toDouble(),
      radiusM: json['radius_m'] as int? ?? 500,
      zoneType: json['zone_type'] as String? ?? 'home',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'name': name,
      'center_lat': centerLat,
      'center_lng': centerLng,
      'radius_m': radiusM,
      'zone_type': zoneType,
    };
  }
}
