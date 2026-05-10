import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/constants/enums.dart';
import '../../../shared/widgets/empty_state.dart';

class ShiftConfigurationScreen extends ConsumerStatefulWidget {
  const ShiftConfigurationScreen({super.key});

  @override
  ConsumerState<ShiftConfigurationScreen> createState() =>
      _ShiftConfigurationScreenState();
}

class _ShiftConfigurationScreenState
    extends ConsumerState<ShiftConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    final shifts = MockData.getShifts();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: Stack(
        children: [
          const _NeonBackdrop(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingL,
                    AppTheme.spacingL,
                    AppTheme.spacingL,
                    AppTheme.spacingM,
                  ),
                  child: _HeaderBar(
                    onBack: () => Navigator.pop(context),
                    onAdd: () => _showAddShiftDialog(context),
                    total: shifts.length,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.2, end: 0),
                ),
                Expanded(
                  child: shifts.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(AppTheme.spacingL),
                          child: _NeonPanel(
                            child: EmptyState(
                              icon: Icons.access_time_outlined,
                              title: 'No shifts configured',
                              message: 'Add your first shift to get started',
                              actionLabel: 'Add Shift',
                              onAction: () => _showAddShiftDialog(context),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppTheme.spacingL,
                            AppTheme.spacingM,
                            AppTheme.spacingL,
                            AppTheme.spacingXL,
                          ),
                          itemCount: shifts.length,
                          itemBuilder: (context, index) {
                            final shift = shifts[index];
                            return _buildShiftCard(context, shift, index);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddShiftDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Shift'),
        backgroundColor: AppTheme.primaryRed,
      ),
    );
  }

  Widget _buildShiftCard(
      BuildContext context, Map<String, dynamic> shift, int index) {
    final shiftType = ShiftType.fromString(shift['type'] as String);

    Color typeColor;
    IconData typeIcon;
    switch (shiftType) {
      case ShiftType.morning:
        typeColor = AppTheme.warningYellow;
        typeIcon = Icons.wb_sunny;
        break;
      case ShiftType.evening:
        typeColor = AppTheme.primaryRed;
        typeIcon = Icons.wb_twilight;
        break;
      case ShiftType.night:
        typeColor = AppTheme.infoBlue;
        typeIcon = Icons.nightlight;
        break;
      case ShiftType.custom:
        typeColor = AppTheme.textSecondary;
        typeIcon = Icons.schedule;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: typeColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(0.2),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppTheme.spacingM),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: typeColor.withOpacity(0.35)),
          ),
          child: Icon(typeIcon, color: typeColor, size: 24),
        ),
        title: Text(
          shift['name'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${shift['startTime']} - ${shift['endTime']}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: typeColor),
              ),
              child: Text(
                shiftType.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: shift['isActive'] == true ? 'deactivate' : 'activate',
              child: Row(
                children: [
                  Icon(
                    shift['isActive'] == true ? Icons.block : Icons.check_circle,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(shift['isActive'] == true ? 'Deactivate' : 'Activate'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppTheme.errorRed),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditShiftDialog(context, shift);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, shift);
            }
          },
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideX(begin: 0.2, end: 0);
  }

  void _showAddShiftDialog(BuildContext context) {
    final nameController = TextEditingController();
    ShiftType selectedType = ShiftType.morning;
    TimeOfDay startTime = const TimeOfDay(hour: 6, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 14, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Shift'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Shift Name',
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                DropdownButtonFormField<ShiftType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Shift Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: ShiftType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (time != null) {
                            setDialogState(() => startTime = time);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(startTime.format(context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                          );
                          if (time != null) {
                            setDialogState(() => endTime = time);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(endTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shift added successfully')),
                );
              },
              child: const Text('Add Shift'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditShiftDialog(BuildContext context, Map<String, dynamic> shift) {
    final nameController = TextEditingController(text: shift['name'] as String);
    ShiftType selectedType = ShiftType.fromString(shift['type'] as String);
    final start = shift['startTime'].toString().split(':');
    final end = shift['endTime'].toString().split(':');
    TimeOfDay startTime =
        TimeOfDay(hour: int.parse(start[0]), minute: int.parse(start[1]));
    TimeOfDay endTime =
        TimeOfDay(hour: int.parse(end[0]), minute: int.parse(end[1]));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Shift'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Shift Name',
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                DropdownButtonFormField<ShiftType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Shift Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: ShiftType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (time != null) {
                            setDialogState(() => startTime = time);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(startTime.format(context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                          );
                          if (time != null) {
                            setDialogState(() => endTime = time);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Time',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(endTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shift updated successfully')),
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> shift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shift'),
        content: Text('Are you sure you want to delete ${shift['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shift deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.onBack,
    required this.onAdd,
    required this.total,
  });

  final VoidCallback onBack;
  final VoidCallback onAdd;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                'Shift Configuration',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '$total shifts configured',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        _ActionPill(
          label: 'Add',
          icon: Icons.add_circle_outline,
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppTheme.primaryRed.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryRed.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryRed, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryRed,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeonPanel extends StatelessWidget {
  const _NeonPanel({required this.child});

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
              size: 260,
              color: AppTheme.primaryRed.withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -160,
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
