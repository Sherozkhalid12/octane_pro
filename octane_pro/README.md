# OctanePro - Enterprise Fuel Station Management System

**OctanePro** is a comprehensive, production-ready fuel station operations and accounting management system designed to digitize all aspects of fuel station operations including sales, shifts, inventory, expenses, and financial management.

## 🎯 Features

### ✅ Implemented

#### Core Infrastructure
- ✅ **Clean Architecture** - Modular, scalable codebase with separation of concerns
- ✅ **Database Schema** - Complete SQLite schema with all required tables
- ✅ **Design System** - Professional red/black/white theme with modern UI components
- ✅ **State Management** - Riverpod for reactive state management
- ✅ **Navigation** - GoRouter for type-safe navigation
- ✅ **Offline-First** - SQLite database for offline capability

#### Authentication & User Management
- ✅ **Login System** - Secure authentication with password hashing
- ✅ **Role-Based Access Control (RBAC)** - Admin, Manager, Operator, Accountant roles
- ✅ **User Management** - Create, update, activate/deactivate users
- ✅ **Password Management** - Reset password functionality
- ✅ **Session Management** - Persistent login sessions

#### Dashboard
- ✅ **Welcome Section** - Personalized greeting
- ✅ **Quick Stats** - Today's sales and fuel sold
- ✅ **Quick Actions** - Start/End shift, Add expense, Record payment
- ✅ **Today's Summary** - Cash sales, credit sales, expenses, net balance
- ✅ **Bottom Navigation** - Mobile-friendly navigation

#### Fuel Management
- ✅ **Fuel Types** - Petrol, Diesel, High Octane
- ✅ **Price Management** - Update prices per liter
- ✅ **Nozzle Management** - Link nozzles to fuel types
- ✅ **Repository Layer** - Complete CRUD operations

#### Shift Management
- ✅ **Shift Creation** - Morning, Evening, Night, Custom shifts
- ✅ **Start Shift** - Opening cash and meter readings
- ✅ **End Shift** - Closing readings, calculations, short/excess
- ✅ **Shift Sessions** - Track active and closed shifts
- ✅ **Meter Readings** - Opening and closing readings per nozzle

#### Customers (Debtors)
- ✅ **Customer Management** - Create, update customers
- ✅ **Credit Limits** - Set credit limits per customer
- ✅ **Customer Ledger** - Track sales and payments
- ✅ **Balance Tracking** - Running balance calculations
- ✅ **Credit Sales** - Support for credit transactions

#### Expenses Management
- ✅ **Expense Categories** - Salaries, Electricity, Generator, Maintenance, Commissions, Miscellaneous
- ✅ **Expense Entry** - Date, category, amount, payment method
- ✅ **Receipt Attachment** - Support for receipt images
- ✅ **Shift Linking** - Link expenses to shift sessions
- ✅ **Expense Reports** - Filter by date, category

#### General Ledger (Double-Entry Accounting)
- ✅ **Account Setup** - Pre-configured accounts (Cash, Bank, Sales, Expenses, etc.)
- ✅ **Double-Entry Validation** - Ensures debits = credits
- ✅ **Automatic Posting** - System auto-posts transactions
- ✅ **Account Ledger** - View transactions per account
- ✅ **Balance Tracking** - Real-time account balances

#### Inventory & Tank Management
- ✅ **Tank Setup** - Create tanks with capacity
- ✅ **Dip Chart** - Upload and manage dip charts (Excel/manual)
- ✅ **Dip Entries** - Routine, pre-delivery, post-delivery dips
- ✅ **Dip to Liters Conversion** - Automatic conversion using chart
- ✅ **Inventory Reconciliation** - Compare system vs physical stock
- ✅ **Variance Tracking** - Flag and track discrepancies
- ✅ **Version Control** - Dip chart versioning

### 🚧 In Progress / Planned

#### Suppliers (Creditors)
- 🔄 Supplier management
- 🔄 Supplier ledger
- 🔄 Payment tracking

#### Payments & Settlements
- 🔄 Receive payments from customers
- 🔄 Pay suppliers
- 🔄 Auto-update ledgers

#### Reports & Analytics
- 🔄 Daily sales reports
- 🔄 Shift performance
- 🔄 Monthly P&L
- 🔄 Cash flow statements
- 🔄 Debtors/creditors aging
- 🔄 Tank variance reports
- 🔄 PDF/Excel export

#### Settings & Security
- 🔄 Station information
- 🔄 Currency settings
- 🔄 Fuel pricing history
- 🔄 Backup/restore
- 🔄 Audit logs viewer
- 🔄 Edit restrictions

#### Advanced Features
- 🔄 Offline sync with conflict resolution
- 🔄 Multi-station support
- 🔄 Real-time notifications
- 🔄 Advanced analytics dashboard
- 🔄 API integration

## 🏗️ Architecture

### Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants, enums, roles
│   ├── database/        # Database helper and schema
│   ├── models/          # Core data models
│   ├── theme/           # Design system and theming
│   ├── routing/         # Navigation and routing
│   └── utils/           # Utility functions
├── features/
│   ├── auth/            # Authentication module
│   ├── dashboard/       # Dashboard module
│   ├── shifts/          # Shift management
│   ├── fuel/            # Fuel management
│   ├── customers/       # Customer management
│   ├── suppliers/       # Supplier management
│   ├── expenses/        # Expense management
│   ├── payments/        # Payment processing
│   ├── ledger/          # General ledger
│   ├── inventory/       # Tank and inventory
│   ├── reports/         # Reports and analytics
│   └── settings/        # Settings and configuration
└── shared/
    ├── widgets/         # Reusable widgets
    └── services/       # Shared services
```

### Technology Stack

- **Framework**: Flutter 3.10.4+
- **State Management**: Riverpod
- **Database**: SQLite (sqflite)
- **Navigation**: GoRouter
- **UI Animations**: flutter_animate
- **Charts**: fl_chart
- **PDF Export**: pdf, printing
- **Excel Export**: excel
- **Local Storage**: shared_preferences, hive

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code / Android Studio (for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd octane_pro
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (if using freezed/json_serializable)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Initial Setup

1. **First Launch**: The app will create the database automatically
2. **Create Admin User**: You'll need to create an admin user manually in the database or through a setup screen
3. **Configure Fuel Types**: Set up your fuel types (Petrol, Diesel, etc.)
4. **Set Up Tanks**: Create tanks and upload dip charts
5. **Configure Shifts**: Create shift schedules

## 📱 User Roles & Permissions

### Admin (Owner)
- Full system access
- User management
- All financial operations
- System configuration

### Manager
- Operational management
- Dip management
- View reports
- Customer/supplier management

### Operator
- Start/end shifts
- Enter sales
- Record meter readings
- Basic operations

### Accountant
- Financial reports
- Ledger access
- Payment processing
- View-only operational data

## 💾 Database Schema

The app uses SQLite with the following main tables:

- `users` - User accounts and authentication
- `fuel_types` - Fuel type definitions
- `nozzles` - Nozzle configurations
- `shifts` - Shift definitions
- `shift_sessions` - Active and closed shift sessions
- `meter_readings` - Meter reading records
- `customers` - Customer/debtor information
- `suppliers` - Supplier/creditor information
- `fuel_sales` - Fuel sale transactions
- `expenses` - Expense records
- `payments` - Payment transactions
- `ledger_accounts` - Chart of accounts
- `ledger_entries` - Double-entry ledger transactions
- `tanks` - Tank configurations
- `dip_charts` - Dip chart data
- `dip_entries` - Dip reading records
- `audit_logs` - Audit trail

## 🎨 Design System

### Colors
- **Primary**: Red (#DC2626)
- **Secondary**: Black (#000000)
- **Background**: White (#FFFFFF)
- **Success**: Green (#10B981)
- **Error**: Red (#EF4444)
- **Warning**: Yellow (#F59E0B)
- **Info**: Blue (#3B82F6)

### Typography
- **Font Family**: Roboto
- **Sizes**: Display (32/28/24), Headline (22/20/18), Title (16/14/12), Body (16/14/12)

### Spacing
- XS: 4px, S: 8px, M: 16px, L: 24px, XL: 32px, XXL: 48px

## 🔒 Security Features

- Password hashing (SHA-256)
- Role-based access control
- Audit logging
- Data validation
- Secure session management

## 📊 Accounting Principles

The system implements **double-entry accounting**:

- Every transaction has equal debits and credits
- Automatic ledger posting
- Real-time balance updates
- Account type-aware balance calculations
- Transaction audit trail

## 🔄 Offline-First Architecture

- All data stored locally in SQLite
- Works completely offline
- Sync status tracking
- Conflict resolution (planned)
- Background sync (planned)

## 📝 Development Guidelines

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

### State Management
- Use Riverpod for all state
- Separate providers by feature
- Use StateNotifier for complex state

### Database
- Always use transactions for multi-step operations
- Validate data before insertion
- Handle errors gracefully
- Use indexes for performance

## 🐛 Known Issues

- SharedPreferences async initialization needs refinement
- Some UI screens are placeholders
- Reports export not yet implemented
- Offline sync conflict resolution pending

## 🗺️ Roadmap

### Phase 1 (Current)
- ✅ Core infrastructure
- ✅ Authentication
- ✅ Dashboard
- ✅ Basic CRUD operations

### Phase 2 (Next)
- 🔄 Complete all feature modules
- 🔄 Reports and analytics
- 🔄 PDF/Excel export
- 🔄 Settings module

### Phase 3 (Future)
- 🔄 Offline sync
- 🔄 Multi-station support
- 🔄 Advanced analytics
- 🔄 Mobile app optimizations
- 🔄 Web admin panel

## 📄 License

[Specify your license here]

## 👥 Contributors

[Add contributors]

## 📞 Support

For support, email [your-email] or create an issue in the repository.

---

**Built with ❤️ for fuel station management**
