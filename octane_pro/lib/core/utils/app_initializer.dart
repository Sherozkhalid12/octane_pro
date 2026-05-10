import '../database/database_helper.dart';
import '../../features/ledger/data/ledger_repository.dart';
import '../../features/auth/data/auth_repository.dart';
import '../constants/user_roles.dart';
import '../utils/password_hasher.dart';

/// Initialize the application on first launch
class AppInitializer {
  static Future<void> initialize() async {
    // Initialize database
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database; // This will create tables if they don't exist

    // Initialize ledger accounts
    final ledgerRepo = LedgerRepository();
    await ledgerRepo.initializeAccounts();

    // Create default admin user if no users exist
    await _createDefaultAdmin();
  }

  static Future<void> _createDefaultAdmin() async {
    final authRepo = AuthRepository();
    final users = await authRepo.getAllUsers();

    if (users.isEmpty) {
      // Create default admin user
      // Username: admin, Password: admin123
      // IMPORTANT: Change this password in production!
      await authRepo.createUser(
        username: 'admin',
        email: 'admin@octanepro.com',
        password: 'admin123',
        role: UserRole.admin,
        fullName: 'System Administrator',
        createdBy: 'system',
      );
    }
  }
}
