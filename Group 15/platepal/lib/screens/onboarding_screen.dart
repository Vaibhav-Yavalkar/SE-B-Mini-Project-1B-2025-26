// lib/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardPage(
      emoji: '🍱',
      title: 'Rescue Surplus Food',
      description:
          'Local restaurants and bakeries list unsold food at up to 70% off every evening. Help save it from going to waste.',
      color: AppTheme.primaryDark,
    ),
    _OnboardPage(
      emoji: '🗺️',
      title: 'Find Bags Near You',
      description:
          'Discover surprise food bags within 5 km using our live map. Browse by category, price, or pickup time.',
      color: const Color(0xFF0D5C7F),
    ),
    _OnboardPage(
      emoji: '🌍',
      title: 'Track Your Impact',
      description:
          'See how many kilograms of food you\'ve rescued and how much CO₂ you\'ve prevented. Every bag counts.',
      color: const Color(0xFF4A2060),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_currentPage].color,
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Skip
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: _goHome,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (_, i) => _buildPage(_pages[i]),
                  ),
                ),
                // Dots + button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _currentPage ? 24 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: i == _currentPage
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _goHome();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _pages[_currentPage].color,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            _currentPage < _pages.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Center(
              child: Text(
                page.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.75),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _OnboardPage {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}
