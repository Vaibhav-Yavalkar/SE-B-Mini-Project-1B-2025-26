// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'admin_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _bgPulse;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotate;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _bgPulse = Tween<double>(begin: 0.96, end: 1.08).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.5)),
    );
    _logoRotate = Tween<double>(begin: -0.12, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _logoController.forward().then((_) => _textController.forward());

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final provider = context.read<AppProvider>();
        Widget nextScreen;
        
        if (provider.isLoggedIn) {
          nextScreen = provider.userType == 'admin' 
              ? const AdminDashboardScreen() 
              : const MainShell();
        } else {
          nextScreen = const LoginScreen();
        }

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => nextScreen,
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Center(
              child: Transform.scale(
                scale: _bgPulse.value,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.rotate(
                      angle: _logoRotate.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🍱',
                              style: TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, __) => FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        children: [
                          const Text(
                            'PlatePal',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Save food. Save the planet.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.75),
                              letterSpacing: 0.2,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
