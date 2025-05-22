import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/models/message_model.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/services/firebase/firestore_service.dart';

class ChatController extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  ConversationModel? _activeConversation;
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;
  final FirestoreService _firestoreService = FirestoreService();
  
  List<ConversationModel> get conversations => _conversations;
  ConversationModel? get activeConversation => _activeConversation;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;
  final uuid = const Uuid();
  
  ChatController() {
    _loadConversations();
  }
  
  Future<void> _loadConversations() async {
    _setLoading(true);
    
    try {
      _conversations = await _firestoreService.getConversations();
    } catch (e) {
      _setError('Failed to load conversations: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<ConversationModel> startNewConversation(CategoryModel category, String topic) async {
    _setLoading(true);
    
    try {
      // Create a new conversation
      final newConversation = ConversationModel(
        id: uuid.v4(),
        categoryId: category.id,
        title: '${category.title} Practice',
        topic: topic,
        createdAt: DateTime.now(),
        messages: [],
      );
      
      // Add initial message from AI
      final initialMessage = await _generateInitialMessage(category, topic);
      
      // Update the conversation with the initial message
      final updatedConversation = newConversation.copyWith(
        messages: [initialMessage],
      );
      
      // Save to Firestore
      await _firestoreService.saveConversation(updatedConversation);
      
      // Set as active conversation
      _activeConversation = updatedConversation;
      
      // Add to conversations list
      _conversations.add(updatedConversation);
      
      notifyListeners();
      return updatedConversation;
    } catch (e) {
      _setError('Failed to start new conversation: ${e.toString()}');
      throw Exception('Failed to start new conversation');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> sendMessage(String content) async {
    if (_activeConversation == null) {
      _setError('No active conversation');
      return;
    }
    
    _setSending(true);
    
    try {
      // Create user message
      final userMessage = MessageModel(
        id: uuid.v4(),
        conversationId: _activeConversation!.id,
        content: content,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      );
      
      // Add user message to conversation
      final updatedMessages = [..._activeConversation!.messages, userMessage];
      _activeConversation = _activeConversation!.copyWith(messages: updatedMessages);
      
      // Generate AI response
      final aiResponse = await _generateAIResponse(content);
      
      // Add AI response to conversation
      final finalMessages = [...updatedMessages, aiResponse];
      _activeConversation = _activeConversation!.copyWith(messages: finalMessages);
      
      // Update conversation in Firestore
      await _firestoreService.saveConversation(_activeConversation!);
      
      // Update conversation in the list
      final index = _conversations.indexWhere((c) => c.id == _activeConversation!.id);
      if (index != -1) {
        _conversations[index] = _activeConversation!;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to send message: ${e.toString()}');
    } finally {
      _setSending(false);
    }
  }
  
  Future<void> endConversation() async {
    if (_activeConversation == null) {
      _setError('No active conversation');
      return;
    }
    
    _setLoading(true);
    
    try {
      // Generate random score
      final score = 3.5 + (1.5 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
      
      // Mark conversation as completed
      _activeConversation = _activeConversation!.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        score: score,
        feedback: 'You demonstrated good communication skills. Try to expand on your answers and provide more specific examples next time.',
      );
      
      // Update conversation in Firestore
      await _firestoreService.saveConversation(_activeConversation!);
      
      // Update conversation in the list
      final index = _conversations.indexWhere((c) => c.id == _activeConversation!.id);
      if (index != -1) {
        _conversations[index] = _activeConversation!;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to end conversation: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  void setActiveConversation(String conversationId) {
    try {
      _activeConversation = _conversations.firstWhere((c) => c.id == conversationId);
      notifyListeners();
    } catch (e) {
      _setError('Conversation not found');
    }
  }
  
  List<ConversationModel> getConversationHistorySorted() {
    final sortedList = [..._conversations];
    sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedList;
  }
  
  List<ConversationModel> filterConversationsByCategory(String categoryId) {
    return _conversations.where((c) => c.categoryId == categoryId).toList();
  }
  
  Future<MessageModel> _generateInitialMessage(CategoryModel category, String topic) async {
    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 1));
    
    String content;
    switch (category.title) {
      case 'Job Interviews':
        content = 'Welcome to your interview practice session on "$topic". I\'ll be your interviewer today. Let\'s get started with a common question related to this topic. Ready?';
        break;
      case 'Public Speaking':
        content = 'Welcome to your public speaking practice on "$topic". Imagine you\'re about to give a short presentation on this topic to a group of 20 people. How would you start your speech?';
        break;
      case 'Social Situations':
        content = 'Let\'s practice navigating social situations related to "$topic". Imagine we\'re at a social gathering and this topic comes up. How would you engage in this conversation?';
        break;
      default:
        content = 'Let\'s practice your communication skills on the topic of "$topic". I\'ll guide you through this conversation to help you improve. Ready to begin?';
    }
    
    return MessageModel(
      id: uuid.v4(),
      conversationId: uuid.v4(), // This will be updated with the actual conversation ID
      content: content,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );
  }
  
  Future<MessageModel> _generateAIResponse(String userMessage) async {
    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple response generation - in a real app, this would use a more sophisticated AI model
    String response;
    if (userMessage.toLowerCase().contains('hello') || userMessage.toLowerCase().contains('hi')) {
      response = 'Hello! How can I help you with your communication practice today?';
    } else if (userMessage.toLowerCase().contains('thank')) {
      response = 'You\'re welcome! Is there anything specific you\'d like to practice?';
    } else {
      response = 'That\'s interesting! Could you tell me more about that?';
    }
    
    return MessageModel(
      id: uuid.v4(),
      conversationId: _activeConversation!.id,
      content: response,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setSending(bool sending) {
    _isSending = sending;
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
  
  Future<void> deleteConversation(String conversationId) async {
    _setLoading(true);
    
    try {
      // Delete from Firestore
      await _firestoreService.deleteConversation(conversationId);
      
      // Remove conversation from the list
      _conversations.removeWhere((c) => c.id == conversationId);
      
      // If the active conversation was deleted, clear it
      if (_activeConversation != null && _activeConversation!.id == conversationId) {
        _activeConversation = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete conversation: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
}