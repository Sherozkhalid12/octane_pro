import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // In a real app, this would send an email/SMS with reset link
      // For now, we'll show a success message
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  Semantics(
                                    label: 'Reset password icon',
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        AppTheme.spacingL,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.lock_reset,
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
                                    'Forgot Password?',
                                    style: textTheme.displayMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1,
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
                                    'Enter your username or email to receive password reset instructions',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
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
                              if (!_emailSent)
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
                                      TextFormField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username or Email',
                                          prefixIcon: const Icon(
                                            Icons.person_outline,
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please enter your username or email';
                                          }
                                          return null;
                                        },
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
                                      const SizedBox(height: AppTheme.spacingL),
                                      GlowingButton(
                                        label: 'Send Reset Link',
                                        onPressed: _isLoading
                                            ? null
                                            : _handleResetPassword,
                                        isLoading: _isLoading,
                                        width: double.infinity,
                                        showGlow: true,
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
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 400.ms, delay: 300.ms)
                                    .scale(
                                      begin: const Offset(0.92, 0.92),
                                      end: const Offset(1, 1),
                                      duration: 400.ms,
                                      delay: 300.ms,
                                    )
                              else
                                GlassmorphicCard(
                                  padding:
                                      const EdgeInsets.all(AppTheme.spacingXL),
                                  margin: EdgeInsets.zero,
                                  showGlow: true,
                                  glowColor: AppTheme.successGreen,
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.successGreen,
                                        size: 64,
                                      ),
                                      const SizedBox(height: AppTheme.spacingL),
                                      Text(
                                        'Reset Link Sent!',
                                        style:
                                            textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: AppTheme.spacingM),
                                      Text(
                                        'Please check your email for password reset instructions.',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.textSecondary,
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: AppTheme.spacingXL),
                                      GlowingButton(
                                        label: 'Back to Login',
                                        onPressed: () => Navigator.pop(context),
                                        width: double.infinity,
                                        showGlow: true,
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 400.ms)
                                    .scale(
                                      begin: const Offset(0.92, 0.92),
                                      end: const Offset(1, 1),
                                      duration: 400.ms,
                                    ),
                              const SizedBox(height: 24),
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
