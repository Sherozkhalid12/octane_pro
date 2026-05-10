import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Premium gradient button with animations
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final EdgeInsets? padding;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.padding,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
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
      child: ScaleTransition(
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
              gradient: widget.isSecondary
                  ? null
                  : LinearGradient(
                      colors: [
                        AppTheme.primaryRed,
                        AppTheme.primaryRedLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: widget.isSecondary ? Colors.white : null,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: widget.isSecondary
                  ? Border.all(color: AppTheme.primaryRed, width: 2)
                  : null,
              boxShadow: widget.isSecondary
                  ? []
                  : [
                      BoxShadow(
                        color: AppTheme.primaryRed.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: widget.width != null 
                              ? MainAxisSize.max 
                              : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: widget.isSecondary
                                    ? AppTheme.primaryRed
                                    : Colors.white,
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
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
