import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/gradient_button.dart';

class StartShiftScreen extends ConsumerStatefulWidget {
  const StartShiftScreen({super.key});

  @override
  ConsumerState<StartShiftScreen> createState() => _StartShiftScreenState();
}

class _StartShiftScreenState extends ConsumerState<StartShiftScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedShiftId;
  final _openingCashController = TextEditingController();
  final Map<String, TextEditingController> _nozzleReadings = {};
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final nozzles = MockData.getNozzles();
    for (var nozzle in nozzles) {
      _nozzleReadings[nozzle['id'] as String] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _openingCashController.dispose();
    for (var controller in _nozzleReadings.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shifts = MockData.getShifts();
    final nozzles = MockData.getNozzles();

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
                    _ScreenHeader(
                      title: 'Start Shift',
                      subtitle: DateFormat('EEEE, MMMM dd, yyyy')
                          .format(DateTime.now()),
                      icon: Icons.play_arrow,
                      pillLabel: 'SHIFTS',
                      pillValue: shifts.length.toString(),
                      onBack: () => Navigator.pop(context),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: -0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingXL),
                    _SectionHeader(
                      title: 'Select Shift',
                      subtitle: 'Choose the shift schedule to begin',
                      step: '1',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    _NeonSectionCard(
                      child: DropdownButtonFormField<String>(
                        value: _selectedShiftId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                          prefixIcon: const Icon(Icons.access_time),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        selectedItemBuilder: (context) {
                          return shifts.map((shift) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${shift['name']} • ${shift['startTime']} - ${shift['endTime']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList();
                        },
                        items: shifts.map((shift) {
                          return DropdownMenuItem(
                            value: shift['id'] as String,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  shift['name'] as String,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${shift['startTime']} - ${shift['endTime']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              ],
                            ),
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
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingXL),
                    _SectionHeader(
                      title: 'Opening Cash',
                      subtitle: 'Starting cash in the drawer',
                      step: '2',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    _NeonSectionCard(
                      child: TextFormField(
                        controller: _openingCashController,
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
                            return 'Please enter opening cash';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingXL),
                    _SectionHeader(
                      title: 'Opening Meter Readings',
                      subtitle: 'Capture all nozzle totals before start',
                      step: '3',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    _NeonSectionCard(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          initiallyExpanded: _isExpanded,
                          onExpansionChanged: (value) {
                            setState(() => _isExpanded = value);
                          },
                          title: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRed.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppTheme.primaryRed.withOpacity(0.35),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.local_gas_station,
                                  color: AppTheme.primaryRed,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nozzle Readings',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${nozzles.length} nozzles connected',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              _PulseTag(
                                label: _isExpanded ? 'OPEN' : 'LOCKED',
                                color: _isExpanded
                                    ? AppTheme.successGreen
                                    : AppTheme.primaryRed,
                              ),
                            ],
                          ),
                          childrenPadding: const EdgeInsets.only(
                            top: AppTheme.spacingM,
                          ),
                          children: [
                            ...nozzles.map((nozzle) {
                              final id = nozzle['id'] as String;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppTheme.spacingM,
                                ),
                                child: _NozzleInputRow(
                                  nozzleName:
                                      '${nozzle['number']} - ${nozzle['fuelType']}',
                                  controller: _nozzleReadings[id]!,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 600.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingXL),
                    GradientButton(
                      label: 'Start Shift',
                      icon: Icons.play_circle_fill,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Shift started successfully'),
                              backgroundColor: AppTheme.successGreen,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 700.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.pillLabel,
    required this.pillValue,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final IconData icon;
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
        _PillBadge(label: pillLabel, value: pillValue),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.35)),
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
                  color: AppTheme.primaryRed,
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
  const _NeonSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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

class _NozzleInputRow extends StatelessWidget {
  const _NozzleInputRow({
    required this.nozzleName,
    required this.controller,
  });

  final String nozzleName;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            nozzleName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        SizedBox(
          width: 140,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              hintText: '0.00',
              suffixText: 'L',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (double.tryParse(value) == null) {
                return 'Invalid';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class _PulseTag extends StatelessWidget {
  const _PulseTag({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
      ),
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
