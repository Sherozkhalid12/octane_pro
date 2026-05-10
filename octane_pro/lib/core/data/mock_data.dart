import '../constants/enums.dart';
import '../constants/user_roles.dart';

class MockData {
  // Dashboard Stats
  static Map<String, dynamic> getDashboardStats() {
    return {
      'todaySales': 125450.50,
      'fuelSold': 3250.75,
      'cashSales': 85000.00,
      'creditSales': 40450.50,
      'expenses': 15000.00,
      'netBalance': 110450.50,
      'activeShift': true,
    };
  }

  // Fuel Types
  static List<Map<String, dynamic>> getFuelTypes() {
    return [
      {
        'id': '1',
        'name': 'Petrol',
        'code': 'PET',
        'pricePerLiter': 185.50,
        'isActive': true,
      },
      {
        'id': '2',
        'name': 'Diesel',
        'code': 'DIE',
        'pricePerLiter': 175.00,
        'isActive': true,
      },
      {
        'id': '3',
        'name': 'High Octane',
        'code': 'HO',
        'pricePerLiter': 195.75,
        'isActive': true,
      },
    ];
  }

  // Nozzles
  static List<Map<String, dynamic>> getNozzles() {
    return [
      {
        'id': '1',
        'number': 'N1',
        'fuelTypeId': '1',
        'fuelType': 'Petrol',
        'isActive': true
      },
      {
        'id': '2',
        'number': 'N2',
        'fuelTypeId': '1',
        'fuelType': 'Petrol',
        'isActive': true
      },
      {
        'id': '3',
        'number': 'N3',
        'fuelTypeId': '2',
        'fuelType': 'Diesel',
        'isActive': true
      },
      {
        'id': '4',
        'number': 'N4',
        'fuelTypeId': '2',
        'fuelType': 'Diesel',
        'isActive': true
      },
      {
        'id': '5',
        'number': 'N5',
        'fuelTypeId': '3',
        'fuelType': 'High Octane',
        'isActive': true
      },
    ];
  }

  // Shifts
  static List<Map<String, dynamic>> getShifts() {
    return [
      {
        'id': '1',
        'name': 'Morning Shift',
        'type': ShiftType.morning.name,
        'startTime': '06:00',
        'endTime': '14:00',
        'isActive': true,
      },
      {
        'id': '2',
        'name': 'Evening Shift',
        'type': ShiftType.evening.name,
        'startTime': '14:00',
        'endTime': '22:00',
        'isActive': true,
      },
      {
        'id': '3',
        'name': 'Night Shift',
        'type': ShiftType.night.name,
        'startTime': '22:00',
        'endTime': '06:00',
        'isActive': true,
      },
    ];
  }

  // Shift Sessions
  static List<Map<String, dynamic>> getShiftSessions() {
    return [
      {
        'id': '1',
        'shiftName': 'Morning Shift',
        'date': '2024-01-15',
        'openingCash': 50000.00,
        'closingCash': 125000.00,
        'totalLiters': 3250.75,
        'totalAmount': 125450.50,
        'cashSales': 85000.00,
        'creditSales': 40450.50,
        'expenses': 15000.00,
        'shortExcess': 0.00,
        'status': 'closed',
        'operator': 'John Doe',
      },
      {
        'id': '2',
        'shiftName': 'Evening Shift',
        'date': '2024-01-15',
        'openingCash': 125000.00,
        'closingCash': null,
        'totalLiters': null,
        'totalAmount': null,
        'cashSales': 0.00,
        'creditSales': 0.00,
        'expenses': 0.00,
        'shortExcess': 0.00,
        'status': 'active',
        'operator': 'Jane Smith',
      },
    ];
  }

  // Customers
  static List<Map<String, dynamic>> getCustomers() {
    return [
      {
        'id': '1',
        'name': 'ABC Transport Ltd',
        'email': 'contact@abctransport.com',
        'phone': '+1234567890',
        'creditLimit': 500000.00,
        'balance': 125000.00,
        'isActive': true,
      },
      {
        'id': '2',
        'name': 'XYZ Logistics',
        'email': 'info@xyzlogistics.com',
        'phone': '+1234567891',
        'creditLimit': 300000.00,
        'balance': 75000.00,
        'isActive': true,
      },
      {
        'id': '3',
        'name': 'City Bus Services',
        'email': 'admin@citybus.com',
        'phone': '+1234567892',
        'creditLimit': 1000000.00,
        'balance': 250000.00,
        'isActive': true,
      },
    ];
  }

