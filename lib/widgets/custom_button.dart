import 'package:flutter/material.dart';
import 'package:communication_practice/utils/theme.dart';

enum ButtonType { filled, outline, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final ButtonType type;
  final bool isLoading;
  final bool showIconAfterLabel;
  final bool isFullWidth;
  
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = ButtonType.filled,
    this.isLoading = false,
    this.showIconAfterLabel = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Define button properties based on type
    Color backgroundColor;
    Color textColor;
    Color? borderColor;
    
    switch (type) {
      case ButtonType.filled:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        borderColor = null;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = AppColors.primary;
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = null;
        break;
    }
    
    // Create button content
    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !showIconAfterLabel) ...[
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: theme.textTheme.labelLarge!.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (icon != null && showIconAfterLabel) ...[
          const SizedBox(width: 8),
          Icon(icon, color: textColor, size: 20),
        ],
      ],
    );
    
    // Show loading indicator if isLoading is true
    if (isLoading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }
    
    // Create container with proper styling
    final container = Container(
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
      ),
      child: Center(child: content),
    );
    
    // Wrap with Material for ink effects
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: type == ButtonType.filled
            ? Colors.white.withOpacity(0.1)
            : AppColors.primary.withOpacity(0.1),
        highlightColor: type == ButtonType.filled
            ? Colors.white.withOpacity(0.2)
            : AppColors.primary.withOpacity(0.2),
        child: isFullWidth ? container : Center(child: container),
      ),
    );
  }
}