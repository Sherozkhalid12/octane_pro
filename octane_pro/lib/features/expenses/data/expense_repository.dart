import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/constants/enums.dart';
import 'package:uuid/uuid.dart';

class ExpenseModel {
  final String id;
  final ExpenseCategory category;
  final String? description;
  final double amount;
  final PaymentMethod paymentMethod;
  final DateTime expenseDate;
  final String? shiftSessionId;
  final String? receiptPath;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.id,
    required this.category,
    this.description,
    required this.amount,
    required this.paymentMethod,
    required this.expenseDate,
    this.shiftSessionId,
    this.receiptPath,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category.name,
        'description': description,
        'amount': amount,
        'paymentMethod': paymentMethod.name,
        'expenseDate': expenseDate.toIso8601String(),
        'shiftSessionId': shiftSessionId,
        'receiptPath': receiptPath,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'] as String,
        category: ExpenseCategory.fromString(json['category'] as String),
        description: json['description'] as String?,
        amount: (json['amount'] as num).toDouble(),
        paymentMethod:
            PaymentMethod.fromString(json['paymentMethod'] as String),
        expenseDate: DateTime.parse(json['expenseDate'] as String),
        shiftSessionId: json['shiftSessionId'] as String?,
        receiptPath: json['receiptPath'] as String?,
        createdBy: json['createdBy'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );
}

class ExpenseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<bool> createExpense({
    required ExpenseCategory category,
    String? description,
    required double amount,
    required PaymentMethod paymentMethod,
    required DateTime expenseDate,
    String? shiftSessionId,
    String? receiptPath,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;
      final id = _uuid.v4();
      final now = DateTime.now();

      await db.insert('expenses', {
        'id': id,
        'category': category.name,
        'description': description,
        'amount': amount,
        'payment_method': paymentMethod.name,
        'expense_date': expenseDate.toIso8601String().split('T')[0],
        'shift_session_id': shiftSessionId,
        'receipt_path': receiptPath,
        'created_by': createdBy,
        'created_at': now.toIso8601String(),
        'sync_status': 'synced',
      });

      // Update shift session expenses if linked
      if (shiftSessionId != null) {
        final shift = await db.query(
          'shift_sessions',
          where: 'id = ?',
          whereArgs: [shiftSessionId],
          limit: 1,
        );
        if (shift.isNotEmpty) {
          final currentExpenses =
              (shift.first['expenses'] as num?)?.toDouble() ?? 0;
          await db.update(
            'shift_sessions',
            {'expenses': currentExpenses + amount},
            where: 'id = ?',
            whereArgs: [shiftSessionId],
          );
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpenseCategory? category,
    String? shiftSessionId,
  }) async {
    final db = await _dbHelper.database;

    String where = '1=1';
    List<dynamic> whereArgs = [];

    if (startDate != null) {
      where += ' AND expense_date >= ?';
      whereArgs.add(startDate.toIso8601String().split('T')[0]);
    }
    if (endDate != null) {
      where += ' AND expense_date <= ?';
      whereArgs.add(endDate.toIso8601String().split('T')[0]);
    }
    if (category != null) {
      where += ' AND category = ?';
      whereArgs.add(category.name);
    }
    if (shiftSessionId != null) {
      where += ' AND shift_session_id = ?';
      whereArgs.add(shiftSessionId);
    }

    final result = await db.query(
      'expenses',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'expense_date DESC, created_at DESC',
    );

    return result.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  Future<double> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpenseCategory? category,
  }) async {
    final expenses = await getExpenses(
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
    double total = 0.0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
}
