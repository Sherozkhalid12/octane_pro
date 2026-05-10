import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'animated_count.dart';

/// Premium stat card with gradient and animations
class StatCard extends StatelessWidget {
  final String title;
  final double? value;
  final String? valueString;
  final IconData icon;
  final Color? color;
  final bool useGradient;
  final String? suffix;
  final bool useCurrency;
  final int index;

  const StatCard({
    super.key,
    required this.title,
    this.value,
    this.valueString,
    required this.icon,
    this.color,
    this.useGradient = false,
    this.suffix,
    this.useCurrency = false,
    this.index = 0,
  }) : assert(value != null || valueString != null);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppTheme.primaryRed;

    return Container(
      decoration: BoxDecoration(
        gradient: useGradient
            ? LinearGradient(
                colors: [
                  cardColor,
                  cardColor == AppTheme.primaryRed
                      ? AppTheme.primaryRedLight
                      : cardColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: useGradient ? null : Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        boxShadow: useGradient
            ? [
                BoxShadow(
                  color: cardColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: useGradient
                          ? Colors.white.withOpacity(0.9)
                          : AppTheme.textSecondary,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: useGradient
                        ? Colors.white.withOpacity(0.2)
                        : cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: useGradient ? Colors.white : cardColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: value != null
                    ? AnimatedCount(
                        value: value!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: useGradient ? Colors.white : cardColor,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        suffix: suffix,
                        useCurrency: useCurrency,
                      )
                    : Text(
                        valueString ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: useGradient ? Colors.white : cardColor,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: (index * 100).ms,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
          delay: (index * 100).ms,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 300.ms,
          delay: (index * 100).ms,
        );
  }
}
