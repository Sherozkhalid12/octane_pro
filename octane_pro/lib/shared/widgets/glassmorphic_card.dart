import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';

/// Premium glassmorphic card with blur effect and futuristic styling
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool showGlow;
  final Color? glowColor;
  final double borderRadius;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.showGlow = false,
    this.glowColor,
    this.borderRadius = AppTheme.radiusXL,
  });

  @override
  Widget build(BuildContext context) {
    final glow = glowColor ?? AppTheme.primaryRed;
    
    Widget card = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: showGlow ? glow.withOpacity(0.15) : AppTheme.borderGray,
            width: 1,
          ),
          gradient: AppTheme.cardGradient,
          boxShadow: showGlow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: glow.withOpacity(0.06),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
          child: child,
        ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}
