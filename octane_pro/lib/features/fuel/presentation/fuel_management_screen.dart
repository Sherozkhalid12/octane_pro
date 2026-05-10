import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';

class FuelManagementScreen extends ConsumerStatefulWidget {
  const FuelManagementScreen({super.key});

  @override
  ConsumerState<FuelManagementScreen> createState() => _FuelManagementScreenState();
}

class _FuelManagementScreenState extends ConsumerState<FuelManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final fuelTypes = MockData.getFuelTypes();
    final nozzles = MockData.getNozzles();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Fuel Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFuelTypeDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fuel Types Section
            Text(
              'Fuel Types',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.1, end: 0),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Fuel Types Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: AppTheme.spacingM,
                mainAxisSpacing: AppTheme.spacingM,
              ),
              itemCount: fuelTypes.length,
              itemBuilder: (context, index) {
                final fuel = fuelTypes[index];
                return _buildFuelTypeCard(context, fuel, formatter, index);
              },
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            // Nozzles Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nozzles',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => _showAddNozzleDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Nozzle'),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 200.ms)
                .slideY(begin: -0.1, end: 0),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Nozzles List
            ...nozzles.map((nozzle) {
              final index = nozzles.indexOf(nozzle);
              return _buildNozzleCard(context, nozzle, index)
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (300 + index * 50).ms)
                  .slideX(begin: 0.2, end: 0, duration: 300.ms);
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: GlowingButton(
        label: 'Bulk Price Update',
        icon: Icons.edit,
        onPressed: () => _showBulkPriceUpdateDialog(context),
        showGlow: true,
      ),
    );
  }

  Widget _buildFuelTypeCard(
    BuildContext context,
    Map<String, dynamic> fuel,
    NumberFormat formatter,
    int index,
  ) {
    final isActive = fuel['isActive'] as bool;
    final statusColor = isActive ? AppTheme.successGreen : AppTheme.errorRed;
    
    return GlassmorphicCard(
      showGlow: isActive,
      glowColor: AppTheme.primaryRed,
      child: InkWell(
        onTap: () => _showEditPriceDialog(context, fuel),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppTheme.redGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      boxShadow: AppTheme.redGlow,
                    ),
                    child: const Icon(
                      Icons.local_gas_station,
                      color: AppTheme.accentWhite,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withOpacity(0.3),
                          statusColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: statusColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(0.6),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (isActive ? 'Active' : 'Inactive').toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fuel['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Code: ${fuel['code']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                formatter.format(fuel['pricePerLiter']),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNozzleCard(BuildContext context, Map<String, dynamic> nozzle, int index) {
    final isActive = nozzle['isActive'] as bool;
    
    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      showGlow: isActive,
      glowColor: AppTheme.primaryRed,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.redGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: AppTheme.redGlow,
          ),
          child: Center(
            child: Text(
              nozzle['number'] as String,
              style: const TextStyle(
                color: AppTheme.accentWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          nozzle['number'] as String,
          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          nozzle['fuelType'] as String,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        trailing: Switch(
          value: isActive,
          onChanged: (value) {
            // TODO: Update nozzle status
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${nozzle['number']} ${value ? 'activated' : 'deactivated'}'),
                backgroundColor: value ? AppTheme.successGreen : AppTheme.errorRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                margin: const EdgeInsets.all(AppTheme.spacingM),
              ),
            );
          },
          activeColor: AppTheme.successGreen,
        ),
        onTap: () {
          // TODO: Show nozzle details/edit
        },
      ),
    );
  }

  void _showAddFuelTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          side: BorderSide(color: AppTheme.borderGray, width: 1),
        ),
        title: const Text(
          'Add Fuel Type',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Add fuel type feature coming soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showEditPriceDialog(BuildContext context, Map<String, dynamic> fuel) {
    final priceController = TextEditingController(
      text: (fuel['pricePerLiter'] as num).toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          side: BorderSide(color: AppTheme.borderGray, width: 1),
        ),
        title: Text(
          'Update Price - ${fuel['name']}',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Price per Liter',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                prefixText: '\$',
                prefixStyle: TextStyle(color: AppTheme.textPrimary),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          GlowingButton(
            label: 'Update',
            onPressed: () {
              // TODO: Update price
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Price updated successfully'),
                  backgroundColor: AppTheme.successGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  margin: const EdgeInsets.all(AppTheme.spacingM),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddNozzleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          side: BorderSide(color: AppTheme.borderGray, width: 1),
        ),
        title: const Text(
          'Add Nozzle',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Add nozzle feature coming soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showBulkPriceUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          side: BorderSide(color: AppTheme.borderGray, width: 1),
        ),
        title: const Text(
          'Bulk Price Update',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Bulk price update feature coming soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }
}
