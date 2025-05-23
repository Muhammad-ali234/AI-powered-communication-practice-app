import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:communication_practice/utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isFirstLaunch = true;
  
  @override
  void initState() {
    super.initState();
    
    // Set the status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    
    _checkFirstLaunch();
    _navigateToNextScreen();
    _animationController.forward();
  }
  
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstLaunch = prefs.getBool('first_launch') ?? true;
    });
  }
  
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('first_launch') ?? true;
      final hasToken = prefs.getString('auth_token') != null;
      
      if (isFirstLaunch) {
        // Mark first launch as completed
        await prefs.setBool('first_launch', false);
        
        // Navigate to onboarding
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      } else if (hasToken) {
        // Navigate to main screen
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        // Navigate to login
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3563E9),
              Color(0xFF8C62EC),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: responsive.responsivePadding(all: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum_rounded,
                          size: responsive.iconSize(100),
                          color: Colors.white,
                        ),
                        SizedBox(height: responsive.md),
                        Text(
                          'SpeakSmart',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.fontSize(Theme.of(context).textTheme.displayMedium?.fontSize ?? 32),
                          ),
                        ),
                        SizedBox(height: responsive.xs),
                        Text(
                          'Speak Smart. Connect Better.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}