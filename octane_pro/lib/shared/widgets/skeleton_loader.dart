import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

/// Skeleton loader with shimmer effect
class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.backgroundGrayLight,
      highlightColor: Colors.white,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height ?? 20,
        decoration: BoxDecoration(
          color: AppTheme.backgroundGrayLight,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );
  }
}

/// Skeleton card for loading states
class SkeletonCard extends StatelessWidget {
  final double? height;

  const SkeletonCard({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(
              width: 100,
              height: 12,
            ),
            const SizedBox(height: AppTheme.spacingM),
            SkeletonLoader(
              width: double.infinity,
              height: 24,
            ),
            if (height != null) ...[
              const SizedBox(height: AppTheme.spacingM),
              SkeletonLoader(
                width: 150,
                height: 12,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton list item
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SkeletonLoader(
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(24),
        ),
        title: SkeletonLoader(
          width: 200,
          height: 16,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SkeletonLoader(
            width: 150,
            height: 12,
          ),
        ),
        trailing: SkeletonLoader(
          width: 80,
          height: 16,
        ),
      ),
    );
  }
}
