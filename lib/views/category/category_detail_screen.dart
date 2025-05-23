import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/models/user_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/utils/responsive.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as CategoryModel;
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, category, responsive),
          SliverToBoxAdapter(
            child: Padding(
              padding: responsive.responsivePadding(all: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDifficultyIndicator(context, category, responsive),
                  SizedBox(height: responsive.lg),
                  _buildCategoryDescription(context, category, responsive),
                  SizedBox(height: responsive.lg),
                  _buildTopicsList(context, category, responsive),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, category, responsive),
    );
  }
  
  Widget _buildAppBar(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
    return SliverAppBar(
      expandedHeight: responsive.isSmallScreen ? 150 : 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          category.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: responsive.fontSize(18),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color,
                category.color.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              _getIconData(category.iconName),
              size: responsive.iconSize(80),
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
      actions: [
        if (category.isPremium)
          Padding(
            padding: responsive.responsivePadding(all: 8),
            child: Chip(
              label: Text(
                'PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.fontSize(12),
                ),
              ),
              backgroundColor: Colors.amber[700],
              avatar: Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: responsive.iconSize(16),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildDifficultyIndicator(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
    // Get color based on difficulty level
    final Color difficultyColor;
    switch (category.difficulty) {
      case CategoryDifficulty.beginner:
        difficultyColor = Colors.green;
        break;
      case CategoryDifficulty.intermediate:
        difficultyColor = Colors.blue;
        break;
      case CategoryDifficulty.advanced:
        difficultyColor = Colors.orange;
        break;
      case CategoryDifficulty.expert:
        difficultyColor = Colors.red;
        break;
    }
    
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
          Text(
            'Difficulty Level',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
            ),
          ),
          SizedBox(height: responsive.md),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _getDifficultyValue(category.difficulty),
                  backgroundColor: Colors.grey.shade200,
                  color: difficultyColor,
                  minHeight: responsive.isSmallScreen ? 6 : 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: responsive.md),
              Container(
                padding: responsive.responsivePadding(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category.difficulty.name,
                  style: TextStyle(
                    color: difficultyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.fontSize(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.md),
          Text(
            _getDifficultyDescription(category.difficulty),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryDescription(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
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
          Text(
            'About this category',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
            ),
          ),
          SizedBox(height: responsive.sm),
          Text(
            category.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopicsList(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
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
          Text(
            'Topics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
            ),
          ),
          SizedBox(height: responsive.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(responsive.xs),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: responsive.isSmallScreen ? 1 : responsive.isMediumScreen ? 2 : 3,
              childAspectRatio: responsive.isSmallScreen ? 4 : 3,
              crossAxisSpacing: responsive.md,
              mainAxisSpacing: responsive.md,
            ),
            itemCount: category.topics.length,
            itemBuilder: (context, index) {
              return _buildTopicItem(context, category.topics[index], category, responsive);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopicItem(BuildContext context, String topic, CategoryModel category, ResponsiveUtil responsive) {
    final isPremiumLocked = category.isPremium && 
        !Provider.of<AuthController>(context, listen: false).currentUser!.isPremium;
    
    return Container(
      margin: responsive.responsivePadding(bottom: 12),
      padding: responsive.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade50
            : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: category.color,
            size: responsive.iconSize(24),
          ),
          SizedBox(width: responsive.md),
          Expanded(
            child: Text(
              topic,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16),
              ),
            ),
          ),
          isPremiumLocked
              ? Icon(
                  Icons.lock_rounded,
                  color: Colors.amber[700],
                  size: responsive.iconSize(20),
                )
              : Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: responsive.iconSize(16),
                ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
    final isPremiumLocked = category.isPremium && 
        !Provider.of<UserController>(context, listen: false).user!.isPremium;
    
    return Container(
      padding: responsive.responsivePadding(all: 16),
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
      child: isPremiumLocked
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _showPremiumDialog(context, responsive),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, responsive.isSmallScreen ? 48 : 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, size: responsive.iconSize(24)),
                      SizedBox(width: responsive.sm),
                      Text(
                        'Unlock Premium Content',
                        style: TextStyle(
                          fontSize: responsive.fontSize(16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.sm),
                TextButton(
                  onPressed: () {
                    // Navigate back
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Not now',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                ),
              ],
            )
          : ElevatedButton(
              onPressed: () => _showPracticeSetupDialog(context, category, responsive),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, responsive.isSmallScreen ? 48 : 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Start Practice Session',
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                ),
              ),
            ),
    );
  }
  
  void _showPremiumDialog(BuildContext context, ResponsiveUtil responsive) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: Colors.amber[700],
              size: responsive.iconSize(24),
            ),
            SizedBox(width: responsive.sm),
            Text(
              'Upgrade to Premium',
              style: TextStyle(
                fontSize: responsive.fontSize(18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unlock all premium features including:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.fontSize(14),
              ),
            ),
            SizedBox(height: responsive.md),
            _buildPremiumFeatureItem(
              context, 
              'All Premium Categories',
              'Access to Business Negotiations, Team Leadership, and more',
              responsive,
            ),
            _buildPremiumFeatureItem(
              context, 
              'Unlimited Practice Sessions',
              'Practice as much as you want with no limits',
              responsive,
            ),
            _buildPremiumFeatureItem(
              context, 
              'Advanced AI Feedback',
              'Get detailed feedback on your communication style',
              responsive,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Not now',
              style: TextStyle(
                fontSize: responsive.fontSize(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement premium purchase
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Premium upgrade would be implemented here',
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Upgrade Now',
              style: TextStyle(
                fontSize: responsive.fontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPremiumFeatureItem(BuildContext context, String title, String description, ResponsiveUtil responsive) {
    return Padding(
      padding: responsive.responsivePadding(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Colors.amber[700],
            size: responsive.iconSize(20),
          ),
          SizedBox(width: responsive.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.fontSize(14),
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: responsive.fontSize(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPracticeSetupDialog(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: responsive.responsivePadding(all: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : AppColors.darkSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Practice Session Setup',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
              ),
            ),
            SizedBox(height: responsive.xs),
            Text(
              'Configure your practice session settings',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
              ),
            ),
            SizedBox(height: responsive.lg),
            Text(
              'Choose a topic:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
              ),
            ),
            SizedBox(height: responsive.md),
            SizedBox(
              height: responsive.isSmallScreen ? 150 : 200,
              child: ListView.builder(
                itemCount: category.topics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: responsive.responsivePadding(vertical: 4, horizontal: 8),
                    leading: Icon(
                      Icons.chat_rounded,
                      color: category.color,
                      size: responsive.iconSize(24),
                    ),
                    title: Text(
                      category.topics[index],
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: responsive.iconSize(16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _startPracticeSession(context, category, category.topics[index]);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: responsive.md),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                _startPracticeSession(
                  context, 
                  category, 
                  category.topics[DateTime.now().second % category.topics.length]
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, responsive.isSmallScreen ? 48 : 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Random Topic',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
            SizedBox(height: responsive.md),
          ],
        ),
      ),
    );
  }
  
  void _startPracticeSession(BuildContext context, CategoryModel category, String topic) {
    Navigator.pushNamed(
      context,
      AppRoutes.chat,
      arguments: {
        'category': category,
        'topic': topic,
      },
    );
  }
  
  double _getDifficultyValue(CategoryDifficulty difficulty) {
    switch (difficulty) {
      case CategoryDifficulty.beginner:
        return 0.25;
      case CategoryDifficulty.intermediate:
        return 0.50;
      case CategoryDifficulty.advanced:
        return 0.75;
      case CategoryDifficulty.expert:
        return 1.0;
    }
  }
  
  String _getDifficultyDescription(CategoryDifficulty difficulty) {
    switch (difficulty) {
      case CategoryDifficulty.beginner:
        return 'Perfect for newcomers. These exercises focus on basic communication skills with gentle guidance.';
      case CategoryDifficulty.intermediate:
        return 'For those with some experience. These scenarios require more nuanced responses and deeper understanding.';
      case CategoryDifficulty.advanced:
        return 'Challenging scenarios that test your ability to handle complex communication situations effectively.';
      case CategoryDifficulty.expert:
        return 'The most demanding level. These exercises simulate high-stakes professional situations requiring mastery of communication.';
    }
  }
  
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work_outline_rounded;
      case 'record_voice_over':
        return Icons.record_voice_over_rounded;
      case 'groups':
        return Icons.groups_rounded;
      case 'handshake':
        return Icons.handshake_rounded;
      case 'balance':
        return Icons.balance_rounded;
      case 'favorite':
        return Icons.favorite_outline_rounded;
      case 'support_agent':
        return Icons.support_agent_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

extension on UserModel {
  // For demonstration purposes only, in a real app this would be a proper field
  bool get isPremium => false;
}

// Extension is likely already defined elsewhere in the codebase 