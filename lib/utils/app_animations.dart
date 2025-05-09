import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppAnimations {
  // Button hover effect
  static Animation<double> buttonHoverEffect(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: AppTheme.fastCurve),
      ),
    );
  }
  
  // Button press effect
  static Animation<double> buttonPressEffect(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: AppTheme.fastCurve),
      ),
    );
  }
  
  // Fade in slide up effect
  static Animation<Offset> fadeInSlideUp(AnimationController controller, {double begin = 0.25}) {
    return Tween<Offset>(
      begin: Offset(0, begin),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: AppTheme.defaultCurve),
      ),
    );
  }
  
  // Scale in effect
  static Animation<double> scaleIn(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: AppTheme.defaultCurve),
      ),
    );
  }
  
  // Pulse effect
  static Animation<double> pulse(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: AppTheme.bounceCurve),
      ),
    );
  }
  
  // Page transition - slide right
  static Widget slideRightTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: AppTheme.defaultCurve,
        ),
      ),
      child: child,
    );
  }
  
  // Page transition - fade and scale
  static Widget fadeScaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: AppTheme.defaultCurve,
          ),
        ),
        child: child,
      ),
    );
  }
  
  // Shimmer effect color
  static const Color shimmerBaseColor = Color(0xFFEEEEEE);
  static const Color shimmerHighlightColor = Color(0xFFF9F9F9);
} 