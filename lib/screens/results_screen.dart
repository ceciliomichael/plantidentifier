import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:plantidentifier1/models/plant.dart';
import 'package:plantidentifier1/services/gemini_service.dart';
import 'package:plantidentifier1/utils/app_theme.dart';
import 'package:plantidentifier1/utils/app_animations.dart';
import 'package:plantidentifier1/widgets/animated_button.dart';
import 'package:plantidentifier1/widgets/pattern_background.dart';
import 'package:plantidentifier1/widgets/plant_info_card.dart';

class ResultsScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const ResultsScreen({
    super.key,
    required this.imageBytes,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _showSuccess = false;
  Plant? _plant;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _identifyPlant();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _identifyPlant() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showSuccess = false;
    });

    try {
      final geminiService = GeminiService();
      final plant = await geminiService.identifyPlant(widget.imageBytes);
      
      if (mounted) {
        setState(() {
          _plant = plant;
          _isLoading = false;
          // Slight delay before showing success animation
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _showSuccess = true;
              });
              _animationController.forward();
            }
          });
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error identifying plant: ${e.toString()}';
          _isLoading = false;
        });
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        animate: false,
        opacity: 0.3,
        child: SafeArea(
          child: Column(
            children: [
              // Custom app bar
              _buildAppBar(context),
              
              // Main content
              Expanded(
                child: _isLoading
                  ? _buildLoadingView()
                  : _errorMessage != null
                    ? _buildErrorView()
                    : _buildResultsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacing,
      ),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing),
          Text(
            'Plant Identification',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          
          Text(
            'Identifying your plant...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            'This may take a moment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: child,
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image that caused the error
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacingSmall,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: AppTheme.subtleShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Image.memory(
                      widget.imageBytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingLarge),
              
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: AppTheme.subtleShadow,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppTheme.errorColor,
                      size: 60,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      _errorMessage ?? 'Unknown error',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedButton(
                          text: 'Try Again',
                          icon: Icons.refresh_rounded,
                          onPressed: _identifyPlant,
                        ),
                        const SizedBox(width: AppTheme.spacingMedium),
                        AnimatedButton(
                          text: 'Go Back',
                          icon: Icons.arrow_back_rounded,
                          type: AnimatedButtonType.outlined,
                          onPressed: () => Navigator.pop(context),
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
    );
  }

  Widget _buildResultsView() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: child,
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the uploaded image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                boxShadow: AppTheme.mediumShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        widget.imageBytes,
                        fit: BoxFit.cover,
                      ),
                      
                      // Success animation overlay
                      // if (_showSuccess)  // Condition commented out
                      //   Positioned.fill( // Lottie animation commented out
                      //     child: Container(
                      //       color: Colors.black.withOpacity(0.3),
                      //       child: Center(
                      //         child: Lottie.asset(
                      //           'assets/lottie/success.json',
                      //           repeat: false,
                      //           width: 100,
                      //           height: 100,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            
            // Success message
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacing,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.successColor.withOpacity(0.8),
                      AppTheme.successColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.successColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacing),
                    const Text(
                      'Plant Identified!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            
            // Plant information card
            if (_plant != null) PlantInfoCard(plant: _plant!),
            
            const SizedBox(height: AppTheme.spacingLarge),
            
            // Action buttons
            Center(
              child: AnimatedButton(
                text: 'Identify Another Plant',
                icon: Icons.add_a_photo_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 