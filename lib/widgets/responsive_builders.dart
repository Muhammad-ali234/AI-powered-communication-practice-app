import 'package:flutter/material.dart';
import 'package:communication_practice/utils/responsive.dart';

/// A responsive grid layout that adjusts based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? smallScreenCrossAxisCount;
  final int? mediumScreenCrossAxisCount;
  final int? largeScreenCrossAxisCount;
  final int? extraLargeScreenCrossAxisCount;
  final double childAspectRatio;
  final ScrollPhysics? physics;
  
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.smallScreenCrossAxisCount,
    this.mediumScreenCrossAxisCount,
    this.largeScreenCrossAxisCount,
    this.extraLargeScreenCrossAxisCount,
    this.childAspectRatio = 1.0,
    this.physics,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    // Determine number of columns based on screen size
    int crossAxisCount = smallScreenCrossAxisCount ?? 1;
    
    if (responsive.isMediumScreen && mediumScreenCrossAxisCount != null) {
      crossAxisCount = mediumScreenCrossAxisCount!;
    } else if (responsive.isLargeScreen && largeScreenCrossAxisCount != null) {
      crossAxisCount = largeScreenCrossAxisCount!;
    } else if (responsive.isExtraLargeScreen && extraLargeScreenCrossAxisCount != null) {
      crossAxisCount = extraLargeScreenCrossAxisCount!;
    } else if (!responsive.isSmallScreen) {
      // Default number of columns if specific counts not provided
      crossAxisCount = responsive.gridCrossAxisCount;
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A builder widget that provides different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, ResponsiveUtil) builder;
  final Widget? smallScreen;
  final Widget? mediumScreen;
  final Widget? largeScreen;
  final Widget? extraLargeScreen;
  
  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.smallScreen,
    this.mediumScreen,
    this.largeScreen,
    this.extraLargeScreen,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    // If specific layouts are provided for the current screen size, use those
    if (responsive.isSmallScreen && smallScreen != null) {
      return smallScreen!;
    } else if (responsive.isMediumScreen && mediumScreen != null) {
      return mediumScreen!;
    } else if (responsive.isLargeScreen && largeScreen != null) {
      return largeScreen!;
    } else if (responsive.isExtraLargeScreen && extraLargeScreen != null) {
      return extraLargeScreen!;
    }
    
    // Otherwise use the builder function
    return builder(context, responsive);
  }
}

/// A responsive row/column that automatically switches between row and column
/// based on screen size or orientation
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final bool rowForLargeScreen;
  final bool columnForSmallScreen;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  
  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.rowForLargeScreen = true,
    this.columnForSmallScreen = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 8.0,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    final isSmallScreen = responsive.isSmallScreen;
    
    // Determine if we should use a row or column
    final useRow = (isSmallScreen && !columnForSmallScreen) || 
                  (!isSmallScreen && rowForLargeScreen);
    
    if (useRow) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacers(children, spacing, true),
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacers(children, spacing, false),
      );
    }
  }
  
  // Helper to add spacing between children
  List<Widget> _addSpacers(List<Widget> widgets, double spacing, bool isRow) {
    if (widgets.isEmpty) return [];
    if (widgets.length == 1) return widgets;
    
    final List<Widget> result = [];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(isRow ? SizedBox(width: spacing) : SizedBox(height: spacing));
      }
    }
    return result;
  }
}

/// A responsive container with text that scales its font size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool scaleText;
  
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.scaleText = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    TextStyle? effectiveStyle = style;
    if (style != null && scaleText) {
      final double fontSize = style!.fontSize ?? Theme.of(context).textTheme.bodyMedium!.fontSize!;
      effectiveStyle = style!.copyWith(
        fontSize: responsive.fontSize(fontSize),
      );
    }
    
    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
} 