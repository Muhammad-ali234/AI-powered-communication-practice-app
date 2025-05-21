import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/models/message_model.dart';
import 'package:communication_practice/utils/theme.dart';

class ConversationDetailScreen extends StatelessWidget {
  final ConversationModel conversation;
  
  const ConversationDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conversation.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: () => _exportConversation(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildMessagesList(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final formattedDate = dateFormat.format(conversation.createdAt);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.surface
            : AppColors.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conversation.topic,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (conversation.isCompleted) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        conversation.score?.toStringAsFixed(1) ?? '0.0',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    conversation.feedback,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildMessagesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: conversation.messages.length,
      itemBuilder: (context, index) {
        final message = conversation.messages[index];
        return _buildMessageTile(context, message);
      },
    );
  }
  
  Widget _buildMessageTile(BuildContext context, MessageModel message) {
    final isUser = message.sender == MessageSender.user;
    final timeFormat = DateFormat('h:mm a');
    final formattedTime = timeFormat.format(message.timestamp);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: AppColors.secondary,
              radius: 16,
              child: Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade100
                        : AppColors.darkCardBackground,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white.withOpacity(0.7)
                          : Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Future<void> _exportConversation(BuildContext context) async {
    // Generate export text
    final buffer = StringBuffer();
    buffer.writeln('CONVERSATION EXPORT');
    buffer.writeln('===================');
    buffer.writeln('Title: ${conversation.title}');
    buffer.writeln('Topic: ${conversation.topic}');
    buffer.writeln('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(conversation.createdAt)}');
    if (conversation.isCompleted) {
      buffer.writeln('Score: ${conversation.score?.toStringAsFixed(1) ?? 'N/A'}');
      buffer.writeln('Feedback: ${conversation.feedback}');
    }
    buffer.writeln('===================');
    buffer.writeln();
    
    // Add messages
    for (final message in conversation.messages) {
      final sender = message.sender == MessageSender.user ? 'You' : 'Assistant';
      final time = DateFormat('HH:mm').format(message.timestamp);
      buffer.writeln('[$time] $sender:');
      buffer.writeln(message.content);
      buffer.writeln();
    }
    
    // Copy to clipboard
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversation exported to clipboard'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
} 