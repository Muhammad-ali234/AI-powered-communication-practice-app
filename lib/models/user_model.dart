class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String bio;
  final int conversationsCompleted;
  final int streak;
  final double averageScore;
  final List<String> badges;
  final DateTime createdAt;
  final DateTime lastActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.bio = '',
    this.conversationsCompleted = 0,
    this.streak = 0,
    this.averageScore = 0.0,
    this.badges = const [],
    required this.createdAt,
    required this.lastActive,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    int? conversationsCompleted,
    int? streak,
    double? averageScore,
    List<String>? badges,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      conversationsCompleted: conversationsCompleted ?? this.conversationsCompleted,
      streak: streak ?? this.streak,
      averageScore: averageScore ?? this.averageScore,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photo_url'] ?? '',
      bio: json['bio'] ?? '',
      conversationsCompleted: json['conversations_completed'] ?? 0,
      streak: json['streak'] ?? 0,
      averageScore: (json['average_score'] ?? 0.0).toDouble(),
      badges: List<String>.from(json['badges'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      lastActive: DateTime.parse(json['last_active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'bio': bio,
      'conversations_completed': conversationsCompleted,
      'streak': streak,
      'average_score': averageScore,
      'badges': badges,
      'created_at': createdAt.toIso8601String(),
      'last_active': lastActive.toIso8601String(),
    };
  }
}