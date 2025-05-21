import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:communication_practice/controllers/achievement_controller.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/models/achievement_model.dart';
import 'package:communication_practice/utils/theme.dart';

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({super.key});

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  AchievementCategory _selectedCategory = AchievementCategory.conversations;
  
  @override
  Widget build(BuildContext context) {
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
          return const Center(
            child: Text('No achievements available'),
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
            _buildCategorySelector(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Progress: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$completionPercentage%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: completionPercentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
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
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredAchievements.length,
                      itemBuilder: (context, index) {
                        return _buildAchievementCard(
                          context,
                          filteredAchievements[index],
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildCategorySelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
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
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildAchievementCard(BuildContext context, AchievementModel achievement) {
    final isUnlocked = achievement.isUnlocked;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isUnlocked
          ? AppColors.surface
          : Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade100
              : AppColors.darkCardBackground.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(achievement.iconName),
                color: isUnlocked ? AppColors.primary : Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUnlocked
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isUnlocked && achievement.unlockedAt != null)
                    Text(
                      'Unlocked on ${DateFormat('MMM d, yyyy').format(achievement.unlockedAt!)}',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    LinearProgressIndicator(
                      value: achievement.progress,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColors.primary,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                ],
              ),
            ),
            if (isUnlocked)
              const Icon(
                Icons.verified_rounded,
                color: AppColors.success,
              ),
          ],
        ),
      ),
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