import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  
  // Notification settings
  bool _practiceReminders = true;
  bool _newFeatureAlerts = true;
  bool _weeklyProgressReports = true;
  
  // Language settings (ISO language codes)
  String _languageCode = 'en';
  final List<Map<String, String>> _supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'zh', 'name': '中文'},
  ];
  
  // Privacy settings
  bool _analyticsEnabled = true;
  bool _personalizedContent = true;
  
  // Data storage
  bool _autoSaveConversations = true;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  
  bool get practiceReminders => _practiceReminders;
  bool get newFeatureAlerts => _newFeatureAlerts;
  bool get weeklyProgressReports => _weeklyProgressReports;
  
  String get languageCode => _languageCode;
  String get languageName => _supportedLanguages
      .firstWhere((lang) => lang['code'] == _languageCode)['name'] ?? 'English';
  List<Map<String, String>> get supportedLanguages => _supportedLanguages;
  
  bool get analyticsEnabled => _analyticsEnabled;
  bool get personalizedContent => _personalizedContent;
  
  bool get autoSaveConversations => _autoSaveConversations;
  
  // App version
  final String appVersion = '1.0.0';
  
  SettingsController() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme settings
      final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      // Load notification settings
      _practiceReminders = prefs.getBool('practice_reminders') ?? true;
      _newFeatureAlerts = prefs.getBool('new_feature_alerts') ?? true;
      _weeklyProgressReports = prefs.getBool('weekly_progress_reports') ?? true;
      
      // Load language settings
      _languageCode = prefs.getString('language_code') ?? 'en';
      
      // Load privacy settings
      _analyticsEnabled = prefs.getBool('analytics_enabled') ?? true;
      _personalizedContent = prefs.getBool('personalized_content') ?? true;
      
      // Load data settings
      _autoSaveConversations = prefs.getBool('auto_save_conversations') ?? true;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: ${e.toString()}');
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', mode.index);
    } catch (e) {
      debugPrint('Error saving theme mode: ${e.toString()}');
    }
  }
  
  Future<void> togglePracticeReminders(bool value) async {
    _practiceReminders = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('practice_reminders', value);
    } catch (e) {
      debugPrint('Error saving practice reminders setting: ${e.toString()}');
    }
  }
  
  Future<void> toggleNewFeatureAlerts(bool value) async {
    _newFeatureAlerts = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('new_feature_alerts', value);
    } catch (e) {
      debugPrint('Error saving new feature alerts setting: ${e.toString()}');
    }
  }
  
  Future<void> toggleWeeklyProgressReports(bool value) async {
    _weeklyProgressReports = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('weekly_progress_reports', value);
    } catch (e) {
      debugPrint('Error saving weekly progress reports setting: ${e.toString()}');
    }
  }
  
  Future<void> setLanguage(String code) async {
    if (_languageCode == code) return;
    
    _languageCode = code;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', code);
    } catch (e) {
      debugPrint('Error saving language setting: ${e.toString()}');
    }
  }
  
  Future<void> toggleAnalytics(bool value) async {
    _analyticsEnabled = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('analytics_enabled', value);
    } catch (e) {
      debugPrint('Error saving analytics setting: ${e.toString()}');
    }
  }
  
  Future<void> togglePersonalizedContent(bool value) async {
    _personalizedContent = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('personalized_content', value);
    } catch (e) {
      debugPrint('Error saving personalized content setting: ${e.toString()}');
    }
  }
  
  Future<void> toggleAutoSaveConversations(bool value) async {
    _autoSaveConversations = value;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_save_conversations', value);
    } catch (e) {
      debugPrint('Error saving auto save conversations setting: ${e.toString()}');
    }
  }
  
  Future<void> clearAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _loadSettings();
    } catch (e) {
      debugPrint('Error clearing settings: ${e.toString()}');
    }
  }
  
  Future<void> exportData() async {
    // In a real app, this would export all user data as JSON
    // or another appropriate format
    return Future.delayed(const Duration(seconds: 1));
  }
  
  Future<void> deleteAllData() async {
    // In a real app, this would delete all user data 
    // and reset the app to its initial state
    await clearAllSettings();
    return Future.delayed(const Duration(seconds: 1));
  }
} 