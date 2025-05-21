import 'package:flutter/material.dart';
import 'package:communication_practice/models/achievement_model.dart';
import 'package:communication_practice/models/user_model.dart';

class AchievementController extends ChangeNotifier {
  List<AchievementModel> _achievements = [];
  bool _isLoading = false;
  String? _error;
  
  List<AchievementModel> get achievements => _achievements;
  List<AchievementModel> get unlockedAchievements => 
      _achievements.where((a) => a.isUnlocked).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  AchievementController() {
    _loadAchievements();
  }
  
  Future<void> _loadAchievements() async {
    _setLoading(true);
    
    try {
      // Simulate API call - replace with actual API call in production
      await Future.delayed(const Duration(seconds: 1));
      
      // Define sample achievements
      _achievements = [
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
        const AchievementModel(
          id: '7',
          title: 'Topic Explorer',
          description: 'Practice on 5 different topics',
          iconName: 'explore',
          category: AchievementCategory.topics,
          requiredCount: 5,
          currentCount: 0,
        ),
      ];
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load achievements: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> updateAchievements(UserModel user) async {
    if (_achievements.isEmpty) {
      await _loadAchievements();
    }
    
    // Update conversation achievements
    _updateAchievement('1', user.conversationsCompleted);
    _updateAchievement('2', user.conversationsCompleted);
    _updateAchievement('3', user.conversationsCompleted);
    
    // Update streak achievements
    _updateAchievement('5', user.streak);
    _updateAchievement('6', user.streak);
    
    // In a real app, you'd have a way to track unique topics and
    // perfect scores, here we're just simulating random progress
    
    notifyListeners();
  }
  
  void _updateAchievement(String achievementId, int count) {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index != -1) {
      final achievement = _achievements[index];
      
      // Check if already unlocked
      if (!achievement.isUnlocked) {
        final updatedAchievement = achievement.copyWith(
          currentCount: count,
          isUnlocked: count >= achievement.requiredCount,
          unlockedAt: count >= achievement.requiredCount ? DateTime.now() : null,
        );
        
        _achievements[index] = updatedAchievement;
      }
    }
  }
  
  void updateTopicProgress(int uniqueTopicsCount) {
    _updateAchievement('7', uniqueTopicsCount);
    notifyListeners();
  }
  
  void recordPerfectScore() {
    _updateAchievement('4', 1);
    notifyListeners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 