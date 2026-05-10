import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import 'daily_report_screen.dart';
import 'monthly_report_screen.dart';
import 'debtors_aging_report_screen.dart';
import 'creditors_aging_report_screen.dart';
import 'cash_flow_summary_screen.dart';
import 'analytics_dashboard_screen.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _reportTypes = [
    {
      'title': 'Sales Report',
      'icon': Icons.local_gas_station,
      'color': AppTheme.successGreen,
      'route': '/reports/daily',
    },
    {
      'title': 'Expense Report',
      'icon': Icons.receipt_long,
      'color': AppTheme.errorRed,
      'route': '/reports/daily',
    },
    {
      'title': 'Profit & Loss',
      'icon': Icons.trending_up,
      'color': AppTheme.infoBlue,
      'route': '/reports/monthly',
    },
    {
      'title': 'Cash Flow',
      'icon': Icons.account_balance_wallet,
      'color': AppTheme.primaryRed,
      'route': '/reports/cash-flow',
    },
    {
      'title': 'Debtors Aging',
      'icon': Icons.people,
      'color': AppTheme.warningYellow,
      'route': '/reports/debtors-aging',
    },
    {
      'title': 'Creditors Aging',
      'icon': Icons.business,
      'color': AppTheme.errorRed,
      'route': '/reports/creditors-aging',
    },
    {
      'title': 'Tank Variance',
      'icon': Icons.water_drop,
      'color': AppTheme.infoBlue,
      'route': '/reports/monthly',
    },
    {
      'title': 'Shift Performance',
      'icon': Icons.access_time,
      'color': AppTheme.primaryRed,
      'route': '/reports/monthly',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AnalyticsDashboardScreen()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  children: [
                    _HeroConsole(
                      title: 'Reports Command',
                      subtitle: 'Explore performance, cash flow, and growth.',
                      icon: Icons.analytics_outlined,
                      pillLabel: 'INSIGHTS',
                      pillValue: 'LIVE',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: -0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    _NeonPanel(
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Daily'),
                          Tab(text: 'Monthly'),
                          Tab(text: 'Yearly'),
                          Tab(text: 'Custom'),
                        ],
                        labelColor: AppTheme.primaryRed,
                        unselectedLabelColor: AppTheme.textSecondary,
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        dividerHeight: 0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .slideY(begin: -0.05, end: 0),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingM,
                    0,
                    AppTheme.spacingM,
                    AppTheme.spacingM,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Types',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 200.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: AppTheme.spacingM),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: AppTheme.spacingM,
                          mainAxisSpacing: AppTheme.spacingM,
                        ),
                        itemCount: _reportTypes.length,
                        itemBuilder: (context, index) {
                          final report = _reportTypes[index];
                          return _buildReportCard(context, report, index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    Map<String, dynamic> report,
    int index,
  ) {
    final color = report['color'] as Color;
    final icon = report['icon'] as IconData;
    final route = report['route'] as String;
    final title = report['title'] as String;

    // Map routes to screen widgets
    Widget? getScreenForRoute(String route) {
      switch (route) {
        case '/reports/daily':
          return const DailyReportScreen();
        case '/reports/monthly':
          return const MonthlyReportScreen();
        case '/reports/debtors-aging':
          return const DebtorsAgingReportScreen();
        case '/reports/creditors-aging':
          return const CreditorsAgingReportScreen();
        case '/reports/cash-flow':
          return const CashFlowSummaryScreen();
        case '/reports/analytics':
          return const AnalyticsDashboardScreen();
        default:
          return null;
      }
    }

    return GestureDetector(
      onTap: () {
        final screen = getScreenForRoute(route);
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Screen not found for: $title'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      },
      child: _NeonReportCard(
        title: title,
        icon: icon,
        color: color,
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
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
      padding: const EdgeInsets.all(AppTheme.spacingS),
      child: child,
    );
  }
}

class _NeonReportCard extends StatelessWidget {
  const _NeonReportCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: _GlowOrb(size: 90, color: color.withOpacity(0.18)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.75)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Open report',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.4,
                          ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 14, color: color),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
