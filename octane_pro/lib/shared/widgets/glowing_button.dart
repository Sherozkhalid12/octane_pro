import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'professional_loader.dart';

/// Premium glowing button with futuristic design
class GlowingButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final EdgeInsets? padding;
  final bool showGlow;

  const GlowingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.padding,
    this.showGlow = true,
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? _handleTapDown : null,
      onTapUp: isEnabled ? _handleTapUp : null,
      onTapCancel: isEnabled ? _handleTapCancel : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 0.95).animate(
              CurvedAnimation(
                parent: _scaleController,
                curve: Curves.easeInOut,
              ),
            ),
            child: AnimatedOpacity(
              opacity: isEnabled ? 1.0 : 0.5,
              duration: AppTheme.animationFast,
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  gradient: widget.isSecondary ? null : AppTheme.redGradient,
                  color: widget.isSecondary ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: widget.isSecondary
                      ? Border.all(color: AppTheme.primaryRed, width: 2)
                      : null,
                  boxShadow: widget.showGlow && !widget.isSecondary
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: AppTheme.primaryRed.withOpacity(
                              0.15 + (_glowController.value * 0.05),
                            ),
                            blurRadius: 6 + (_glowController.value * 2),
                            spreadRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : widget.isSecondary
                          ? []
                          : AppTheme.buttonShadow,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEnabled ? widget.onPressed : null,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    child: Container(
                      padding: widget.padding ??
                          const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingL,
                            vertical: AppTheme.spacingM,
                          ),
                      child: widget.isLoading
                          ? ProfessionalLoader(
                              size: 20,
                              color: widget.isSecondary
                                  ? AppTheme.primaryRed
                                  : AppTheme.accentWhite,
                              strokeWidth: 2.5,
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(
                                    widget.icon,
                                    color: widget.isSecondary
                                        ? AppTheme.primaryRed
                                        : AppTheme.accentWhite,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppTheme.spacingS),
                                ],
                                Flexible(
                                  child: Text(
                                    widget.label,
                                    style: TextStyle(
                                      color: widget.isSecondary
                                          ? AppTheme.primaryRed
                                          : AppTheme.accentWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppTheme.fontFamily,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
