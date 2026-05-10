import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaxSettingsScreen extends ConsumerStatefulWidget {
  const TaxSettingsScreen({super.key});

  @override
  ConsumerState<TaxSettingsScreen> createState() => _TaxSettingsScreenState();
}

class _TaxSettingsScreenState extends ConsumerState<TaxSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salesTaxController = TextEditingController();
  final _vatController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTaxSettings();
  }

  @override
  void dispose() {
    _salesTaxController.dispose();
    _vatController.dispose();
    super.dispose();
  }

  Future<void> _loadTaxSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _salesTaxController.text =
          (prefs.getDouble('sales_tax_rate') ?? 0.0).toString();
      _vatController.text = (prefs.getDouble('vat_rate') ?? 0.0).toString();
    });
  }

  Future<void> _saveTaxSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(
          'sales_tax_rate', double.parse(_salesTaxController.text));
      await prefs.setDouble('vat_rate', double.parse(_vatController.text));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tax settings saved successfully'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Tax Settings'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassmorphicCard(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryRed,
                                AppTheme.primaryRed.withOpacity(0.8)
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: const Icon(Icons.receipt,
                              color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tax Configuration',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Configure tax rates for sales',
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
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    TextFormField(
                      controller: _salesTaxController,
                      decoration: InputDecoration(
                        labelText: 'Sales Tax Rate (%)',
                        hintText: 'Enter sales tax percentage',
                        prefixIcon: const Icon(Icons.percent),
                        filled: true,
                        fillColor: AppTheme.backgroundWhiteSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sales tax rate';
                        }
                        final rate = double.tryParse(value);
                        if (rate == null || rate < 0 || rate > 100) {
                          return 'Please enter a valid rate between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    TextFormField(
                      controller: _vatController,
                      decoration: InputDecoration(
                        labelText: 'VAT Rate (%)',
                        hintText: 'Enter VAT percentage',
                        prefixIcon: const Icon(Icons.percent),
                        filled: true,
                        fillColor: AppTheme.backgroundWhiteSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter VAT rate';
                        }
                        final rate = double.tryParse(value);
                        if (rate == null || rate < 0 || rate > 100) {
                          return 'Please enter a valid rate between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    GlowingButton(
                      label: 'Save Tax Settings',
                      onPressed: _isLoading ? null : _saveTaxSettings,
                      isLoading: _isLoading,
                      width: double.infinity,
                      showGlow: true,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
