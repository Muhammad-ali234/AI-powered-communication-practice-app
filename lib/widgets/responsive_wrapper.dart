import 'package:flutter/material.dart';
import 'package:communication_practice/utils/responsive.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;
  final Alignment alignment;
  final bool applyScalingToChild;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.alignment = Alignment.center,
    this.applyScalingToChild = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    // Determine if we should apply a scaling factor to text
    Widget scaledChild = child;
    if (applyScalingToChild) {
      scaledChild = MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            responsive.isSmallScreen ? 0.8 :
            responsive.isMediumScreen ? 1.0 :
            responsive.isLargeScreen ? 1.2 : 1.4,
          ),
        ),
        child: child,
      );
    }

    // Determine responsive padding
    EdgeInsetsGeometry responsivePadding = padding ?? EdgeInsets.zero;
    if (padding != null && padding is EdgeInsets) {
      final EdgeInsets p = padding as EdgeInsets;
      responsivePadding = responsive.responsivePadding(
        left: p.left,
        right: p.right,
        top: p.top,
        bottom: p.bottom,
      );
    }

    // Determine responsive margin
    EdgeInsetsGeometry responsiveMargin = margin ?? EdgeInsets.zero;
    if (margin != null && margin is EdgeInsets) {
      final EdgeInsets m = margin as EdgeInsets;
      responsiveMargin = responsive.responsivePadding(
        left: m.left,
        right: m.right,
        top: m.top,
        bottom: m.bottom,
      );
    }

    // Apply responsive width/height constraints
    double? responsiveWidth = width;
    double? responsiveHeight = height;
    double? responsiveMaxWidth = maxWidth;
    double? responsiveMaxHeight = maxHeight;

    if (width != null && width! <= 1.0) {
      // If width is a percentage (0.0 to 1.0)
      responsiveWidth = responsive.width(width!);
    }
    
    if (height != null && height! <= 1.0) {
      // If height is a percentage (0.0 to 1.0)
      responsiveHeight = responsive.height(height!);
    }
    
    if (maxWidth != null && maxWidth! <= 1.0) {
      // If maxWidth is a percentage (0.0 to 1.0)
      responsiveMaxWidth = responsive.width(maxWidth!);
    }
    
    if (maxHeight != null && maxHeight! <= 1.0) {
      // If maxHeight is a percentage (0.0 to 1.0)
      responsiveMaxHeight = responsive.height(maxHeight!);
    }

    return Container(
      width: responsiveWidth,
      height: responsiveHeight,
      padding: responsivePadding,
      margin: responsiveMargin,
      alignment: alignment,
      constraints: BoxConstraints(
        maxWidth: responsiveMaxWidth ?? double.infinity,
        maxHeight: responsiveMaxHeight ?? double.infinity,
      ),
      child: scaledChild,
    );
  }
} 