import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../../../core/database/database_helper.dart';
import '../../../core/models/shift_session_model.dart';
import '../../../core/utils/date_formatter.dart';
import 'package:uuid/uuid.dart';

class ShiftRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<bool> createShift({
    required String name,
    required String type,
    required String startTime,
    required String endTime,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await db.insert('shifts', {
        'id': id,
        'name': name,
        'type': type,
        'start_time': startTime,
        'end_time': endTime,
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

  Future<List<Map<String, dynamic>>> getAllShifts() async {
    final db = await _dbHelper.database;
    return await db.query('shifts',
        where: 'is_active = 1', orderBy: 'name ASC');
  }

  Future<ShiftSessionModel?> getActiveShiftSession(String userId) async {
    final db = await _dbHelper.database;
    final today = DateFormatter.formatDate(DateTime.now());

    final result = await db.query(
      'shift_sessions',
      where: 'user_id = ? AND date = ? AND status = ?',
      whereArgs: [userId, today, 'active'],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return _shiftSessionFromMap(result.first);
  }

  Future<bool> startShift({
    required String shiftId,
    required String userId,
    required double openingCash,
    required Map<String, double> openingMeterReadings,
  }) async {
    try {
      final db = await _dbHelper.database;
      final id = _uuid.v4();
      final now = DateTime.now();
      final date = DateFormatter.formatDate(now);

      await db.insert('shift_sessions', {
        'id': id,
        'shift_id': shiftId,
        'user_id': userId,
        'date': date,
        'opening_cash': openingCash,
        'opening_meter_readings': jsonEncode(openingMeterReadings),
        'status': 'active',
        'started_at': now.toIso8601String(),
        'created_at': now.toIso8601String(),
        'sync_status': 'synced',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> endShift({
    required String shiftSessionId,
    required double closingCash,
    required Map<String, double> closingMeterReadings,
    required double totalLiters,
    required double totalAmount,
    required double cashSales,
    required double creditSales,
    required double expenses,
    double? shortExcess,
    String? remarks,
  }) async {
    try {
      final db = await _dbHelper.database;
      final now = DateTime.now();

      await db.update(
        'shift_sessions',
        {
          'closing_cash': closingCash,
          'closing_meter_readings': jsonEncode(closingMeterReadings),
          'total_liters': totalLiters,
          'total_amount': totalAmount,
          'cash_sales': cashSales,
          'credit_sales': creditSales,
          'expenses': expenses,
          'short_excess': shortExcess ?? 0,
          'remarks': remarks,
          'status': 'closed',
          'ended_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [shiftSessionId],
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ShiftSessionModel>> getShiftSessions({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
  }) async {
    final db = await _dbHelper.database;

    String where = '1=1';
    List<dynamic> whereArgs = [];

    if (startDate != null) {
      where += ' AND date >= ?';
      whereArgs.add(DateFormatter.formatDate(startDate));
    }
    if (endDate != null) {
      where += ' AND date <= ?';
      whereArgs.add(DateFormatter.formatDate(endDate));
    }
    if (userId != null) {
      where += ' AND user_id = ?';
      whereArgs.add(userId);
    }

    final result = await db.query(
      'shift_sessions',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date DESC, started_at DESC',
    );

    return result.map((map) => _shiftSessionFromMap(map)).toList();
  }

  ShiftSessionModel _shiftSessionFromMap(Map<String, dynamic> map) {
    Map<String, double>? parseMeterReadings(String? jsonStr) {
      if (jsonStr == null || jsonStr.isEmpty) return null;
      try {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
      } catch (e) {
        return null;
      }
    }

    return ShiftSessionModel(
      id: map['id'] as String,
      shiftId: map['shift_id'] as String,
      userId: map['user_id'] as String,
      date: DateFormatter.parseDate(map['date'] as String) ?? DateTime.now(),
      openingCash: (map['opening_cash'] as num?)?.toDouble() ?? 0,
      closingCash: (map['closing_cash'] as num?)?.toDouble(),
      openingMeterReadings:
          parseMeterReadings(map['opening_meter_readings'] as String?),
      closingMeterReadings:
          parseMeterReadings(map['closing_meter_readings'] as String?),
      totalLiters: (map['total_liters'] as num?)?.toDouble(),
      totalAmount: (map['total_amount'] as num?)?.toDouble(),
      cashSales: (map['cash_sales'] as num?)?.toDouble() ?? 0,
      creditSales: (map['credit_sales'] as num?)?.toDouble() ?? 0,
      expenses: (map['expenses'] as num?)?.toDouble() ?? 0,
      shortExcess: (map['short_excess'] as num?)?.toDouble() ?? 0,
      remarks: map['remarks'] as String?,
      status: map['status'] as String,
      startedAt: DateTime.parse(map['started_at'] as String),
      endedAt: map['ended_at'] != null
          ? DateTime.parse(map['ended_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
