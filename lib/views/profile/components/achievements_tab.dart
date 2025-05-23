import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/controllers/achievement_controller.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/models/achievement_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({super.key});

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  AchievementCategory _selectedCategory = AchievementCategory.conversations;
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return Consumer<AchievementController>(
      builder: (context, achievementController, child) {
        if (achievementController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Update achievements based on user profile
        final userController = Provider.of<UserController>(context);
        if (userController.user != null) {
          // This would typically be called when user data changes or on login
          // but we're calling it here for demo purposes
          achievementController.updateAchievements(userController.user!);
        }
        
        final allAchievements = achievementController.achievements;
        
        if (allAchievements.isEmpty) {
          return Center(
            child: Text(
              'No achievements available',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: responsive.fontSize(16),
              ),
            ),
          );
        }
        
        // Filter achievements by selected category
        final filteredAchievements = allAchievements
            .where((a) => a.category == _selectedCategory)
            .toList();
        
        // Calculate completion percentage
        final unlockedCount = filteredAchievements
            .where((a) => a.isUnlocked)
            .length;
        final completionPercentage = filteredAchievements.isNotEmpty
            ? (unlockedCount / filteredAchievements.length * 100).round()
            : 0;
        
        return Column(
          children: [
            _buildCategorySelector(responsive),
            Padding(
              padding: responsive.responsivePadding(all: 16.0),
              child: Row(
                children: [
                  Text(
                    'Progress: ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: responsive.fontSize(16),
                    ),
                  ),
                  Text(
                    '$completionPercentage%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSize(16),
                    ),
                  ),
                  SizedBox(width: responsive.sm),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: completionPercentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.primary,
                      minHeight: responsive.isSmallScreen ? 6 : 8,
                      borderRadius: BorderRadius.circular(responsive.xs),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredAchievements.isEmpty
                  ? Center(
                      child: Text(
                        'No ${_selectedCategory.name} achievements available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: responsive.fontSize(16),
                        ),
                      ),
                    )
                  : _buildAchievementsList(responsive, filteredAchievements),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildAchievementsList(ResponsiveUtil responsive, List<AchievementModel> achievements) {
    // Use grid layout for larger screens
    if (responsive.isLargeScreen || responsive.isExtraLargeScreen) {
      return GridView.builder(
        padding: responsive.responsivePadding(all: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive.gridCrossAxisCount.clamp(1, 2), // Max 2 columns for achievements
          crossAxisSpacing: responsive.md,
          mainAxisSpacing: responsive.md,
          childAspectRatio: responsive.isExtraLargeScreen ? 2.5 : 2.0,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return _buildAchievementCard(
            context,
            responsive,
            achievements[index],
          );
        },
      );
    }
    
    // Use list layout for smaller screens
    return ListView.builder(
      padding: responsive.responsivePadding(all: 16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: responsive.md),
          child: _buildAchievementCard(
            context,
            responsive,
            achievements[index],
          ),
        );
      },
    );
  }
  
  Widget _buildCategorySelector(ResponsiveUtil responsive) {
    return Container(
      height: responsive.isSmallScreen ? 50 : 60,
      padding: responsive.responsivePadding(
        vertical: 8,
        horizontal: 16,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AchievementCategory.values.map((category) {
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: responsive.sm * 1.5),
              padding: responsive.responsivePadding(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(responsive.isSmallScreen ? 16 : 20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  _formatCategoryName(category.name),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: responsive.fontSize(14),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildAchievementCard(BuildContext context, ResponsiveUtil responsive, AchievementModel achievement) {
    final isUnlocked = achievement.isUnlocked;
    final cardPadding = responsive.responsivePadding(all: 16.0);
    final iconSize = responsive.iconSize(30);
    final containerSize = responsive.iconSize(60);
    
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.md),
      ),
      color: isUnlocked
          ? AppColors.surface
          : Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade100
              : AppColors.darkCardBackground.withOpacity(0.5),
      child: Padding(
        padding: cardPadding,
        child: responsive.isSmallScreen
            ? _buildCompactLayout(context, responsive, achievement, isUnlocked, iconSize, containerSize)
            : _buildStandardLayout(context, responsive, achievement, isUnlocked, iconSize, containerSize),
      ),
    );
  }
  
  Widget _buildStandardLayout(
    BuildContext context,
    ResponsiveUtil responsive,
    AchievementModel achievement,
    bool isUnlocked,
    double iconSize,
    double containerSize,
  ) {
    return Row(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: isUnlocked
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconData(achievement.iconName),
            color: isUnlocked ? AppColors.primary : Colors.grey,
            size: iconSize,
          ),
        ),
        SizedBox(width: responsive.md),
        Expanded(
          child: _buildAchievementContent(context, responsive, achievement, isUnlocked),
        ),
        if (isUnlocked)
          Icon(
            Icons.verified_rounded,
            color: AppColors.success,
            size: responsive.iconSize(24),
          ),
      ],
    );
  }
  
  Widget _buildCompactLayout(
    BuildContext context,
    ResponsiveUtil responsive,
    AchievementModel achievement,
    bool isUnlocked,
    double iconSize,
    double containerSize,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: containerSize * 0.8, // Smaller icon container for mobile
              height: containerSize * 0.8,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(achievement.iconName),
                color: isUnlocked ? AppColors.primary : Colors.grey,
                size: iconSize * 0.8,
              ),
            ),
            SizedBox(width: responsive.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isUnlocked
                          ? Theme.of(context).textTheme.titleMedium?.color
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                  if (isUnlocked)
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.success,
                      size: responsive.iconSize(20),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.sm),
        _buildAchievementContent(context, responsive, achievement, isUnlocked),
      ],
    );
  }
  
  Widget _buildAchievementContent(
    BuildContext context,
    ResponsiveUtil responsive,
    AchievementModel achievement,
    bool isUnlocked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!responsive.isSmallScreen) // Title already shown in compact layout
          Text(
            achievement.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isUnlocked
                  ? Theme.of(context).textTheme.titleMedium?.color
                  : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: responsive.fontSize(16),
            ),
          ),
        if (!responsive.isSmallScreen)
          SizedBox(height: responsive.xs),
        Text(
          achievement.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isUnlocked
                ? Theme.of(context).textTheme.bodyMedium?.color
                : Colors.grey,
            fontSize: responsive.fontSize(14),
          ),
        ),
        SizedBox(height: responsive.sm),
        if (isUnlocked && achievement.unlockedAt != null)
          Text(
            'Unlocked on ${DateFormat('MMM d, yyyy').format(achievement.unlockedAt!)}',
            style: TextStyle(
              color: AppColors.success,
              fontSize: responsive.fontSize(12),
              fontWeight: FontWeight.w500,
            ),
          )
        else
          LinearProgressIndicator(
            value: achievement.progress,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.primary,
            minHeight: responsive.isSmallScreen ? 4 : 6,
            borderRadius: BorderRadius.circular(responsive.xs / 2),
          ),
      ],
    );
  }
  
  String _formatCategoryName(String name) {
    return name.split('_').map((word) {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }).join(' ');
  }
  
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'chat_bubble':
        return Icons.chat_bubble_outline_rounded;
      case 'school':
        return Icons.school_outlined;
      case 'workspace_premium':
        return Icons.workspace_premium_outlined;
      case 'star':
        return Icons.star_outline_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_outlined;
      case 'auto_awesome':
        return Icons.auto_awesome_outlined;
      case 'explore':
        return Icons.explore_outlined;
      default:
        return Icons.emoji_events_outlined;
    }
  }
}