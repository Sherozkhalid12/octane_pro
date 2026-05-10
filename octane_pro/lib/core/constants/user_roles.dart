/// User roles and permissions
enum UserRole {
  admin('Admin', 'Full system access'),
  manager('Manager', 'Operational and dip management'),
  operator('Operator', 'Shift and sales entry only'),
  accountant('Accountant', 'Financial reports and ledger');

  final String label;
  final String description;

  const UserRole(this.label, this.description);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.operator,
    );
  }
}

/// Permission definitions
class Permissions {
  // User Management
  static const String createUser = 'create_user';
  static const String editUser = 'edit_user';
  static const String deleteUser = 'delete_user';
  static const String viewUsers = 'view_users';

  // Fuel Management
  static const String manageFuelTypes = 'manage_fuel_types';
  static const String manageNozzles = 'manage_nozzles';
  static const String updatePricing = 'update_pricing';

  // Shift Management
  static const String startShift = 'start_shift';
  static const String endShift = 'end_shift';
  static const String viewShifts = 'view_shifts';

  // Financial
  static const String viewLedger = 'view_ledger';
  static const String postJournal = 'post_journal';
  static const String viewReports = 'view_reports';

  // Inventory
  static const String manageTanks = 'manage_tanks';
  static const String recordDip = 'record_dip';
  static const String reconcileInventory = 'reconcile_inventory';

  // Customers & Suppliers
  static const String manageCustomers = 'manage_customers';
  static const String manageSuppliers = 'manage_suppliers';
  static const String processPayments = 'process_payments';

  // Expenses
  static const String manageExpenses = 'manage_expenses';

  // Settings
  static const String manageSettings = 'manage_settings';

  /// Get permissions for a role
  static List<String> getPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          createUser,
          editUser,
          deleteUser,
          viewUsers,
          manageFuelTypes,
          manageNozzles,
          updatePricing,
          startShift,
          endShift,
          viewShifts,
          viewLedger,
          postJournal,
          viewReports,
          manageTanks,
          recordDip,
          reconcileInventory,
          manageCustomers,
          manageSuppliers,
          processPayments,
          manageExpenses,
          manageSettings,
        ];
      case UserRole.manager:
        return [
          viewUsers,
          viewShifts,
          startShift,
          endShift,
          manageTanks,
          recordDip,
          reconcileInventory,
          viewReports,
          manageCustomers,
          manageSuppliers,
          processPayments,
          manageExpenses,
        ];
      case UserRole.operator:
        return [
          startShift,
          endShift,
          viewShifts,
        ];
      case UserRole.accountant:
        return [
          viewLedger,
          postJournal,
          viewReports,
          viewShifts,
          manageCustomers,
          manageSuppliers,
          processPayments,
        ];
    }
  }

  /// Check if role has permission
  static bool hasPermission(UserRole role, String permission) {
    return getPermissionsForRole(role).contains(permission);
  }
}
