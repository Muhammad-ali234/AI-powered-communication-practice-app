import 'package:flutter/material.dart';

class ResponsiveUtil {
  static const double _smallScreenWidth = 320;
  static const double _mediumScreenWidth = 500;
  static const double _largeScreenWidth = 800;
  static const double _extraLargeScreenWidth = 1200;

  // Device screen info
  final BuildContext context;
  final Size _screenSize;
  final double _width;
  final double _height;
  final double _topPadding;
  final double _bottomPadding;

  // Singleton pattern
  static ResponsiveUtil? _instance;
  static ResponsiveUtil get instance => _instance!;

  factory ResponsiveUtil(BuildContext context) {
    _instance ??= ResponsiveUtil._internal(context);
    return _instance!;
  }

  ResponsiveUtil._internal(this.context)
      : _screenSize = MediaQuery.of(context).size,
        _width = MediaQuery.of(context).size.width,
        _height = MediaQuery.of(context).size.height,
        _topPadding = MediaQuery.of(context).padding.top,
        _bottomPadding = MediaQuery.of(context).padding.bottom;

  // Screen size getters
  double get screenWidth => _width;
  double get screenHeight => _height;
  double get safeHeight => _height - _topPadding - _bottomPadding;
  
  // Screen type checks
  bool get isSmallScreen => _width < _mediumScreenWidth;
  bool get isMediumScreen => _width >= _mediumScreenWidth && _width < _largeScreenWidth;
  bool get isLargeScreen => _width >= _largeScreenWidth && _width < _extraLargeScreenWidth;
  bool get isExtraLargeScreen => _width >= _extraLargeScreenWidth;
  
  // Proportional sizing helpers
  double width(double percentage) => _width * percentage;
  double height(double percentage) => _height * percentage;

  // Responsive sizing methods
  double fontSize(double size) {
    if (isSmallScreen) return size * 0.8;
    if (isMediumScreen) return size;
    if (isLargeScreen) return size * 1.2;
    return size * 1.4; // extraLarge
  }

  double iconSize(double size) {
    if (isSmallScreen) return size * 0.8;
    if (isMediumScreen) return size;
    if (isLargeScreen) return size * 1.2;
    return size * 1.3; // extraLarge
  }

  EdgeInsets responsivePadding({
    double? horizontal,
    double? vertical,
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    // Calculate the scale factor based on screen size
    double scale = 1.0;
    if (isSmallScreen) scale = 0.8;
    if (isLargeScreen) scale = 1.2;
    if (isExtraLargeScreen) scale = 1.5;

    // Apply padding with scaling
    if (all != null) {
      return EdgeInsets.all(all * scale);
    }
    
    return EdgeInsets.only(
      left: (left ?? horizontal ?? 0) * scale,
      right: (right ?? horizontal ?? 0) * scale,
      top: (top ?? vertical ?? 0) * scale,
      bottom: (bottom ?? vertical ?? 0) * scale,
    );
  }

  // Responsive spacing
  double get xs => 4 * (isSmallScreen ? 0.8 : isExtraLargeScreen ? 1.5 : 1.0);
  double get sm => 8 * (isSmallScreen ? 0.8 : isExtraLargeScreen ? 1.5 : 1.0);
  double get md => 16 * (isSmallScreen ? 0.8 : isExtraLargeScreen ? 1.5 : 1.0);
  double get lg => 24 * (isSmallScreen ? 0.8 : isExtraLargeScreen ? 1.5 : 1.0);
  double get xl => 32 * (isSmallScreen ? 0.8 : isExtraLargeScreen ? 1.5 : 1.0);
  double get xxl => 48 * (isSmallScreen ? 0.8 : isExtraLargeScreen ? 1.5 : 1.0);

  // Get appropriate number of grid columns based on screen size
  int get gridCrossAxisCount {
    if (isSmallScreen) return 1;
    if (isMediumScreen) return 2;
    if (isLargeScreen) return 3;
    return 4; // extraLarge
  }
} 