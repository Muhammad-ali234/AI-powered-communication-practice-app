import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/utils/theme.dart';

class StatsDashboard extends StatelessWidget {
  const StatsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context).user;
    if (user == null) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Conversations',
                  '${user.conversationsCompleted}',
                  Icons.chat_bubble_outline_rounded,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Current Streak',
                  '${user.streak} days',
                  Icons.local_fire_department_outlined,
                  AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Average Score',
                  user.averageScore.toStringAsFixed(1),
                  Icons.star_outline_rounded,
                  AppColors.secondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Badges Earned',
                  '${user.badges.length}',
                  Icons.workspace_premium_outlined,
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildActivityCard(context, user.lastActive),
          const SizedBox(height: 32),
          _buildTipsCard(context),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.textPrimary
                  : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.textSecondary
                  : AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityCard(BuildContext context, DateTime lastActive) {
    final dateFormat = DateFormat('MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActiveDate = DateTime(
      lastActive.year,
      lastActive.month,
      lastActive.day,
    );
    
    final difference = today.difference(lastActiveDate).inDays;
    
    String activityStatus;
    Color statusColor;
    
    if (difference == 0) {
      activityStatus = 'Today';
      statusColor = AppColors.success;
    } else if (difference == 1) {
      activityStatus = 'Yesterday';
      statusColor = AppColors.success;
    } else if (difference <= 3) {
      activityStatus = '$difference days ago';
      statusColor = AppColors.warning;
    } else {
      activityStatus = '$difference days ago';
      statusColor = AppColors.error;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
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
            'Last Activity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(lastActive),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    timeFormat.format(lastActive),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  activityStatus,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTipsCard(BuildContext context) {
    const tips = [
      'Practice regularly to improve your communication skills',
      'Review your past conversations to identify patterns',
      'Try different topics to expand your communication range',
      'Challenge yourself with more complex scenarios',
      'Share your progress with friends to stay motivated',
    ];
    
    final randomTip = tips[DateTime.now().millisecond % tips.length];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tip of the Day',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  randomTip,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 