import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_count.dart';

class DipEntryScreen extends ConsumerStatefulWidget {
  const DipEntryScreen({super.key});

  @override
  ConsumerState<DipEntryScreen> createState() => _DipEntryScreenState();
}

class _DipEntryScreenState extends ConsumerState<DipEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedTankId;
  final _dipDepthController = TextEditingController();
  final _remarksController = TextEditingController();
  double? _calculatedLiters;
  double? _systemStock;
  double? _variance;

  @override
  void dispose() {
    _dipDepthController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _calculateFromDip() {
    final dipDepth = double.tryParse(_dipDepthController.text);
    if (dipDepth != null && _selectedTankId != null) {
      // Mock dip chart conversion (in real app, lookup from dip chart)
      // Example: dip chart lookup table
      final dipChart = {
        100.0: 50000.0, // 100cm = 50000L
        90.0: 45000.0,
        80.0: 40000.0,
        70.0: 35000.0,
        60.0: 30000.0,
        50.0: 25000.0,
        40.0: 20000.0,
        30.0: 15000.0,
        20.0: 10000.0,
        10.0: 5000.0,
      };

      // Find closest match (simplified - in real app use interpolation)
      double? closestLiters;
      double minDiff = double.infinity;
      dipChart.forEach((depth, liters) {
        final diff = (dipDepth - depth).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestLiters = liters;
        }
      });

      setState(() {
        _calculatedLiters = closestLiters;
        _systemStock = 35000.0; // Mock system stock
        _variance = _calculatedLiters != null && _systemStock != null
            ? _calculatedLiters! - _systemStock!
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanks = MockData.getTankInventory();
    final hasVariance = _variance != null && _variance!.abs() > 0.01;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dip Entry'),
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
                    colors: [AppTheme.infoBlue, AppTheme.infoBlue.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.infoBlue.withOpacity(0.3),
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
                            Icons.water_drop,
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
                                'Record Dip Reading',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Physical fuel measurement',
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

              // Date & Time
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    children: [
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
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: const Text('Time'),
                        subtitle: Text(_selectedTime.format(context)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (time != null) {
                              setState(() => _selectedTime = time);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 100.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Tank Selector
              Text(
                'Select Tank',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              DropdownButtonFormField<String>(
                value: _selectedTankId,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
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
                  .fadeIn(duration: 300.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Dip Depth Input
              Text(
                'Dip Depth',
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _dipDepthController,
                decoration: const InputDecoration(
                  labelText: 'Dip Depth (cm)',
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
                  ),
                  prefixIcon: Icon(Icons.straighten),
                  suffixText: 'cm',
                  hintText: '0.00',
                ),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateFromDip(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dip depth';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              // Calculated Results
              if (_calculatedLiters != null) ...[
                Card(
                  color: AppTheme.infoBlueLight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculated Results',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Physical Stock (from dip):',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            AnimatedCount(
                              value: _calculatedLiters!,
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
                              'System Stock (calculated):',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            AnimatedCount(
                              value: _systemStock!,
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
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              ],

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
                label: 'Save Dip Entry',
                icon: Icons.save,
                onPressed: _handleSave,
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
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_calculatedLiters == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter dip depth to calculate liters'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dip entry saved successfully'),
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
