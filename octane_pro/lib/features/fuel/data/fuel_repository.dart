import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/models/fuel_type_model.dart';
import 'package:uuid/uuid.dart';

class FuelRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<List<FuelTypeModel>> getAllFuelTypes() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'fuel_types',
      orderBy: 'name ASC',
    );
    return result.map((json) => FuelTypeModel.fromJson(json)).toList();
  }

  Future<FuelTypeModel?> getFuelTypeById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'fuel_types',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return FuelTypeModel.fromJson(result.first);
  }

  Future<bool> createFuelType({
    required String name,
    required String code,
    required double pricePerLiter,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await db.insert('fuel_types', {
        'id': id,
        'name': name,
        'code': code,
        'price_per_liter': pricePerLiter,
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

  Future<bool> updateFuelType(FuelTypeModel fuelType) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'fuel_types',
        {
          'name': fuelType.name,
          'code': fuelType.code,
          'price_per_liter': fuelType.pricePerLiter,
          'is_active': fuelType.isActive ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [fuelType.id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePrice(String fuelTypeId, double newPrice) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'fuel_types',
        {
          'price_per_liter': newPrice,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [fuelTypeId],
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
