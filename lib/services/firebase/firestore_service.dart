import 'package:flutter/material.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/models/message_model.dart';
import 'package:communication_practice/models/achievement_model.dart';

class FirestoreService {
  bool useMock = true;

  // Mock Categories
  final List<CategoryModel> _mockCategories = [
    CategoryModel(
      id: '1',
      title: 'Job Interviews',
      description: 'Practice common job interview scenarios and questions to boost your confidence.',
      iconName: 'work',
      color: const Color(0xFF3563E9),
      difficulty: CategoryDifficulty.intermediate,
      topics: ['Tell me about yourself', 'Strengths and weaknesses', 'Behavioral questions', 'Situational scenarios', 'Salary negotiation'],
    ),
    CategoryModel(
      id: '2',
      title: 'Public Speaking',
      description: 'Overcome stage fright and learn effective public speaking techniques.',
      iconName: 'record_voice_over',
      color: const Color(0xFF8C62EC),
      difficulty: CategoryDifficulty.advanced,
      topics: ['Introduction techniques', 'Body language', 'Voice modulation', 'Handling Q&A', 'Closing strong'],
    ),
    CategoryModel(
      id: '3',
      title: 'Social Situations',
      description: 'Navigate social gatherings with confidence and make meaningful connections.',
      iconName: 'groups',
      color: const Color(0xFFFFA500),
      difficulty: CategoryDifficulty.beginner,
      topics: ['Starting conversations', 'Active listening', 'Finding common interests', 'Group discussions', 'Graceful exits'],
    ),
    CategoryModel(
      id: '4',
      title: 'Business Negotiations',
      description: 'Master the art of negotiation for business deals and professional settings.',
      iconName: 'handshake',
      color: const Color(0xFF4CAF50),
      difficulty: CategoryDifficulty.expert,
      isPremium: true,
      topics: ['Opening strategies', 'Interest-based bargaining', 'Countering tactics', 'Deal structuring', 'Closing negotiations'],
    ),
    CategoryModel(
      id: '5',
      title: 'Conflict Resolution',
      description: 'Learn to address and resolve conflicts in personal and professional settings.',
      iconName: 'balance',
      color: const Color(0xFFE53935),
      difficulty: CategoryDifficulty.intermediate,
      topics: ['Identifying conflicts', 'Active listening', 'Finding common ground', 'De-escalation techniques', 'Win-win solutions'],
    ),
    CategoryModel(
      id: '6',
      title: 'Dating Conversations',
      description: 'Build confidence for first dates and develop meaningful relationships.',
      iconName: 'favorite',
      color: const Color(0xFFEC407A),
      difficulty: CategoryDifficulty.beginner,
      topics: ['Breaking the ice', 'Asking meaningful questions', 'Sharing personal stories', 'Showing interest', 'Follow-up conversations'],
    ),
    CategoryModel(
      id: '7',
      title: 'Customer Service',
      description: 'Handle difficult customer scenarios and provide excellent service.',
      iconName: 'support_agent',
      color: const Color(0xFF00BCD4),
      difficulty: CategoryDifficulty.intermediate,
      topics: ['Greeting customers', 'Problem resolution', 'Handling complaints', 'Upselling techniques', 'Building loyalty'],
    ),
    CategoryModel(
      id: '8',
      title: 'Team Leadership',
      description: 'Develop communication skills essential for effective team leadership.',
      iconName: 'psychology',
      color: const Color(0xFF5C6BC0),
      difficulty: CategoryDifficulty.advanced,
      isPremium: true,
      topics: ['Setting expectations', 'Giving feedback', 'Motivating team members', 'Delegating tasks', 'Managing conflicts'],
    ),
  ];

