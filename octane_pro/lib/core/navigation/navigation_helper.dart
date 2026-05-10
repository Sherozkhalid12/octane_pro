import 'package:flutter/material.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/shifts/presentation/start_shift_screen.dart';
import '../../features/shifts/presentation/end_shift_screen.dart';
import '../../features/shifts/presentation/shift_summary_screen.dart';
import '../../features/shifts/presentation/shift_configuration_screen.dart';
import '../../features/entries/presentation/meter_readings_screen.dart';
import '../../features/expenses/presentation/add_expense_screen.dart';
import '../../features/payments/presentation/record_payment_received_screen.dart';
import '../../features/payments/presentation/record_payment_made_screen.dart';
import '../../features/payments/presentation/payment_history_screen.dart';
import '../../features/reports/presentation/daily_report_screen.dart';
import '../../features/reports/presentation/monthly_report_screen.dart';
import '../../features/reports/presentation/analytics_dashboard_screen.dart';
import '../../features/reports/presentation/debtors_aging_report_screen.dart';
import '../../features/reports/presentation/creditors_aging_report_screen.dart';
import '../../features/reports/presentation/cash_flow_summary_screen.dart';
import '../../features/inventory/presentation/tank_management_screen.dart';
import '../../features/inventory/presentation/dip_entry_screen.dart';
import '../../features/inventory/presentation/delivery_dip_screen.dart';
import '../../features/inventory/presentation/tank_stock_screen.dart';
import '../../features/customers/presentation/customers_screen.dart';
import '../../features/customers/presentation/customer_ledger_screen.dart';
import '../../features/suppliers/presentation/suppliers_screen.dart';
import '../../features/suppliers/presentation/supplier_ledger_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/user_management_screen.dart';
import '../../features/settings/presentation/tax_settings_screen.dart';
import '../../features/fuel/presentation/fuel_management_screen.dart';
import '../../features/ledger/presentation/ledger_overview_screen.dart';
import '../../features/ledger/presentation/ledger_entry_screen.dart';
import '../../features/ledger/presentation/ledger_detail_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/expenses/presentation/expenses_screen.dart';
import '../../features/entries/presentation/entries_screen.dart';

class NavigationHelper {
  /// Navigate to a screen by route name
  static Future<T?>? pushNamed<T>(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    final screen = _getScreenForRoute(route, arguments);
    if (screen != null) {
      return Navigator.push<T>(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
    return null;
  }

  /// Navigate and replace current screen
  static void pushReplacementNamed(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    final screen = _getScreenForRoute(route, arguments);
    if (screen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }

  /// Navigate and remove all previous routes
  static void pushAndRemoveUntilNamed(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    final screen = _getScreenForRoute(route, arguments);
    if (screen != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => screen),
        (route) => false,
      );
    }
  }

  /// Get screen widget for route
  static Widget? _getScreenForRoute(String route, Map<String, dynamic>? arguments) {
    switch (route) {
      // Auth
      case '/forgot-password':
        return const ForgotPasswordScreen();

      // Shifts
      case '/shifts/start':
        return const StartShiftScreen();
      case '/shifts/end':
        return const EndShiftScreen();
      case '/shifts/configuration':
        return const ShiftConfigurationScreen();
      case '/shifts/summary':
        if (arguments != null && arguments['id'] != null) {
          return ShiftSummaryScreen(shiftId: arguments['id'] as String);
        }
        return null;

      // Entries
      case '/entries/meter-readings':
        return const MeterReadingsScreen();

      // Expenses
      case '/expenses/add':
        return const AddExpenseScreen();
      case '/expenses':
        return const ExpensesScreen();

      // Payments
      case '/payments/received':
        return const RecordPaymentReceivedScreen();
      case '/payments/made':
        return const RecordPaymentMadeScreen();
      case '/payments/history':
        return const PaymentHistoryScreen();

      // Reports
      case '/reports/daily':
        return const DailyReportScreen();
      case '/reports/monthly':
        return const MonthlyReportScreen();
      case '/reports/analytics':
        return const AnalyticsDashboardScreen();
      case '/reports/debtors-aging':
        return const DebtorsAgingReportScreen();
      case '/reports/creditors-aging':
        return const CreditorsAgingReportScreen();
      case '/reports/cash-flow':
        return const CashFlowSummaryScreen();

      // Inventory
      case '/inventory/tanks':
        return const TankManagementScreen();
      case '/inventory/dip-entry':
        return const DipEntryScreen();
      case '/inventory/delivery-dip':
        return const DeliveryDipScreen();
      case '/inventory/stock':
        if (arguments != null && arguments['tankId'] != null) {
          return TankStockScreen(tankId: arguments['tankId'] as String);
        }
        return null;

      // Customers
      case '/customers':
        return const CustomersScreen();
      case '/customers/ledger':
        if (arguments != null) {
          return CustomerLedgerScreen(
            customerId: arguments['customerId'] as String? ?? '',
            customerName: arguments['customerName'] as String? ?? 'Customer',
          );
        }
        return null;

      // Suppliers
      case '/suppliers':
        return const SuppliersScreen();
      case '/suppliers/ledger':
        if (arguments != null) {
          return SupplierLedgerScreen(
            supplierId: arguments['supplierId'] as String? ?? '',
            supplierName: arguments['supplierName'] as String? ?? 'Supplier',
          );
        }
        return null;

      // Settings
      case '/settings':
        return const SettingsScreen();
      case '/settings/users':
        return const UserManagementScreen();
      case '/settings/tax':
        return const TaxSettingsScreen();

      // Fuel
      case '/fuel':
        return const FuelManagementScreen();

      // Ledger
      case '/ledger':
        return const LedgerOverviewScreen();
      case '/ledger/entry':
        return const LedgerEntryScreen();
      case '/ledger/detail':
        if (arguments != null && arguments['accountName'] != null) {
          return LedgerDetailScreen(
            accountName: arguments['accountName'] as String,
          );
        }
        return null;

      // Dashboard
      case '/dashboard':
        return const DashboardScreen();

      // Entries
      case '/entries':
        return const EntriesScreen();

      default:
        return null;
    }
  }
}
