import 'package:flutter/material.dart';
import 'package:communication_practice/utils/responsive.dart';
import 'package:communication_practice/widgets/responsive_wrapper.dart';

class ResponsiveScreen extends StatelessWidget {
  final Widget child;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  const ResponsiveScreen({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.padding,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    // Determine responsive padding for the screen
    EdgeInsetsGeometry screenPadding = padding ?? 
      responsive.responsivePadding(
        horizontal: responsive.md, 
        vertical: responsive.sm
      );
    
    // Calculate content maximum width for larger screens
    double? maxWidth;
    
    if (responsive.isLargeScreen || responsive.isExtraLargeScreen) {
      // On larger screens, we want to constrain the width to avoid excessively wide content
      maxWidth = 1200.0;
    }
    
    return Scaffold(
      appBar: appBar is PreferredSizeWidget 
        ? appBar as PreferredSizeWidget 
        : (appBar != null ? _buildCustomAppBar(appBar!, responsive) : null),
      body: SafeArea(
        child: ResponsiveWrapper(
          padding: screenPadding,
          maxWidth: maxWidth,
          alignment: Alignment.topCenter,
          applyScalingToChild: false,
          child: child,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
    );
  }
  
  PreferredSizeWidget _buildCustomAppBar(Widget appBarWidget, ResponsiveUtil responsive) {
    // Wrap the provided appBar widget to make it a PreferredSizeWidget
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: appBarWidget,
    );
  }
} 