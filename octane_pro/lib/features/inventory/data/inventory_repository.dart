import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/constants/enums.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class TankModel {
  final String id;
  final String tankId;
  final String fuelTypeId;
  final double capacity;
  final double currentStock;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  TankModel({
    required this.id,
    required this.tankId,
    required this.fuelTypeId,
    required this.capacity,
    this.currentStock = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tankId': tankId,
        'fuelTypeId': fuelTypeId,
        'capacity': capacity,
        'currentStock': currentStock,
        'isActive': isActive ? 1 : 0,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'createdBy': createdBy,
      };

  factory TankModel.fromJson(Map<String, dynamic> json) => TankModel(
        id: json['id'] as String,
        tankId: json['tankId'] as String,
        fuelTypeId: json['fuelTypeId'] as String,
        capacity: (json['capacity'] as num).toDouble(),
        currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0,
        isActive: (json['isActive'] as int) == 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        createdBy: json['createdBy'] as String?,
      );
}

class DipChartModel {
  final String id;
  final String tankId;
  final int version;
  final Map<double, double> chartData; // dip_value -> liters
  final DateTime createdAt;
  final String createdBy;

  DipChartModel({
    required this.id,
    required this.tankId,
    required this.version,
    required this.chartData,
    required this.createdAt,
    required this.createdBy,
  });

  /// Convert dip value to liters using chart
  double? dipToLiters(double dipValue) {
    if (chartData.isEmpty) return null;

    // Exact match
    if (chartData.containsKey(dipValue)) {
      return chartData[dipValue];
    }

    // Interpolate between nearest values
    final sortedKeys = chartData.keys.toList()..sort();

    if (dipValue < sortedKeys.first) {
      return chartData[sortedKeys.first];
    }
    if (dipValue > sortedKeys.last) {
      return chartData[sortedKeys.last];
    }

    // Find surrounding values
    for (int i = 0; i < sortedKeys.length - 1; i++) {
      if (dipValue >= sortedKeys[i] && dipValue <= sortedKeys[i + 1]) {
        final lowerDip = sortedKeys[i];
        final upperDip = sortedKeys[i + 1];
        final lowerLiters = chartData[lowerDip]!;
        final upperLiters = chartData[upperDip]!;

        // Linear interpolation
        final ratio = (dipValue - lowerDip) / (upperDip - lowerDip);
        return lowerLiters + (upperLiters - lowerLiters) * ratio;
      }
    }

    return null;
  }
}

class DipEntryModel {
  final String id;
  final String tankId;
  final DipEntryType entryType;
  final double dipValue;
  final double liters;
  final DateTime entryDate;
  final String entryTime;
  final double? deliveryInvoiceQty;
  final double? systemStock;
  final double? physicalStock;
  final double? variance;
  final String? remarks;
  final String recordedBy;
  final DateTime createdAt;

  DipEntryModel({
    required this.id,
    required this.tankId,
    required this.entryType,
    required this.dipValue,
    required this.liters,
    required this.entryDate,
    required this.entryTime,
    this.deliveryInvoiceQty,
    this.systemStock,
    this.physicalStock,
    this.variance,
    this.remarks,
    required this.recordedBy,
    required this.createdAt,
  });
}

class InventoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<bool> createTank({
    required String tankId,
    required String fuelTypeId,
    required double capacity,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await db.insert('tanks', {
        'id': id,
        'tank_id': tankId,
        'fuel_type_id': fuelTypeId,
        'capacity': capacity,
        'current_stock': 0,
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

  Future<List<TankModel>> getAllTanks() async {
    final db = await _dbHelper.database;
    final result =
        await db.query('tanks', where: 'is_active = 1', orderBy: 'tank_id ASC');
    return result.map((json) => TankModel.fromJson(json)).toList();
  }

  Future<bool> saveDipChart({
    required String tankId,
    required Map<double, double> chartData,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Get current version
      final existing = await db.query(
        'dip_charts',
        where: 'tank_id = ?',
        whereArgs: [tankId],
        orderBy: 'version DESC',
        limit: 1,
      );

      final version =
          existing.isEmpty ? 1 : (existing.first['version'] as int) + 1;
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await db.insert('dip_charts', {
        'id': id,
        'tank_id': tankId,
        'version': version,
        'chart_data': jsonEncode(chartData),
        'created_at': now,
        'created_by': createdBy,
        'sync_status': 'synced',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DipChartModel?> getLatestDipChart(String tankId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'dip_charts',
      where: 'tank_id = ?',
      whereArgs: [tankId],
      orderBy: 'version DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    final data = result.first;
    final chartDataJson =
        jsonDecode(data['chart_data'] as String) as Map<String, dynamic>;
    final chartData = chartDataJson
        .map((k, v) => MapEntry(double.parse(k), (v as num).toDouble()));

    return DipChartModel(
      id: data['id'] as String,
      tankId: data['tank_id'] as String,
      version: data['version'] as int,
      chartData: chartData,
      createdAt: DateTime.parse(data['created_at'] as String),
      createdBy: data['created_by'] as String,
    );
  }

  Future<bool> recordDipEntry({
    required String tankId,
    required DipEntryType entryType,
    required double dipValue,
    required DateTime entryDate,
    required String recordedBy,
    double? deliveryInvoiceQty,
    String? remarks,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Get dip chart to convert dip to liters
      final dipChart = await getLatestDipChart(tankId);
      if (dipChart == null) {
        throw Exception('No dip chart found for tank');
      }

      final liters = dipChart.dipToLiters(dipValue);
      if (liters == null) {
        throw Exception('Could not convert dip value to liters');
      }

      // Get current system stock
      final tank = await db.query('tanks',
          where: 'id = ?', whereArgs: [tankId], limit: 1);
      if (tank.isEmpty) throw Exception('Tank not found');

      final systemStock = (tank.first['current_stock'] as num).toDouble();
      final physicalStock = liters;
      final variance = physicalStock - systemStock;

      final id = _uuid.v4();
      final now = DateTime.now();

      await db.insert('dip_entries', {
        'id': id,
        'tank_id': tankId,
        'entry_type': entryType.name,
        'dip_value': dipValue,
        'liters': liters,
        'entry_date': entryDate.toIso8601String().split('T')[0],
        'entry_time': now.toIso8601String(),
        'delivery_invoice_qty': deliveryInvoiceQty,
        'system_stock': systemStock,
        'physical_stock': physicalStock,
        'variance': variance,
        'remarks': remarks,
        'recorded_by': recordedBy,
        'created_at': now.toIso8601String(),
        'sync_status': 'synced',
      });

      // Update tank current stock
      await db.update(
        'tanks',
        {
          'current_stock': physicalStock,
          'updated_at': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [tankId],
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getDipEntries({
    String? tankId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = '1=1';
    List<dynamic> whereArgs = [];

    if (tankId != null) {
      where += ' AND tank_id = ?';
      whereArgs.add(tankId);
    }
    if (startDate != null) {
      where += ' AND entry_date >= ?';
      whereArgs.add(startDate.toIso8601String().split('T')[0]);
    }
    if (endDate != null) {
      where += ' AND entry_date <= ?';
      whereArgs.add(endDate.toIso8601String().split('T')[0]);
    }

    return await db.query(
      'dip_entries',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'entry_date DESC, entry_time DESC',
    );
  }
}
