import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:communication_practice/models/user_model.dart';
import 'package:communication_practice/services/firebase/auth_service.dart';

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  String? _token;
  UserModel? _currentUser;
  final AuthService _authService = AuthService();
  
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser;
  
  AuthController() {
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
      }
    } catch (e) {
      _setError('Failed to check auth status: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final success = await _authService.login(email, password);
      if (success) {
        _isAuthenticated = true;
        _currentUser = await _authService.getCurrentUser();
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
      final success = await _authService.signup(name, email, password);
      if (success) {
        _isAuthenticated = true;
        _currentUser = await _authService.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _setError('Signup failed');
        return false;
      }
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
      final success = await _authService.forgotPassword(email);
      if (!success) {
        _setError('Failed to send password reset email');
      }
      return success;
    } catch (e) {
      _setError('Failed to send password reset email: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError(null);
    
    try {
      final success = await _authService.loginWithGoogle();
      if (success) {
        _isAuthenticated = true;
        _currentUser = await _authService.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _setError('Google login failed');
        return false;
      }
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
      final success = await _authService.loginWithApple();
      if (success) {
        _isAuthenticated = true;
        _currentUser = await _authService.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _setError('Apple login failed');
        return false;
      }
    } catch (e) {
      _setError('Apple login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> updateUserProfile(UserModel updatedUser) async {
    _setLoading(true);
    try {
      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
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