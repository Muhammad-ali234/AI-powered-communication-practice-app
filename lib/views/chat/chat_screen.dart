import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/controllers/chat_controller.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/models/message_model.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/widgets/loading_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isRecording = false;
  bool _isSpeaking = false;
  Timer? _sessionTimer;
  Duration _elapsed = Duration.zero;
  int _messageCount = 0;
  final int _targetMessageCount = 10; // Target number of messages to achieve 100%
  late AnimationController _typingAnimationController;
  
  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
      _startSessionTimer();
    });
  }
  
  @override
  void dispose() {
    _typingAnimationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }
  
  void _initializeChat() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final CategoryModel category = args['category'];
    final String topic = args['topic'];
    
    try {
      final ChatController chatController = Provider.of<ChatController>(context, listen: false);
      await chatController.startNewConversation(category, topic);
      
      // Update user's streak
      Provider.of<UserController>(context, listen: false).updateUserStreak();
      
      setState(() {
        _messageCount = 1; // Start with one AI message
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start conversation: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
      
      Navigator.pop(context); // Go back to previous screen
    }
  }
  
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = Duration(seconds: timer.tick);
      });
    });
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) {
      return;
    }
    
    final message = _textController.text;
    _textController.clear();
    
    final chatController = Provider.of<ChatController>(context, listen: false);
    
    setState(() {
      _messageCount += 1; // User message
    });
    
    await chatController.sendMessage(message);
    
    setState(() {
      _messageCount += 1; // AI response
    });
    
    _scrollToBottom();
  }
  
  void _toggleVoiceRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (_isRecording) {
      // Simulate voice recording for demo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice recording started. Say something...'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // Simulate ending recording after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isRecording) {
          setState(() {
            _isRecording = false;
            _textController.text = "This is a simulated voice input message.";
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice recording cancelled'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  
  void _playVoice(String message) {
    setState(() {
      _isSpeaking = true;
    });
    
    // Simulate text-to-speech for demo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing audio response...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Simulate speech duration based on message length
    final speechDuration = Duration(milliseconds: message.length * 50);
    Future.delayed(speechDuration, () {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }
  
  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Practice Session'),
        content: const Text('Are you sure you want to end this practice session? You\'ll receive feedback on your performance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _endSession();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }
  
  void _endSession() async {
    _sessionTimer?.cancel();
    
    final chatController = Provider.of<ChatController>(context, listen: false);
    await chatController.endConversation();
    
    _showFeedbackDialog();
  }
  
  void _showFeedbackDialog() {
    final chatController = Provider.of<ChatController>(context, listen: false);
    final conversation = chatController.activeConversation;
    
    if (conversation == null || conversation.score == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
      return;
    }
    
    // Update user stats
    final userController = Provider.of<UserController>(context, listen: false);
    userController.incrementConversationsCompleted();
    userController.updateAverageScore(conversation.score!);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  conversation.score!.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  '/5.0',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              conversation.feedback,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildSessionStats(),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.main);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSessionStats() {
    final sessionMinutes = _elapsed.inMinutes;
    final sessionSeconds = _elapsed.inSeconds % 60;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Session Stats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Duration:'),
              Text('$sessionMinutes min $sessionSeconds sec'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Messages exchanged:'),
              Text('${_messageCount.toString()} messages'),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ChatController>(
              builder: (context, chatController, child) {
                final conversation = chatController.activeConversation;
                return Text(
                  conversation?.title ?? 'Practice Session',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Consumer<ChatController>(
              builder: (context, chatController, child) {
                final conversation = chatController.activeConversation;
                return Text(
                  conversation?.topic ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                );
              },
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Session timer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                '${_elapsed.inMinutes.toString().padLeft(2, '0')}:${(_elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // End session button
          IconButton(
            onPressed: _showEndSessionDialog,
            icon: const Icon(Icons.stop_circle_outlined),
            tooltip: 'End Session',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_messageCount / _targetMessageCount).clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            color: AppColors.primary,
            minHeight: 4,
          ),
          
          // Chat messages
          Expanded(
            child: Consumer<ChatController>(
              builder: (context, chatController, child) {
                if (chatController.isLoading) {
                  return const Center(child: LoadingIndicator());
                }
                
                final conversation = chatController.activeConversation;
                
                if (conversation == null) {
                  return const Center(
                    child: Text('No active conversation'),
                  );
                }
                
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  itemCount: conversation.messages.length + (chatController.isSending ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator as the last item when sending
                    if (chatController.isSending && index == conversation.messages.length) {
                      return _buildTypingIndicator();
                    }
                    
                    final message = conversation.messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),
          
          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }
  
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _typingAnimationController,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.3;
                    final opacity = sin((_typingAnimationController.value * 2 - delay) * 3.14)
                        .clamp(0.1, 1.0);
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(opacity),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMessageBubble(MessageModel message) {
    final isUserMessage = message.sender == MessageSender.user;
    
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUserMessage 
              ? AppColors.primary 
              : (message.isError ? AppColors.error.withOpacity(0.1) : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUserMessage ? 20 : 2),
            topRight: Radius.circular(isUserMessage ? 2 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isUserMessage 
                    ? Colors.white 
                    : (message.isError ? AppColors.error : null),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: TextStyle(
                    color: isUserMessage 
                        ? Colors.white.withOpacity(0.7) 
                        : Colors.grey,
                    fontSize: 10,
                  ),
                ),
                if (!isUserMessage) 
                  GestureDetector(
                    onTap: () => _playVoice(message.content),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : AppColors.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Voice input button
          _isRecording
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _toggleVoiceRecording,
                    icon: const Icon(Icons.mic, color: Colors.white),
                  ),
                )
              : IconButton(
                  onPressed: _toggleVoiceRecording,
                  icon: const Icon(Icons.mic_none_rounded),
                  color: AppColors.textSecondary,
                ),
          
          // Text input field
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade100
                    : AppColors.darkCardBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          
          // Send button
          Consumer<ChatController>(
            builder: (context, chatController, child) {
              return IconButton(
                onPressed: chatController.isSending ? null : _sendMessage,
                icon: const Icon(Icons.send_rounded),
                color: AppColors.primary,
              );
            },
          ),
        ],
      ),
    );
  }
} 