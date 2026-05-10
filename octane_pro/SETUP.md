# OctanePro Setup Guide

## Quick Start

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run Code Generation** (if needed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Initial Configuration

### Default Admin Account

On first launch, the app automatically creates a default admin user:

- **Username**: `admin`
- **Password**: `admin123`
- **Email**: `admin@octanepro.com`

⚠️ **IMPORTANT**: Change this password immediately in production!

### First Steps After Login

1. **Set Up Fuel Types**
   - Navigate to Fuel Management
   - Add your fuel types (Petrol, Diesel, High Octane, etc.)
   - Set initial prices per liter

2. **Configure Nozzles**
   - Link nozzles to fuel types
   - Activate/deactivate as needed

3. **Create Shifts**
   - Set up shift schedules (Morning, Evening, Night)
   - Define start and end times

4. **Set Up Tanks**
   - Create tanks for each fuel type
   - Upload dip charts (Excel format or manual entry)
   - Link nozzles to tanks

5. **Add Customers** (if using credit sales)
   - Create customer accounts
   - Set credit limits

6. **Add Suppliers** (if purchasing fuel)
   - Create supplier accounts

## Database Initialization

The database is automatically created on first run. The following accounts are pre-configured in the ledger:

- **Cash** (Asset)
- **Bank** (Asset)
- **Fuel Sales** (Revenue)
- **Expenses** (Expense)
- **Fuel Inventory** (Asset)
- **Debtors Control** (Asset)
- **Creditors Control** (Liability)
- **Stock Adjustment** (Expense)

## Troubleshooting

### Package Errors

If you see import errors, run:
```bash
flutter clean
flutter pub get
```

### Database Issues

If the database doesn't initialize:
1. Uninstall the app
2. Reinstall and run again
3. The database will be recreated

### Build Errors

If you encounter build errors:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Next Steps

After initial setup, you can:

1. Start your first shift
2. Record fuel sales
3. Enter expenses
4. Record dip readings
5. Generate reports

## Support

For issues or questions, refer to the main README.md file.
