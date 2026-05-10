import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/animated_count.dart';

class TankStockScreen extends ConsumerWidget {
  final String tankId;
  
  const TankStockScreen({
    super.key,
    required this.tankId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tanks = MockData.getTankInventory();
    final tank = tanks.firstWhere(
      (t) => t['tankId'] == tankId,
      orElse: () => tanks.first,
    );

    final physicalStock = tank['currentStock'] as double;
    final systemStock = 35000.0; // Mock
    final variance = physicalStock - systemStock;
    final hasVariance = variance.abs() > 0.01;

    // Mock historical data for chart
    final historicalData = [
      {'date': '2024-01-10', 'stock': 40000.0},
      {'date': '2024-01-11', 'stock': 38000.0},
      {'date': '2024-01-12', 'stock': 36000.0},
      {'date': '2024-01-13', 'stock': 35000.0},
      {'date': '2024-01-14', 'stock': 35000.0},
      {'date': '2024-01-15', 'stock': 35000.0},
    ];

    final spots = historicalData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['stock'] as double);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tank Stock - $tankId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tank Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.infoBlueLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tankId,
                            style: const TextStyle(
                              color: AppTheme.infoBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Text(
                            tank['fuelType'] as String,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      'Capacity: ${tank['capacity']} L',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.1, end: 0),

            const SizedBox(height: AppTheme.spacingXL),

            // Stock Comparison
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: AppTheme.infoBlueLight,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Physical Stock',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.infoBlue,
                                ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedCount(
                            value: physicalStock,
                            suffix: ' L',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.infoBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Card(
                    color: AppTheme.backgroundGray,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System Stock',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedCount(
                            value: systemStock,
                            suffix: ' L',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppTheme.spacingM),

            // Variance Card
            Card(
              color: hasVariance ? AppTheme.errorRedLight : AppTheme.successGreenLight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Variance',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          hasVariance ? 'Variance detected' : 'No variance',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    AnimatedCount(
                      value: variance.abs(),
                      suffix: ' L',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: hasVariance ? AppTheme.errorRed : AppTheme.successGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 200.ms)
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

            const SizedBox(height: AppTheme.spacingXL),

            // Stock Movement Chart
            Text(
              'Stock Movement',
              style: Theme.of(context).textTheme.titleLarge,
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 300.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppTheme.spacingM),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < historicalData.length) {
                                final date = historicalData[value.toInt()]['date'] as String;
                                return Text(
                                  date.split('-').last,
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
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
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: AppTheme.primaryRed,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Last Dip Entry
            Text(
              'Last Dip Entry',
              style: Theme.of(context).textTheme.titleLarge,
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 400.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppTheme.spacingM),

            Card(
              child: ListTile(
                leading: const Icon(Icons.water_drop, color: AppTheme.infoBlue),
                title: const Text('Dip Reading'),
                subtitle: Text(
                  'Date: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
                ),
                trailing: Text(
                  '${physicalStock.toStringAsFixed(0)} L',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 500.ms)
                .slideX(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
