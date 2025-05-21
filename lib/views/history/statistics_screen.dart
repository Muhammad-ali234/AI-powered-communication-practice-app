import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/controllers/chat_controller.dart';
import 'package:communication_practice/models/conversation_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(
            fontSize: responsive.fontSize(20),
          ),
        ),
      ),
      body: Consumer<ChatController>(
        builder: (context, chatController, child) {
          final conversations = chatController.getConversationHistorySorted();
          
          if (conversations.isEmpty) {
            return Center(
              child: Text(
                'No conversations available',
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                ),
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: responsive.responsivePadding(all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewSection(context, conversations, responsive),
                SizedBox(height: responsive.lg),
                _buildRecentActivitySection(context, conversations, responsive),
                SizedBox(height: responsive.lg),
                _buildCategoryBreakdownSection(context, conversations, responsive),
                SizedBox(height: responsive.lg),
                _buildScoreAnalysisSection(context, conversations, responsive),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildOverviewSection(BuildContext context, List<ConversationModel> conversations, ResponsiveUtil responsive) {
    final completedConversations = conversations.where((c) => c.isCompleted).toList();
    final averageScore = completedConversations.isEmpty 
        ? 0.0 
        : completedConversations.map((c) => c.score ?? 0.0).reduce((a, b) => a + b) / completedConversations.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
          ),
        ),
        SizedBox(height: responsive.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Total Conversations',
                conversations.length.toString(),
                Icons.chat_outlined,
                responsive,
              ),
            ),
            SizedBox(width: responsive.md),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed',
                completedConversations.length.toString(),
                Icons.check_circle_outline_rounded,
                responsive,
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Average Score',
                averageScore.toStringAsFixed(1),
                Icons.star_outline_rounded,
                responsive,
              ),
            ),
            SizedBox(width: responsive.md),
            Expanded(
              child: _buildStatCard(
                context,
                'Last 7 Days',
                _getLastSevenDaysCount(conversations).toString(),
                Icons.date_range_outlined,
                responsive,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildRecentActivitySection(BuildContext context, List<ConversationModel> conversations, ResponsiveUtil responsive) {
    // Get conversations from the last 30 days
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Group by day
    final Map<String, int> activityByDay = {};
    
    for (var conversation in conversations) {
      if (conversation.createdAt.isAfter(thirtyDaysAgo)) {
        final day = DateFormat('MM/dd').format(conversation.createdAt);
        activityByDay[day] = (activityByDay[day] ?? 0) + 1;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
          ),
        ),
        SizedBox(height: responsive.md),
        Container(
          height: responsive.isSmallScreen ? 150 : 180,
          padding: responsive.responsivePadding(all: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.surface
                : AppColors.darkCardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: activityByDay.isEmpty
              ? Center(
                  child: Text(
                    'No recent activity',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                )
              : _buildActivityChart(context, activityByDay, responsive),
        ),
      ],
    );
  }
  
  Widget _buildActivityChart(BuildContext context, Map<String, int> activityByDay, ResponsiveUtil responsive) {
    // Sort keys by date
    final sortedKeys = activityByDay.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MM/dd').parse(a);
        final dateB = DateFormat('MM/dd').parse(b);
        return dateA.compareTo(dateB);
      });
    
    final maxValue = activityByDay.values.reduce((a, b) => a > b ? a : b);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Y-axis labels
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$maxValue', 
              style: TextStyle(
                fontSize: responsive.fontSize(10)
              )
            ),
            Text(
              '${(maxValue / 2).round()}', 
              style: TextStyle(
                fontSize: responsive.fontSize(10)
              )
            ),
            Text(
              '0', 
              style: TextStyle(
                fontSize: responsive.fontSize(10)
              )
            ),
          ],
        ),
        SizedBox(width: responsive.xs),
        // Bars
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sortedKeys.map((day) {
              final value = activityByDay[day]!;
              final heightPercent = maxValue > 0 ? value / maxValue : 0;
              final barHeight = responsive.isSmallScreen ? 110.0 : 140.0;
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.isSmallScreen ? 16 : 20,
                    height: barHeight * heightPercent,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: responsive.xs),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: responsive.fontSize(10),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, ResponsiveUtil responsive) {
    return Container(
      padding: responsive.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.surface
            : AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: responsive.iconSize(20),
              ),
              SizedBox(width: responsive.xs),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryBreakdownSection(BuildContext context, List<ConversationModel> conversations, ResponsiveUtil responsive) {
    // Group by category
    final Map<String, int> categoryBreakdown = {};
    
    for (var conversation in conversations) {
      categoryBreakdown[conversation.categoryId] = (categoryBreakdown[conversation.categoryId] ?? 0) + 1;
    }
    
    final categoryNames = {
      '1': 'Job Interviews',
      '2': 'Public Speaking',
      '3': 'Social Situations',
    };
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
          ),
        ),
        SizedBox(height: responsive.md),
        Container(
          padding: responsive.responsivePadding(all: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.surface
                : AppColors.darkCardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: categoryBreakdown.entries.map((entry) {
              final categoryId = entry.key;
              final count = entry.value;
              final total = conversations.length;
              final percent = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryNames[categoryId] ?? 'Unknown Category',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                          ),
                        ),
                        Text(
                          '$count ($percent%)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.xs),
                    LinearProgressIndicator(
                      value: total > 0 ? count / total : 0,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildScoreAnalysisSection(BuildContext context, List<ConversationModel> conversations, ResponsiveUtil responsive) {
    final completedConversations = conversations.where((c) => c.isCompleted && c.score != null).toList();
    
    if (completedConversations.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Analysis',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
            ),
          ),
          SizedBox(height: responsive.md),
          Container(
            padding: responsive.responsivePadding(all: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.surface
                  : AppColors.darkCardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No scored conversations yet'),
              ),
            ),
          ),
        ],
      );
    }
    
    // Find highest and lowest scoring conversations
    completedConversations.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    final highestScoring = completedConversations.first;
    final lowestScoring = completedConversations.last;
    
    // Calculate score distribution
    final scoreRanges = {
      '0-1': 0,
      '1-2': 0,
      '2-3': 0,
      '3-4': 0,
      '4-5': 0,
    };
    
    for (var conversation in completedConversations) {
      final score = conversation.score ?? 0;
      if (score < 1) {
        scoreRanges['0-1'] = (scoreRanges['0-1'] ?? 0) + 1;
      } else if (score < 2) {
        scoreRanges['1-2'] = (scoreRanges['1-2'] ?? 0) + 1;
      } else if (score < 3) {
        scoreRanges['2-3'] = (scoreRanges['2-3'] ?? 0) + 1;
      } else if (score < 4) {
        scoreRanges['3-4'] = (scoreRanges['3-4'] ?? 0) + 1;
      } else {
        scoreRanges['4-5'] = (scoreRanges['4-5'] ?? 0) + 1;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score Analysis',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
          ),
        ),
        SizedBox(height: responsive.md),
        Container(
          padding: responsive.responsivePadding(all: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.surface
                : AppColors.darkCardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score Distribution',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 18),
                ),
              ),
              SizedBox(height: responsive.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: scoreRanges.entries.map((entry) {
                  final range = entry.key;
                  final count = entry.value;
                  final total = completedConversations.length;
                  final percent = total > 0 ? (count / total * 100).round() : 0;
                  
                  return Column(
                    children: [
                      Text(
                        '$count',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.titleLarge?.fontSize ?? 20),
                        ),
                      ),
                      SizedBox(height: responsive.xs),
                      Text(
                        range,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.bodySmall?.fontSize ?? 12),
                        ),
                      ),
                      SizedBox(height: responsive.xs),
                      Container(
                        width: responsive.isSmallScreen ? 80 : 100,
                        height: 60.0 * (percent / 100.0),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: responsive.md),
              Text(
                'Highest Scoring Conversation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 18),
                ),
              ),
              SizedBox(height: responsive.xs),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  highestScoring.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                  ),
                ),
                subtitle: Text(
                  highestScoring.topic,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: responsive.fontSize(Theme.of(context).textTheme.bodySmall?.fontSize ?? 12),
                  ),
                ),
                trailing: Container(
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
                      SizedBox(width: responsive.xs),
                      Text(
                        highestScoring.score?.toStringAsFixed(1) ?? '0.0',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ).copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  int _getLastSevenDaysCount(List<ConversationModel> conversations) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return conversations.where((c) => c.createdAt.isAfter(sevenDaysAgo)).length;
  }
} 