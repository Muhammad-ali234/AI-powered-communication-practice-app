enum MessageSender { user, ai }

class MessageModel {
  final String id;
  final String conversationId;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isError;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isError = false,
  });

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isError,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      content: json['content'],
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.ai,
      timestamp: DateTime.parse(json['timestamp']),
      isError: json['is_error'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'content': content,
      'sender': sender == MessageSender.user ? 'user' : 'ai',
      'timestamp': timestamp.toIso8601String(),
      'is_error': isError,
    };
  }
}