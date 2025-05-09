import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_theme.dart';

class PatternBackground extends StatelessWidget {
  final Widget child;
  final double opacity;
  final int patternCount;
  final bool animate;

  const PatternBackground({
    super.key,
    required this.child,
    this.opacity = 0.5,
    this.patternCount = 8,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor.withOpacity(0.05),
                AppTheme.backgroundColor,
                AppTheme.backgroundColor,
              ],
            ),
          ),
        ),
        
        // SVG patterns
        ...List.generate(
          patternCount,
          (index) {
            final random = index * 12345 % 100;
            final top = (MediaQuery.of(context).size.height / patternCount) * index;
            final left = (random / 100) * MediaQuery.of(context).size.width;
            final size = 40.0 + (random % 40);
            
            return Positioned(
              top: top,
              left: left,
              child: Opacity(
                opacity: opacity * (0.5 + (random % 50) / 100),
                child: animate 
                  ? _AnimatedPattern(
                      size: size,
                      initialDelay: Duration(milliseconds: index * 200),
                    )
                  : SizedBox(
                      height: size,
                      width: size,
                      child: SvgPicture.asset(
                        'assets/svg/leaf_pattern.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
              ),
            );
          },
        ),
        
        // Content
        child,
      ],
    );
  }
}

class _AnimatedPattern extends StatefulWidget {
  final double size;
  final Duration initialDelay;

  const _AnimatedPattern({
    required this.size,
    required this.initialDelay,
  });

  @override
  State<_AnimatedPattern> createState() => _AnimatedPatternState();
}

class _AnimatedPatternState extends State<_AnimatedPattern>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    
    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Add delay before starting animation
    Future.delayed(widget.initialDelay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: SvgPicture.asset(
          'assets/svg/leaf_pattern.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
} 