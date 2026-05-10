import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/data/mock_data.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/gradient_button.dart';
import '../../../../../shared/widgets/animated_chart.dart';
import '../../../../../features/shifts/presentation/shifts_screen.dart';
import '../../../../../features/expenses/presentation/expenses_screen.dart';
import '../../../../../features/payments/presentation/payments_screen.dart';
import '../../../../../features/reports/presentation/reports_screen.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = MockData.getDashboardStats();
    final salesByFuel = MockData.getSalesByFuelType();
    final recentTransactions = MockData.getRecentTransactions();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    // Prepare pie chart data
    final pieSections = [
      PieChartSectionData(
        value: stats['cashSales'] as double,
        title: 'Cash',
        color: AppTheme.successGreen,
        radius: 60,
      ),
      PieChartSectionData(
        value: stats['creditSales'] as double,
        title: 'Credit',
        color: AppTheme.infoBlue,
        radius: 60,
      ),
    ];

    // Prepare bar chart data
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
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(context, stats)
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Critical Metrics Rail
          _buildMetricsRail(context, stats)
              .animate()
              .fadeIn(duration: 300.ms, delay: 120.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Active Shift Banner
          if (stats['activeShift'] as bool)
            _buildActiveShiftBanner(context)
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideY(begin: 0.1, end: 0),

          if (stats['activeShift'] as bool) const SizedBox(height: AppTheme.spacingL),

          // Key Stats Grid
          _buildStatsGrid(context, stats)
              .animate()
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Quick Actions
          _buildQuickActions(context)
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Charts Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 760;
              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildPieChart(context, pieSections, stats)
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 400.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                          ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _buildBarChart(context, barGroups, salesByFuel)
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 500.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                          ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _buildPieChart(context, pieSections, stats)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 400.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                      ),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildBarChart(context, barGroups, salesByFuel, isTall: true)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                      ),
                ],
              );
            },
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Today's Summary
          _buildTodaysSummary(context, stats)
              .animate()
              .fadeIn(duration: 300.ms, delay: 600.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Recent Transactions
          _buildRecentTransactions(context, recentTransactions, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 700.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isActiveShift = stats['activeShift'] as bool;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            border: Border.all(color: AppTheme.primaryRed.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.redGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.redGlow,
                    ),
                    child: const Icon(
                      Icons.local_gas_station,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OctanePro Station',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, MMMM dd, yyyy')
                              .format(DateTime.now()),
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeroPill(
                    label: 'STATUS',
                    value: isActiveShift ? 'SHIFT LIVE' : 'NO SHIFT',
                    accent: isActiveShift
                        ? AppTheme.successGreen
                        : AppTheme.errorRed,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingL),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      label: 'Today Sales',
                      value: formatter.format(stats['todaySales']),
                      icon: Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: _HeroMetric(
                      label: 'Fuel Sold',
                      value: '${stats['fuelSold']} L',
                      icon: Icons.local_gas_station_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          right: -10,
          child: _HeroGlow(
            size: 120,
            color: AppTheme.primaryRed.withOpacity(0.12),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -20,
          child: _HeroGlow(
            size: 160,
            color: AppTheme.infoBlue.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _HeroPill({
    required String label,
    required String value,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.6,
              color: accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRail(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final items = [
      _RailMetric(
        label: 'Cash Sales',
        value: formatter.format(stats['cashSales']),
        color: AppTheme.successGreen,
        icon: Icons.payments,
      ),
      _RailMetric(
        label: 'Credit Sales',
        value: formatter.format(stats['creditSales']),
        color: AppTheme.infoBlue,
        icon: Icons.credit_card,
      ),
      _RailMetric(
        label: 'Expenses',
        value: formatter.format(stats['expenses']),
        color: AppTheme.errorRed,
        icon: Icons.trending_down,
      ),
      _RailMetric(
        label: 'Net Balance',
        value: formatter.format(stats['netBalance']),
        color: AppTheme.primaryRed,
        icon: Icons.account_balance_wallet,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Critical Metrics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingM),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spacingM),
                    child: item,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveShiftBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.successGreenLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.successGreen, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.successGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Shift: Evening Shift',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Started at 2:00 PM',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to shifts - handled by bottom nav
              // For now, just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Shifts via bottom navigation')),
              );
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, Map<String, dynamic> stats) {
    final cards = [
      StatCard(
        title: 'Today\'s Sales',
        value: stats['todaySales'] as double,
        icon: Icons.attach_money,
        color: AppTheme.successGreen,
        useGradient: true,
        useCurrency: true,
        index: 0,
      ),
      StatCard(
        title: 'Fuel Sold',
        value: stats['fuelSold'] as double,
        icon: Icons.local_gas_station,
        color: AppTheme.infoBlue,
        useGradient: true,
        suffix: ' L',
        index: 1,
      ),
      StatCard(
        title: 'Cash Sales',
        value: stats['cashSales'] as double,
        icon: Icons.money,
        color: AppTheme.successGreen,
        useCurrency: true,
        index: 2,
      ),
      StatCard(
        title: 'Credit Sales',
        value: stats['creditSales'] as double,
        icon: Icons.credit_card,
        color: AppTheme.infoBlue,
        useCurrency: true,
        index: 3,
      ),
      StatCard(
        title: 'Total Expenses',
        value: stats['expenses'] as double,
        icon: Icons.trending_down,
        color: AppTheme.errorRed,
        useCurrency: true,
        index: 4,
      ),
      StatCard(
        title: 'Net Balance',
        value: stats['netBalance'] as double,
        icon: Icons.account_balance,
        color: AppTheme.primaryRed,
        useGradient: true,
        useCurrency: true,
        index: 5,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900 ? 3 : 2;
        final ratio = columns == 3 ? 1.6 : 1.2;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: ratio,
          children: cards,
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingM),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 700 ? 4 : 2;
            final actions = [
              _ActionTile(
                label: 'Start Shift',
                icon: Icons.play_arrow,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Navigate to Shifts via bottom navigation'),
                    ),
                  );
                },
              ),
              _ActionTile(
                label: 'End Shift',
                icon: Icons.stop,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Navigate to Shifts via bottom navigation'),
                    ),
                  );
                },
                isSecondary: true,
              ),
              _ActionTile(
                label: 'Add Expense',
                icon: Icons.add_card,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                ),
                isSecondary: true,
              ),
              _ActionTile(
                label: 'Record Payment',
                icon: Icons.payment,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentsScreen()),
                ),
                isSecondary: true,
              ),
            ];

            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              children: actions,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPieChart(
    BuildContext context,
    List<PieChartSectionData> sections,
    Map<String, dynamic> stats,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cash vs Credit',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            SizedBox(
              height: 200,
              child: AnimatedPieChart(
                sections: sections,
                centerSpaceRadius: 50,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Cash', AppTheme.successGreen),
                _buildLegendItem('Credit', AppTheme.infoBlue),
              ],
            ),
          ],
        ),
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
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    List<BarChartGroupData> barGroups,
    List<Map<String, dynamic>> sales,
    {bool isTall = false}
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            SizedBox(
              height: isTall ? 260 : 200,
              child: AnimatedBarChart(
                barGroups: barGroups,
                xLabels: sales.map((s) => s['fuelType'] as String).toList(),
                maxY: 300000,
                title: 'Sales by Fuel Type',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysSummary(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingM),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Cash Sales',
                  value: formatter.format(stats['cashSales']),
                  color: AppTheme.successGreen,
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Credit Sales',
                  value: formatter.format(stats['creditSales']),
                  color: AppTheme.infoBlue,
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Total Expenses',
                  value: formatter.format(stats['expenses']),
                  color: AppTheme.errorRed,
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Net Balance',
                  value: formatter.format(stats['netBalance']),
                  color: AppTheme.textPrimary,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context,
    List<Map<String, dynamic>> transactions,
    NumberFormat formatter,
  ) {
    final netTotal = transactions.fold<double>(
      0,
      (sum, item) => sum + (item['amount'] as num).toDouble(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 420;
            final netColumn = Column(
              crossAxisAlignment:
                  isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  'Net',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                Text(
                  formatter.format(netTotal),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: netTotal >= 0
                            ? AppTheme.successGreen
                            : AppTheme.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            );

            final viewAllButton = TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsScreen()),
              ),
              child: const Text('View All'),
            );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Wrap(
                    spacing: AppTheme.spacingM,
                    runSpacing: AppTheme.spacingS,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      netColumn,
                      viewAllButton,
                    ],
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Row(
                  children: [
                    netColumn,
                    const SizedBox(width: AppTheme.spacingM),
                    viewAllButton,
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppTheme.spacingM),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isPositive = (transaction['amount'] as num) >= 0;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  backgroundColor: isPositive
                      ? AppTheme.successGreenLight
                      : AppTheme.errorRedLight,
                  child: Icon(
                    transaction['type'] == 'sale'
                        ? Icons.local_gas_station
                        : transaction['type'] == 'payment'
                            ? Icons.payment
                            : Icons.receipt,
                    color: isPositive ? AppTheme.successGreen : AppTheme.errorRed,
                    size: 20,
                  ),
                ),
                title: Text(transaction['description'] as String),
                subtitle: Text(
                  transaction['date'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Text(
                  formatter.format(transaction['amount']),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isPositive
                            ? AppTheme.successGreen
                            : AppTheme.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (index * 50).ms)
                  .slideX(begin: 0.2, end: 0, duration: 300.ms);
            },
          ),
        ),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow({
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

class _RailMetric extends StatelessWidget {
  const _RailMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 170,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingS),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GradientButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
        isSecondary: isSecondary,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
