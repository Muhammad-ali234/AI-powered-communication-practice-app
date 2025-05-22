import 'package:flutter/material.dart';
import 'package:communication_practice/models/user_model.dart';
import 'package:communication_practice/services/firebase/auth_service.dart';

class UserController extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  final AuthService _authService = AuthService();
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  UserController() {
    _loadCurrentUser();
  }
  
  Future<void> _loadCurrentUser() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
    } catch (e) {
      _setError('Failed to load user: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
  
  Future<void> updateUserProfile({
    String? name,
    String? bio,
    String? photoUrl,
  }) async {
    if (_user == null) {
      _setError('User not logged in');
      return;
    }
    
    _setLoading(true);
    
    try {
      final updatedUser = _user!.copyWith(
        name: name ?? _user!.name,
        bio: bio ?? _user!.bio,
        photoUrl: photoUrl ?? _user!.photoUrl,
        lastActive: DateTime.now(),
      );
      await _authService.updateUserProfile(updatedUser);
      // Reload user data
      await _loadCurrentUser();
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  void incrementConversationsCompleted() {
    if (_user == null) return;
    
    final newCount = _user!.conversationsCompleted + 1;
    _user = _user!.copyWith(
      conversationsCompleted: newCount,
      lastActive: DateTime.now(),
    );
    
    notifyListeners();
  }
  
  void updateUserStreak() {
    if (_user == null) return;
    
    // Check if last active was yesterday or today
    final now = DateTime.now();
    final lastActive = _user!.lastActive;
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final isStreak = lastActive.year == yesterday.year && 
                    lastActive.month == yesterday.month && 
                    lastActive.day == yesterday.day;
    
    if (isStreak) {
      final newStreak = _user!.streak + 1;
      _user = _user!.copyWith(
        streak: newStreak,
        lastActive: now,
      );
      
      notifyListeners();
      
      // In a real app, update backend with new streak
    }
  }
  
  void updateAverageScore(double newScore) {
    if (_user == null) return;
    
    final oldAverage = _user!.averageScore;
    final oldCount = _user!.conversationsCompleted;
    
    // Calculate new average
    final newAverage = (oldAverage * oldCount + newScore) / (oldCount + 1);
    
    _user = _user!.copyWith(
      averageScore: newAverage,
      lastActive: DateTime.now(),
    );
    
    notifyListeners();
    
    // In a real app, update backend with new average
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