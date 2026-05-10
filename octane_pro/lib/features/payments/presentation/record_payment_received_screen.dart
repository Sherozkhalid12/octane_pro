import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/constants/enums.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_count.dart';

class RecordPaymentReceivedScreen extends ConsumerStatefulWidget {
  const RecordPaymentReceivedScreen({super.key});

  @override
  ConsumerState<RecordPaymentReceivedScreen> createState() => _RecordPaymentReceivedScreenState();
}

class _RecordPaymentReceivedScreenState extends ConsumerState<RecordPaymentReceivedScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomerId;
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _remarksController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0.0;
  double get _customerBalance {
    if (_selectedCustomerId == null) return 0.0;
    final customers = MockData.getCustomers();
    final customer = customers.firstWhere(
      (c) => c['id'] == _selectedCustomerId,
      orElse: () => <String, dynamic>{},
    );
    if (customer.isEmpty) return 0.0;
    return (customer['balance'] as num).toDouble();
  }
  double get _newBalance => _customerBalance - _amount;

  @override
  Widget build(BuildContext context) {
    final customers = MockData.getCustomers();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Payment Received'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(accentColor: AppTheme.successGreen),
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroConsole(
                    title: 'Payment Received',
                    subtitle: 'From customer',
                    icon: Icons.arrow_downward,
                    accentColor: AppTheme.successGreen,
                    pillLabel: 'MODE',
                    pillValue: _selectedPaymentMethod.label,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingXL),

                  _NeonPanel(
                    accentColor: AppTheme.successGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Customer',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        DropdownButtonFormField<String>(
                          value: _selectedCustomerId,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppTheme.backgroundWhite,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          items: customers.map((customer) {
                            return DropdownMenuItem(
                              value: customer['id'] as String,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppTheme.primaryRedLighter,
                                    child: Text(
                                      (customer['name'] as String)[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: AppTheme.primaryRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacingS),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          customer['name'] as String,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Balance: ${formatter.format(customer['balance'])}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppTheme.textSecondary,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedCustomerId = value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a customer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 150.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingXL),

                  _NeonPanel(
                    accentColor: AppTheme.successGreen,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixIcon: Icon(Icons.attach_money),
                            prefixText: '\$ ',
                            hintText: '0.00',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid amount';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Amount must be greater than 0';
                            }
                            if (double.parse(value) > _customerBalance) {
                              return 'Amount exceeds customer balance';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        DropdownButtonFormField<PaymentMethod>(
                          value: _selectedPaymentMethod,
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            prefixIcon: Icon(Icons.payment),
                          ),
                          items: PaymentMethod.values.map((method) {
                            return DropdownMenuItem(
                              value: method,
                              child: Text(method.label),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedPaymentMethod = value);
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Date'),
                          subtitle: Text(
                            DateFormat('EEEE, MMMM dd, yyyy')
                                .format(_selectedDate),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        TextFormField(
                          controller: _referenceController,
                          decoration: const InputDecoration(
                            labelText: 'Reference Number (Optional)',
                            prefixIcon: Icon(Icons.tag),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        TextFormField(
                          controller: _remarksController,
                          decoration: const InputDecoration(
                            labelText: 'Remarks (Optional)',
                            prefixIcon: Icon(Icons.note),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 250.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingXL),

                  if (_selectedCustomerId != null && _amount > 0)
                    _NeonPanel(
                      accentColor: AppTheme.infoBlue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance Preview',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          _BalanceRow(
                            label: 'Current Balance',
                            value: _customerBalance,
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          _BalanceRow(
                            label: 'Payment Amount',
                            value: _amount,
                            valueColor: AppTheme.successGreen,
                          ),
                          const Divider(),
                          _BalanceRow(
                            label: 'New Balance',
                            value: _newBalance,
                            isEmphasis: true,
                            valueColor: _newBalance < 0
                                ? AppTheme.errorRed
                                : AppTheme.successGreen,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1)),

                  const SizedBox(height: AppTheme.spacingXL),

                  GradientButton(
                    label: 'Record Payment',
                    icon: Icons.check,
                    onPressed: _handleSave,
                    width: double.infinity,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 450.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                        duration: 300.ms,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment recorded successfully'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}

class _NeonBackdrop extends StatelessWidget {
  const _NeonBackdrop({required this.accentColor});

  final Color accentColor;

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
              color: accentColor.withOpacity(0.18),
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
    required this.accentColor,
    required this.pillLabel,
    required this.pillValue,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String pillLabel;
  final String pillValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: accentColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.18),
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
                colors: [accentColor, accentColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.35),
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
          _NeonPill(
            label: pillLabel,
            value: pillValue,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

class _NeonPill extends StatelessWidget {
  const _NeonPill({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accentColor.withOpacity(0.4)),
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
                  color: accentColor,
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
    required this.accentColor,
  });

  final Widget child;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: accentColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
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

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
    this.valueColor,
  });

  final String label;
  final double value;
  final bool isEmphasis;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final labelStyle = isEmphasis
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            )
        : Theme.of(context).textTheme.bodyMedium;

    final valueStyle = (isEmphasis
            ? Theme.of(context).textTheme.titleLarge
            : Theme.of(context).textTheme.bodyLarge)
        ?.copyWith(
      fontWeight: FontWeight.bold,
      color: valueColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        AnimatedCount(
          value: value,
          useCurrency: true,
          style: valueStyle,
        ),
      ],
    );
  }
}
