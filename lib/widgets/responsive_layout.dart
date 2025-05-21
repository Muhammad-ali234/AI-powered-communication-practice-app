import 'package:flutter/material.dart';
import 'package:communication_practice/utils/responsive.dart';
import 'package:communication_practice/widgets/responsive_screen.dart';
import 'package:communication_practice/widgets/responsive_wrapper.dart';

/// A utility class for making existing screens responsive.
/// This class provides methods to convert any screen to a responsive layout.
class ResponsiveLayout {
  
  /// Wraps an existing screen with responsive components.
  /// Use this to quickly convert any existing screen to be responsive.
  static Widget wrapScreen(
    BuildContext context, 
    Widget screen, 
    {
      bool useScaffold = true,
      bool useSafeArea = true,
      EdgeInsetsGeometry? padding,
      Color? backgroundColor,
      PreferredSizeWidget? appBar,
      Widget? bottomNavigationBar,
      Widget? floatingActionButton,
      FloatingActionButtonLocation? floatingActionButtonLocation,
      bool resizeToAvoidBottomInset = true,
    }
  ) {
    final responsive = ResponsiveUtil(context);
    
    Widget wrappedScreen = screen;
    
    // Apply padding if specified
    if (padding != null) {
      wrappedScreen = ResponsiveWrapper(
        padding: padding,
        child: wrappedScreen,
      );
    }
    
    // Apply SafeArea if requested
    if (useSafeArea) {
      wrappedScreen = SafeArea(child: wrappedScreen);
    }
    
    // Apply Scaffold if requested
    if (useScaffold) {
      wrappedScreen = ResponsiveScreen(
        padding: EdgeInsets.zero,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        child: wrappedScreen,
      );
    }
    
    return wrappedScreen;
  }
  
  /// Converts any screen layout to be responsive based on breakpoints
  static Widget adaptiveLayout({
    required BuildContext context,
    Widget? smallScreen,
    Widget? mediumScreen,
    Widget? largeScreen,
    Widget? extraLargeScreen,
    required Widget defaultScreen,
  }) {
    final responsive = ResponsiveUtil(context);
    
    if (responsive.isSmallScreen && smallScreen != null) {
      return smallScreen;
    } else if (responsive.isMediumScreen && mediumScreen != null) {
      return mediumScreen;
    } else if (responsive.isLargeScreen && largeScreen != null) {
      return largeScreen;
    } else if (responsive.isExtraLargeScreen && extraLargeScreen != null) {
      return extraLargeScreen;
    }
    
    return defaultScreen;
  }
  
  /// Creates a responsive padding based on screen size
  static EdgeInsets getPadding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final responsive = ResponsiveUtil(context);
    
    return responsive.responsivePadding(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
  
  /// Gets a proportional font size that scales with screen size
  static double getFontSize(BuildContext context, double baseFontSize) {
    final responsive = ResponsiveUtil(context);
    return responsive.fontSize(baseFontSize);
  }
  
  /// Gets a proportional icon size that scales with screen size
  static double getIconSize(BuildContext context, double baseIconSize) {
    final responsive = ResponsiveUtil(context);
    return responsive.iconSize(baseIconSize);
  }
  
  /// Gets a responsive spacing value based on screen size
  static double getSpacing(BuildContext context, SpacingSize size) {
    final responsive = ResponsiveUtil(context);
    
    switch (size) {
      case SpacingSize.xs:
        return responsive.xs;
      case SpacingSize.sm:
        return responsive.sm;
      case SpacingSize.md:
        return responsive.md;
      case SpacingSize.lg:
        return responsive.lg;
      case SpacingSize.xl:
        return responsive.xl;
      case SpacingSize.xxl:
        return responsive.xxl;
    }
  }
  
  /// Gets number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return responsive.gridCrossAxisCount;
  }
}

/// Enum for common spacing sizes
enum SpacingSize {
  xs, // Extra small
  sm, // Small
  md, // Medium
  lg, // Large
  xl, // Extra large
  xxl, // Extra-extra large
} 