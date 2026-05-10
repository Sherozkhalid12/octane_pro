import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/animated_chart.dart';

class ShiftSummaryScreen extends ConsumerWidget {
  final String shiftId;

  const ShiftSummaryScreen({
    super.key,
    required this.shiftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = MockData.getShiftSessions();
    final session = sessions.firstWhere(
      (s) => s['id'] == shiftId,
      orElse: () => sessions.first,
    );
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final salesByFuel = MockData.getSalesByFuelType();

    final pieSections = [
      PieChartSectionData(
        value: (session['cashSales'] as num).toDouble(),
        title: 'Cash',
        color: AppTheme.successGreen,
        radius: 60,
      ),
      PieChartSectionData(
        value: (session['creditSales'] as num).toDouble(),
        title: 'Credit',
        color: AppTheme.infoBlue,
        radius: 60,
      ),
    ];

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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: Stack(
        children: [
          const _NeonBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingL,
                AppTheme.spacingL,
                AppTheme.spacingL,
                AppTheme.spacingXL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderBar(
                    title: 'Shift Summary',
                    onBack: () => Navigator.pop(context),
                    onExport: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exporting report...')),
                      );
                    },
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.2, end: 0),
                  const SizedBox(height: AppTheme.spacingL),
                  _HeroConsole(
                    title: session['shiftName'] as String,
                    subtitle: '${session['date']} • ${session['operator']}',
                    icon: Icons.assessment,
                    status: (session['status'] as String).toUpperCase(),
                  )
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 80.ms)
                      .slideY(begin: -0.05, end: 0),
                  const SizedBox(height: AppTheme.spacingXL),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth > 720 ? 4 : 2;
                      final cards = [
                        _MetricCard(
                          title: 'Total Sales',
                          value: (session['totalAmount'] as num?)?.toDouble() ??
                              0.0,
                          icon: Icons.attach_money,
                          color: AppTheme.successGreen,
                          formatter: formatter,
                        ),
                        _MetricCard(
                          title: 'Fuel Sold',
                          value: (session['totalLiters'] as num?)?.toDouble() ??
                              0.0,
                          icon: Icons.local_gas_station,
                          color: AppTheme.infoBlue,
                          suffix: ' L',
                        ),
                        _MetricCard(
                          title: 'Net Balance',
                          value: ((session['totalAmount'] as num?)?.toDouble() ??
                                  0.0) -
                              ((session['expenses'] as num).toDouble()),
                          icon: Icons.account_balance,
                          color: AppTheme.primaryRed,
                          formatter: formatter,
                        ),
                        _MetricCard(
                          title: 'Short/Excess',
                          value: (session['shortExcess'] as num).toDouble(),
                          icon: Icons.trending_up,
                          color: (session['shortExcess'] as num) < 0
                              ? AppTheme.errorRed
                              : AppTheme.successGreen,
                          formatter: formatter,
                        ),
                      ];

                      return GridView.count(
                        crossAxisCount: columns,
                        crossAxisSpacing: AppTheme.spacingM,
                        mainAxisSpacing: AppTheme.spacingM,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.25,
                        children: cards,
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXL),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 760;
                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(
                              child: _ChartPanel(
                                title: 'Payment Mix',
                                child: AnimatedPieChart(
                                  sections: pieSections,
                                  centerSpaceRadius: 48,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Expanded(
                              child: _ChartPanel(
                                title: 'Fuel Sales',
                                child: AnimatedBarChart(
                                  barGroups: barGroups,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _ChartPanel(
                            title: 'Payment Mix',
                            child: AnimatedPieChart(
                              sections: pieSections,
                              centerSpaceRadius: 48,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          _ChartPanel(
                            title: 'Fuel Sales',
                            child: AnimatedBarChart(
                              barGroups: barGroups,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXL),
                  Text(
                    'Detailed Breakdown',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppTheme.spacingM),
                  _BreakdownPanel(
                    session: session,
                    formatter: formatter,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 260.ms)
                      .slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.title,
    required this.onBack,
    required this.onExport,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
          ),
        ),
        IconButton(
          onPressed: onExport,
          icon: const Icon(Icons.download),
        ),
      ],
    );
  }
}

class _HeroConsole extends StatelessWidget {
  const _HeroConsole({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.86),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppTheme.redGradient,
              borderRadius: BorderRadius.circular(18),
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
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
          _StatusChip(status: status),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';
    final color = isActive ? AppTheme.successGreen : AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.formatter,
    this.suffix,
  });

  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final NumberFormat? formatter;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: color.withOpacity(0.5), size: 18),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 6),
          AnimatedCount(
            value: value,
            useCurrency: formatter != null,
            suffix: suffix,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChartPanel extends StatelessWidget {
  const _ChartPanel({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.infoBlue.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.infoBlue.withOpacity(0.2),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          SizedBox(height: 220, child: child),
        ],
      ),
    );
  }
}

class _BreakdownPanel extends StatelessWidget {
  const _BreakdownPanel({
    required this.session,
    required this.formatter,
  });

  final Map<String, dynamic> session;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          _BreakdownRow(
            label: 'Opening Cash',
            value: formatter.format(session['openingCash']),
          ),
          const Divider(),
          _BreakdownRow(
            label: 'Cash Sales',
            value: formatter.format(session['cashSales']),
          ),
          const Divider(),
          _BreakdownRow(
            label: 'Credit Sales',
            value: formatter.format(session['creditSales']),
          ),
          const Divider(),
          _BreakdownRow(
            label: 'Expenses',
            value: formatter.format(session['expenses']),
            valueColor: AppTheme.errorRed,
          ),
          const Divider(),
          _BreakdownRow(
            label: 'Closing Cash',
            value: formatter.format(session['closingCash']),
          ),
          const Divider(),
          _BreakdownRow(
            label: 'Short/Excess',
            value: formatter.format(session['shortExcess']),
            valueColor: (session['shortExcess'] as num) < 0
                ? AppTheme.errorRed
                : AppTheme.successGreen,
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? AppTheme.textPrimary,
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
            top: -140,
            right: -60,
            child: _GlowOrb(
              size: 260,
              color: AppTheme.primaryRed.withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -160,
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
