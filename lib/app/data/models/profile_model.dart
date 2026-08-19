class ProfileModel {
  final String id;
  final String role; // 'senior', 'caregiver', 'institution_admin'
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;
  final int riskScore;
  final String relationship;
  final String lastActive;

  ProfileModel({
    required this.id,
    required this.role,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.createdAt,
    this.riskScore = 0,
    this.relationship = 'Senior',
    this.lastActive = 'Active now',
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'role':
        return role;
      case 'full_name':
        return fullName;
      case 'phone':
        return phone;
      case 'avatar_url':
        return avatarUrl;
      case 'risk_score':
        return riskScore;
      case 'relationship':
        return relationship;
      case 'last_active':
        return lastActive;
      default:
        return null;
    }
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? 'senior',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      riskScore: json['risk_score'] as int? ?? 0,
      relationship: json['relationship'] as String? ?? 'Senior',
      lastActive: json['last_active'] as String? ?? 'Active now',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'risk_score': riskScore,
      'relationship': relationship,
      'last_active': lastActive,
    };
  }
}