  // Mock Conversations
  final List<ConversationModel> _mockConversations = [
    ConversationModel(
      id: '1',
      categoryId: '1',
      title: 'Interview Preparation',
      topic: 'Tell me about yourself',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      completedAt: DateTime.now().subtract(const Duration(days: 5)),
      score: 4.5,
      feedback: 'Good job! You provided clear examples of your experience and skills.',
      isCompleted: true,
      messages: [
        MessageModel(
          id: '1',
          conversationId: '1',
          content: 'Let\'s practice a common job interview question. Tell me about yourself.',
          sender: MessageSender.ai,
          timestamp: DateTime.now().subtract(const Duration(days: 5, minutes: 30)),
        ),
        MessageModel(
          id: '2',
          conversationId: '1',
          content: 'I\'m a software developer with 5 years of experience in building web applications...',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(days: 5, minutes: 28)),
        ),
      ],
    ),
    ConversationModel(
      id: '2',
      categoryId: '3',
      title: 'Social Networking',
      topic: 'Starting conversations at a party',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      score: 3.8,
      feedback: 'You could improve by asking more open-ended questions to keep the conversation flowing.',
      isCompleted: true,
      messages: [
        MessageModel(
          id: '3',
          conversationId: '2',
          content: 'Let\'s practice starting a conversation at a party. Imagine you don\'t know anyone there.',
          sender: MessageSender.ai,
          timestamp: DateTime.now().subtract(const Duration(days: 2, minutes: 45)),
        ),
        MessageModel(
          id: '4',
          conversationId: '2',
          content: 'Hi there! I noticed your t-shirt. Are you a fan of that band?',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(days: 2, minutes: 43)),
        ),
      ],
    ),
  ];

  // Mock Achievements
  final List<AchievementModel> _mockAchievements = [
    const AchievementModel(
      id: '1',
      title: 'Conversation Starter',
      description: 'Complete your first conversation',
      iconName: 'chat_bubble',
      category: AchievementCategory.conversations,
      requiredCount: 1,
      currentCount: 0,
    ),
    const AchievementModel(
      id: '2',
      title: 'Dedicated Learner',
      description: 'Complete 10 conversations',
      iconName: 'school',
      category: AchievementCategory.conversations,
      requiredCount: 10,
      currentCount: 0,
    ),
    const AchievementModel(
      id: '3',
      title: 'Communication Master',
      description: 'Complete 50 conversations',
      iconName: 'workspace_premium',
      category: AchievementCategory.conversations,
      requiredCount: 50,
      currentCount: 0,
    ),
    const AchievementModel(
      id: '4',
      title: 'Perfect Score',
      description: 'Get a 5.0 score in any conversation',
      iconName: 'star',
      category: AchievementCategory.scores,
      requiredCount: 1,
      currentCount: 0,
    ),
    const AchievementModel(
      id: '5',
      title: 'On Fire',
      description: 'Maintain a 3-day streak',
      iconName: 'local_fire_department',
      category: AchievementCategory.streaks,
      requiredCount: 3,
      currentCount: 0,
    ),
    const AchievementModel(
      id: '6',
      title: 'Dedicated Practitioner',
      description: 'Maintain a 7-day streak',
      iconName: 'auto_awesome',
      category: AchievementCategory.streaks,
      requiredCount: 7,
      currentCount: 0,
    ),
  ];

  // Category Methods
  Future<List<CategoryModel>> getCategories() async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      return _mockCategories;
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      try {
        return _mockCategories.firstWhere((category) => category.id == id);
      } catch (e) {
        return null;
      }
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  // Conversation Methods
  Future<List<ConversationModel>> getConversations() async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      return _mockConversations;
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<ConversationModel?> getConversationById(String id) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      try {
        return _mockConversations.firstWhere((conversation) => conversation.id == id);
      } catch (e) {
        return null;
      }
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<List<ConversationModel>> getConversationsByCategory(String categoryId) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return _mockConversations.where((c) => c.categoryId == categoryId).toList();
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<void> saveConversation(ConversationModel conversation) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockConversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _mockConversations[index] = conversation;
      } else {
        _mockConversations.add(conversation);
      }
      return;
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<void> deleteConversation(String id) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      _mockConversations.removeWhere((c) => c.id == id);
      return;
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  // Achievement Methods
  Future<List<AchievementModel>> getAchievements() async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return _mockAchievements;
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<AchievementModel?> getAchievementById(String id) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      try {
        return _mockAchievements.firstWhere((achievement) => achievement.id == id);
      } catch (e) {
        return null;
      }
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }

  Future<void> updateAchievementProgress(String id, int currentCount) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockAchievements.indexWhere((a) => a.id == id);
      if (index != -1) {
        final achievement = _mockAchievements[index];
        _mockAchievements[index] = achievement.copyWith(
          currentCount: currentCount,
          isUnlocked: currentCount >= achievement.requiredCount,
          unlockedAt: currentCount >= achievement.requiredCount ? DateTime.now() : null,
        );
      }
      return;
    }
    // TODO: Implement real Firestore call
    throw UnimplementedError('Real Firestore implementation not yet available');
  }
} 