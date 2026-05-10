import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_chart.dart';
import '../../../shared/widgets/animated_count.dart';

class MonthlyReportScreen extends ConsumerStatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  ConsumerState<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends ConsumerState<MonthlyReportScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final monthLabel = DateFormat('MMMM yyyy').format(_selectedMonth);

    final monthlyData = [
      {'month': 'Jan', 'sales': 1200000.0, 'expenses': 450000.0},
      {'month': 'Feb', 'sales': 1350000.0, 'expenses': 480000.0},
      {'month': 'Mar', 'sales': 1500000.0, 'expenses': 500000.0},
      {'month': 'Apr', 'sales': 1450000.0, 'expenses': 490000.0},
      {'month': 'May', 'sales': 1600000.0, 'expenses': 520000.0},
      {'month': 'Jun', 'sales': 1700000.0, 'expenses': 550000.0},
    ];

    final salesSpots = monthlyData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['sales'] as double);
    }).toList();

    final expensesSpots = monthlyData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['expenses'] as double);
    }).toList();

    final pieSections = [
      PieChartSectionData(
        value: 500000.0,
        title: 'Sales',
        color: AppTheme.successGreen,
        radius: 60,
      ),
      PieChartSectionData(
        value: 150000.0,
        title: 'Expenses',
        color: AppTheme.errorRed,
        radius: 60,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Exporting monthly report...'),
                  backgroundColor: AppTheme.successGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  margin: const EdgeInsets.all(AppTheme.spacingM),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroConsole(
                  title: 'Monthly Intelligence',
                  subtitle: 'Trends, breakdowns, and profitability.',
                  icon: Icons.calendar_month,
                  pillLabel: 'MONTH',
                  pillValue: DateFormat('MMM').format(_selectedMonth).toUpperCase(),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.1, end: 0),

                const SizedBox(height: AppTheme.spacingL),

                _NeonPanel(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('Month'),
                    subtitle: Text(monthLabel),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.primaryRed),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedMonth,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          initialDatePickerMode: DatePickerMode.year,
                        );
                        if (date != null) {
                          setState(() => _selectedMonth = date);
                        }
                      },
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingXL),

                Text(
                  'Monthly Highlights',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 150.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingM),

                Row(
                  children: [
                    Expanded(
                      child: _NeonStatCard(
                        title: 'Total Sales',
                        value: 3750000.0,
                        icon: Icons.attach_money,
                        color: AppTheme.successGreen,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 200.ms)
                          .slideY(begin: 0.1, end: 0),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _NeonStatCard(
                        title: 'Total Expenses',
                        value: 1490000.0,
                        icon: Icons.trending_down,
                        color: AppTheme.errorRed,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 250.ms)
                          .slideY(begin: 0.1, end: 0),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingM),

                _NeonStatCard(
                  title: 'Net Profit',
                  value: 2260000.0,
                  icon: Icons.account_balance,
                  color: AppTheme.primaryRed,
                  isWide: true,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingXL),

                _NeonPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Trend',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 46,
                                    interval: 500000,
                                    getTitlesWidget: (value, meta) {
                                      final display = value / 1000000;
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 8,
                                        child: Text(
                                          '${display.toStringAsFixed(1)}M',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: AppTheme.textSecondary,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 24,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() < monthlyData.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space: 8,
                                          child: Text(
                                            monthlyData[value.toInt()]['month']
                                                as String,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
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
                                  spots: salesSpots,
                                  isCurved: true,
                                  color: AppTheme.successGreen,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: expensesSpots,
                                  isCurved: true,
                                  color: AppTheme.errorRed,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem('Sales', AppTheme.successGreen),
                            _buildLegendItem('Expenses', AppTheme.errorRed),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 150.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),

                const SizedBox(height: AppTheme.spacingXL),

                _NeonPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Breakdown',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        SizedBox(
                          height: 200,
                          child: AnimatedPieChart(
                            sections: pieSections,
                            centerSpaceRadius: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),

                const SizedBox(height: AppTheme.spacingXL),

                Text(
                  'Comparison with Previous Month',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingM),

                _NeonPanel(
                  child: Column(
                    children: [
                      _ComparisonRow(
                        label: 'Sales',
                        current: 1700000.0,
                        previous: 1600000.0,
                        formatter: formatter,
                        isPositive: true,
                      ),
                      Divider(color: AppTheme.borderGray),
                      _ComparisonRow(
                        label: 'Expenses',
                        current: 550000.0,
                        previous: 520000.0,
                        formatter: formatter,
                        isPositive: false,
                      ),
                      Divider(color: AppTheme.borderGray),
                      _ComparisonRow(
                        label: 'Profit',
                        current: 1150000.0,
                        previous: 1080000.0,
                        formatter: formatter,
                        isPositive: true,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 350.ms)
                    .slideY(begin: 0.1, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final double current;
  final double previous;
  final NumberFormat formatter;
  final bool isPositive;

  const _ComparisonRow({
    required this.label,
    required this.current,
    required this.previous,
    required this.formatter,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final change = current - previous;
    final changePercent = previous > 0 ? (change / previous * 100) : 0;
    final isIncrease = isPositive ? change > 0 : change < 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatter.format(current),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              children: [
                Icon(
                  isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isIncrease ? AppTheme.successGreen : AppTheme.errorRed,
                ),
                Text(
                  '${changePercent.abs().toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isIncrease ? AppTheme.successGreen : AppTheme.errorRed,
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _NeonBackdrop extends StatelessWidget {
  const _NeonBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundGray,
            AppTheme.backgroundGrayLight,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _GlowOrb(
              size: 240,
              color: AppTheme.primaryRed.withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -40,
            child: _GlowOrb(
              size: 260,
              color: AppTheme.infoBlue.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
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

class _HeroConsole extends StatelessWidget {
  const _HeroConsole({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.pillLabel,
    required this.pillValue,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String pillLabel;
  final String pillValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: AppTheme.redGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.redGlow,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          _NeonPill(label: pillLabel, value: pillValue),
        ],
      ),
    );
  }
}

class _NeonPill extends StatelessWidget {
  const _NeonPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.6,
                ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _NeonPanel extends StatelessWidget {
  const _NeonPanel({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: child,
    );
  }
}

class _NeonStatCard extends StatelessWidget {
  const _NeonStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isWide = false,
  });

  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isWide ? null : 122,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: color.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          AnimatedCount(
            value: value,
            useCurrency: true,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
