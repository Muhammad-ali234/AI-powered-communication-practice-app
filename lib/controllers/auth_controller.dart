import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:communication_practice/models/user_model.dart';

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  UserModel? _currentUser;
  String? _error;
  
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  String? get error => _error;
  
  AuthController() {
    _initializeAuth();
  }
  
  Future<void> _initializeAuth() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');
      
      if (savedToken != null) {
        // In a real app, you would validate the token with your backend
        _token = savedToken;
        await _fetchUserProfile();
        _isAuthenticated = true;
      }
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
      _logout();
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Simulate API call - replace with actual API call in production
      await Future.delayed(const Duration(seconds: 2));
      
      if (email == 'test@example.com' && password == 'password123') {
        _token = 'mock_token_12345';
        _isAuthenticated = true;
        
        // Save token to persistent storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', _token!);
        
        // Fetch user profile
        await _fetchUserProfile();
        
        notifyListeners();
        return true;
      } else {
        _setError('Invalid email or password');
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> signup(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Simulate API call - replace with actual API call in production
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would create a new user account
      _token = 'mock_token_12345';
      _isAuthenticated = true;
      
      // Create a mock user
      _currentUser = UserModel(
        id: 'user_123',
        name: name,
        email: email,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
      
      // Save token to persistent storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', _token!);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Signup failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Simulate API call - replace with actual API call in production
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would send a password reset email
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send reset email: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Simulate API call - replace with actual Google Sign-In in production
      await Future.delayed(const Duration(seconds: 2));
      
      _token = 'mock_google_token_12345';
      _isAuthenticated = true;
      
      // Save token to persistent storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', _token!);
      
      // Fetch user profile
      await _fetchUserProfile();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Google login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> loginWithApple() async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Simulate API call - replace with actual Apple Sign-In in production
      await Future.delayed(const Duration(seconds: 2));
      
      _token = 'mock_apple_token_12345';
      _isAuthenticated = true;
      
      // Save token to persistent storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', _token!);
      
      // Fetch user profile
      await _fetchUserProfile();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Apple login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _fetchUserProfile() async {
    try {
      // Simulate API call - replace with actual API call in production
      await Future.delayed(const Duration(seconds: 1));
      
      // Create a mock user profile
      _currentUser = UserModel(
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
    } catch (e) {
      _setError('Failed to fetch user profile: ${e.toString()}');
    }
  }
  
  Future<void> logout() async {
    await _logout();
  }
  
  Future<void> _logout() async {
    _isAuthenticated = false;
    _token = null;
    _currentUser = null;
    
    // Clear token from persistent storage
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    
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