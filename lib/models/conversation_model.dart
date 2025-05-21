import 'package:communication_practice/models/message_model.dart';

class ConversationModel {
  final String id;
  final String categoryId;
  final String title;
  final String topic;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double? score;
  final String feedback;
  final List<MessageModel> messages;
  final bool isCompleted;

  ConversationModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.topic,
    required this.createdAt,
    this.completedAt,
    this.score,
    this.feedback = '',
    this.messages = const [],
    this.isCompleted = false,
  });

  ConversationModel copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? topic,
    DateTime? createdAt,
    DateTime? completedAt,
    double? score,
    String? feedback,
    List<MessageModel>? messages,
    bool? isCompleted,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      messages: messages ?? this.messages,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      topic: json['topic'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      score: json['score']?.toDouble(),
      feedback: json['feedback'] ?? '',
      messages: json['messages'] != null
          ? List<MessageModel>.from(json['messages'].map((x) => MessageModel.fromJson(x)))
          : [],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'topic': topic,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'score': score,
      'feedback': feedback,
      'messages': messages.map((x) => x.toJson()).toList(),
      'is_completed': isCompleted,
    };
  }
}