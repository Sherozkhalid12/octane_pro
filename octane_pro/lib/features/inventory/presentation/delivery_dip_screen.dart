import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_count.dart';

class DeliveryDipScreen extends ConsumerStatefulWidget {
  const DeliveryDipScreen({super.key});

  @override
  ConsumerState<DeliveryDipScreen> createState() => _DeliveryDipScreenState();
}

class _DeliveryDipScreenState extends ConsumerState<DeliveryDipScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedTankId;
  String? _selectedSupplierId;
  final _preDipController = TextEditingController();
  final _postDipController = TextEditingController();
  final _invoiceNumberController = TextEditingController();
  final _invoiceQuantityController = TextEditingController();
  final _remarksController = TextEditingController();
  
  double? _receivedQuantity;
  double? _invoiceQuantity;
  double? _variance;

  @override
  void dispose() {
    _preDipController.dispose();
    _postDipController.dispose();
    _invoiceNumberController.dispose();
    _invoiceQuantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _calculateReceived() {
    final preDip = double.tryParse(_preDipController.text);
    final postDip = double.tryParse(_postDipController.text);
    final invoiceQty = double.tryParse(_invoiceQuantityController.text);

    if (preDip != null && postDip != null) {
      // Mock dip chart conversion
      final dipChart = {
        100.0: 50000.0,
        90.0: 45000.0,
        80.0: 40000.0,
        70.0: 35000.0,
        60.0: 30000.0,
      };

      double? preLiters, postLiters;
      dipChart.forEach((depth, liters) {
        if ((preDip - depth).abs() < 5) preLiters = liters;
        if ((postDip - depth).abs() < 5) postLiters = liters;
      });

      setState(() {
        _receivedQuantity = postLiters != null && preLiters != null
            ? postLiters! - preLiters!
            : null;
        _invoiceQuantity = invoiceQty;
        _variance = _receivedQuantity != null && _invoiceQuantity != null
            ? _receivedQuantity! - _invoiceQuantity!
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanks = MockData.getTankInventory();
    final suppliers = MockData.getSuppliers();
    final hasVariance = _variance != null && _variance!.abs() > 0.01;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Dip Entry'),
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
              // Special Mode Banner
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.warningYellowLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  border: Border.all(color: AppTheme.warningYellow, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, color: AppTheme.warningYellow),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Text(
                        'Delivery Mode - Pre & Post Dip Entry',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.warningYellow,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Date
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

              // Tank Selector
              DropdownButtonFormField<String>(
                value: _selectedTankId,
                decoration: const InputDecoration(
                  labelText: 'Select Tank',
                  prefixIcon: Icon(Icons.water_drop),
                ),
                items: tanks.map((tank) {
                  return DropdownMenuItem(
                    value: tank['tankId'] as String,
                    child: Text('${tank['tankId']} - ${tank['fuelType']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedTankId = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a tank';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Pre-Delivery Dip
              Text(
                'Pre-Delivery Dip',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _preDipController,
                decoration: const InputDecoration(
                  labelText: 'Dip Depth Before Delivery (cm)',
                  prefixIcon: Icon(Icons.straighten),
                  suffixText: 'cm',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateReceived(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Delivery Details
              Text(
                'Delivery Details',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              DropdownButtonFormField<String>(
                value: _selectedSupplierId,
                decoration: const InputDecoration(
                  labelText: 'Supplier',
                  prefixIcon: Icon(Icons.business),
                ),
                items: suppliers.map((supplier) {
                  return DropdownMenuItem(
                    value: supplier['id'] as String,
                    child: Text(supplier['name'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedSupplierId = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select supplier';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _invoiceNumberController,
                decoration: const InputDecoration(
                  labelText: 'Invoice Number',
                  prefixIcon: Icon(Icons.receipt),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter invoice number';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 700.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _invoiceQuantityController,
                decoration: const InputDecoration(
                  labelText: 'Invoice Quantity (Liters)',
                  prefixIcon: Icon(Icons.inventory),
                  suffixText: 'L',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateReceived(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter invoice quantity';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 800.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Post-Delivery Dip
              Text(
                'Post-Delivery Dip',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 900.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _postDipController,
                decoration: const InputDecoration(
                  labelText: 'Dip Depth After Delivery (cm)',
                  prefixIcon: Icon(Icons.straighten),
                  suffixText: 'cm',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateReceived(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 1000.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Summary Card
              if (_receivedQuantity != null && _invoiceQuantity != null)
                Card(
                  color: hasVariance ? AppTheme.errorRedLight : AppTheme.successGreenLight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Summary',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Received (Dip-based):',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            AnimatedCount(
                              value: _receivedQuantity!,
                              suffix: ' L',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.infoBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice Quantity:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            AnimatedCount(
                              value: _invoiceQuantity!,
                              suffix: ' L',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variance:',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            AnimatedCount(
                              value: _variance!.abs(),
                              suffix: ' L',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: hasVariance ? AppTheme.errorRed : AppTheme.successGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

              const SizedBox(height: AppTheme.spacingXL),

              // Remarks (if variance)
              if (hasVariance) ...[
                Text(
                  'Remarks *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.errorRed,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                TextFormField(
                  controller: _remarksController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppTheme.backgroundWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
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
                const SizedBox(height: AppTheme.spacingXL),
              ],

              // Save Button
              GradientButton(
                label: 'Save Delivery Dip',
                icon: Icons.save,
                onPressed: _handleSave,
                width: double.infinity,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 1100.ms)
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
      if (_receivedQuantity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter pre and post dip readings'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Delivery dip entry saved successfully'),
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
