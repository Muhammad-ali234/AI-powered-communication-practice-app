import 'package:flutter/material.dart';
import 'package:communication_practice/utils/theme.dart';

enum SocialLoginType { google, apple, facebook }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback onPressed;
  
  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    String label;
    
    switch (type) {
      case SocialLoginType.google:
        iconData = Icons.g_mobiledata_rounded;
        label = 'Google';
        break;
      case SocialLoginType.apple:
        iconData = Icons.apple_rounded;
        label = 'Apple';
        break;
      case SocialLoginType.facebook:
        iconData = Icons.facebook_rounded;
        label = 'Facebook';
        break;
    }
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textHint.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.2),
          child: Center(
            child: Icon(
              iconData,
              size: 32,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}