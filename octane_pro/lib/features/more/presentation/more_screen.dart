import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/navigation/navigation_helper.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          ListView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            children: [
              _HeroConsole(
                title: 'Control Center',
                subtitle: 'Manage station settings and master data.',
                icon: Icons.more_horiz,
                pillLabel: 'SECTIONS',
                pillValue: '4',
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.1, end: 0),

              const SizedBox(height: AppTheme.spacingXL),

              _NeonSectionCard(
                title: 'Fuel Management',
                icon: Icons.local_gas_station,
                color: AppTheme.primaryRed,
                items: [
                  _NeonMenuItem(
                    title: 'Fuel Types',
                    icon: Icons.category,
                    onTap: () => _showFuelTypes(context),
                  ),
                  _NeonMenuItem(
                    title: 'Nozzles',
                    icon: Icons.settings,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nozzles management')),
                      );
                    },
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 80.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingL),

              _NeonSectionCard(
                title: 'Customers & Suppliers',
                icon: Icons.people,
                color: AppTheme.infoBlue,
                items: [
                  _NeonMenuItem(
                    title: 'Customers',
                    icon: Icons.person,
                    onTap: () =>
                        NavigationHelper.pushNamed(context, '/customers'),
                  ),
                  _NeonMenuItem(
                    title: 'Suppliers',
                    icon: Icons.business,
                    onTap: () =>
                        NavigationHelper.pushNamed(context, '/suppliers'),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 140.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingL),

              _NeonSectionCard(
                title: 'Inventory',
                icon: Icons.inventory,
                color: AppTheme.successGreen,
                items: [
                  _NeonMenuItem(
                    title: 'Tank Management',
                    icon: Icons.storage,
                    onTap: () =>
                        NavigationHelper.pushNamed(context, '/inventory/tanks'),
                  ),
                  _NeonMenuItem(
                    title: 'Record Dip',
                    icon: Icons.water_drop,
                    onTap: () => NavigationHelper.pushNamed(
                        context, '/inventory/dip-entry'),
                  ),
                  _NeonMenuItem(
                    title: 'Delivery Dip',
                    icon: Icons.local_shipping,
                    onTap: () => NavigationHelper.pushNamed(
                        context, '/inventory/delivery-dip'),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppTheme.spacingL),

              _NeonSectionCard(
                title: 'Settings',
                icon: Icons.settings,
                color: AppTheme.textSecondary,
                items: [
                  _NeonMenuItem(
                    title: 'General Settings',
                    icon: Icons.tune,
                    onTap: () =>
                        NavigationHelper.pushNamed(context, '/settings'),
                  ),
                  _NeonMenuItem(
                    title: 'Shift Configuration',
                    icon: Icons.access_time,
                    onTap: () => NavigationHelper.pushNamed(
                        context, '/shifts/configuration'),
                  ),
                  _NeonMenuItem(
                    title: 'Users',
                    icon: Icons.people_outline,
                    onTap: () =>
                        NavigationHelper.pushNamed(context, '/settings/users'),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 260.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
          ),
        ],
      ),
    );
  }

  void _showFuelTypes(BuildContext context) {
    final fuelTypes = MockData.getFuelTypes();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fuel Types',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...fuelTypes.map((fuel) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryRedLighter,
                  child: const Icon(Icons.local_gas_station,
                      color: AppTheme.primaryRed),
                ),
                title: Text(fuel['name'] as String),
                subtitle: Text('Code: ${fuel['code']}'),
                trailing: Text(
                  '\$${fuel['pricePerLiter']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            }),
          ],
        ),
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
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.2),
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
        color: Colors.white.withOpacity(0.9),
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

class _NeonSectionCard extends StatelessWidget {
  const _NeonSectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<_NeonMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => item),
        ],
      ),
    );
  }
}

class _NeonMenuItem extends StatelessWidget {
  const _NeonMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingM,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.primaryRedLighter.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryRed, size: 20),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 14, color: AppTheme.textSecondary),
          ],
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
