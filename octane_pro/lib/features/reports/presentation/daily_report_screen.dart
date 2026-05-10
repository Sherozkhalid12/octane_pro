import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/animated_chart.dart';
import '../../../shared/widgets/animated_count.dart';

class DailyReportScreen extends ConsumerStatefulWidget {
  const DailyReportScreen({super.key});

  @override
  ConsumerState<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends ConsumerState<DailyReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final stats = MockData.getDashboardStats();
    final salesByFuel = MockData.getSalesByFuelType();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateLabel = DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate);
    final isCompact = MediaQuery.of(context).size.width < 380;

    final barGroups = salesByFuel.asMap().entries.map((entry) {
      final index = entry.key;
      final sale = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (sale['amount'] as num).toDouble(),
            color: AppTheme.primaryRed,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Report'),
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
                  content: const Text('Exporting daily report...'),
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
                  title: 'Daily Pulse',
                  subtitle: 'Snapshot of sales, expenses, and profit.',
                  icon: Icons.insights,
                  pillLabel: 'DATE',
                  pillValue: DateFormat('MMM dd').format(_selectedDate),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.1, end: 0),

                const SizedBox(height: AppTheme.spacingL),

                _NeonPanel(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle: Text(dateLabel),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.primaryRed),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
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
                  'Key Totals',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 150.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingM),

                if (isCompact) ...[
                  _NeonStatCard(
                    title: 'Total Sales',
                    value: stats['todaySales'] as double,
                    icon: Icons.attach_money,
                    color: AppTheme.successGreen,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppTheme.spacingM),
                  _NeonStatCard(
                    title: 'Total Expenses',
                    value: stats['expenses'] as double,
                    icon: Icons.trending_down,
                    color: AppTheme.errorRed,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 250.ms)
                      .slideY(begin: 0.1, end: 0),
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: _NeonStatCard(
                          title: 'Total Sales',
                          value: stats['todaySales'] as double,
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
                          value: stats['expenses'] as double,
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
                  value: stats['netBalance'] as double,
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
                    child: AnimatedBarChart(
                      barGroups: barGroups,
                      xLabels:
                          salesByFuel.map((s) => s['fuelType'] as String).toList(),
                      maxY: 300000,
                      title: 'Fuel Sales Breakdown',
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 350.ms)
                    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

                const SizedBox(height: AppTheme.spacingXL),

                Text(
                  'Shift Performance',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingM),

                _NeonPanel(
                  child: Column(
                    children: [
                      _ShiftRow(
                        shift: 'Morning Shift',
                        sales: 45000.0,
                        formatter: formatter,
                      ),
                      Divider(color: AppTheme.borderGray),
                      _ShiftRow(
                        shift: 'Evening Shift',
                        sales: 55000.0,
                        formatter: formatter,
                      ),
                      Divider(color: AppTheme.borderGray),
                      _ShiftRow(
                        shift: 'Night Shift',
                        sales: 25450.0,
                        formatter: formatter,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 450.ms)
                    .slideY(begin: 0.1, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftRow extends StatelessWidget {
  final String shift;
  final double sales;
  final NumberFormat formatter;

  const _ShiftRow({
    required this.shift,
    required this.sales,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          shift,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
        Text(
          formatter.format(sales),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.bold,
              ),
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
