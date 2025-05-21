import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/models/message_model.dart';
import 'package:communication_practice/models/category_model.dart';

class ChatController extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  ConversationModel? _activeConversation;
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;
  
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
      // Simulate API call - replace with actual API call in production
      await Future.delayed(const Duration(seconds: 2));
      
      // Create mock conversations
      _conversations = [
        ConversationModel(
          id: '1',
          categoryId: '1',
          title: 'Interview Preparation',
          topic: 'Tell me about yourself',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          completedAt: DateTime.now().subtract(const Duration(days: 5)),
          score: 4.5,
          feedback: 'Good job! You provided clear examples of your experience and skills.',
          isCompleted: true,
          messages: [
            MessageModel(
              id: '1',
              conversationId: '1',
              content: 'Let\'s practice a common job interview question. Tell me about yourself.',
              sender: MessageSender.ai,
              timestamp: DateTime.now().subtract(const Duration(days: 5, minutes: 30)),
            ),
            MessageModel(
              id: '2',
              conversationId: '1',
              content: 'I\'m a software developer with 5 years of experience in building web applications...',
              sender: MessageSender.user,
              timestamp: DateTime.now().subtract(const Duration(days: 5, minutes: 28)),
            ),
          ],
        ),
        ConversationModel(
          id: '2',
          categoryId: '3',
          title: 'Social Networking',
          topic: 'Starting conversations at a party',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
          score: 3.8,
          feedback: 'You could improve by asking more open-ended questions to keep the conversation flowing.',
          isCompleted: true,
          messages: [
            MessageModel(
              id: '3',
              conversationId: '2',
              content: 'Let\'s practice starting a conversation at a party. Imagine you don\'t know anyone there.',
              sender: MessageSender.ai,
              timestamp: DateTime.now().subtract(const Duration(days: 2, minutes: 45)),
            ),
            MessageModel(
              id: '4',
              conversationId: '2',
              content: 'Hi there! I noticed your t-shirt. Are you a fan of that band?',
              sender: MessageSender.user,
              timestamp: DateTime.now().subtract(const Duration(days: 2, minutes: 43)),
            ),
          ],
        ),
      ];
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
    
    _isSending = true;
    notifyListeners();
    
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
      _activeConversation = _activeConversation!.copyWith(
        messages: updatedMessages,
      );
      
      notifyListeners();
      
      // Generate AI response
      final aiResponse = await _generateAIResponse(content);
      
      // Add AI message to conversation
      final finalMessages = [..._activeConversation!.messages, aiResponse];
      _activeConversation = _activeConversation!.copyWith(
        messages: finalMessages,
      );
      
      // Update conversation in the list
      final index = _conversations.indexWhere((c) => c.id == _activeConversation!.id);
      if (index != -1) {
        _conversations[index] = _activeConversation!;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to send message: ${e.toString()}');
      
      // Add error message to conversation
      final errorMessage = MessageModel(
        id: uuid.v4(),
        conversationId: _activeConversation!.id,
        content: 'Sorry, there was an error sending your message. Please try again.',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        isError: true,
      );
      
      final updatedMessages = [..._activeConversation!.messages, errorMessage];
      _activeConversation = _activeConversation!.copyWith(
        messages: updatedMessages,
      );
      
      notifyListeners();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
  
  Future<void> endConversation() async {
    if (_activeConversation == null) {
      _setError('No active conversation');
      return;
    }
    
    _setLoading(true);
    
    try {
      // Simulate API call to end conversation and get feedback
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate random score
      final score = 3.5 + (1.5 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
      
      // Mark conversation as completed
      _activeConversation = _activeConversation!.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        score: score,
        feedback: 'You demonstrated good communication skills. Try to expand on your answers and provide more specific examples next time.',
      );
      
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
    await Future.delayed(const Duration(seconds: 2));
    
    // Simple keyword-based response generation
    String response;
    
    if (userMessage.toLowerCase().contains('help') || userMessage.toLowerCase().contains('confused')) {
      response = 'I understand this might be challenging. Let me clarify. Would you like me to provide some tips or examples to help you with this scenario?';
    } else if (userMessage.toLowerCase().contains('yes') || userMessage.toLowerCase().contains('ready')) {
      response = 'Great! Let\'s continue. Try to be specific in your responses and provide examples when possible. This helps make your communication more engaging and credible.';
    } else if (userMessage.length < 20) {
      response = 'I notice your response was quite brief. In real conversations, expanding on your thoughts helps create a connection. Could you elaborate a bit more on what you just shared?';
    } else {
      // Generate a more generic thoughtful response
      final responses = [
        'Thank you for sharing that. I appreciate your perspective. How do you think others might respond to that approach?',
        'That\'s an interesting point. In what situations do you think this approach works best?',
        'I see where you\'re coming from. Have you considered how this might be perceived by someone with a different background or experience?',
        'Good insights. If you were to face resistance to this idea, how might you adapt your communication?',
        'That\'s a solid approach. What do you think is the most challenging aspect of communicating in this scenario?'
      ];
      
      // Pick a random response
      response = responses[DateTime.now().millisecondsSinceEpoch % responses.length];
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