import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/services/export_service.dart';
import '../../../core/database/database_helper.dart';

class CashFlowSummaryScreen extends ConsumerStatefulWidget {
  const CashFlowSummaryScreen({super.key});

  @override
  ConsumerState<CashFlowSummaryScreen> createState() => _CashFlowSummaryScreenState();
}

class _CashFlowSummaryScreenState extends ConsumerState<CashFlowSummaryScreen> {
  final _dbHelper = DatabaseHelper.instance;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  List<Map<String, dynamic>> _cashFlowData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCashFlow();
  }

  Future<void> _loadCashFlow() async {
    setState(() => _isLoading = true);
    final db = await _dbHelper.database;
    final cashFlow = <Map<String, dynamic>>[];

    // Get cash sales
    final cashSales = await db.query(
      'fuel_sales',
      where: 'payment_method = ? AND sale_date >= ? AND sale_date <= ?',
      whereArgs: ['cash', _dateRange.start.toIso8601String().split('T')[0], _dateRange.end.toIso8601String().split('T')[0]],
    );
    final totalCashSales = cashSales.fold<double>(0, (sum, sale) => sum + ((sale['amount'] as num?)?.toDouble() ?? 0));

    // Get payments received
    final paymentsReceived = await db.query(
      'payments',
      where: 'payment_type = ? AND payment_date >= ? AND payment_date <= ?',
      whereArgs: ['received', _dateRange.start.toIso8601String().split('T')[0], _dateRange.end.toIso8601String().split('T')[0]],
    );
    final totalPaymentsReceived = paymentsReceived.fold<double>(0, (sum, payment) => sum + ((payment['amount'] as num?)?.toDouble() ?? 0));

    // Get expenses
    final expenses = await db.query(
      'expenses',
      where: 'expense_date >= ? AND expense_date <= ?',
      whereArgs: [_dateRange.start.toIso8601String().split('T')[0], _dateRange.end.toIso8601String().split('T')[0]],
    );
    final totalExpenses = expenses.fold<double>(0, (sum, expense) => sum + ((expense['amount'] as num?)?.toDouble() ?? 0));

    // Get payments made
    final paymentsMade = await db.query(
      'payments',
      where: 'payment_type = ? AND payment_date >= ? AND payment_date <= ?',
      whereArgs: ['made', _dateRange.start.toIso8601String().split('T')[0], _dateRange.end.toIso8601String().split('T')[0]],
    );
    final totalPaymentsMade = paymentsMade.fold<double>(0, (sum, payment) => sum + ((payment['amount'] as num?)?.toDouble() ?? 0));

    cashFlow.addAll([
      {'date': _dateRange.start.toIso8601String().split('T')[0], 'type': 'Cash Sales', 'inflow': totalCashSales, 'outflow': 0.0},
      {'date': _dateRange.start.toIso8601String().split('T')[0], 'type': 'Payments Received', 'inflow': totalPaymentsReceived, 'outflow': 0.0},
      {'date': _dateRange.start.toIso8601String().split('T')[0], 'type': 'Expenses', 'inflow': 0.0, 'outflow': totalExpenses},
      {'date': _dateRange.start.toIso8601String().split('T')[0], 'type': 'Payments Made', 'inflow': 0.0, 'outflow': totalPaymentsMade},
    ]);

    setState(() {
      _cashFlowData = cashFlow;
      _isLoading = false;
    });
  }

  Future<void> _exportReport() async {
    final totalInflow = _cashFlowData.fold<double>(0, (sum, row) => sum + ((row['inflow'] as num?)?.toDouble() ?? 0));
    final totalOutflow = _cashFlowData.fold<double>(0, (sum, row) => sum + ((row['outflow'] as num?)?.toDouble() ?? 0));
    final netFlow = totalInflow - totalOutflow;

    await ExportService.instance.showExportDialog(
      context,
      title: 'Cash Flow Summary',
      fileName: 'cash_flow_${DateTime.now().millisecondsSinceEpoch}',
      data: _cashFlowData,
      headers: ['Date', 'Type', 'Cash Inflow', 'Cash Outflow'],
      columns: ['date', 'type', 'inflow', 'outflow'],
      summary: {
        'Total Inflow': totalInflow,
        'Total Outflow': totalOutflow,
        'Net Cash Flow': netFlow,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final totalInflow = _cashFlowData.fold<double>(0, (sum, row) => sum + ((row['inflow'] as num?)?.toDouble() ?? 0));
    final totalOutflow = _cashFlowData.fold<double>(0, (sum, row) => sum + ((row['outflow'] as num?)?.toDouble() ?? 0));
    final netFlow = totalInflow - totalOutflow;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Cash Flow Summary'),
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
                _loadCashFlow();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: GlassmorphicCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Inflow',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                                AnimatedCount(
                                  value: totalInflow,
                                  useCurrency: true,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.successGreen,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: GlassmorphicCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Outflow',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                                AnimatedCount(
                                  value: totalOutflow,
                                  useCurrency: true,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.errorRed,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: GlassmorphicCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Net Flow',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                                AnimatedCount(
                                  value: netFlow.abs(),
                                  useCurrency: true,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: netFlow >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Cash Flow Table
                  GlassmorphicCard(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          decoration: BoxDecoration(
                            color: AppTheme.infoBlue,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppTheme.radiusM),
                              topRight: Radius.circular(AppTheme.radiusM),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: _buildHeaderText('Type')),
                              Expanded(flex: 2, child: _buildHeaderText('Cash Inflow')),
                              Expanded(flex: 2, child: _buildHeaderText('Cash Outflow')),
                            ],
                          ),
                        ),
                        ..._cashFlowData.map((row) {
                          return Container(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme.borderGray),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(row['type'] as String)),
                                Expanded(flex: 2, child: Text(formatter.format(row['inflow']), textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.successGreen))),
                                Expanded(flex: 2, child: Text(formatter.format(row['outflow']), textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.errorRed))),
                              ],
                            ),
                          );
                        }).toList(),
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundGray,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(AppTheme.radiusM),
                              bottomRight: Radius.circular(AppTheme.radiusM),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text('TOTAL', style: const TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text(formatter.format(totalInflow), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.successGreen))),
                              Expanded(flex: 2, child: Text(formatter.format(totalOutflow), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.errorRed))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
