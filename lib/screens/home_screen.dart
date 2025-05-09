import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:plantidentifier1/screens/results_screen.dart';
import 'package:plantidentifier1/utils/app_theme.dart';
import 'package:plantidentifier1/widgets/animated_button.dart';
import 'package:plantidentifier1/widgets/pattern_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      setState(() {
        _isLoading = false;
      });

      if (image != null && mounted) {
        final Uint8List imageBytes = await image.readAsBytes();
        
        if (mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                ResultsScreen(imageBytes: imageBytes),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var curve = Curves.easeInOut;
                var curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );
                
                return FadeTransition(
                  opacity: curvedAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeInAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: child,
                ),
              );
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo and app name
                    Hero(
                      tag: 'plant_icon',
                      child: SvgPicture.asset(
                        'assets/svg/plant_icon.svg',
                        height: 120,
                        width: 120,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    
                    // App title
                    ShaderMask(
                      shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                      child: Text(
                        'Plant Identifier',
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLarge,
                      ),
                      child: Text(
                        'Take a photo or upload an image to identify plants instantly',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge * 2),
                    
                    // Action buttons
                    if (_isLoading)
                      Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: Lottie.asset(
                              'assets/lottie/plant_loading.json',
                              repeat: true,
                              animate: true,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          Text(
                            'Opening camera...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          // Button to take a photo
                          Container(
                            margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                            child: AnimatedButton(
                              text: 'Take a Photo',
                              icon: Icons.camera_alt_rounded,
                              isFullWidth: true,
                              onPressed: () => _getImage(ImageSource.camera),
                            ),
                          ),
                          
                          // Button to upload from gallery
                          AnimatedButton(
                            text: 'Upload from Gallery',
                            icon: Icons.photo_library_rounded,
                            type: AnimatedButtonType.outlined,
                            isFullWidth: true,
                            onPressed: () => _getImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: AppTheme.spacingLarge * 2),
                    
                    // Information section
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        boxShadow: AppTheme.mediumShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppTheme.spacingSmall),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                                ),
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppTheme.accentColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacing),
                              Text(
                                'How It Works',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingSmall),
                          Text(
                            'Our app uses the powerful Google Gemini AI to analyze your plant photos and provide detailed identification and care instructions.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppTheme.spacingSmall),
                          const Divider(),
                          const SizedBox(height: AppTheme.spacingSmall),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppTheme.successColor,
                                size: 16,
                              ),
                              const SizedBox(width: AppTheme.spacingSmall),
                              Expanded(
                                child: Text(
                                  'Fast and accurate plant identification',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingSmall),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppTheme.successColor,
                                size: 16,
                              ),
                              const SizedBox(width: AppTheme.spacingSmall),
                              Expanded(
                                child: Text(
                                  'Detailed care instructions for each plant',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingSmall),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppTheme.successColor,
                                size: 16,
                              ),
                              const SizedBox(width: AppTheme.spacingSmall),
                              Expanded(
                                child: Text(
                                  'Works offline for previously identified plants',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 