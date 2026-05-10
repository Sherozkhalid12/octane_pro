import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/data/mock_data.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/gradient_button.dart';
import '../../../../../features/shifts/presentation/shifts_screen.dart';
import '../../../../../features/reports/presentation/reports_screen.dart';

/// Operations-focused dashboard for Managers
class ManagerDashboard extends ConsumerWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = MockData.getDashboardStats();
    final tankInventory = MockData.getTankInventory();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(context)
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          _buildOpsSnapshot(context, stats, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 60.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Operations Stats
          _buildOperationsStats(context, stats)
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Inventory Status
          _buildInventoryStatus(context, tankInventory)
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

          // Shift Performance
          _buildShiftPerformance(context, stats, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 400.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.infoBlue.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.infoBlue.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.infoBlue, AppTheme.infoBlue.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.infoBlue.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.dashboard,
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
                  'Operations Dashboard',
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _HeroPill(
            label: 'OPS',
            value: 'LIVE',
            accent: AppTheme.infoBlue,
          ),
        ],
      ),
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

  Widget _buildOperationsStats(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
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
        title: 'Total Expenses',
        value: stats['expenses'] as double,
        icon: Icons.trending_down,
        color: AppTheme.errorRed,
        useCurrency: true,
        index: 2,
      ),
      StatCard(
        title: 'Net Balance',
        value: stats['netBalance'] as double,
        icon: Icons.account_balance,
        color: AppTheme.primaryRed,
        useCurrency: true,
        index: 3,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 700 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.7,
          children: cards,
        );
      },
    );
  }

  Widget _buildInventoryStatus(
    BuildContext context,
    List<Map<String, dynamic>> tanks,
  ) {
    final average = tanks.isEmpty
        ? 0
        : tanks
                .map((tank) => tank['percentage'] as double)
                .reduce((a, b) => a + b) /
            tanks.length;
    final lowCount = tanks.where((tank) {
      final percentage = tank['percentage'] as double;
      return percentage < 30;
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tank Inventory',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to inventory
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            _StatusChip(
              label: 'Tanks',
              value: tanks.length.toString(),
              color: AppTheme.infoBlue,
            ),
            const SizedBox(width: AppTheme.spacingS),
            _StatusChip(
              label: 'Avg Fill',
              value: '${average.toStringAsFixed(1)}%',
              color: AppTheme.successGreen,
            ),
            const SizedBox(width: AppTheme.spacingS),
            _StatusChip(
              label: 'Low',
              value: lowCount.toString(),
              color: AppTheme.errorRed,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        ...tanks.map((tank) {
          final percentage = tank['percentage'] as double;
          final color = percentage < 30
              ? AppTheme.errorRed
              : percentage < 50
                  ? AppTheme.warningYellow
                  : AppTheme.successGreen;
          return Card(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tank['tankId']} - ${tank['fuelType']}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppTheme.backgroundGrayLight,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '${tank['currentStock']} L / ${tank['capacity']} L',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideX(begin: 0.2, end: 0);
        }).toList(),
      ],
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
                label: 'Record Dip',
                icon: Icons.water_drop,
                onPressed: () {
                  // TODO: Navigate to dip entry
                },
              ),
              _ActionTile(
                label: 'View Shifts',
                icon: Icons.access_time,
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
                label: 'Inventory',
                icon: Icons.inventory,
                onPressed: () {
                  // TODO: Navigate to inventory
                },
                isSecondary: true,
              ),
              _ActionTile(
                label: 'Reports',
                icon: Icons.assessment,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen()),
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

  Widget _buildShiftPerformance(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shift Performance',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingM),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Today\'s Sales',
                  value: formatter.format(stats['todaySales']),
                  color: AppTheme.successGreen,
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Fuel Sold',
                  value: '${stats['fuelSold']} L',
                  color: AppTheme.infoBlue,
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Net Balance',
                  value: formatter.format(stats['netBalance']),
                  color: AppTheme.primaryRed,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: textTheme.labelSmall?.copyWith(
              color: color,
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

class _OpsSnapshotItem extends StatelessWidget {
  const _OpsSnapshotItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on ManagerDashboard {
  Widget _buildOpsSnapshot(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
    return Row(
      children: [
        _OpsSnapshotItem(
          label: 'Today Sales',
          value: formatter.format(stats['todaySales']),
          color: AppTheme.successGreen,
        ),
        const SizedBox(width: AppTheme.spacingM),
        _OpsSnapshotItem(
          label: 'Fuel Sold',
          value: '${stats['fuelSold']} L',
          color: AppTheme.infoBlue,
        ),
        const SizedBox(width: AppTheme.spacingM),
        _OpsSnapshotItem(
          label: 'Net Balance',
          value: formatter.format(stats['netBalance']),
          color: AppTheme.primaryRed,
        ),
      ],
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
