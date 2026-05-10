import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_count.dart';

class EndShiftScreen extends ConsumerStatefulWidget {
  const EndShiftScreen({super.key});

  @override
  ConsumerState<EndShiftScreen> createState() => _EndShiftScreenState();
}

class _EndShiftScreenState extends ConsumerState<EndShiftScreen> {
  final _formKey = GlobalKey<FormState>();
  final _closingCashController = TextEditingController();
  final _remarksController = TextEditingController();
  final Map<String, TextEditingController> _closingReadings = {};
  final Map<String, double> _calculatedLiters = {};
  final Map<String, double> _calculatedAmounts = {};
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
    final nozzles = MockData.getNozzles();

    for (var nozzle in nozzles) {
      _closingReadings[nozzle['id'] as String] = TextEditingController();
      _closingReadings[nozzle['id']]!.addListener(() => _calculateNozzle(nozzle));
    }
  }

  void _calculateNozzle(Map<String, dynamic> nozzle) {
    final closingReading =
        double.tryParse(_closingReadings[nozzle['id']]?.text ?? '') ?? 0;
    final openingReading = 1000.0;
    final liters =
        (closingReading - openingReading).clamp(0.0, double.infinity);
    final fuelType = MockData.getFuelTypes().firstWhere(
      (ft) => ft['id'] == nozzle['fuelTypeId'],
    );
    final pricePerLiter = fuelType['pricePerLiter'] as double;
    final amount = liters * pricePerLiter;

    setState(() {
      _calculatedLiters[nozzle['id'] as String] = liters;
      _calculatedAmounts[nozzle['id'] as String] = amount;
    });
  }

  @override
  void dispose() {
    _closingCashController.dispose();
    _remarksController.dispose();
    for (var controller in _closingReadings.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _totalLiters =>
      _calculatedLiters.values.fold(0.0, (sum, val) => sum + val);
  double get _totalAmount =>
      _calculatedAmounts.values.fold(0.0, (sum, val) => sum + val);
  double get _cashSales => 85000.0;
  double get _creditSales => 40450.0;
  double get _expenses => 15000.0;
  double get _openingCash => 125000.0;
  double get _closingCash => double.tryParse(_closingCashController.text) ?? 0;
  double get _shortExcess {
    final expectedCash = _openingCash + _cashSales - _expenses;
    return _closingCash - expectedCash;
  }

  @override
  Widget build(BuildContext context) {
    final nozzles = MockData.getNozzles();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final hasVariance = _shortExcess.abs() > 0.01;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: Stack(
        children: [
          const _NeonBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingL,
                AppTheme.spacingL,
                AppTheme.spacingL,
                AppTheme.spacingXL,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderBar(
                      title: 'End Shift',
                      subtitle:
                          'Evening Shift · ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                      accent: hasVariance
                          ? AppTheme.warningYellow
                          : AppTheme.successGreen,
                      pillLabel: 'VARIANCE',
                      pillValue: hasVariance ? 'CHECK' : 'CLEAR',
                      onBack: () => Navigator.pop(context),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: -0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingXL),
                    _SectionHeader(
                      title: 'Closing Meter Readings',
                      subtitle: 'Enter final readings for each nozzle',
                      step: '1',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    ...nozzles.map((nozzle) {
                      final index = nozzles.indexOf(nozzle);
                      final nozzleId = nozzle['id'] as String;
                      final liters = _calculatedLiters[nozzleId] ?? 0.0;
                      final amount = _calculatedAmounts[nozzleId] ?? 0.0;

                      return _NeonSectionCard(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryRed.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppTheme.primaryRed.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    nozzle['number'] as String,
                                    style: const TextStyle(
                                      color: AppTheme.primaryRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Expanded(
                                  child: Text(
                                    nozzle['fuelType'] as String,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                if (liters > 0)
                                  _MiniStat(
                                    label: 'Liters',
                                    value: liters.toStringAsFixed(1),
                                    color: AppTheme.infoBlue,
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingM),
                            TextFormField(
                              controller: _closingReadings[nozzleId],
                              decoration: InputDecoration(
                                labelText: 'Closing Reading',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusM),
                                ),
                                prefixIcon: const Icon(Icons.speed),
                                suffixText: 'L',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            if (liters > 0) ...[
                              const SizedBox(height: AppTheme.spacingM),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Liters Sold',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                      ),
                                      AnimatedCount(
                                        value: liters,
                                        suffix: ' L',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppTheme.infoBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Amount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                      ),
                                      AnimatedCount(
                                        value: amount,
                                        useCurrency: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppTheme.successGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 300.ms,
                            delay: (200 + index * 50).ms,
                          )
                          .slideX(begin: 0.2, end: 0);
                    }).toList(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _SectionHeader(
                      title: 'Cash Collection',
                      subtitle: 'Enter cash collected at shift end',
                      step: '2',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    _NeonSectionCard(
                      child: TextFormField(
                        controller: _closingCashController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                          prefixText: '\$ ',
                          hintText: '0.00',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter closing cash';
                          }
                          return null;
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingXL),
                    if (_showSummary || _closingCashController.text.isNotEmpty)
                      _SummaryPanel(
                        formatter: formatter,
                        totalLiters: _totalLiters,
                        totalAmount: _totalAmount,
                        cashSales: _cashSales,
                        creditSales: _creditSales,
                        expenses: _expenses,
                        shortExcess: _shortExcess,
                        hasVariance: hasVariance,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                          ),
                    const SizedBox(height: AppTheme.spacingXL),
                    if (hasVariance) ...[
                      Text(
                        'Remarks *',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.errorRed,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      _NeonSectionCard(
                        child: TextFormField(
                          controller: _remarksController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusM),
                            ),
                            hintText: 'Please explain the variance...',
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (hasVariance && (value == null || value.isEmpty)) {
                              return 'Remarks required for variance';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXL),
                    ],
                    GradientButton(
                      label: 'End Shift',
                      icon: Icons.check,
                      onPressed: _handleEndShift,
                      width: double.infinity,
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 600.ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                          duration: 300.ms,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEndShift() {
    if (_formKey.currentState!.validate()) {
      setState(() => _showSummary = true);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm End Shift'),
          content: const Text(
            'Are you sure you want to end this shift? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Shift ended successfully'),
                    backgroundColor: AppTheme.successGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('End Shift'),
            ),
          ],
        ),
      );
    }
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.pillLabel,
    required this.pillValue,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final String pillLabel;
  final String pillValue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 4),
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        _StatusPill(label: pillLabel, value: pillValue, accent: accent),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.4,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.step,
  });

  final String title;
  final String subtitle;
  final String step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppTheme.primaryRed.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryRed.withOpacity(0.35)),
          ),
          child: Center(
            child: Text(
              step,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NeonSectionCard extends StatelessWidget {
  const _NeonSectionCard({
    required this.child,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.16),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label $value',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.formatter,
    required this.totalLiters,
    required this.totalAmount,
    required this.cashSales,
    required this.creditSales,
    required this.expenses,
    required this.shortExcess,
    required this.hasVariance,
  });

  final NumberFormat formatter;
  final double totalLiters;
  final double totalAmount;
  final double cashSales;
  final double creditSales;
  final double expenses;
  final double shortExcess;
  final bool hasVariance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(
          color: (hasVariance ? AppTheme.errorRed : AppTheme.successGreen)
              .withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (hasVariance ? AppTheme.errorRed : AppTheme.successGreen)
                .withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shift Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: (hasVariance ? AppTheme.errorRed : AppTheme.successGreen)
                    .withOpacity(0.2),
              ),
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
                AnimatedCount(
                  value: totalAmount - expenses,
                  useCurrency: true,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: hasVariance
                            ? AppTheme.errorRed
                            : AppTheme.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          _SummaryRow(
            label: 'Total Liters',
            value: AnimatedCount(
              value: totalLiters,
              suffix: ' L',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Divider(),
          _SummaryRow(
            label: 'Total Amount',
            value: AnimatedCount(
              value: totalAmount,
              useCurrency: true,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Divider(),
          _SummaryRow(
            label: 'Cash Sales',
            value: AnimatedCount(
              value: cashSales,
              useCurrency: true,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(),
          _SummaryRow(
            label: 'Credit Sales',
            value: AnimatedCount(
              value: creditSales,
              useCurrency: true,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(),
          _SummaryRow(
            label: 'Expenses',
            value: AnimatedCount(
              value: expenses,
              useCurrency: true,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.errorRed,
                  ),
            ),
          ),
          const Divider(),
          _SummaryRow(
            label: 'Short/Excess',
            value: AnimatedCount(
              value: shortExcess,
              useCurrency: true,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: hasVariance
                        ? AppTheme.errorRed
                        : AppTheme.successGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        value,
      ],
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
