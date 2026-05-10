import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import 'ledger_entry_screen.dart';
import 'ledger_detail_screen.dart';

class LedgerOverviewScreen extends ConsumerWidget {
  const LedgerOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock ledger accounts
    final accounts = [
      {'name': 'Cash Account', 'type': 'Asset', 'balance': 250000.0, 'icon': Icons.money},
      {'name': 'Bank Account', 'type': 'Asset', 'balance': 500000.0, 'icon': Icons.account_balance},
      {'name': 'Fuel Sales', 'type': 'Revenue', 'balance': 1250000.0, 'icon': Icons.local_gas_station},
      {'name': 'Expenses', 'type': 'Expense', 'balance': -150000.0, 'icon': Icons.receipt},
      {'name': 'Debtors Control', 'type': 'Asset', 'balance': 450000.0, 'icon': Icons.people},
      {'name': 'Creditors Control', 'type': 'Liability', 'balance': -125000.0, 'icon': Icons.business},
      {'name': 'Fuel Inventory', 'type': 'Asset', 'balance': 800000.0, 'icon': Icons.inventory},
      {'name': 'Stock Adjustment', 'type': 'Expense', 'balance': -5000.0, 'icon': Icons.trending_down},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('General Ledger'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LedgerEntryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            GlassmorphicCard(
              padding: const EdgeInsets.all(AppTheme.spacingXL),
              showGlow: true,
              glowColor: AppTheme.infoBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.infoBlue.withOpacity(0.3),
                              AppTheme.infoBlue.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          border: Border.all(
                            color: AppTheme.infoBlue.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.book,
                          color: AppTheme.infoBlue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'General Ledger',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'All Accounts Overview',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.1, end: 0),

            const SizedBox(height: AppTheme.spacingXL),

            // Accounts Grid
            Text(
              'Accounts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppTheme.spacingM),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: AppTheme.spacingM,
                mainAxisSpacing: AppTheme.spacingM,
              ),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return _buildAccountCard(context, account, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, Map<String, dynamic> account, int index) {
    final balance = account['balance'] as double;
    final isPositive = balance >= 0;
    final accountType = account['type'] as String;
    
    Color typeColor;
    switch (accountType) {
      case 'Asset':
        typeColor = AppTheme.infoBlue;
        break;
      case 'Liability':
        typeColor = AppTheme.errorRed;
        break;
      case 'Revenue':
        typeColor = AppTheme.successGreen;
        break;
      case 'Expense':
        typeColor = AppTheme.warningYellow;
        break;
      default:
        typeColor = AppTheme.textSecondary;
    }

    return GlassmorphicCard(
      showGlow: true,
      glowColor: typeColor,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LedgerDetailScreen(accountName: account['name'] as String),
          ),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          typeColor.withOpacity(0.3),
                          typeColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: typeColor.withOpacity(0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: typeColor.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      account['icon'] as IconData,
                      color: typeColor,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          typeColor.withOpacity(0.3),
                          typeColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: typeColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: typeColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      accountType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account['name'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  AnimatedCount(
                    value: balance.abs(),
                    useCurrency: true,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isPositive ? AppTheme.successGreen : AppTheme.errorRed,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}
