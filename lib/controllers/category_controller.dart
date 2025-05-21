import 'package:flutter/material.dart';
import 'package:communication_practice/models/category_model.dart';

class CategoryController extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  CategoryController() {
    print('CategoryController: constructor called');
    fetchCategories();
  }
  
  Future<void> fetchCategories() async {
    _setLoading(true);
    print('CategoryController: fetchCategories started');
    
    try {
      // Simulate API call - replace with actual API call in production
      print('CategoryController: simulating API call');
      await Future.delayed(const Duration(seconds: 2));
      
      // Create mock categories
      print('CategoryController: creating mock categories');
      _categories = [
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
    } catch (e) {
      _setError('Failed to fetch categories: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      _setError('Category not found');
      return null;
    }
  }
  
  List<CategoryModel> searchCategories(String query) {
    if (query.isEmpty) {
      return _categories;
    }
    
    final queryLower = query.toLowerCase();
    return _categories.where((category) {
      return category.title.toLowerCase().contains(queryLower) ||
             category.description.toLowerCase().contains(queryLower);
    }).toList();
  }
  
  List<CategoryModel> filterByDifficulty(CategoryDifficulty difficulty) {
    return _categories.where((category) => category.difficulty == difficulty).toList();
  }
  
  void _setLoading(bool loading) {
    print('CategoryController: setting loading to $loading');
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? errorMessage) {
    print('CategoryController: setting error to $errorMessage');
    _error = errorMessage;
    notifyListeners();
  }
  
  void clearError() {
    print('CategoryController: clearing error');
    _error = null;
    notifyListeners();
  }
}