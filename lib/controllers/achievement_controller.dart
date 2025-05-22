import 'package:flutter/material.dart';
import 'package:communication_practice/models/achievement_model.dart';
import 'package:communication_practice/models/user_model.dart';
import 'package:communication_practice/services/firebase/firestore_service.dart';

class AchievementController extends ChangeNotifier {
  final List<AchievementModel> _achievements = [];
  bool _isLoading = false;
  String? _error;
  final FirestoreService _firestoreService = FirestoreService();
  
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
      final achievements = await _firestoreService.getAchievements();
      _achievements.clear();
      _achievements.addAll(achievements);
      _clearError();
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
  
  Future<void> updateAchievementProgress(String id, int currentCount) async {
    try {
      await _firestoreService.updateAchievementProgress(id, currentCount);
      await _loadAchievements(); // Reload to get updated achievements
    } catch (e) {
      _setError('Failed to update achievement progress: ${e.toString()}');
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
} 