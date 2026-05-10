import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import 'meter_readings_screen.dart';
import '../../expenses/presentation/add_expense_screen.dart';
import '../../payments/presentation/record_payment_received_screen.dart';

class EntriesScreen extends ConsumerWidget {
  const EntriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _EntriesHeader()
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: -0.2, end: 0),
                  const SizedBox(height: AppTheme.spacingL),
                  const _CommandConsole()
                      .animate()
                      .fadeIn(duration: 450.ms, delay: 120.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppTheme.spacingL),
                  const _SignalRow()
                      .animate()
                      .fadeIn(duration: 450.ms, delay: 180.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppTheme.spacingXL),
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = constraints.maxWidth;
                      final bool isWide = maxWidth >= 420;
                      final double spacing = AppTheme.spacingM;
                      final double cardWidth = isWide
                          ? (maxWidth - spacing) / 2
                          : maxWidth;
                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: _EntriesActionCard(
                              title: 'Meter Readings',
                              subtitle: 'Capture live pump totals',
                              icon: Icons.speed,
                              accent: AppTheme.primaryRed,
                              meta: const ['Shift Sync', 'Auto Audit'],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MeterReadingsScreen(),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 450.ms, delay: 220.ms)
                                .slideX(begin: 0.2, end: 0),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _EntriesActionCard(
                              title: 'Add Expense',
                              subtitle: 'Log operational costs',
                              icon: Icons.add_card,
                              accent: AppTheme.errorRed,
                              meta: const ['Smart Categories', 'Receipt Scan'],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddExpenseScreen(),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 450.ms, delay: 300.ms)
                                .slideX(begin: 0.2, end: 0),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _EntriesActionCard(
                              title: 'Record Payment',
                              subtitle: 'Capture incoming/outgoing',
                              icon: Icons.payment,
                              accent: AppTheme.successGreen,
                              meta: const ['Auto Reconcile', 'Ledger Sync'],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RecordPaymentReceivedScreen(),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 450.ms, delay: 380.ms)
                                .slideX(begin: 0.2, end: 0),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXL),
                  const _IntelPanel()
                      .animate()
                      .fadeIn(duration: 450.ms, delay: 420.ms)
                      .slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ],
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
            top: -140,
            right: -60,
            child: _GlowOrb(
              size: 260,
              color: AppTheme.primaryRed.withOpacity(0.18),
            ),
          ),
          Positioned(
            top: 220,
            left: -100,
            child: _GlowOrb(
              size: 220,
              color: AppTheme.infoBlue.withOpacity(0.14),
            ),
          ),
          Positioned(
            bottom: -160,
            right: -40,
            child: _GlowOrb(
              size: 260,
              color: AppTheme.successGreen.withOpacity(0.12),
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

class _EntriesHeader extends StatelessWidget {
  const _EntriesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entries',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Operational capture hub',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        _StatusBadge(
          label: 'LIVE',
          color: AppTheme.successGreen,
          icon: Icons.sensors,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}

class _CommandConsole extends StatelessWidget {
  const _CommandConsole();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.96),
            Colors.white.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              gradient: AppTheme.redGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.redGlow,
            ),
            child: const Icon(Icons.flash_on, color: Colors.white, size: 32),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Command Console',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Track, verify, and submit entries with precision workflows.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _ConsoleChip(label: 'Realtime Sync'),
                    _ConsoleChip(label: 'Auto Audit'),
                    _ConsoleChip(label: 'Smart Flags'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsoleChip extends StatelessWidget {
  const _ConsoleChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

class _SignalRow extends StatelessWidget {
  const _SignalRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: AppTheme.spacingS,
      children: const [
        _SignalPill(label: 'SYSTEM', value: 'ACTIVE'),
        _SignalPill(label: 'QUEUE', value: '3'),
        _SignalPill(label: 'MODE', value: 'LIVE'),
        _SignalPill(label: 'AUDIT', value: 'CLEAN'),
      ],
    );
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({
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
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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

class _EntriesActionCard extends StatelessWidget {
  const _EntriesActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.meta,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<String> meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: accent.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withOpacity(0.9),
                          accent.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: accent.withOpacity(0.35)),
                    ),
                    child: Text(
                      'READY',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: meta
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border:
                              Border.all(color: accent.withOpacity(0.25)),
                        ),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntelPanel extends StatelessWidget {
  const _IntelPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.infoBlue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.infoBlue.withOpacity(0.18),
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
              color: AppTheme.infoBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.infoBlue.withOpacity(0.35)),
            ),
            child: Icon(Icons.insights,
                color: AppTheme.infoBlue.withOpacity(0.9), size: 28),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Intel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3 entries pending review. Last sync 2m ago. Keep the flow clean.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 18, color: AppTheme.infoBlue.withOpacity(0.7)),
        ],
      ),
    );
  }
}
