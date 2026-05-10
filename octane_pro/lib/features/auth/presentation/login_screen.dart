import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/auth_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';
import '../../../core/navigation/main_navigator.dart';
import '../../../core/navigation/navigation_helper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authProvider.notifier).login(
            _usernameController.text.trim(),
            _passwordController.text,
          );

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigator()),
          (route) => false,
        );
      } else if (mounted) {
        final error = ref.read(authProvider).error;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.redGradient,
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
                  final maxWidth = constraints.maxWidth > 560
                      ? 560.0
                      : constraints.maxWidth;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 24,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24),
                              Column(
                                children: [
                                  Semantics(
                                    label: 'OctanePro logo',
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        AppTheme.spacingL,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.local_gas_station,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms)
                                      .scale(
                                        begin: const Offset(0.6, 0.6),
                                        end: const Offset(1, 1),
                                        duration: 450.ms,
                                        curve: Curves.easeOutBack,
                                      ),
                                  const SizedBox(height: AppTheme.spacingL),
                                  Text(
                                    'OctanePro',
                                    style: textTheme.displayLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      letterSpacing: 1.1,
                                      height: 1.05,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms, delay: 100.ms)
                                      .slideY(
                                        begin: -0.2,
                                        end: 0,
                                        duration: 450.ms,
                                      ),
                                  const SizedBox(height: AppTheme.spacingS),
                                  Text(
                                    'Fuel Station Management System',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      letterSpacing: 0.4,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms, delay: 200.ms)
                                      .slideY(
                                        begin: -0.2,
                                        end: 0,
                                        duration: 450.ms,
                                      ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingXXL),
                              GlassmorphicCard(
                                padding:
                                    const EdgeInsets.all(AppTheme.spacingXL),
                                margin: EdgeInsets.zero,
                                showGlow: true,
                                glowColor: AppTheme.primaryRed,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Welcome Back',
                                      style: textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 300.ms,
                                          delay: 300.ms,
                                        )
                                        .slideY(
                                          begin: 0.2,
                                          end: 0,
                                          duration: 300.ms,
                                        ),
                                    const SizedBox(height: AppTheme.spacingS),
                                    Text(
                                      'Sign in to continue',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 300.ms,
                                          delay: 400.ms,
                                        )
                                        .slideY(
                                          begin: 0.2,
                                          end: 0,
                                          duration: 300.ms,
                                        ),
                                    const SizedBox(height: AppTheme.spacingL),
                                    TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username or Email',
                                        prefixIcon:
                                            const Icon(Icons.person_outline),
                                        filled: true,
                                        fillColor:
                                            AppTheme.backgroundWhiteSoft,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusM,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.borderGray,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusM,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.borderGray,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusM,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.primaryRed,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username or email';
                                        }
                                        return null;
                                      },
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 300.ms,
                                          delay: 500.ms,
                                        )
                                        .slideY(
                                          begin: 0.2,
                                          end: 0,
                                          duration: 300.ms,
                                        ),
                                    const SizedBox(height: AppTheme.spacingM),
                                    TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon:
                                            const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                        filled: true,
                                        fillColor:
                                            AppTheme.backgroundWhiteSoft,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusM,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.borderGray,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusM,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.borderGray,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.radiusM,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.primaryRed,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) => _handleLogin(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 300.ms,
                                          delay: 600.ms,
                                        )
                                        .slideY(
                                          begin: 0.2,
                                          end: 0,
                                          duration: 300.ms,
                                        ),
                                    const SizedBox(height: AppTheme.spacingS),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () =>
                                            NavigationHelper.pushNamed(
                                          context,
                                          '/forgot-password',
                                        ),
                                        child: const Text('Forgot Password?'),
                                      ),
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 300.ms,
                                          delay: 700.ms,
                                        ),
                                    const SizedBox(height: AppTheme.spacingL),
                                    GlowingButton(
                                      label: 'Login',
                                      onPressed: authState.isLoading
                                          ? null
                                          : _handleLogin,
                                      isLoading: authState.isLoading,
                                      width: double.infinity,
                                      showGlow: true,
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 300.ms,
                                          delay: 800.ms,
                                        )
                                        .slideY(
                                          begin: 0.2,
                                          end: 0,
                                          duration: 300.ms,
                                        )
                                        .scale(
                                          begin: const Offset(0.96, 0.96),
                                          end: const Offset(1, 1),
                                          duration: 300.ms,
                                          delay: 800.ms,
                                        ),
                                  ],
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms, delay: 250.ms)
                                  .scale(
                                    begin: const Offset(0.94, 0.94),
                                    end: const Offset(1, 1),
                                    duration: 400.ms,
                                    delay: 250.ms,
                                  ),
                              const SizedBox(height: AppTheme.spacingXL),
                              Container(
                                padding:
                                    const EdgeInsets.all(AppTheme.spacingM),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusM),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Demo Credentials',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spacingS),
                                    Text(
                                      'admin / manager1 / operator1 / accountant1',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Password: any',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms, delay: 900.ms)
                                  .slideY(
                                    begin: 0.2,
                                    end: 0,
                                    duration: 400.ms,
                                  ),
                              const SizedBox(height: 16),
                            ],
                          ),
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
