import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    // Start the animation
    _controller.forward();

    // Wait for 3 seconds total
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to main screen using go_router
    if (mounted) {
      AppNavigation.goToHome();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lightbulb,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppConstants.extraLargeSpacing),

              // App Name
              Text(
                AppConstants.appName,
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),

              const SizedBox(height: AppConstants.smallSpacing),

              // Tagline
              Text(
                'Where Ideas Come to Life',
                style: AppTextStyles.subtitle1.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),

              const SizedBox(height: AppConstants.extraLargeSpacing * 2),

              // Loading Indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ).animate().fadeIn(delay: 1200.ms),

              const SizedBox(height: AppConstants.mediumSpacing),

              Text(
                'Loading amazing ideas...',
                style: AppTextStyles.body2.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ).animate().fadeIn(delay: 1500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
