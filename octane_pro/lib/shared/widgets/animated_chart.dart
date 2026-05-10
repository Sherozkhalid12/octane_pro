import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Animated pie chart wrapper
class AnimatedPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final double? centerSpaceRadius;
  final String? centerText;

  const AnimatedPieChart({
    super.key,
    required this.sections,
    this.centerSpaceRadius = 40,
    this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: centerSpaceRadius,
        centerSpaceColor: Colors.transparent,
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 500.ms,
        );
  }
}

/// Animated bar chart wrapper
class AnimatedBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final List<String>? xLabels;
  final double? maxY;
  final String? title;

  const AnimatedBarChart({
    super.key,
    required this.barGroups,
    this.xLabels,
    this.maxY,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingM),
        ],
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              maxY: maxY,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (xLabels != null && value.toInt() < xLabels!.length) {
                        return Text(
                          xLabels![value.toInt()],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textSecondary,
                          ),
                        );
                      }
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY != null ? maxY! / 5 : null,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.borderGray,
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2, end: 0, duration: 500.ms),
        ),
      ],
    );
  }
}
