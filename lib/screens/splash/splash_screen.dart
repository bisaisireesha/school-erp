import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<double>(
      begin: 40.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDE9FA),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEDE9FA), Color(0xFFE8E4F8), Color(0xFFF0EDF9)],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: size.height * 0.18,
                left: size.width * 0.08,
                child: const _DecorativeCircle(size: 36),
              ),
              Positioned(
                top: size.height * 0.44,
                right: size.width * 0.06,
                child: const _DecorativeCircle(size: 14, filled: true),
              ),
              Positioned(
                top: size.height * 0.62,
                right: size.width * 0.12,
                child: const _DecorativeCircle(size: 30),
              ),
              Positioned(
                top: size.height * 0.60,
                left: size.width * 0.08,
                child: const _DecorativeCircle(size: 12, filled: true),
              ),

              // Main centered content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Icon card — centered
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF9C8DDB,
                              ).withValues(alpha: 0.18),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'lib/assets/graduation logo.png',
                            width: 90,
                            height: 90,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.school,
                                  size: 60,
                                  color: Color(0xFF9C8DDB),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LOGO block
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(color: Color(0xFFE6E3ED)),
                      child: const Center(
                        child: Text(
                          'LOGO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App title — centered
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: child,
                      ),
                      child: const Text(
                        'Smart School Management',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1035),
                          letterSpacing: 0.3,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Simplified" pill badge — centered
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FA),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFF9C8DDB).withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Simplified',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6C5CE7),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // TAP ANYWHERE TO START — centered at bottom
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'TAP ANYWHERE TO START',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9C8DDB),
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 1.5,
                          height: 30,
                          color: const Color(0xFF9C8DDB).withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final bool filled;

  const _DecorativeCircle({required this.size, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled
            ? const Color(0xFF9C8DDB).withValues(alpha: 0.25)
            : Colors.transparent,
        border: filled
            ? null
            : Border.all(
                color: const Color(0xFF9C8DDB).withValues(alpha: 0.3),
                width: 1.5,
              ),
      ),
    );
  }
}
