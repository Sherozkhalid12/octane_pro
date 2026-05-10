import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/data/mock_data.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/gradient_button.dart';
import '../../../../../features/entries/presentation/entries_screen.dart';

/// Simplified dashboard for Operators - focused on sales entry
class OperatorDashboard extends ConsumerWidget {
  const OperatorDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = MockData.getDashboardStats();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Shift Banner (Prominent)
          if (stats['activeShift'] as bool)
            _buildActiveShiftBanner(context)
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

          if (stats['activeShift'] as bool) const SizedBox(height: AppTheme.spacingL),

          // Key Metrics (Simplified - Only 2-3)
          _buildKeyMetrics(context, stats, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingXL),

          // Quick Sales Entry Button (Large and Prominent)
          _buildQuickSalesEntry(context)
              .animate()
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

          const SizedBox(height: AppTheme.spacingL),

          // Today's Summary (Simplified)
          _buildTodaysSummary(context, stats, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildActiveShiftBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successGreen.withOpacity(0.2),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.successGreen,
                  AppTheme.successGreen.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.access_time,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evening Shift',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Started at 2:00 PM',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppTheme.successGreen.withOpacity(0.4),
              ),
            ),
            child: Text(
              'LIVE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.successGreen,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 600 ? 3 : 2;
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
            title: 'Net Balance',
            value: stats['netBalance'] as double,
            icon: Icons.account_balance_wallet,
            color: AppTheme.primaryRed,
            useCurrency: true,
            index: 2,
          ),
        ];
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: cards,
        );
      },
    );
  }

  Widget _buildQuickSalesEntry(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryRed, AppTheme.primaryRedLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'Quick Sales Entry',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                'Record a new fuel sale',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              GradientButton(
                label: 'Add Sale',
                icon: Icons.add,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EntriesScreen()),
                ),
                width: double.infinity,
                isSecondary: true,
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          right: -10,
          child: _GlowBubble(
            size: 120,
            color: Colors.white.withOpacity(0.12),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -20,
          child: _GlowBubble(
            size: 160,
            color: Colors.black.withOpacity(0.08),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysSummary(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
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
                  label: 'Total Sales',
                  value: formatter.format(stats['todaySales']),
                  color: AppTheme.successGreen,
                  isBold: true,
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Fuel Sold',
                  value: '${stats['fuelSold']} L',
                  color: AppTheme.infoBlue,
                ),
              ],
            ),
          ),
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

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({
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
