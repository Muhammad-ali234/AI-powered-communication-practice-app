import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:communication_practice/models/user_model.dart';

class AuthService {
  bool useMock = true;
  String? _token;
  UserModel? _currentUser;

  // Mock User Data
  final UserModel _mockUser = UserModel(
    id: 'user_123',
    name: 'John Doe',
    email: 'test@example.com',
    photoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    bio: 'Passionate about improving communication skills!',
    conversationsCompleted: 15,
    streak: 7,
    averageScore: 4.2,
    badges: ['Consistent Learner', 'Conversation Starter'],
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    lastActive: DateTime.now(),
  );

  // Authentication Methods
  Future<bool> login(String email, String password) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      if (email == 'test@example.com' && password == 'password123') {
        _token = 'mock_token_12345';
        _currentUser = _mockUser;
        
        // Save token to persistent storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        
        return true;
      }
      return false;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<bool> signup(String name, String email, String password) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      _token = 'mock_token_12345';
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
      
      // Save token to persistent storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      
      return true;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<bool> forgotPassword(String email) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<bool> loginWithGoogle() async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      _token = 'mock_google_token_12345';
      _currentUser = _mockUser;
      
      // Save token to persistent storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      
      return true;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<bool> loginWithApple() async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 2));
      
      _token = 'mock_apple_token_12345';
      _currentUser = _mockUser;
      
      // Save token to persistent storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      
      return true;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<void> logout() async {
    if (useMock) {
      _token = null;
      _currentUser = null;
      
      // Clear token from persistent storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      return;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<UserModel?> getCurrentUser() async {
    if (useMock) {
      if (_currentUser != null) {
        return _currentUser;
      }
      
      // Check for saved token
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');
      
      if (savedToken != null) {
        _token = savedToken;
        _currentUser = _mockUser;
        return _currentUser;
      }
      
      return null;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = updatedUser;
      return;
    }
    // TODO: Implement real Firebase Auth call
    throw UnimplementedError('Real Firebase Auth implementation not yet available');
  }
} 