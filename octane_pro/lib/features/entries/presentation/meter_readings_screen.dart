import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_count.dart';

class MeterReadingsScreen extends ConsumerStatefulWidget {
  const MeterReadingsScreen({super.key});

  @override
  ConsumerState<MeterReadingsScreen> createState() => _MeterReadingsScreenState();
}

class _MeterReadingsScreenState extends ConsumerState<MeterReadingsScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedShiftId;
  int _selectedFuelTypeIndex = 0;
  final Map<String, TextEditingController> _closingReadings = {};
  final Map<String, double> _calculatedLiters = {};
  final Map<String, double> _calculatedAmounts = {};

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
    final closingReading = double.tryParse(_closingReadings[nozzle['id']]?.text ?? '') ?? 0;
    final openingReading = 1000.0; // Mock opening reading
    final liters = (closingReading - openingReading).clamp(0.0, double.infinity);
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
    for (var controller in _closingReadings.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shifts = MockData.getShifts();
    final fuelTypes = MockData.getFuelTypes();
    final nozzles = MockData.getNozzles();
    final filteredNozzles = nozzles.where((n) {
      return n['fuelTypeId'] == fuelTypes[_selectedFuelTypeIndex]['id'];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Fuel Entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _handleSave,
          ),
        ],
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroConsole(
                    title: 'Daily Fuel Entry',
                    subtitle: DateFormat('EEEE, MMMM dd, yyyy')
                        .format(_selectedDate),
                    icon: Icons.speed,
                    pillLabel: 'SHIFT',
                    pillValue: _selectedShiftId == null ? 'UNSET' : 'SET',
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingL),

                  // Date & Shift Selector
                  _NeonPanel(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Date'),
                          subtitle: Text(DateFormat('EEEE, MMMM dd, yyyy')
                              .format(_selectedDate)),
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
                        DropdownButtonFormField<String>(
                          value: _selectedShiftId,
                          decoration: const InputDecoration(
                            labelText: 'Select Shift',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          items: shifts.map((shift) {
                            return DropdownMenuItem(
                              value: shift['id'] as String,
                              child: Text(shift['name'] as String),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedShiftId = value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a shift';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingL),

                  // Fuel Type Tabs
                  Text(
                    'Select Fuel Type',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingM),

                  Wrap(
                    spacing: AppTheme.spacingS,
                    runSpacing: AppTheme.spacingS,
                    children: List.generate(fuelTypes.length, (index) {
                      final fuelType = fuelTypes[index];
                      final isSelected = _selectedFuelTypeIndex == index;
                      return _NeonFuelChip(
                        label: fuelType['name'] as String,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedFuelTypeIndex = index),
                      )
                          .animate()
                          .fadeIn(duration: 200.ms, delay: (index * 50).ms)
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                          );
                    }),
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Nozzle Readings
                  Text(
                    'Meter Readings - ${fuelTypes[_selectedFuelTypeIndex]['name']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingM),

                  ...filteredNozzles.map((nozzle) {
                    final index = filteredNozzles.indexOf(nozzle);
                    final nozzleId = nozzle['id'] as String;
                    final liters = _calculatedLiters[nozzleId] ?? 0.0;
                    final amount = _calculatedAmounts[nozzleId] ?? 0.0;
                    final hasVariance = liters < 0;

                    return _NeonPanel(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRedLighter,
                                  borderRadius: BorderRadius.circular(8),
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
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              if (hasVariance)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.warningYellowLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Variance',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.warningYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Opening Reading',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                    Text(
                                      '1000.00 L',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _closingReadings[nozzleId],
                                  decoration: InputDecoration(
                                    labelText: 'Closing Reading',
                                    filled: true,
                                    fillColor: AppTheme.backgroundGray,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppTheme.radiusM),
                                    ),
                                    prefixIcon: const Icon(Icons.speed),
                                    suffixText: 'L',
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppTheme.radiusM),
                                      borderSide: const BorderSide(
                                          color: AppTheme.errorRed),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final reading = double.tryParse(value);
                                    if (reading == null) {
                                      return 'Invalid';
                                    }
                                    if (reading < 1000.0) {
                                      return 'Must be >= opening';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (liters > 0) ...[
                            const SizedBox(height: AppTheme.spacingM),
                            _NeonPanel(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
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
                            ),
                          ],
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                            duration: 300.ms, delay: (300 + index * 50).ms)
                        .slideX(begin: 0.2, end: 0);
                  }).toList(),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Save Button
                  GradientButton(
                    label: 'Save Meter Readings',
                    icon: Icons.save,
                    onPressed: _handleSave,
                    width: double.infinity,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 500.ms)
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
      // Bottom navigation removed - this is a detail screen
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Meter readings saved successfully'),
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
              color: AppTheme.primaryRed.withOpacity(0.18),
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
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.18),
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
              gradient: AppTheme.redGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.redGlow,
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
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.4)),
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
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _NeonFuelChip extends StatelessWidget {
  const _NeonFuelChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                isSelected ? AppTheme.primaryRed : AppTheme.primaryRed.withOpacity(0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryRed.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTheme.primaryRed.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
        ),
      ),
    );
  }
}

class _NeonPanel extends StatelessWidget {
  const _NeonPanel({
    required this.child,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: child,
      ),
    );
  }
}
