import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    // Navigate to the auth page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/auth');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using SvgPicture instead of Image.asset for SVG files
            SvgPicture.asset(
              'assets/blood-drop.svg',
              width: 200,
              height: 200,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(height: 30),
            // App name with fade animation
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'Blood Connect',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
