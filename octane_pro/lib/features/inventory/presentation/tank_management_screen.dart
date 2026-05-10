import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';
import 'tank_stock_screen.dart';
import 'dip_entry_screen.dart';

class TankManagementScreen extends ConsumerWidget {
  const TankManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tanks = MockData.getTankInventory();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Tank Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTankDialog(context),
          ),
        ],
      ),
      body: tanks.isEmpty
          ? EmptyState(
              icon: Icons.water_drop_outlined,
              title: 'No tanks configured',
              message: 'Add your first tank to get started',
              actionLabel: 'Add Tank',
              onAction: () => _showAddTankDialog(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: tanks.length,
              itemBuilder: (context, index) {
                final tank = tanks[index];
                return _buildTankCard(context, tank, index);
              },
            ),
      floatingActionButton: GlowingButton(
        label: 'Add Tank',
        icon: Icons.add,
        onPressed: () => _showAddTankDialog(context),
        showGlow: true,
      ),
    );
  }

  Widget _buildTankCard(
      BuildContext context, Map<String, dynamic> tank, int index) {
    final percentage = tank['percentage'] as double;
    final currentStock = tank['currentStock'] as double;

    Color statusColor;
    if (percentage < 30) {
      statusColor = AppTheme.errorRed;
    } else if (percentage < 50) {
      statusColor = AppTheme.warningYellow;
    } else {
      statusColor = AppTheme.successGreen;
    }

    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      showGlow: true,
      glowColor: statusColor,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TankStockScreen(tankId: tank['tankId'] as String),
          ),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
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
                          AppTheme.infoBlue.withOpacity(0.3),
                          AppTheme.infoBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(
                        color: AppTheme.infoBlue.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.infoBlue.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      tank['tankId'] as String,
                      style: const TextStyle(
                        color: AppTheme.infoBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tank['fuelType'] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Capacity: ${tank['capacity']} L',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 13,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundDarkElevated,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 10,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Stock',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  AnimatedCount(
                    value: currentStock,
                    suffix: ' L',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Row(
                children: [
                  Expanded(
                    child: GlowingButton(
                      label: 'Record Dip',
                      icon: Icons.water_drop,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DipEntryScreen()),
                      ),
                      showGlow: false,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: GlowingButton(
                      label: 'View Stock',
                      icon: Icons.inventory,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TankStockScreen(tankId: tank['tankId'] as String),
                        ),
                      ),
                      isSecondary: true,
                      showGlow: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideX(begin: 0.2, end: 0)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  void _showAddTankDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundDarkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          side: BorderSide(color: AppTheme.borderDark, width: 1),
        ),
        title: const Text(
          'Add Tank',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Tank ID/Name',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: AppTheme.backgroundDarkCard,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Fuel Type',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'petrol',
                    child: Text('Petrol',
                        style: TextStyle(color: AppTheme.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'diesel',
                    child: Text('Diesel',
                        style: TextStyle(color: AppTheme.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'highOctane',
                    child: Text('High Octane',
                        style: TextStyle(color: AppTheme.textPrimary)),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Capacity (Liters)',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          GlowingButton(
            label: 'Add',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tank added successfully'),
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
}
