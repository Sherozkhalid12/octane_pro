import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/data/mock_data.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/gradient_button.dart';
import '../../../../../features/ledger/presentation/ledger_overview_screen.dart';
import '../../../../../features/payments/presentation/payments_screen.dart';
import '../../../../../features/reports/presentation/reports_screen.dart';
import '../../../../../features/customers/presentation/customers_screen.dart';

/// Financial metrics-focused dashboard for Accountants
class AccountantDashboard extends ConsumerWidget {
  const AccountantDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = MockData.getDashboardStats();
    final customers = MockData.getCustomers();
    final suppliers = MockData.getSuppliers();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    // Calculate outstanding amounts
    final totalReceivables = customers.fold<double>(
      0,
      (sum, customer) => sum + (customer['balance'] as num).toDouble(),
    );
    final totalPayables = suppliers.fold<double>(
      0,
      (sum, supplier) => sum + ((supplier['balance'] as num).toDouble().abs()),
    );

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

          _buildFinanceSnapshot(context, stats, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 60.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Financial Metrics
          _buildFinancialMetrics(context, stats, formatter)
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppTheme.spacingL),

          // Outstanding Amounts
          _buildOutstandingAmounts(
            context,
            totalReceivables,
            totalPayables,
            formatter,
          )
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

          // Cash Flow Summary
          _buildCashFlowSummary(context, stats, formatter)
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
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successGreen.withOpacity(0.2),
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
                colors: [
                  AppTheme.successGreen,
                  AppTheme.successGreen.withOpacity(0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.successGreen.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance,
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
                  'Financial Dashboard',
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
            label: 'MODE',
            value: 'FINANCE',
            accent: AppTheme.successGreen,
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

  Widget _buildFinanceSnapshot(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
    final todaySales = stats['todaySales'] as double;
    final profitPercent = todaySales == 0
        ? 0
        : ((stats['netBalance'] as double) / todaySales) * 100;
    return Row(
      children: [
        _SnapshotCard(
          label: 'Today Sales',
          value: formatter.format(stats['todaySales']),
          color: AppTheme.successGreen,
        ),
        const SizedBox(width: AppTheme.spacingM),
        _SnapshotCard(
          label: 'Net Balance',
          value: formatter.format(stats['netBalance']),
          color: AppTheme.primaryRed,
        ),
        const SizedBox(width: AppTheme.spacingM),
        _SnapshotCard(
          label: 'Profit %',
          value: profitPercent.toStringAsFixed(1),
          color: AppTheme.infoBlue,
        ),
      ],
    );
  }

  Widget _buildFinancialMetrics(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
    final cards = [
      StatCard(
        title: 'Total Sales',
        value: stats['todaySales'] as double,
        icon: Icons.attach_money,
        color: AppTheme.successGreen,
        useGradient: true,
        useCurrency: true,
        index: 0,
      ),
      StatCard(
        title: 'Net Balance',
        value: stats['netBalance'] as double,
        icon: Icons.account_balance_wallet,
        color: AppTheme.primaryRed,
        useGradient: true,
        useCurrency: true,
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
        title: 'Profit Margin',
        value:
            ((stats['netBalance'] as double) / (stats['todaySales'] as double)) *
                100,
        icon: Icons.percent,
        color: AppTheme.infoBlue,
        suffix: '%',
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

  Widget _buildOutstandingAmounts(
    BuildContext context,
    double receivables,
    double payables,
    NumberFormat formatter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Outstanding Amounts',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.infoBlueLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color: AppTheme.infoBlue,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          'Receivables',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.infoBlue,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      formatter.format(receivables),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.infoBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.errorRedLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: AppTheme.errorRed,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          'Payables',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.errorRed,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      formatter.format(payables),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.errorRed,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                label: 'View Ledger',
                icon: Icons.book,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LedgerOverviewScreen(),
                  ),
                ),
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
              _ActionTile(
                label: 'Reports',
                icon: Icons.assessment,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen()),
                ),
                isSecondary: true,
              ),
              _ActionTile(
                label: 'Customers',
                icon: Icons.people,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomersScreen()),
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

  Widget _buildCashFlowSummary(
    BuildContext context,
    Map<String, dynamic> stats,
    NumberFormat formatter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cash Flow Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingM),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net Balance',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      Text(
                        formatter.format(stats['netBalance']),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
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

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({
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
