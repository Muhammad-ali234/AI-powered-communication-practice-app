import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:communication_practice/controllers/chat_controller.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/models/message_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';
import 'package:communication_practice/views/history/conversation_detail_screen.dart';
import 'package:communication_practice/views/history/statistics_screen.dart';
import 'package:communication_practice/widgets/empty_state.dart';

class ConversationHistoryScreen extends StatefulWidget {
  const ConversationHistoryScreen({super.key});

  @override
  State<ConversationHistoryScreen> createState() => _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState extends State<ConversationHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;
  bool _onlyCompleted = false;
  bool _isExporting = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
            fontSize: responsive.fontSize(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.bar_chart_rounded,
              size: responsive.iconSize(24),
            ),
            tooltip: 'Statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              size: responsive.iconSize(24),
            ),
            tooltip: 'Filter',
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(responsive),
          Expanded(
            child: _buildConversationList(responsive),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar(ResponsiveUtil responsive) {
    return Padding(
      padding: responsive.responsivePadding(all: 16),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontSize: responsive.fontSize(16),
        ),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: TextStyle(
            fontSize: responsive.fontSize(16),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: responsive.iconSize(20),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: responsive.iconSize(20),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
          contentPadding: responsive.responsivePadding(vertical: 12, horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }
  
  Widget _buildConversationList(ResponsiveUtil responsive) {
    return Consumer<ChatController>(
      builder: (context, chatController, child) {
        final allConversations = chatController.getConversationHistorySorted();
        
        // Apply filters
        final filteredConversations = allConversations.where((conversation) {
          // Filter by search query
          final matchesSearch = _searchQuery.isEmpty ||
              conversation.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              conversation.topic.toLowerCase().contains(_searchQuery.toLowerCase());
          
          // Filter by category
          final matchesCategory = _selectedCategoryId == null || 
              conversation.categoryId == _selectedCategoryId;
          
          // Filter by completed status
          final matchesCompleted = !_onlyCompleted || conversation.isCompleted;
          
          return matchesSearch && matchesCategory && matchesCompleted;
        }).toList();
        
        if (filteredConversations.isEmpty) {
          return EmptyState(
            icon: Icons.history_rounded,
            title: 'No conversations found',
            message: _searchQuery.isNotEmpty || _selectedCategoryId != null || _onlyCompleted
                ? 'Try changing your filters'
                : 'Start a new conversation to see it here',
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.only(bottom: responsive.md),
          itemCount: filteredConversations.length,
          itemBuilder: (context, index) {
            final conversation = filteredConversations[index];
            return _buildConversationCard(conversation, responsive);
          },
        );
      },
    );
  }
  
  Widget _buildConversationCard(ConversationModel conversation, ResponsiveUtil responsive) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final formattedDate = dateFormat.format(conversation.createdAt);
    
    return Padding(
      padding: responsive.responsivePadding(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationDetailScreen(conversation: conversation),
              ),
            );
          },
          child: Padding(
            padding: responsive.responsivePadding(all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        conversation.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (conversation.isCompleted)
                      Container(
                        padding: responsive.responsivePadding(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.primary,
                              size: responsive.iconSize(16),
                            ),
                            SizedBox(width: responsive.xs),
                            Text(
                              conversation.score?.toStringAsFixed(1) ?? '0.0',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.fontSize(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: responsive.xs),
                Text(
                  conversation.topic,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: responsive.fontSize(12),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.file_download_outlined, 
                            size: responsive.iconSize(20)
                          ),
                          tooltip: 'Export',
                          onPressed: () => _exportConversation(conversation),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: responsive.md),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline, 
                            size: responsive.iconSize(20)
                          ),
                          tooltip: 'Delete',
                          onPressed: () => _confirmDeleteConversation(conversation),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showFilterDialog() {
    final responsive = ResponsiveUtil(context);
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Filter Conversations',
                style: TextStyle(
                  fontSize: responsive.fontSize(18),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: responsive.fontSize(16),
                    ),
                  ),
                  SizedBox(height: responsive.xs),
                  _buildCategoryFilter(setState, responsive),
                  SizedBox(height: responsive.md),
                  Row(
                    children: [
                      Transform.scale(
                        scale: responsive.isSmallScreen ? 0.9 : 1.0,
                        child: Checkbox(
                          value: _onlyCompleted,
                          onChanged: (value) {
                            setState(() {
                              _onlyCompleted = value ?? false;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Show only completed conversations',
                        style: TextStyle(
                          fontSize: responsive.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    this.setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Widget _buildCategoryFilter(StateSetter setState, ResponsiveUtil responsive) {
    return Container(
      padding: responsive.responsivePadding(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: _selectedCategoryId,
          hint: Text(
            'All categories',
            style: TextStyle(
              fontSize: responsive.fontSize(14),
            ),
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategoryId = newValue;
            });
          },
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                'All categories',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
            DropdownMenuItem<String>(
              value: '1',
              child: Text(
                'Job Interviews',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
            DropdownMenuItem<String>(
              value: '2',
              child: Text(
                'Public Speaking',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
            DropdownMenuItem<String>(
              value: '3',
              child: Text(
                'Social Situations',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _exportConversation(ConversationModel conversation) async {
    if (_isExporting) return;
    
    setState(() {
      _isExporting = true;
    });
    
    try {
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
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conversation exported to clipboard'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export conversation: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }
  
  void _confirmDeleteConversation(ConversationModel conversation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: const Text('Are you sure you want to delete this conversation? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteConversation(conversation);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  
  void _deleteConversation(ConversationModel conversation) {
    final chatController = Provider.of<ChatController>(context, listen: false);
    chatController.deleteConversation(conversation.id).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversation deleted'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete conversation: $error'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
} 