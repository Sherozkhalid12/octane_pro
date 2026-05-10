import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/glowing_button.dart';
import 'start_shift_screen.dart';
import 'end_shift_screen.dart';
import 'shift_summary_screen.dart';

class ShiftsScreen extends ConsumerStatefulWidget {
  const ShiftsScreen({super.key});

  @override
  ConsumerState<ShiftsScreen> createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends ConsumerState<ShiftsScreen> {
  @override
  Widget build(BuildContext context) {
    final sessions = MockData.getShiftSessions();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final activeSession =
        sessions.where((s) => s['status'] == 'active').toList();

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
                    totalShifts: sessions.length,
                    onAdd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StartShiftScreen(),
                        ),
                      );
                    },
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.2, end: 0),
                ),
                if (activeSession.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingL,
                    ),
                    child: _ActiveShiftConsole(
                      shiftName: activeSession.first['shiftName'] as String,
                      onEndShift: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EndShiftScreen(),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(duration: 350.ms, delay: 120.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacingL,
                      AppTheme.spacingL,
                      AppTheme.spacingL,
                      AppTheme.spacingXL,
                    ),
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppTheme.spacingM),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isActive = session['status'] == 'active';
                      final totalAmount = session['totalAmount'] as num?;

                      return _ShiftSessionCard(
                        isActive: isActive,
                        title: session['shiftName'] as String,
                        date: session['date'] as String,
                        operatorName: session['operator'] as String,
                        totalAmount: totalAmount,
                        formatter: formatter,
                        onView: isActive
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShiftSummaryScreen(
                                      shiftId: session['id'] as String,
                                    ),
                                  ),
                                );
                              },
                        details: Column(
                          children: [
                            _buildSessionDetailRow(
                              'Opening Cash',
                              formatter.format(session['openingCash']),
                            ),
                            if (!isActive && session['closingCash'] != null)
                              _buildSessionDetailRow(
                                'Closing Cash',
                                formatter.format(session['closingCash']),
                              ),
                            if (!isActive && session['totalLiters'] != null)
                              _buildSessionDetailRow(
                                'Total Liters',
                                '${session['totalLiters']} L',
                              ),
                            if (!isActive && totalAmount != null)
                              _buildSessionDetailRow(
                                'Total Amount',
                                formatter.format(totalAmount),
                              ),
                            _buildSessionDetailRow(
                              'Cash Sales',
                              formatter.format(session['cashSales']),
                            ),
                            _buildSessionDetailRow(
                              'Credit Sales',
                              formatter.format(session['creditSales']),
                            ),
                            _buildSessionDetailRow(
                              'Expenses',
                              formatter.format(session['expenses']),
                            ),
                            if (!isActive && session['shortExcess'] != null)
                              _buildSessionDetailRow(
                                'Short/Excess',
                                formatter.format(session['shortExcess']),
                                color: (session['shortExcess'] as num) < 0
                                    ? AppTheme.errorRed
                                    : AppTheme.successGreen,
                              ),
                            if (!isActive)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: AppTheme.spacingM,
                                ),
                                child: GlowingButton(
                                  label: 'View Full Summary',
                                  icon: Icons.assessment,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ShiftSummaryScreen(
                                          shiftId: session['id'] as String,
                                        ),
                                      ),
                                    );
                                  },
                                  showGlow: false,
                                ),
                              ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 250.ms,
                            delay: (index * 40).ms,
                          )
                          .slideY(begin: 0.08, end: 0);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.totalShifts,
    required this.onAdd,
  });

  final int totalShifts;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shifts',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '$totalShifts sessions tracked',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        _ActionPill(
          label: 'Start Shift',
          icon: Icons.play_circle_fill,
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

class _ActiveShiftConsole extends StatelessWidget {
  const _ActiveShiftConsole({
    required this.shiftName,
    required this.onEndShift,
  });

  final String shiftName;
  final VoidCallback onEndShift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.86),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successGreen.withOpacity(0.2),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.successGreen,
                  AppTheme.successGreen.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.timer, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Shift',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  shiftName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: const [
                    _SignalChip(label: 'Live Sync'),
                    _SignalChip(label: 'Auto Audit'),
                  ],
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onEndShift,
            icon: const Icon(Icons.stop_circle, size: 18),
            label: const Text('End'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.successGreen,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ShiftSessionCard extends StatelessWidget {
  const _ShiftSessionCard({
    required this.isActive,
    required this.title,
    required this.date,
    required this.operatorName,
    required this.totalAmount,
    required this.formatter,
    required this.onView,
    required this.details,
  });

  final bool isActive;
  final String title;
  final String date;
  final String operatorName;
  final num? totalAmount;
  final NumberFormat formatter;
  final VoidCallback? onView;
  final Widget details;

  @override
  Widget build(BuildContext context) {
    final accent = isActive ? AppTheme.successGreen : AppTheme.primaryRed;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: accent.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            _StatusPill(
              label: isActive ? 'ACTIVE' : 'CLOSED',
              color: isActive ? AppTheme.successGreen : AppTheme.textSecondary,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: Theme.of(context).textTheme.bodySmall),
              Text('Operator: $operatorName',
                  style: Theme.of(context).textTheme.bodySmall),
              if (!isActive && totalAmount != null)
                Text(
                  formatter.format(totalAmount),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
        ),
        trailing: onView != null
            ? IconButton(
                icon: Icon(Icons.visibility, color: accent.withOpacity(0.8)),
                onPressed: onView,
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: details,
          ),
        ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              letterSpacing: 0.6,
              fontWeight: FontWeight.bold,
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
