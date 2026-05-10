import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_count.dart';

class LedgerEntryScreen extends ConsumerStatefulWidget {
  const LedgerEntryScreen({super.key});

  @override
  ConsumerState<LedgerEntryScreen> createState() => _LedgerEntryScreenState();
}

class _LedgerEntryScreenState extends ConsumerState<LedgerEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _debitAccount;
  String? _creditAccount;
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _accounts = [
    'Cash Account',
    'Bank Account',
    'Fuel Sales',
    'Expenses',
    'Debtors Control',
    'Creditors Control',
    'Fuel Inventory',
    'Stock Adjustment',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text) ?? 0.0;
  bool get _isBalanced => _debitAccount != null && _creditAccount != null && _amount > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryRed, AppTheme.primaryRedLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryRed.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit_note,
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
                                'Manual Journal Entry',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Double-entry accounting',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
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

              // Date Picker
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate)),
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
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 100.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingL),

              // Debit Account
              Text(
                'Debit Account',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              DropdownButtonFormField<String>(
                value: _debitAccount,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
                  prefixIcon: Icon(Icons.arrow_downward, color: AppTheme.errorRed),
                ),
                items: _accounts.map((account) {
                  return DropdownMenuItem(
                    value: account,
                    child: Text(account),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _debitAccount = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select debit account';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Credit Account
              Text(
                'Credit Account',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              DropdownButtonFormField<String>(
                value: _creditAccount,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
                  prefixIcon: Icon(Icons.arrow_upward, color: AppTheme.successGreen),
                ),
                items: _accounts.map((account) {
                  return DropdownMenuItem(
                    value: account,
                    child: Text(account),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _creditAccount = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select credit account';
                  }
                  if (value == _debitAccount) {
                    return 'Debit and credit accounts must be different';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Amount
              Text(
                'Amount',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
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
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 700.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Reference
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
                  labelText: 'Reference Number',
                  prefixIcon: Icon(Icons.tag),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 800.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 900.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Balance Indicator
              if (_debitAccount != null && _creditAccount != null && _amount > 0)
                Card(
                  color: _isBalanced ? AppTheme.successGreenLight : AppTheme.errorRedLight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Row(
                      children: [
                        Icon(
                          _isBalanced ? Icons.check_circle : Icons.error,
                          color: _isBalanced ? AppTheme.successGreen : AppTheme.errorRed,
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Text(
                            _isBalanced
                                ? 'Entry is balanced (Debit = Credit)'
                                : 'Entry must be balanced',
                            style: TextStyle(
                              color: _isBalanced ? AppTheme.successGreen : AppTheme.errorRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

              const SizedBox(height: AppTheme.spacingXL),

              // Save Button
              GradientButton(
                label: 'Post Entry',
                icon: Icons.check,
                onPressed: _isBalanced ? _handleSave : null,
                width: double.infinity,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 1000.ms)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal entry posted successfully'),
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
