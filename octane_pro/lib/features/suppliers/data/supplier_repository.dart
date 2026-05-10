import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import 'package:uuid/uuid.dart';

class SupplierModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  SupplierModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
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
        'balance': balance,
        'isActive': isActive ? 1 : 0,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'createdBy': createdBy,
      };

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        isActive: (json['isActive'] as int) == 1,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
        createdBy: json['created_by'] as String?,
      );
}

class SupplierRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<List<SupplierModel>> getAllSuppliers({bool activeOnly = true}) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'suppliers',
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'name ASC',
    );
    return result.map((json) => SupplierModel.fromJson(json)).toList();
  }

  Future<SupplierModel?> getSupplierById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return SupplierModel.fromJson(result.first);
  }

  Future<List<Map<String, dynamic>>> getSupplierLedger(
    String supplierId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;
    
    // Get purchases (from fuel_sales where supplier_id exists or from ledger)
    // For now, we'll get from payments and ledger entries
    final payments = await db.query(
      'payments',
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
      orderBy: 'payment_date DESC',
    );

    // Get ledger entries for supplier
    final ledgerEntries = await db.query(
      'ledger_entries',
      where: 'description LIKE ? AND entry_date >= ?',
      whereArgs: ['%Supplier%', startDate?.toIso8601String().split('T')[0] ?? '2020-01-01'],
      orderBy: 'entry_date DESC',
    );

    // Combine and sort
    final ledger = <Map<String, dynamic>>[];
    
    for (var payment in payments) {
      ledger.add({
        'type': 'payment',
        'date': payment['payment_date'],
        'voucher': payment['id'],
        'description': 'Payment Made',
        'debit': payment['amount'],
        'credit': 0.0,
        'balance': 0.0,
      });
    }

    // Sort by date and calculate running balance
    ledger.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
    
    double balance = 0;
    for (var entry in ledger) {
      balance += (entry['credit'] as num).toDouble() - (entry['debit'] as num).toDouble();
      entry['balance'] = balance;
    }

    return ledger.reversed.toList(); // Most recent first
  }
}
