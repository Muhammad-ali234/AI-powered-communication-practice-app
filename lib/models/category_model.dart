import 'package:flutter/material.dart';

enum CategoryDifficulty { beginner, intermediate, advanced, expert }

extension CategoryDifficultyExtension on CategoryDifficulty {
  String get name {
    switch (this) {
      case CategoryDifficulty.beginner:
        return 'Beginner';
      case CategoryDifficulty.intermediate:
        return 'Intermediate';
      case CategoryDifficulty.advanced:
        return 'Advanced';
      case CategoryDifficulty.expert:
        return 'Expert';
    }
  }
  
  Color get color {
    switch (this) {
      case CategoryDifficulty.beginner:
        return Colors.green;
      case CategoryDifficulty.intermediate:
        return Colors.blue;
      case CategoryDifficulty.advanced:
        return Colors.orange;
      case CategoryDifficulty.expert:
        return Colors.red;
    }
  }
}

class CategoryModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final Color color;
  final CategoryDifficulty difficulty;
  final int conversationsCount;
  final List<String> topics;
  final bool isPremium;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.color,
    required this.difficulty,
    this.conversationsCount = 0,
    this.topics = const [],
    this.isPremium = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['icon_name'],
      color: Color(int.parse(json['color'], radix: 16)).withOpacity(1.0),
      difficulty: CategoryDifficulty.values.firstWhere(
        (e) => e.name.toLowerCase() == json['difficulty'].toLowerCase(),
        orElse: () => CategoryDifficulty.beginner,
      ),
      conversationsCount: json['conversations_count'] ?? 0,
      topics: List<String>.from(json['topics'] ?? []),
      isPremium: json['is_premium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'color': color.value.toRadixString(16),
      'difficulty': difficulty.name.toLowerCase(),
      'conversations_count': conversationsCount,
      'topics': topics,
      'is_premium': isPremium,
    };
  }
}