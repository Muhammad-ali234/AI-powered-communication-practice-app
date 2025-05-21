import 'package:flutter/material.dart';
import 'package:communication_practice/utils/theme.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  
  const LoadingIndicator({
    super.key,
    this.size = 36.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
          strokeWidth: 3.0,
        ),
      ),
    );
  }
} 