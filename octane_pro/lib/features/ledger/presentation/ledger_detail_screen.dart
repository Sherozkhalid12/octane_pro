import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_count.dart';

class LedgerDetailScreen extends ConsumerWidget {
  final String accountName;
  
  const LedgerDetailScreen({
    super.key,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    // Mock transactions
    final transactions = [
      {
        'date': '2024-01-15',
        'voucher': 'V-001',
        'description': 'Fuel Sales',
        'debit': 50000.0,
        'credit': 0.0,
        'balance': 50000.0,
      },
      {
        'date': '2024-01-15',
        'voucher': 'V-002',
        'description': 'Payment Received',
        'debit': 25000.0,
        'credit': 0.0,
        'balance': 75000.0,
      },
      {
        'date': '2024-01-14',
        'voucher': 'V-003',
        'description': 'Expense Payment',
        'debit': 0.0,
        'credit': 15000.0,
        'balance': 60000.0,
      },
    ];

    final currentBalance = transactions.isNotEmpty 
        ? transactions.first['balance'] as double 
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(accountName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting ledger...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Account Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.infoBlue, AppTheme.infoBlue.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  accountName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                AnimatedCount(
                  value: currentBalance.abs(),
                  useCurrency: true,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.1, end: 0),

          // Transactions Table
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          'No transactions found',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppTheme.radiusM),
                            topRight: Radius.circular(AppTheme.radiusM),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Date',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Voucher',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Description',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Debit',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Credit',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Balance',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Table Rows
                      ...transactions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final transaction = entry.value;
                        final isEven = index % 2 == 0;

                        return Container(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          decoration: BoxDecoration(
                            color: isEven ? Colors.white : AppTheme.backgroundGray,
                            border: Border(
                              bottom: BorderSide(color: AppTheme.borderGray),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  transaction['date'] as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  transaction['voucher'] as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  transaction['description'] as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  (transaction['debit'] as double) > 0
                                      ? formatter.format(transaction['debit'])
                                      : '-',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.errorRed,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  (transaction['credit'] as double) > 0
                                      ? formatter.format(transaction['credit'])
                                      : '-',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.successGreen,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: AnimatedCount(
                                  value: (transaction['balance'] as double).abs(),
                                  useCurrency: true,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 200.ms, delay: (index * 30).ms)
                            .slideX(begin: 0.1, end: 0);
                      }).toList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
