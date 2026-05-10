import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import 'package:uuid/uuid.dart';

class CustomerModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final double creditLimit;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  CustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.creditLimit = 0,
    this.balance = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'creditLimit': creditLimit,
        'balance': balance,
        'isActive': isActive ? 1 : 0,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'createdBy': createdBy,
      };

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0,
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        isActive: (json['isActive'] as int) == 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        createdBy: json['createdBy'] as String?,
      );
}

class CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<List<CustomerModel>> getAllCustomers({bool activeOnly = true}) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'customers',
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'name ASC',
    );
    return result.map((json) => CustomerModel.fromJson(json)).toList();
  }

  Future<CustomerModel?> getCustomerById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return CustomerModel.fromJson(result.first);
  }

  Future<bool> createCustomer({
    required String name,
    String? email,
    String? phone,
    String? address,
    double creditLimit = 0,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await db.insert('customers', {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'credit_limit': creditLimit,
        'balance': 0,
        'is_active': 1,
        'created_at': now,
        'created_by': createdBy,
        'sync_status': 'synced',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCustomer(CustomerModel customer) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'customers',
        {
          'name': customer.name,
          'email': customer.email,
          'phone': customer.phone,
          'address': customer.address,
          'credit_limit': customer.creditLimit,
          'is_active': customer.isActive ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [customer.id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCustomerBalance(String customerId, double amount) async {
    try {
      final db = await _dbHelper.database;
      final customer = await getCustomerById(customerId);
      if (customer == null) return false;

      final newBalance = customer.balance + amount;
      await db.update(
        'customers',
        {
          'balance': newBalance,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [customerId],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getCustomerLedger(
    String customerId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = 'customer_id = ?';
    List<dynamic> whereArgs = [customerId];

    if (startDate != null) {
      where += ' AND sale_date >= ?';
      whereArgs.add(startDate.toIso8601String().split('T')[0]);
    }
    if (endDate != null) {
      where += ' AND sale_date <= ?';
      whereArgs.add(endDate.toIso8601String().split('T')[0]);
    }

    // Get sales
    final sales = await db.query(
      'fuel_sales',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'sale_date DESC, sale_time DESC',
    );

    // Get payments
    final payments = await db.query(
      'payments',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'payment_date DESC',
    );

    // Combine and sort
    final ledger = <Map<String, dynamic>>[];

    for (var sale in sales) {
      ledger.add({
        'type': 'sale',
        'date': sale['sale_date'],
        'description': 'Fuel Sale',
        'debit': sale['amount'],
        'credit': 0.0,
        'balance': 0.0, // Will calculate
      });
    }

    for (var payment in payments) {
      ledger.add({
        'type': 'payment',
        'date': payment['payment_date'],
        'description': 'Payment',
        'debit': 0.0,
        'credit': payment['amount'],
        'balance': 0.0, // Will calculate
      });
    }

    // Sort by date and calculate running balance
    ledger.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));

    double balance = 0;
    for (var entry in ledger) {
      balance += (entry['debit'] as num).toDouble() -
          (entry['credit'] as num).toDouble();
      entry['balance'] = balance;
    }

    return ledger.reversed.toList(); // Most recent first
  }
}
