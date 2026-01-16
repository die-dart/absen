import 'package:flutter/material.dart';

/// Provides responsive spacing values based on screen size
class AppSpacing {
  /// Base spacing unit (8px)
  static const double base = 8.0;
  
  /// Extra small spacing (4px)
  static const double xs = 4.0;
  
  /// Small spacing (8px)
  static const double sm = 8.0;
  
  /// Medium spacing (16px)
  static const double md = 16.0;
  
  /// Large spacing (24px)
  static const double lg = 24.0;
  
  /// Extra large spacing (32px)
  static const double xl = 32.0;
  
  /// Extra extra large spacing (48px)
  static const double xxl = 48.0;
  
  /// Get responsive horizontal padding based on screen width
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return md; // Small screens (12px)
    } else if (width < 600) {
      return md; // Medium screens (16px)
    } else {
      return lg; // Large screens (24px)
    }
  }
  
  /// Get responsive vertical padding based on screen height
  static double getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) {
      return md; // Short screens
    } else {
      return lg; // Tall screens
    }
  }
  
  /// Check if screen is small (width < 360)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }
  
  /// Check if screen is medium (360 <= width < 600)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 360 && width < 600;
  }
  
  /// Check if screen is large (width >= 600)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }
}

/// Screen size breakpoints
class AppBreakpoints {
  static const double small = 360;
  static const double medium = 600;
  static const double large = 900;
}
