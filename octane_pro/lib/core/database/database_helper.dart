import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('${AppConstants.dbName}');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        full_name TEXT,
        role TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        last_login_at TEXT,
        created_by TEXT,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Fuel types table
    await db.execute('''
      CREATE TABLE fuel_types (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT UNIQUE NOT NULL,
        price_per_liter REAL NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        created_by TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Nozzles table
    await db.execute('''
      CREATE TABLE nozzles (
        id TEXT PRIMARY KEY,
        number TEXT NOT NULL,
        fuel_type_id TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        created_by TEXT,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (fuel_type_id) REFERENCES fuel_types(id)
      )
    ''');

    // Shifts table
    await db.execute('''
      CREATE TABLE shifts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        created_by TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Shift sessions table
    await db.execute('''
      CREATE TABLE shift_sessions (
        id TEXT PRIMARY KEY,
        shift_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        date TEXT NOT NULL,
        opening_cash REAL NOT NULL DEFAULT 0,
        closing_cash REAL,
        opening_meter_readings TEXT,
        closing_meter_readings TEXT,
        total_liters REAL,
        total_amount REAL,
        cash_sales REAL DEFAULT 0,
        credit_sales REAL DEFAULT 0,
        expenses REAL DEFAULT 0,
        short_excess REAL DEFAULT 0,
        remarks TEXT,
        status TEXT NOT NULL,
        started_at TEXT NOT NULL,
        ended_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (shift_id) REFERENCES shifts(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Meter readings table
    await db.execute('''
      CREATE TABLE meter_readings (
        id TEXT PRIMARY KEY,
        shift_session_id TEXT NOT NULL,
        nozzle_id TEXT NOT NULL,
        reading REAL NOT NULL,
        reading_type TEXT NOT NULL,
        recorded_at TEXT NOT NULL,
        recorded_by TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (shift_session_id) REFERENCES shift_sessions(id),
        FOREIGN KEY (nozzle_id) REFERENCES nozzles(id)
      )
    ''');

    // Customers table
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        address TEXT,
        credit_limit REAL DEFAULT 0,
        balance REAL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        created_by TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Suppliers table
    await db.execute('''
      CREATE TABLE suppliers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        address TEXT,
        balance REAL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        created_by TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Fuel sales table
    await db.execute('''
      CREATE TABLE fuel_sales (
        id TEXT PRIMARY KEY,
        shift_session_id TEXT NOT NULL,
        nozzle_id TEXT NOT NULL,
        customer_id TEXT,
        liters REAL NOT NULL,
        price_per_liter REAL NOT NULL,
        amount REAL NOT NULL,
        payment_method TEXT NOT NULL,
        sale_date TEXT NOT NULL,
        sale_time TEXT NOT NULL,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (shift_session_id) REFERENCES shift_sessions(id),
        FOREIGN KEY (nozzle_id) REFERENCES nozzles(id),
        FOREIGN KEY (customer_id) REFERENCES customers(id)
      )
    ''');

    // Expenses table
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        description TEXT,
        amount REAL NOT NULL,
        payment_method TEXT NOT NULL,
        expense_date TEXT NOT NULL,
        shift_session_id TEXT,
        receipt_path TEXT,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (shift_session_id) REFERENCES shift_sessions(id)
      )
    ''');

    // Payments table
    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        customer_id TEXT,
        supplier_id TEXT,
        amount REAL NOT NULL,
        payment_method TEXT NOT NULL,
        payment_date TEXT NOT NULL,
        reference TEXT,
        remarks TEXT,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (customer_id) REFERENCES customers(id),
        FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
      )
    ''');

    // Ledger accounts table
    await db.execute('''
      CREATE TABLE ledger_accounts (
        id TEXT PRIMARY KEY,
        code TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        balance REAL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Ledger entries table (double-entry)
    await db.execute('''
      CREATE TABLE ledger_entries (
        id TEXT PRIMARY KEY,
        transaction_id TEXT NOT NULL,
        transaction_type TEXT NOT NULL,
        account_id TEXT NOT NULL,
        debit REAL DEFAULT 0,
        credit REAL DEFAULT 0,
        description TEXT,
        reference TEXT,
        entry_date TEXT NOT NULL,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (account_id) REFERENCES ledger_accounts(id)
      )
    ''');

    // Tanks table
    await db.execute('''
      CREATE TABLE tanks (
        id TEXT PRIMARY KEY,
        tank_id TEXT UNIQUE NOT NULL,
        fuel_type_id TEXT NOT NULL,
        capacity REAL NOT NULL,
        current_stock REAL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        created_by TEXT,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (fuel_type_id) REFERENCES fuel_types(id)
      )
    ''');

    // Tank nozzles mapping
    await db.execute('''
      CREATE TABLE tank_nozzles (
        tank_id TEXT NOT NULL,
        nozzle_id TEXT NOT NULL,
        PRIMARY KEY (tank_id, nozzle_id),
        FOREIGN KEY (tank_id) REFERENCES tanks(id),
        FOREIGN KEY (nozzle_id) REFERENCES nozzles(id)
      )
    ''');

    // Dip charts table
    await db.execute('''
      CREATE TABLE dip_charts (
        id TEXT PRIMARY KEY,
        tank_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        chart_data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        created_by TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (tank_id) REFERENCES tanks(id)
      )
    ''');

    // Dip entries table
    await db.execute('''
      CREATE TABLE dip_entries (
        id TEXT PRIMARY KEY,
        tank_id TEXT NOT NULL,
        entry_type TEXT NOT NULL,
        dip_value REAL NOT NULL,
        liters REAL NOT NULL,
        entry_date TEXT NOT NULL,
        entry_time TEXT NOT NULL,
        delivery_invoice_qty REAL,
        system_stock REAL,
        physical_stock REAL,
        variance REAL,
        remarks TEXT,
        recorded_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (tank_id) REFERENCES tanks(id)
      )
    ''');

    // Audit logs table
    await db.execute('''
      CREATE TABLE audit_logs (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        action TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id TEXT,
        old_values TEXT,
        new_values TEXT,
        ip_address TEXT,
        user_agent TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Create indexes for performance
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_users_username ON users(username)');
    await db.execute(
        'CREATE INDEX idx_shift_sessions_date ON shift_sessions(date)');
    await db.execute(
        'CREATE INDEX idx_shift_sessions_user ON shift_sessions(user_id)');
    await db
        .execute('CREATE INDEX idx_fuel_sales_date ON fuel_sales(sale_date)');
    await db.execute(
        'CREATE INDEX idx_ledger_entries_date ON ledger_entries(entry_date)');
    await db.execute(
        'CREATE INDEX idx_ledger_entries_account ON ledger_entries(account_id)');
    await db.execute(
        'CREATE INDEX idx_dip_entries_date ON dip_entries(entry_date)');
    await db.execute('CREATE INDEX idx_audit_logs_user ON audit_logs(user_id)');
    await db.execute(
        'CREATE INDEX idx_audit_logs_created ON audit_logs(created_at)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < newVersion) {
      // Add migration logic as needed
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
