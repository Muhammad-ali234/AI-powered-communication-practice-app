import 'package:flutter/material.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  
  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.categoryDetail,
          arguments: category,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
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
            // Category header with icon
            Container(
              height: responsive.isSmallScreen ? 80 : 100,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getIconData(category.iconName),
                  size: responsive.iconSize(48),
                  color: category.color,
                ),
              ),
            ),
            
            // Category title and description
            Expanded(
              child: Padding(
                padding: responsive.responsivePadding(all: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            category.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16)
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (category.isPremium)
                          Icon(
                            Icons.star_rounded,
                            size: responsive.iconSize(18),
                            color: Colors.amber[700],
                          ),
                      ],
                    ),
                    SizedBox(height: responsive.xs),
                    Flexible(
                      child: Text(
                        category.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14)
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    _buildDifficultyBadge(context, responsive),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDifficultyBadge(BuildContext context, ResponsiveUtil responsive) {
    Color badgeColor;
    switch (category.difficulty) {
      case CategoryDifficulty.beginner:
        badgeColor = Colors.green;
        break;
      case CategoryDifficulty.intermediate:
        badgeColor = Colors.blue;
        break;
      case CategoryDifficulty.advanced:
        badgeColor = Colors.orange;
        break;
      case CategoryDifficulty.expert:
        badgeColor = Colors.red;
        break;
    }
    
    return Container(
      padding: responsive.responsivePadding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category.difficulty.name,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: responsive.fontSize(Theme.of(context).textTheme.bodySmall?.fontSize ?? 12),
        ),
      ),
    );
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