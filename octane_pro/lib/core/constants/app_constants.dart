/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'OctanePro';
  static const String appVersion = '1.0.0';

  // Database
  static const String dbName = 'octane_pro.db';
  static const int dbVersion = 1;

  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';

  // Pagination
  static const int defaultPageSize = 20;

  // Sync
  static const int syncIntervalMinutes = 5;

  // Validation
  static const int minPasswordLength = 6;
  static const double minFuelPrice = 0.01;
  static const double maxFuelPrice = 1000.0;

  // File Limits
  static const int maxFileSizeMB = 10;
  static const int maxImageSizeMB = 5;
}
