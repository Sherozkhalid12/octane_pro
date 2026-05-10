import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/services/export_service.dart';
import '../../suppliers/data/supplier_repository.dart';

class CreditorsAgingReportScreen extends ConsumerStatefulWidget {
  const CreditorsAgingReportScreen({super.key});

  @override
  ConsumerState<CreditorsAgingReportScreen> createState() =>
      _CreditorsAgingReportScreenState();
}

class _CreditorsAgingReportScreenState
    extends ConsumerState<CreditorsAgingReportScreen> {
  final _supplierRepo = SupplierRepository();
  List<Map<String, dynamic>> _agingData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAgingReport();
  }

  Future<void> _loadAgingReport() async {
    setState(() => _isLoading = true);
    final suppliers = await _supplierRepo.getAllSuppliers(activeOnly: false);
    final now = DateTime.now();
    final agingData = <Map<String, dynamic>>[];

    for (var supplier in suppliers) {
      if (supplier.balance >= 0) continue;

      final ledger = await _supplierRepo.getSupplierLedger(supplier.id);
      double current = 0;
      double days30 = 0;
      double days60 = 0;
      double days90 = 0;
      double days90Plus = 0;

      for (var entry in ledger) {
        final dateStr = entry['date'] as String?;
        if (dateStr == null) continue;

        final entryDate = DateTime.tryParse(dateStr);
        if (entryDate == null) continue;

        final daysDiff = now.difference(entryDate).inDays;
        final amount = (entry['credit'] as num?)?.toDouble() ?? 0.0;

        if (daysDiff <= 30) {
          current += amount;
        } else if (daysDiff <= 60) {
          days30 += amount;
        } else if (daysDiff <= 90) {
          days60 += amount;
        } else if (daysDiff <= 180) {
          days90 += amount;
        } else {
          days90Plus += amount;
        }
      }

      final total = current + days30 + days60 + days90 + days90Plus;
      if (total > 0) {
        agingData.add({
          'supplier': supplier.name,
          'current': current,
          'days30': days30,
          'days60': days60,
          'days90': days90,
          'days90Plus': days90Plus,
          'total': total,
        });
      }
    }

    setState(() {
      _agingData = agingData;
      _isLoading = false;
    });
  }

  Future<void> _exportReport() async {
    final exportData = _agingData
        .map((row) => {
              'supplier': row['supplier'] ?? '',
              'current': row['current'] ?? 0.0,
              'days30': row['days30'] ?? 0.0,
              'days60': row['days60'] ?? 0.0,
              'days90': row['days90'] ?? 0.0,
              'days90Plus': row['days90Plus'] ?? 0.0,
              'total': row['total'] ?? 0.0,
            })
        .toList();

    final totalCurrent = _agingData.fold<double>(
        0, (sum, row) => sum + (row['current'] as num).toDouble());
    final total30 = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days30'] as num).toDouble());
    final total60 = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days60'] as num).toDouble());
    final total90 = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days90'] as num).toDouble());
    final total90Plus = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days90Plus'] as num).toDouble());
    final grandTotal = totalCurrent + total30 + total60 + total90 + total90Plus;

    await ExportService.instance.showExportDialog(
      context,
      title: 'Creditors Aging Report',
      fileName: 'creditors_aging_${DateTime.now().millisecondsSinceEpoch}',
      data: exportData,
      headers: [
        'Supplier',
        'Current (0-30)',
        '31-60 Days',
        '61-90 Days',
        '91-180 Days',
        '180+ Days',
        'Total'
      ],
      columns: [
        'supplier',
        'current',
        'days30',
        'days60',
        'days90',
        'days90Plus',
        'total'
      ],
      summary: {
        'Total Current': totalCurrent,
        'Total 31-60 Days': total30,
        'Total 61-90 Days': total60,
        'Total 91-180 Days': total90,
        'Total 180+ Days': total90Plus,
        'Grand Total': grandTotal,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final totalCurrent = _agingData.fold<double>(
        0, (sum, row) => sum + (row['current'] as num).toDouble());
    final total30 = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days30'] as num).toDouble());
    final total60 = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days60'] as num).toDouble());
    final total90 = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days90'] as num).toDouble());
    final total90Plus = _agingData.fold<double>(
        0, (sum, row) => sum + (row['days90Plus'] as num).toDouble());
    final grandTotal = totalCurrent + total30 + total60 + total90 + total90Plus;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creditors Aging Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroConsole(
                        title: 'Creditors Aging',
                        subtitle: 'Payables by aging bucket.',
                        icon: Icons.business,
                        pillLabel: 'TOTAL',
                        pillValue: formatter.format(grandTotal),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: -0.1, end: 0),

                      const SizedBox(height: AppTheme.spacingXL),

                      Row(
                        children: [
                          Expanded(
                            child: _NeonStatCard(
                              title: 'Current (0-30)',
                              value: totalCurrent,
                              color: AppTheme.successGreen,
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 150.ms)
                                .slideY(begin: 0.1, end: 0),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: _NeonStatCard(
                              title: 'Total Payable',
                              value: grandTotal,
                              color: AppTheme.errorRed,
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 200.ms)
                                .slideY(begin: 0.1, end: 0),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingXL),

                      _NeonPanel(
                        child: _NeonTable(
                          headerColor: AppTheme.errorRed,
                          formatter: formatter,
                          rows: _agingData,
                          totals: {
                            'current': totalCurrent,
                            'days30': total30,
                            'days60': total60,
                            'days90': total90,
                            'days90Plus': total90Plus,
                            'total': grandTotal,
                          },
                          isCustomer: false,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 250.ms)
                          .scale(
                            begin: const Offset(0.98, 0.98),
                            end: const Offset(1, 1),
                          ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _NeonTable extends StatelessWidget {
  const _NeonTable({
    required this.headerColor,
    required this.formatter,
    required this.rows,
    required this.totals,
    required this.isCustomer,
  });

  final Color headerColor;
  final NumberFormat formatter;
  final List<Map<String, dynamic>> rows;
  final Map<String, double> totals;
  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    const nameWidth = 220.0;
    const bucketWidth = 110.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 920),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusM),
                  topRight: Radius.circular(AppTheme.radiusM),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: nameWidth,
                    child: _buildHeaderText(
                        isCustomer ? 'Customer' : 'Supplier'),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: _buildHeaderText('0-30 Days'),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: _buildHeaderText('31-60 Days'),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: _buildHeaderText('61-90 Days'),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: _buildHeaderText('91-180 Days'),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: _buildHeaderText('180+ Days'),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: _buildHeaderText('Total'),
                  ),
                ],
              ),
            ),
            ...rows.map((row) {
              return Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppTheme.borderGray),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: nameWidth,
                      child: Text(row[isCustomer ? 'customer' : 'supplier'] as String),
                    ),
                    SizedBox(
                      width: bucketWidth,
                      child: Text(
                        formatter.format(row['current']),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: bucketWidth,
                      child: Text(
                        formatter.format(row['days30']),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: bucketWidth,
                      child: Text(
                        formatter.format(row['days60']),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: bucketWidth,
                      child: Text(
                        formatter.format(row['days90']),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: bucketWidth,
                      child: Text(
                        formatter.format(row['days90Plus']),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: bucketWidth,
                      child: Text(
                        formatter.format(row['total']),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
                  SizedBox(
                    width: nameWidth,
                    child: Text(
                      'TOTAL',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: Text(
                      formatter.format(totals['current']),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: Text(
                      formatter.format(totals['days30']),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: Text(
                      formatter.format(totals['days60']),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: Text(
                      formatter.format(totals['days90']),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: Text(
                      formatter.format(totals['days90Plus']),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: bucketWidth,
                    child: Text(
                      formatter.format(totals['total']),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorRed,
                      ),
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
              color: AppTheme.errorRed.withOpacity(0.18),
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
        border: Border.all(color: AppTheme.errorRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.errorRed.withOpacity(0.18),
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
              gradient: LinearGradient(
                colors: [AppTheme.errorRed, AppTheme.errorRed.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.errorRed.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
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
        border: Border.all(color: AppTheme.errorRed.withOpacity(0.4)),
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
                  color: AppTheme.errorRed,
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
        border: Border.all(color: AppTheme.errorRed.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.errorRed.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: child,
    );
  }
}

class _NeonStatCard extends StatelessWidget {
  const _NeonStatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: color.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          AnimatedCount(
            value: value,
            useCurrency: true,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
