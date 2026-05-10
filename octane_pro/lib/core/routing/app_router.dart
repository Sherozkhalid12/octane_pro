import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/shifts/presentation/shifts_screen.dart';
import '../../features/expenses/presentation/expenses_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/entries/presentation/entries_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import 'bottom_nav_shell.dart';
import '../../features/fuel/presentation/fuel_management_screen.dart';
import '../../features/customers/presentation/customers_screen.dart';
import '../../features/shifts/presentation/start_shift_screen.dart';
import '../../features/shifts/presentation/end_shift_screen.dart';
import '../../features/shifts/presentation/shift_summary_screen.dart';
import '../../features/entries/presentation/meter_readings_screen.dart';
import '../../features/suppliers/presentation/suppliers_screen.dart';
import '../../features/suppliers/presentation/supplier_ledger_screen.dart';
import '../../features/customers/presentation/customer_ledger_screen.dart';
import '../../features/shifts/presentation/shift_configuration_screen.dart';
import '../../features/ledger/presentation/ledger_overview_screen.dart';
import '../../features/ledger/presentation/ledger_entry_screen.dart';
import '../../features/ledger/presentation/ledger_detail_screen.dart';
import '../../features/expenses/presentation/add_expense_screen.dart';
import '../../features/payments/presentation/payments_screen.dart';
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
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/user_management_screen.dart';
import '../../features/settings/presentation/tax_settings_screen.dart';
import '../../features/auth/domain/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;

      // If authenticated, never show splash or login - go directly to dashboard
      if (isAuthenticated) {
        if (location == '/splash' || location == '/login') {
          return '/dashboard';
        }
        // Allow authenticated users to access other routes
        return null;
      }

      // If not authenticated
      if (!isAuthenticated) {
        // Allow splash and login screens
        if (location == '/splash' || location == '/login') {
          return null;
        }
        // Redirect everything else to login
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavShell(
            child: child,
            state: state,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/shifts',
            builder: (context, state) => const ShiftsScreen(),
          ),
          GoRoute(
            path: '/entries',
            builder: (context, state) => const EntriesScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
          // Sub-routes that should show bottom nav
          GoRoute(
            path: '/expenses',
            builder: (context, state) => const ExpensesScreen(),
          ),
          GoRoute(
            path: '/expenses/add',
            builder: (context, state) => const AddExpenseScreen(),
          ),
          GoRoute(
            path: '/shifts/start',
            builder: (context, state) => const StartShiftScreen(),
          ),
          GoRoute(
            path: '/shifts/end',
            builder: (context, state) => const EndShiftScreen(),
          ),
          GoRoute(
            path: '/shifts/summary/:id',
            builder: (context, state) {
              final shiftId = state.pathParameters['id']!;
              return ShiftSummaryScreen(shiftId: shiftId);
            },
          ),
          GoRoute(
            path: '/shifts/configuration',
            builder: (context, state) => const ShiftConfigurationScreen(),
          ),
          GoRoute(
            path: '/entries/meter-readings',
            builder: (context, state) => const MeterReadingsScreen(),
          ),
          GoRoute(
            path: '/reports/daily',
            builder: (context, state) => const DailyReportScreen(),
          ),
          GoRoute(
            path: '/reports/monthly',
            builder: (context, state) => const MonthlyReportScreen(),
          ),
          GoRoute(
            path: '/reports/analytics',
            builder: (context, state) => const AnalyticsDashboardScreen(),
          ),
          GoRoute(
            path: '/reports/debtors-aging',
            builder: (context, state) => const DebtorsAgingReportScreen(),
          ),
          GoRoute(
            path: '/reports/creditors-aging',
            builder: (context, state) => const CreditorsAgingReportScreen(),
          ),
          GoRoute(
            path: '/reports/cash-flow',
            builder: (context, state) => const CashFlowSummaryScreen(),
          ),
          GoRoute(
            path: '/fuel',
            builder: (context, state) => const FuelManagementScreen(),
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomersScreen(),
          ),
          GoRoute(
            path: '/customers/:customerId/ledger',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final customerId = state.pathParameters['customerId'] ??
                  extra?['customerId'] as String? ??
                  '';
              final customerName =
                  extra?['customerName'] as String? ?? 'Customer';
              return CustomerLedgerScreen(
                customerId: customerId,
                customerName: customerName,
              );
            },
          ),
          // Suppliers Routes
          GoRoute(
            path: '/suppliers',
            builder: (context, state) => const SuppliersScreen(),
          ),
          GoRoute(
            path: '/suppliers/:supplierId/ledger',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final supplierId = state.pathParameters['supplierId'] ??
                  extra?['supplierId'] as String? ??
                  '';
              final supplierName =
                  extra?['supplierName'] as String? ?? 'Supplier';
              return SupplierLedgerScreen(
                supplierId: supplierId,
                supplierName: supplierName,
              );
            },
          ),
          // Inventory Routes
          GoRoute(
            path: '/inventory/tanks',
            builder: (context, state) => const TankManagementScreen(),
          ),
          GoRoute(
            path: '/inventory/dip-entry',
            builder: (context, state) => const DipEntryScreen(),
          ),
          GoRoute(
            path: '/inventory/delivery-dip',
            builder: (context, state) => const DeliveryDipScreen(),
          ),
          GoRoute(
            path: '/inventory/stock/:tankId',
            builder: (context, state) {
              final tankId = state.pathParameters['tankId']!;
              return TankStockScreen(tankId: tankId);
            },
          ),
          // Settings Routes
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/settings/users',
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: '/settings/tax',
            builder: (context, state) => const TaxSettingsScreen(),
          ),
        ],
      ),
      // Routes outside shell (no bottom nav bar)
      // Ledger Routes
      GoRoute(
        path: '/ledger',
        builder: (context, state) => const LedgerOverviewScreen(),
      ),
      GoRoute(
        path: '/ledger/entry',
        builder: (context, state) => const LedgerEntryScreen(),
      ),
      GoRoute(
        path: '/ledger/:accountName',
        builder: (context, state) {
          final accountName = state.pathParameters['accountName']!;
          return LedgerDetailScreen(accountName: accountName);
        },
      ),
      // Payments Routes
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/payments/received',
        builder: (context, state) => const RecordPaymentReceivedScreen(),
      ),
      GoRoute(
        path: '/payments/made',
        builder: (context, state) => const RecordPaymentMadeScreen(),
      ),
      GoRoute(
        path: '/payments/history',
        builder: (context, state) => const PaymentHistoryScreen(),
      ),
    ],
  );
});
