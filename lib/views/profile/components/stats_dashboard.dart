import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';

class StatsDashboard extends StatelessWidget {
  const StatsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    final user = Provider.of<UserController>(context).user;
    
    if (user == null) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      padding: responsive.responsivePadding(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: responsive.fontSize(24),
            ),
          ),
          SizedBox(height: responsive.lg),
          _buildStatsGrid(context, responsive, user),
          SizedBox(height: responsive.xl),
          _buildActivityCard(context, responsive, user.lastActive),
          SizedBox(height: responsive.xl),
          _buildTipsCard(context, responsive),
        ],
      ),
    );
  }
  
  Widget _buildStatsGrid(BuildContext context, ResponsiveUtil responsive, dynamic user) {
    final stats = [
      {
        'title': 'Conversations',
        'value': '${user.conversationsCompleted}',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Current Streak',
        'value': '${user.streak} days',
        'icon': Icons.local_fire_department_outlined,
        'color': AppColors.accent,
      },
      {
        'title': 'Average Score',
        'value': user.averageScore.toStringAsFixed(1),
        'icon': Icons.star_outline_rounded,
        'color': AppColors.secondary,
      },
      {
        'title': 'Badges Earned',
        'value': '${user.badges.length}',
        'icon': Icons.workspace_premium_outlined,
        'color': Colors.amber,
      },
    ];
    
    // Always use 2 cards per row, stacked in columns
    return Column(
      children: [
        // First row: Conversations and Current Streak
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                responsive,
                stats[0]['title'] as String,
                stats[0]['value'] as String,
                stats[0]['icon'] as IconData,
                stats[0]['color'] as Color,
              ),
            ),
            SizedBox(width: responsive.md),
            Expanded(
              child: _buildStatCard(
                context,
                responsive,
                stats[1]['title'] as String,
                stats[1]['value'] as String,
                stats[1]['icon'] as IconData,
                stats[1]['color'] as Color,
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.md),
        // Second row: Average Score and Badges Earned
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                responsive,
                stats[2]['title'] as String,
                stats[2]['value'] as String,
                stats[2]['icon'] as IconData,
                stats[2]['color'] as Color,
              ),
            ),
            SizedBox(width: responsive.md),
            Expanded(
              child: _buildStatCard(
                context,
                responsive,
                stats[3]['title'] as String,
                stats[3]['value'] as String,
                stats[3]['icon'] as IconData,
                stats[3]['color'] as Color,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    ResponsiveUtil responsive,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: responsive.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.surface
            : AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(responsive.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.isSmallScreen ? 8 : 10,
            offset: Offset(0, responsive.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: responsive.iconSize(28),
          ),
          SizedBox(height: responsive.sm * 1.5),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: responsive.fontSize(20),
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.textPrimary
                  : AppColors.darkTextPrimary,
            ),
          ),
          SizedBox(height: responsive.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: responsive.fontSize(14),
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.textSecondary
                  : AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityCard(BuildContext context, ResponsiveUtil responsive, DateTime lastActive) {
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
      padding: responsive.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.surface
            : AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(responsive.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.isSmallScreen ? 8 : 10,
            offset: Offset(0, responsive.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: responsive.fontSize(18),
            ),
          ),
          SizedBox(height: responsive.md),
          responsive.isSmallScreen
              ? _buildActivityContentVertical(
                  context, responsive, dateFormat, timeFormat, lastActive, activityStatus, statusColor)
              : _buildActivityContentHorizontal(
                  context, responsive, dateFormat, timeFormat, lastActive, activityStatus, statusColor),
        ],
      ),
    );
  }
  
  Widget _buildActivityContentHorizontal(
    BuildContext context,
    ResponsiveUtil responsive,
    DateFormat dateFormat,
    DateFormat timeFormat,
    DateTime lastActive,
    String activityStatus,
    Color statusColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(lastActive),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: responsive.fontSize(16),
              ),
            ),
            Text(
              timeFormat.format(lastActive),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: responsive.fontSize(14),
              ),
            ),
          ],
        ),
        _buildStatusBadge(responsive, activityStatus, statusColor),
      ],
    );
  }
  
  Widget _buildActivityContentVertical(
    BuildContext context,
    ResponsiveUtil responsive,
    DateFormat dateFormat,
    DateFormat timeFormat,
    DateTime lastActive,
    String activityStatus,
    Color statusColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateFormat.format(lastActive),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: responsive.fontSize(16),
              ),
            ),
            _buildStatusBadge(responsive, activityStatus, statusColor),
          ],
        ),
        SizedBox(height: responsive.xs),
        Text(
          timeFormat.format(lastActive),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: responsive.fontSize(14),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusBadge(ResponsiveUtil responsive, String activityStatus, Color statusColor) {
    return Container(
      padding: responsive.responsivePadding(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      child: Text(
        activityStatus,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: responsive.fontSize(12),
        ),
      ),
    );
  }
  
  Widget _buildTipsCard(BuildContext context, ResponsiveUtil responsive) {
    const tips = [
      'Practice regularly to improve your communication skills',
      'Review your past conversations to identify patterns',
      'Try different topics to expand your communication range',
      'Challenge yourself with more complex scenarios',
      'Share your progress with friends to stay motivated',
    ];
    
    final randomTip = tips[DateTime.now().millisecond % tips.length];
    
    return Container(
      padding: responsive.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      child: responsive.isSmallScreen
          ? _buildTipsContentVertical(context, responsive, randomTip)
          : _buildTipsContentHorizontal(context, responsive, randomTip),
    );
  }
  
  Widget _buildTipsContentHorizontal(BuildContext context, ResponsiveUtil responsive, String randomTip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lightbulb_outline,
          color: AppColors.primary,
          size: responsive.iconSize(24),
        ),
        SizedBox(width: responsive.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tip of the Day',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: responsive.fontSize(14),
                ),
              ),
              SizedBox(height: responsive.xs),
              Text(
                randomTip,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTipsContentVertical(BuildContext context, ResponsiveUtil responsive, String randomTip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: AppColors.primary,
              size: responsive.iconSize(20),
            ),
            SizedBox(width: responsive.sm),
            Text(
              'Tip of the Day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: responsive.fontSize(14),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.sm),
        Text(
          randomTip,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: responsive.fontSize(14),
          ),
        ),
      ],
    );
  }
}