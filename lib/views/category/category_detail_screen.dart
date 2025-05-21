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
    
    // Debug prints to help diagnose layout issues
    print('Screen size: ${MediaQuery.of(context).size}');
    print('Responsive status: Small: ${responsive.isSmallScreen}, Medium: ${responsive.isMediumScreen}');
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, category),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDifficultyIndicator(context, category),
                  const SizedBox(height: 24),
                  _buildCategoryDescription(context, category),
                  const SizedBox(height: 24),
                  Container(
                    color: Colors.red.withOpacity(0.3),
                    height: 200,
                    child: _buildTopicsList(context, category, responsive),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, category),
    );
  }
  
  Widget _buildAppBar(BuildContext context, CategoryModel category) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          category.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
              size: 80,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
      actions: [
        if (category.isPremium)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: const Text(
                'PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              backgroundColor: Colors.amber[700],
              avatar: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildDifficultyIndicator(BuildContext context, CategoryModel category) {
    final difficultyColor = category.difficulty.color;
    
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
            'Difficulty Level',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _getDifficultyValue(category.difficulty),
                  backgroundColor: Colors.grey.shade200,
                  color: difficultyColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category.difficulty.name,
                  style: TextStyle(
                    color: difficultyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getDifficultyDescription(category.difficulty),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryDescription(BuildContext context, CategoryModel category) {
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
            'About this category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            category.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopicsList(BuildContext context, CategoryModel category, ResponsiveUtil responsive) {
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
            'Topics',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: SizedBox(
              height: 200,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(responsive.md),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: responsive.isMediumScreen ? 2 : responsive.isLargeScreen ? 3 : 4,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: responsive.md,
                  mainAxisSpacing: responsive.md,
                ),
                itemCount: category.topics.length,
                itemBuilder: (context, index) {
                  return _buildTopicItem(context, category.topics[index], category);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopicItem(BuildContext context, String topic, CategoryModel category) {
    final isPremiumLocked = category.isPremium && 
        !Provider.of<AuthController>(context, listen: false).currentUser!.isPremium;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              topic,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          isPremiumLocked
              ? Icon(
                  Icons.lock_rounded,
                  color: Colors.amber[700],
                  size: 20,
                )
              : Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar(BuildContext context, CategoryModel category) {
    final isPremiumLocked = category.isPremium && 
        !Provider.of<UserController>(context, listen: false).user!.isPremium;
    
    return Container(
      padding: const EdgeInsets.all(16),
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
                  onPressed: () => _showPremiumDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded),
                      SizedBox(width: 8),
                      Text('Unlock Premium Content'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Navigate back
                    Navigator.pop(context);
                  },
                  child: const Text('Not now'),
                ),
              ],
            )
          : ElevatedButton(
              onPressed: () => _showPracticeSetupDialog(context, category),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Start Practice Session'),
            ),
    );
  }
  
  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: Colors.amber[700],
            ),
            const SizedBox(width: 8),
            const Text('Upgrade to Premium'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock all premium features including:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPremiumFeatureItem(
              context, 
              'All Premium Categories',
              'Access to Business Negotiations, Team Leadership, and more',
            ),
            _buildPremiumFeatureItem(
              context, 
              'Unlimited Practice Sessions',
              'Practice as much as you want with no limits',
            ),
            _buildPremiumFeatureItem(
              context, 
              'Advanced AI Feedback',
              'Get detailed feedback on your communication style',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Not now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement premium purchase
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Premium upgrade would be implemented here'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPremiumFeatureItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Colors.amber[700],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPracticeSetupDialog(BuildContext context, CategoryModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Configure your practice session settings',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Choose a topic:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: category.topics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.chat_rounded,
                      color: category.color,
                    ),
                    title: Text(category.topics[index]),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.pop(context);
                      _startPracticeSession(context, category, category.topics[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
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
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Random Topic'),
            ),
            const SizedBox(height: 16),
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