import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/services/export_service.dart';
import '../data/customer_repository.dart';

class CustomerLedgerScreen extends ConsumerStatefulWidget {
  final String customerId;
  final String customerName;

  const CustomerLedgerScreen({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  ConsumerState<CustomerLedgerScreen> createState() =>
      _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends ConsumerState<CustomerLedgerScreen> {
  DateTimeRange? _dateRange;
  final _customerRepo = CustomerRepository();
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLedger();
  }

  Future<void> _loadLedger() async {
    setState(() => _isLoading = true);
    final ledger = await _customerRepo.getCustomerLedger(
      widget.customerId,
      startDate: _dateRange?.start,
      endDate: _dateRange?.end,
    );
    setState(() {
      _transactions = ledger;
      _isLoading = false;
    });
  }

  Future<void> _exportLedger() async {
    final exportData = _transactions
        .map((t) => {
              'date': t['date'] ?? '',
              'voucher': t['voucher'] ?? '',
              'description': t['description'] ?? '',
              'debit': t['debit'] ?? 0.0,
              'credit': t['credit'] ?? 0.0,
              'balance': t['balance'] ?? 0.0,
            })
        .toList();

    final currentBalance = _transactions.isNotEmpty
        ? _transactions.first['balance'] as double? ?? 0.0
        : 0.0;

    await ExportService.instance.showExportDialog(
      context,
      title: 'Customer Ledger Statement',
      fileName:
          'customer_ledger_${widget.customerId}_${DateTime.now().millisecondsSinceEpoch}',
      data: exportData,
      headers: ['Date', 'Voucher', 'Description', 'Debit', 'Credit', 'Balance'],
      columns: ['date', 'voucher', 'description', 'debit', 'credit', 'balance'],
      summary: {
        'Customer': widget.customerName,
        'Current Balance': currentBalance,
        'Total Transactions': _transactions.length,
      },
      subtitle: widget.customerName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    final transactions = _transactions;

    final currentBalance = transactions.isNotEmpty
        ? (transactions.first['balance'] as num?)?.toDouble() ?? 0.0
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customerName} - Ledger'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _dateRange,
              );
              if (range != null) {
                setState(() => _dateRange = range);
                _loadLedger();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLedger,
          ),
        ],
      ),
      body: Column(
        children: [
          // Customer Header
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
                  widget.customerName,
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
                Text(
                  currentBalance >= 0
                      ? 'Outstanding Balance'
                      : 'Credit Balance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),

          // Transactions Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : transactions.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No transactions found',
                        message: 'No transactions recorded for this customer',
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Voucher',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Description',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
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
                            final isSale = transaction['type'] == 'sale';
                            final date = transaction['date'] as String? ?? '';
                            final voucher =
                                transaction['voucher'] as String? ?? '';
                            final description =
                                transaction['description'] as String? ?? '';
                            final debit =
                                (transaction['debit'] as num?)?.toDouble() ??
                                    0.0;
                            final credit =
                                (transaction['credit'] as num?)?.toDouble() ??
                                    0.0;
                            final balance =
                                (transaction['balance'] as num?)?.toDouble() ??
                                    0.0;

                            return Container(
                              padding: const EdgeInsets.all(AppTheme.spacingM),
                              decoration: BoxDecoration(
                                color: isEven
                                    ? Colors.white
                                    : AppTheme.backgroundGray,
                                border: Border(
                                  bottom:
                                      BorderSide(color: AppTheme.borderGray),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      date,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      voucher,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSale
                                              ? Icons.local_gas_station
                                              : Icons.payment,
                                          size: 16,
                                          color: isSale
                                              ? AppTheme.primaryRed
                                              : AppTheme.successGreen,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      debit > 0 ? formatter.format(debit) : '-',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.errorRed,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      credit > 0
                                          ? formatter.format(credit)
                                          : '-',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.successGreen,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: AnimatedCount(
                                      value: balance.abs(),
                                      useCurrency: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(
                                    duration: 200.ms, delay: (index * 30).ms)
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
