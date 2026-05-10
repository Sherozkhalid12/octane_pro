import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/constants/enums.dart';
import '../../../shared/widgets/glowing_button.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedShiftId;
  ExpenseCategory? _selectedCategory;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _remarksController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  File? _receiptImage;
  final ImagePicker _imagePicker = ImagePicker();

  final List<Map<String, dynamic>> _categories = [
    {
      'category': ExpenseCategory.salaries,
      'icon': Icons.people,
      'color': AppTheme.infoBlue
    },
    {
      'category': ExpenseCategory.electricity,
      'icon': Icons.bolt,
      'color': AppTheme.warningYellow
    },
    {
      'category': ExpenseCategory.generator,
      'icon': Icons.power,
      'color': AppTheme.errorRed
    },
    {
      'category': ExpenseCategory.maintenance,
      'icon': Icons.build,
      'color': AppTheme.primaryRed
    },
    {
      'category': ExpenseCategory.commissions,
      'icon': Icons.percent,
      'color': AppTheme.successGreen
    },
    {
      'category': ExpenseCategory.miscellaneous,
      'icon': Icons.category,
      'color': AppTheme.textSecondary
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shifts = MockData.getShifts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    title: 'Record Expense',
                    subtitle: 'Track your expenses',
                    icon: Icons.add_card,
                    pillLabel: 'SHIFT',
                    pillValue: _selectedShiftId == null ? 'NONE' : 'SET',
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.1, end: 0)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),

                  const SizedBox(height: AppTheme.spacingXL),

                  _NeonPanel(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: AppTheme.redGradient,
                              borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: AppTheme.accentWhite,
                              size: 20,
                            ),
                          ),
                          title: const Text('Date'),
                          subtitle: Text(
                            DateFormat('EEEE, MMMM dd, yyyy')
                                .format(_selectedDate),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: AppTheme.primaryRed),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: AppTheme.primaryRed,
                                        onPrimary: AppTheme.accentWhite,
                                        surface: AppTheme.backgroundDarkCard,
                                        onSurface: AppTheme.textPrimary,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
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
                          dropdownColor: AppTheme.backgroundDarkCard,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Shift (Optional)',
                            labelStyle: TextStyle(color: AppTheme.textSecondary),
                            prefixIcon: Icon(Icons.access_time,
                                color: AppTheme.textSecondary),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('None',
                                  style: TextStyle(color: AppTheme.textPrimary)),
                            ),
                            ...shifts.map((shift) {
                              return DropdownMenuItem(
                                value: shift['id'] as String,
                                child: Text(
                                  shift['name'] as String,
                                  style:
                                      const TextStyle(color: AppTheme.textPrimary),
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedShiftId = value);
                          },
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingXL),

                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingM),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: AppTheme.spacingM,
                      mainAxisSpacing: AppTheme.spacingM,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final category = cat['category'] as ExpenseCategory;
                      final isSelected = _selectedCategory == category;
                      final color = cat['color'] as Color;
                      final icon = cat['icon'] as IconData;

                      return _NeonCategoryTile(
                        label: category.label,
                        icon: icon,
                        color: color,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedCategory = category),
                      )
                          .animate()
                          .fadeIn(duration: 200.ms, delay: (300 + index * 50).ms)
                          .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1, 1));
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  _NeonPanel(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixIcon: Icon(Icons.attach_money),
                            prefixText: '\$ ',
                            hintText: '0.00',
                          ),
                          keyboardType: TextInputType.number,
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
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        DropdownButtonFormField<PaymentMethod>(
                          value: _selectedPaymentMethod,
                          dropdownColor: AppTheme.backgroundDarkCard,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            labelStyle: TextStyle(color: AppTheme.textSecondary),
                            prefixIcon:
                                Icon(Icons.payment, color: AppTheme.textSecondary),
                          ),
                          items: PaymentMethod.values.map((method) {
                            return DropdownMenuItem(
                              value: method,
                              child: Text(
                                method.label,
                                style:
                                    const TextStyle(color: AppTheme.textPrimary),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(
                                  () => _selectedPaymentMethod = value);
                            }
                          },
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
                      .fadeIn(duration: 300.ms, delay: 500.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingXL),

                  Text(
                    'Receipt Photo (Optional)',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 600.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppTheme.spacingS),

                  _NeonPanel(
                    child: _receiptImage != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusXL),
                                child: Image.file(
                                  _receiptImage!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.redGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: AppTheme.redGlow,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: AppTheme.accentWhite),
                                    onPressed: () {
                                      setState(() {
                                        _receiptImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: _pickReceiptImage,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusXL),
                            child: SizedBox(
                              height: 140,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.redGradient,
                                      shape: BoxShape.circle,
                                      boxShadow: AppTheme.redGlow,
                                    ),
                                    child: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 32,
                                      color: AppTheme.accentWhite,
                                    ),
                                  ),
                                  const SizedBox(height: AppTheme.spacingS),
                                  Text(
                                    'Tap to add receipt photo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 700.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),

                  const SizedBox(height: AppTheme.spacingXL),

                  GlowingButton(
                    label: 'Save Expense',
                    icon: Icons.save,
                    onPressed: _handleSave,
                    width: double.infinity,
                    showGlow: true,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 800.ms)
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

  Future<void> _pickReceiptImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _receiptImage = File(image.path);
        });
      }
    } catch (e) {
      // If camera is not available, try gallery
      try {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _receiptImage = File(image.path);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error picking image: ${e.toString()}'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        return;
      }

      // In a real app, you would save the receipt image to storage
      // and associate it with the expense record
      if (_receiptImage != null) {
        // TODO: Save image to storage and link to expense
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _receiptImage != null
                ? 'Expense saved successfully with receipt'
                : 'Expense saved successfully',
          ),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          margin: const EdgeInsets.all(AppTheme.spacingM),
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
            top: -140,
            right: -60,
            child: _GlowOrb(
              size: 240,
              color: AppTheme.primaryRed.withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -160,
            left: -50,
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
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.15),
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

class _NeonCategoryTile extends StatelessWidget {
  const _NeonCategoryTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight =
            constraints.maxHeight < 90 || constraints.maxWidth < 90;
        final iconSize = isTight ? 20.0 : 28.0;
        final padding = isTight ? 8.0 : AppTheme.spacingM;
        final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isSelected ? color : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              letterSpacing: 0.3,
              fontSize: isTight ? 9 : 11,
            );

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(AppTheme.radiusXL),
              border: Border.all(
                color: isSelected ? color : AppTheme.primaryRed.withOpacity(0.12),
                width: isSelected ? 1.8 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? color : AppTheme.primaryRed)
                      .withOpacity(isSelected ? 0.3 : 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(isTight ? 6 : 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              color.withOpacity(0.35),
                              color.withOpacity(0.1),
                            ],
                          )
                        : null,
                    color: isSelected ? null : AppTheme.backgroundGrayLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : AppTheme.textSecondary,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: isTight ? 4 : AppTheme.spacingS),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: labelStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
