enum AchievementCategory {
  conversations,
  scores,
  streaks,
  topics
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final AchievementCategory category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int requiredCount;
  final int currentCount;
  
  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.requiredCount,
    this.currentCount = 0,
  });
  
  double get progress => requiredCount > 0 
      ? (currentCount / requiredCount).clamp(0.0, 1.0) 
      : 0.0;
  
  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    AchievementCategory? category,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? requiredCount,
    int? currentCount,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requiredCount: requiredCount ?? this.requiredCount,
      currentCount: currentCount ?? this.currentCount,
    );
  }
  
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['icon_name'],
      category: AchievementCategory.values.firstWhere(
        (e) => e.toString() == 'AchievementCategory.${json['category']}',
        orElse: () => AchievementCategory.conversations,
      ),
      isUnlocked: json['is_unlocked'] ?? false,
      unlockedAt: json['unlocked_at'] != null 
          ? DateTime.parse(json['unlocked_at']) 
          : null,
      requiredCount: json['required_count'],
      currentCount: json['current_count'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'category': category.toString().split('.').last,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'required_count': requiredCount,
      'current_count': currentCount,
    };
  }
} 