import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/domain/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../core/navigation/main_navigator.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check auth state immediately on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final authState = ref.read(authProvider);
    
    if (authState.isAuthenticated) {
      // User is already authenticated, go directly to main navigator
      Future.microtask(() {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigator()),
          );
        }
      });
    } else {
      // User not authenticated, show splash animation then go to login
      _navigateToLogin();
    }
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryRed,
              AppTheme.primaryRedLight,
              AppTheme.primaryRed.withOpacity(0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -80,
                right: -60,
                child: _BackdropBubble(
                  size: 220,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              Positioned(
                bottom: -120,
                left: -40,
                child: _BackdropBubble(
                  size: 260,
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
              Positioned(
                top: 140,
                left: -30,
                child: _BackdropBubble(
                  size: 140,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth > 520
                      ? 520.0
                      : constraints.maxWidth;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            const Spacer(flex: 2),
                            Column(
                              children: [
                                Semantics(
                                  label: 'OctanePro logo',
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.28),
                                          blurRadius: 30,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_gas_station,
                                      size: 60,
                                      color: AppTheme.primaryRed,
                                    ),
                                  )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(reverse: true),
                                      )
                                      .fadeIn(duration: 500.ms)
                                      .scale(
                                        begin: const Offset(0.7, 0.7),
                                        end: const Offset(1, 1),
                                        duration: 700.ms,
                                        curve: Curves.easeOutBack,
                                      )
                                      .then()
                                      .move(
                                        begin: const Offset(0, 2),
                                        end: const Offset(0, -2),
                                        duration: 1600.ms,
                                        curve: Curves.easeInOut,
                                      ),
                                ),
                                const SizedBox(height: 36),
                                Text(
                                  'OctanePro',
                                  textAlign: TextAlign.center,
                                  style: textTheme.displayLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    height: 1.1,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 200.ms)
                                    .slideY(
                                      begin: 0.25,
                                      end: 0,
                                      duration: 600.ms,
                                      curve: Curves.easeOut,
                                    ),
                                const SizedBox(height: 10),
                                Text(
                                  'Fuel Station Management System',
                                  textAlign: TextAlign.center,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.88),
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w300,
                                    height: 1.4,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 350.ms)
                                    .slideY(
                                      begin: 0.2,
                                      end: 0,
                                      duration: 600.ms,
                                      curve: Curves.easeOut,
                                    ),
                              ],
                            ),
                            const Spacer(flex: 3),
                            Column(
                              children: [
                                Semantics(
                                  label: 'Loading indicator',
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 400.ms, delay: 800.ms)
                                    .scale(
                                      begin: const Offset(0.85, 0.85),
                                      end: const Offset(1, 1),
                                      duration: 400.ms,
                                    ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading...',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 0.8,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 400.ms, delay: 1000.ms)
                                    .then()
                                    .fadeOut(duration: 220.ms)
                                    .then()
                                    .fadeIn(duration: 220.ms)
                                    .then()
                                    .fadeOut(duration: 220.ms)
                                    .then()
                                    .fadeIn(duration: 220.ms),
                                const SizedBox(height: 28),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackdropBubble extends StatelessWidget {
  const _BackdropBubble({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
