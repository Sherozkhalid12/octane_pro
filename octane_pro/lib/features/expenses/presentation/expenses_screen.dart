import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/constants/enums.dart';
import '../../../shared/widgets/animated_count.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';
import '../../entries/presentation/entries_screen.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final expenses = MockData.getExpenses();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    // Filter expenses
    var filteredExpenses = expenses.where((expense) {
      final matchesCategory = _selectedCategory == 'All' ||
          expense['category'] == _selectedCategory.toLowerCase();
      return matchesCategory;
    }).toList();

    final totalExpenses = filteredExpenses.fold<double>(
      0,
      (sum, expense) => sum + (expense['amount'] as num).toDouble(),
    );

    final categories = [
      'All',
      ...ExpenseCategory.values.map((c) => c.label),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Expenses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EntriesScreen()),
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          GlassmorphicCard(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            margin: const EdgeInsets.all(AppTheme.spacingM),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spacingS),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      selectedColor: AppTheme.primaryRed,
                      checkmarkColor: AppTheme.accentWhite,
                      backgroundColor: AppTheme.backgroundWhiteSoft,
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
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),

          // Total Summary Card
          if (filteredExpenses.isNotEmpty)
            GlassmorphicCard(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              showGlow: true,
              glowColor: AppTheme.errorRed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Expenses',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedCount(
                        value: totalExpenses,
                        useCurrency: true,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: AppTheme.errorRed,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.errorRed.withOpacity(0.3),
                          AppTheme.errorRed.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(
                        color: AppTheme.errorRed.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.trending_down,
                      color: AppTheme.errorRed,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms).scale(
                begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

          // Expenses List
          Expanded(
            child: filteredExpenses.isEmpty
                ? EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No expenses found',
                    message: _selectedCategory != 'All'
                        ? 'Try selecting a different category'
                        : 'Add your first expense to get started',
                    actionLabel: 'Add Expense',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen()),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return _buildExpenseCard(
                          context, expense, formatter, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: GlowingButton(
        label: 'Add Expense',
        icon: Icons.add,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        ),
        showGlow: true,
      ),
    );
  }

  Widget _buildExpenseCard(
    BuildContext context,
    Map<String, dynamic> expense,
    NumberFormat formatter,
    int index,
  ) {
    final category = ExpenseCategory.fromString(expense['category'] as String);
    final amount = (expense['amount'] as num).toDouble();
    final paymentMethod =
        PaymentMethod.fromString(expense['paymentMethod'] as String);

    // Category colors and icons
    final categoryData = {
      ExpenseCategory.salaries: {
        'icon': Icons.people,
        'color': AppTheme.infoBlue
      },
      ExpenseCategory.electricity: {
        'icon': Icons.bolt,
        'color': AppTheme.warningYellow
      },
      ExpenseCategory.generator: {
        'icon': Icons.power,
        'color': AppTheme.errorRed
      },
      ExpenseCategory.maintenance: {
        'icon': Icons.build,
        'color': AppTheme.primaryRed
      },
      ExpenseCategory.commissions: {
        'icon': Icons.percent,
        'color': AppTheme.successGreen
      },
      ExpenseCategory.miscellaneous: {
        'icon': Icons.category,
        'color': AppTheme.textSecondary
      },
    };

    final data = categoryData[category] ??
        {'icon': Icons.category, 'color': AppTheme.textSecondary};
    final icon = data['icon'] as IconData;
    final color = data['color'] as Color;

    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      showGlow: false,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          expense['description'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Text(
                category.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${expense['date']} • ${paymentMethod.label}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
        trailing: AnimatedCount(
          value: amount,
          useCurrency: true,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideX(begin: 0.2, end: 0)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}
