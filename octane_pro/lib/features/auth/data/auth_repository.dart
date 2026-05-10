import '../../../core/database/database_helper.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/password_hasher.dart';
import '../../../core/constants/user_roles.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<UserModel?> login(String username, String password) async {
    final db = await _dbHelper.database;
    final passwordHash = PasswordHasher.hashPassword(password);

    final result = await db.query(
      'users',
      where:
          '(username = ? OR email = ?) AND password_hash = ? AND is_active = 1',
      whereArgs: [username, username, passwordHash],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    final user = UserModel.fromJson(result.first);

    // Update last login
    await db.update(
      'users',
      {'last_login_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [user.id],
    );

    return user;
  }

  Future<UserModel?> getUserById(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  Future<bool> createUser({
    required String username,
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
    required String createdBy,
  }) async {
    try {
      final db = await _dbHelper.database;
      final userId = _uuid.v4();
      final passwordHash = PasswordHasher.hashPassword(password);
      final now = DateTime.now().toIso8601String();

      await db.insert('users', {
        'id': userId,
        'username': username,
        'email': email,
        'password_hash': passwordHash,
        'full_name': fullName,
        'role': role.name,
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

  Future<bool> updateUser(UserModel user) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'users',
        {
          'username': user.username,
          'email': user.email,
          'full_name': user.fullName,
          'role': user.role.name,
          'is_active': user.isActive ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String userId, String newPassword) async {
    try {
      final db = await _dbHelper.database;
      final passwordHash = PasswordHasher.hashPassword(newPassword);
      await db.update(
        'users',
        {
          'password_hash': passwordHash,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', orderBy: 'created_at DESC');
    return result.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<bool> deactivateUser(String userId) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'users',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
