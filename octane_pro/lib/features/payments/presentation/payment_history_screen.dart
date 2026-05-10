import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/empty_state.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  String _filterType = 'All'; // All, Received, Made

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    // Mock payment history
    final payments = [
      {
        'id': '1',
        'type': 'received',
        'party': 'ABC Transport Ltd',
        'amount': 50000.0,
        'date': '2024-01-15',
        'method': 'Bank Transfer',
        'reference': 'REF-001',
      },
      {
        'id': '2',
        'type': 'made',
        'party': 'National Fuel Corp',
        'amount': 25000.0,
        'date': '2024-01-14',
        'method': 'Cash',
        'reference': 'REF-002',
      },
      {
        'id': '3',
        'type': 'received',
        'party': 'XYZ Logistics',
        'amount': 30000.0,
        'date': '2024-01-13',
        'method': 'Mobile Money',
        'reference': 'REF-003',
      },
    ];

    final filteredPayments = payments.where((payment) {
      return _filterType == 'All' || payment['type'] == _filterType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting payment history...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'received', 'made'].map((type) {
                  final isSelected = _filterType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spacingS),
                    child: FilterChip(
                      label: Text(type == 'received' ? 'Received' : type == 'made' ? 'Made' : 'All'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _filterType = type);
                      },
                      selectedColor: AppTheme.primaryRedLighter,
                      checkmarkColor: AppTheme.primaryRed,
                    ),
                  );
                }).toList(),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.1, end: 0),

          // Payments List
          Expanded(
            child: filteredPayments.isEmpty
                ? EmptyState(
                    icon: Icons.payment_outlined,
                    title: 'No payments found',
                    message: 'No payment transactions match your filter',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    itemCount: filteredPayments.length,
                    itemBuilder: (context, index) {
                      final payment = filteredPayments[index];
                      return _buildPaymentCard(context, payment, formatter, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    Map<String, dynamic> payment,
    NumberFormat formatter,
    int index,
  ) {
    final isReceived = payment['type'] == 'received';
    final color = isReceived ? AppTheme.successGreen : AppTheme.errorRed;
    final icon = isReceived ? Icons.arrow_downward : Icons.arrow_upward;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          payment['party'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payment['date'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${payment['method']} • ${payment['reference']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
        trailing: AnimatedCount(
          value: (payment['amount'] as num).toDouble(),
          useCurrency: true,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideX(begin: 0.2, end: 0);
  }
}
