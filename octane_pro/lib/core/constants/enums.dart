/// Fuel types
enum FuelType {
  petrol('Petrol'),
  diesel('Diesel'),
  highOctane('High Octane');

  final String label;
  const FuelType(this.label);

  static FuelType fromString(String value) {
    return FuelType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => FuelType.petrol,
    );
  }
}

/// Payment methods
enum PaymentMethod {
  cash('Cash'),
  credit('Credit'),
  bankTransfer('Bank Transfer'),
  card('Card'),
  mobileMoney('Mobile Money');

  final String label;
  const PaymentMethod(this.label);

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.name == value,
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Transaction types
enum TransactionType {
  debit('Debit'),
  credit('Credit');

  final String label;
  const TransactionType(this.label);
}

/// Expense categories
enum ExpenseCategory {
  salaries('Salaries'),
  electricity('Electricity'),
  generator('Generator'),
  maintenance('Maintenance'),
  commissions('Commissions'),
  miscellaneous('Miscellaneous');

  final String label;
  const ExpenseCategory(this.label);

  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ExpenseCategory.miscellaneous,
    );
  }
}

/// Shift types
enum ShiftType {
  morning('Morning'),
  evening('Evening'),
  night('Night'),
  custom('Custom');

  final String label;
  const ShiftType(this.label);

  static ShiftType fromString(String value) {
    return ShiftType.values.firstWhere(
      (shift) => shift.name == value,
      orElse: () => ShiftType.morning,
    );
  }
}

/// Account types for ledger
enum AccountType {
  asset('Asset'),
  liability('Liability'),
  equity('Equity'),
  revenue('Revenue'),
  expense('Expense');

  final String label;
  const AccountType(this.label);
}

/// Ledger account codes
enum LedgerAccount {
  cash('Cash', AccountType.asset),
  bank('Bank', AccountType.asset),
  fuelSales('Fuel Sales', AccountType.revenue),
  expenses('Expenses', AccountType.expense),
  fuelInventory('Fuel Inventory', AccountType.asset),
  debtorsControl('Debtors Control', AccountType.asset),
  creditorsControl('Creditors Control', AccountType.liability),
  stockAdjustment('Stock Adjustment', AccountType.expense);

  final String name;
  final AccountType type;
  const LedgerAccount(this.name, this.type);
}

/// Dip entry types
enum DipEntryType {
  routine('Routine'),
  preDelivery('Pre-Delivery'),
  postDelivery('Post-Delivery');

  final String label;
  const DipEntryType(this.label);
}

/// Sync status
enum SyncStatus {
  pending('Pending'),
  syncing('Syncing'),
  synced('Synced'),
  failed('Failed');

  final String label;
  const SyncStatus(this.label);
}