  // Suppliers
  static List<Map<String, dynamic>> getSuppliers() {
    return [
      {
        'id': '1',
        'name': 'National Fuel Corp',
        'email': 'sales@nationalfuel.com',
        'phone': '+1234567800',
        'balance': -50000.00,
        'isActive': true,
      },
      {
        'id': '2',
        'name': 'Global Petroleum',
        'email': 'orders@globalpetro.com',
        'phone': '+1234567801',
        'balance': -75000.00,
        'isActive': true,
      },
    ];
  }

  // Expenses
  static List<Map<String, dynamic>> getExpenses() {
    return [
      {
        'id': '1',
        'category': ExpenseCategory.salaries.name,
        'description': 'Staff salaries for January',
        'amount': 50000.00,
        'paymentMethod': PaymentMethod.bankTransfer.name,
        'date': '2024-01-15',
      },
      {
        'id': '2',
        'category': ExpenseCategory.electricity.name,
        'description': 'Monthly electricity bill',
        'amount': 15000.00,
        'paymentMethod': PaymentMethod.bankTransfer.name,
        'date': '2024-01-14',
      },
      {
        'id': '3',
        'category': ExpenseCategory.maintenance.name,
        'description': 'Pump maintenance',
        'amount': 25000.00,
        'paymentMethod': PaymentMethod.cash.name,
        'date': '2024-01-13',
      },
    ];
  }

  // Sales by Fuel Type
  static List<Map<String, dynamic>> getSalesByFuelType() {
    return [
      {'fuelType': 'Petrol', 'liters': 1500.50, 'amount': 278325.75},
      {'fuelType': 'Diesel', 'liters': 1200.25, 'amount': 210043.75},
      {'fuelType': 'High Octane', 'liters': 550.00, 'amount': 107662.50},
    ];
  }

  // Recent Transactions
  static List<Map<String, dynamic>> getRecentTransactions() {
    return [
      {
        'id': '1',
        'type': 'sale',
        'description': 'Fuel Sale - Petrol',
        'amount': 18550.00,
        'date': '2024-01-15 10:30',
        'customer': 'ABC Transport Ltd',
      },
      {
        'id': '2',
        'type': 'payment',
        'description': 'Payment Received',
        'amount': 50000.00,
        'date': '2024-01-15 09:15',
        'customer': 'XYZ Logistics',
      },
      {
        'id': '3',
        'type': 'expense',
        'description': 'Electricity Bill',
        'amount': -15000.00,
        'date': '2024-01-14 16:00',
        'customer': null,
      },
    ];
  }

  // Tank Inventory
  static List<Map<String, dynamic>> getTankInventory() {
    return [
      {
        'id': '1',
        'tankId': 'T1',
        'fuelType': 'Petrol',
        'capacity': 50000.00,
        'currentStock': 35000.00,
        'percentage': 70.0,
      },
      {
        'id': '2',
        'tankId': 'T2',
        'fuelType': 'Diesel',
        'capacity': 50000.00,
        'currentStock': 28000.00,
        'percentage': 56.0,
      },
      {
        'id': '3',
        'tankId': 'T3',
        'fuelType': 'High Octane',
        'capacity': 30000.00,
        'currentStock': 15000.00,
        'percentage': 50.0,
      },
    ];
  }

  // Reports Data
  static Map<String, dynamic> getDailyReport(DateTime date) {
    return {
      'date': date.toString().split(' ')[0],
      'totalSales': 125450.50,
      'totalLiters': 3250.75,
      'cashSales': 85000.00,
      'creditSales': 40450.50,
      'expenses': 15000.00,
      'netProfit': 110450.50,
      'transactions': 45,
    };
  }

  // Users
  static List<Map<String, dynamic>> getUsers() {
    return [
      {
        'id': '1',
        'username': 'admin',
        'email': 'admin@octanepro.com',
        'fullName': 'System Administrator',
        'role': UserRole.admin.name,
        'isActive': true,
      },
      {
        'id': '2',
        'username': 'manager1',
        'email': 'manager@octanepro.com',
        'fullName': 'John Manager',
        'role': UserRole.manager.name,
        'isActive': true,
      },
      {
        'id': '3',
        'username': 'operator1',
        'email': 'operator@octanepro.com',
        'fullName': 'Jane Operator',
        'role': UserRole.operator.name,
        'isActive': true,
      },
      {
        'id': '4',
        'username': 'accountant1',
        'email': 'accountant@octanepro.com',
        'fullName': 'Sarah Accountant',
        'role': UserRole.accountant.name,
        'isActive': true,
      },
    ];
  }
}
