import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/constants/enums.dart';
import 'package:uuid/uuid.dart';

class LedgerEntryModel {
  final String id;
  final String transactionId;
  final TransactionType transactionType;
  final String accountId;
  final double debit;
  final double credit;
  final String? description;
  final String? reference;
  final DateTime entryDate;
  final String createdBy;
  final DateTime createdAt;

  LedgerEntryModel({
    required this.id,
    required this.transactionId,
    required this.transactionType,
    required this.accountId,
    required this.debit,
    required this.credit,
    this.description,
    this.reference,
    required this.entryDate,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'transactionId': transactionId,
        'transactionType': transactionType.name,
        'accountId': accountId,
        'debit': debit,
        'credit': credit,
        'description': description,
        'reference': reference,
        'entryDate': entryDate.toIso8601String(),
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
      };
}

class LedgerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  /// Initialize default ledger accounts
  Future<void> initializeAccounts() async {
    final db = await _dbHelper.database;

    // Check if accounts already exist
    final existing = await db.query('ledger_accounts', limit: 1);
    if (existing.isNotEmpty) return;

    final now = DateTime.now().toIso8601String();
    final accounts = [
      {'code': 'CASH', 'name': 'Cash', 'type': AccountType.asset.name},
      {'code': 'BANK', 'name': 'Bank', 'type': AccountType.asset.name},
      {
        'code': 'FUEL_SALES',
        'name': 'Fuel Sales',
        'type': AccountType.revenue.name
      },
      {
        'code': 'EXPENSES',
        'name': 'Expenses',
        'type': AccountType.expense.name
      },
      {
        'code': 'FUEL_INV',
        'name': 'Fuel Inventory',
        'type': AccountType.asset.name
      },
      {
        'code': 'DEBTORS',
        'name': 'Debtors Control',
        'type': AccountType.asset.name
      },
      {
        'code': 'CREDITORS',
        'name': 'Creditors Control',
        'type': AccountType.liability.name
      },
      {
        'code': 'STOCK_ADJ',
        'name': 'Stock Adjustment',
        'type': AccountType.expense.name
      },
    ];

    for (var account in accounts) {
      await db.insert('ledger_accounts', {
        'id': _uuid.v4(),
        'code': account['code'],
        'name': account['name'],
        'type': account['type'],
        'balance': 0,
        'is_active': 1,
        'created_at': now,
        'sync_status': 'synced',
      });
    }
  }

  /// Post a double-entry transaction
  Future<bool> postTransaction({
    required String transactionId,
    required List<Map<String, dynamic>>
        entries, // [{accountId, debit, credit, description}]
    required DateTime entryDate,
    required String createdBy,
    String? reference,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Validate double-entry: total debits must equal total credits
      double totalDebits = 0;
      double totalCredits = 0;

      for (var entry in entries) {
        totalDebits += (entry['debit'] as num).toDouble();
        totalCredits += (entry['credit'] as num).toDouble();
      }

      if ((totalDebits - totalCredits).abs() > 0.01) {
        throw Exception(
            'Double-entry validation failed: Debits ($totalDebits) must equal Credits ($totalCredits)');
      }

      // Insert ledger entries
      for (var entry in entries) {
        final entryId = _uuid.v4();
        await db.insert('ledger_entries', {
          'id': entryId,
          'transaction_id': transactionId,
          'transaction_type': totalDebits > 0
              ? TransactionType.debit.name
              : TransactionType.credit.name,
          'account_id': entry['accountId'],
          'debit': entry['debit'],
          'credit': entry['credit'],
          'description': entry['description'],
          'reference': reference,
          'entry_date': entryDate.toIso8601String().split('T')[0],
          'created_by': createdBy,
          'created_at': DateTime.now().toIso8601String(),
          'sync_status': 'synced',
        });

        // Update account balance
        await _updateAccountBalance(
          entry['accountId'] as String,
          (entry['debit'] as num).toDouble(),
          (entry['credit'] as num).toDouble(),
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateAccountBalance(
      String accountId, double debit, double credit) async {
    final db = await _dbHelper.database;
    final account = await db.query(
      'ledger_accounts',
      where: 'id = ?',
      whereArgs: [accountId],
      limit: 1,
    );

    if (account.isEmpty) return;

    final currentBalance = (account.first['balance'] as num).toDouble();
    final accountType = account.first['type'] as String;

    // Calculate new balance based on account type
    double newBalance;
    if (accountType == AccountType.asset.name ||
        accountType == AccountType.expense.name) {
      // Assets and Expenses: Debit increases, Credit decreases
      newBalance = currentBalance + debit - credit;
    } else {
      // Liabilities, Equity, Revenue: Credit increases, Debit decreases
      newBalance = currentBalance + credit - debit;
    }

    await db.update(
      'ledger_accounts',
      {
        'balance': newBalance,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<List<Map<String, dynamic>>> getAccountLedger(
    String accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = 'account_id = ?';
    List<dynamic> whereArgs = [accountId];

    if (startDate != null) {
      where += ' AND entry_date >= ?';
      whereArgs.add(startDate.toIso8601String().split('T')[0]);
    }
    if (endDate != null) {
      where += ' AND entry_date <= ?';
      whereArgs.add(endDate.toIso8601String().split('T')[0]);
    }

    return await db.query(
      'ledger_entries',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'entry_date DESC, created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    final db = await _dbHelper.database;
    return await db.query('ledger_accounts',
        where: 'is_active = 1', orderBy: 'code ASC');
  }

  Future<Map<String, dynamic>?> getAccountByCode(String code) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'ledger_accounts',
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first;
  }
}
