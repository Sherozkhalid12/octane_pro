import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glowing_button.dart';
import 'customer_ledger_screen.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final customers = MockData.getCustomers();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    var filteredCustomers = customers.where((customer) {
      final matchesSearch = (customer['name'] as String)
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == 'All' ||
          (_filterStatus == 'Due' && (customer['balance'] as num) > 0) ||
          (_filterStatus == 'Overdue' &&
              (customer['balance'] as num) >
                  (customer['creditLimit'] as num) * 0.8) ||
          (_filterStatus == 'Clear' && (customer['balance'] as num) == 0);
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCustomerDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  children: [
                    _HeroConsole(
                      title: 'Customer Ledger',
                      subtitle: 'Track balances, credit limits, and activity.',
                      icon: Icons.people_outline,
                      pillLabel: 'TOTAL',
                      pillValue: '${filteredCustomers.length}',
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: -0.1, end: 0),
                    const SizedBox(height: AppTheme.spacingM),
                    _NeonPanel(
                      child: Column(
                        children: [
                          TextField(
                            style: const TextStyle(color: AppTheme.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search customers...',
                              hintStyle:
                                  const TextStyle(color: AppTheme.textTertiary),
                              prefixIcon: const Icon(Icons.search,
                                  color: AppTheme.textSecondary),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: AppTheme.textSecondary),
                                      onPressed: () {
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: AppTheme.backgroundWhiteSoft,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusM),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ['All', 'Due', 'Overdue', 'Clear']
                                  .map((status) {
                                final isSelected = _filterStatus == status;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: AppTheme.spacingS),
                                  child: FilterChip(
                                    label: Text(status),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() => _filterStatus = status);
                                    },
                                    selectedColor: AppTheme.primaryRed,
                                    checkmarkColor: AppTheme.accentWhite,
                                    backgroundColor:
                                        AppTheme.backgroundWhiteSoft,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? AppTheme.accentWhite
                                          : AppTheme.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppTheme.primaryRed
                                          : AppTheme.borderGray,
                                      width: 1,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
              Expanded(
                child: filteredCustomers.isEmpty
                    ? EmptyState(
                        icon: Icons.people_outline,
                        title: 'No customers found',
                        message: _searchQuery.isNotEmpty
                            ? 'Try adjusting your search'
                            : 'Add your first customer to get started',
                        actionLabel: 'Add Customer',
                        onAction: () => _showAddCustomerDialog(context),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = filteredCustomers[index];
                          return _buildCustomerCard(
                              context, customer, formatter, index);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: GlowingButton(
        label: 'Add Customer',
        icon: Icons.add,
        onPressed: () => _showAddCustomerDialog(context),
        showGlow: true,
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    Map<String, dynamic> customer,
    NumberFormat formatter,
    int index,
  ) {
    final balance = (customer['balance'] as num).toDouble();
    final creditLimit = (customer['creditLimit'] as num).toDouble();
    final percentage =
        creditLimit > 0 ? (balance / creditLimit * 100).clamp(0, 100) : 0;
    final isOverdue = percentage > 80;
    final isDue = balance > 0 && percentage <= 80;

    Color statusColor;
    String statusText;
    if (isOverdue) {
      statusColor = AppTheme.errorRed;
      statusText = 'Overdue';
    } else if (isDue) {
      statusColor = AppTheme.warningYellow;
      statusText = 'Due';
    } else {
      statusColor = AppTheme.successGreen;
      statusText = 'Clear';
    }

    return _NeonPanel(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: () => _navigateToCustomerDetail(context, customer),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryRed.withOpacity(0.2),
                          AppTheme.primaryRed.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.primaryRed.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (customer['name'] as String)[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                          customer['name'] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                        ),
                        if (customer['phone'] != null)
                          Text(
                            customer['phone'] as String,
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
                  _StatusPill(label: statusText, color: statusColor),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatter.format(balance),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: balance > 0
                                  ? AppTheme.errorRed
                                  : AppTheme.successGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Credit Limit',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatter.format(creditLimit),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              if (balance > 0) ...[
                const SizedBox(height: AppTheme.spacingS),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percentage.toStringAsFixed(1)}% of credit limit used',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideX(begin: 0.2, end: 0, duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  void _navigateToCustomerDetail(
      BuildContext context, Map<String, dynamic> customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerLedgerScreen(
          customerId: customer['id'] as String,
          customerName: customer['name'] as String,
        ),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          side: BorderSide(color: AppTheme.borderGray, width: 1),
        ),
        title: const Text(
          'Add Customer',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Credit Limit',
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
                  content: const Text('Customer added successfully'),
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
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
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
  const _NeonPill({required this.label, required this.value});

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

class _NeonPanel extends StatelessWidget {
  const _NeonPanel({required this.child, this.margin});

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
      padding: const EdgeInsets.all(AppTheme.spacingM),
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
  const _GlowOrb({required this.size, required this.color});

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
