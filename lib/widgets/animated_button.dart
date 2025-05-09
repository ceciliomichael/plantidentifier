import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum AnimatedButtonType { primary, outlined }

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final AnimatedButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AnimatedButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.fastTransitionDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.type == AnimatedButtonType.primary
        ? BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            boxShadow: _isPressed 
                ? [] 
                : [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          )
        : BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          );

    final contentColor = widget.type == AnimatedButtonType.primary
        ? Colors.white
        : AppTheme.primaryColor;

    final buttonContent = widget.isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: contentColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          );

    final paddingToUse = widget.padding ??
        const EdgeInsets.symmetric(
          vertical: AppTheme.spacing * 1.5,
          horizontal: AppTheme.spacingMedium,
        );

    return GestureDetector(
      onTapDown: widget.isLoading ? null : _handleTapDown,
      onTapUp: widget.isLoading ? null : _handleTapUp,
      onTapCancel: widget.isLoading ? null : _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          padding: paddingToUse,
          decoration: decoration,
          child: Center(child: buttonContent),
        ),
      ),
    );
  }
} 