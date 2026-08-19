class ProfileModel {
  final String id;
  final String role; // 'senior', 'caregiver', 'institution_admin'
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    required this.role,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      role: json['role'] as String? ?? 'senior',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }
}
