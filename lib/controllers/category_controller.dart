import 'package:flutter/material.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/services/firebase/firestore_service.dart';

class CategoryController extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  final FirestoreService _firestoreService = FirestoreService();
  
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
      _categories = await _firestoreService.getCategories();
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