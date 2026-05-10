# Futuristic White/Red Design Pattern Guide

## ✅ Theme Updated
- **Background**: White/Gray (`backgroundWhite`, `backgroundGray`)
- **Primary**: Red (`primaryRed`, `primaryRedLight`, `primaryRedGlow`)
- **Text**: Black on white (`textPrimary` = `#1A1A1A`)
- **Minimal Black**: Only for text and subtle borders

## ✅ Completed Screens
1. ✅ User Management Screen
2. ✅ Add Expense Screen  
3. ✅ Tank Management Screen
4. ✅ Suppliers Screen
5. ✅ Login Screen

## 📋 Pattern for Remaining Screens

### 1. Scaffold Background
```dart
Scaffold(
  backgroundColor: AppTheme.backgroundGray, // NOT backgroundDark
  ...
)
```

### 2. Replace Cards with GlassmorphicCard
```dart
// OLD:
Card(
  child: ...
)

// NEW:
GlassmorphicCard(
  showGlow: true, // Optional - for important cards
  glowColor: AppTheme.primaryRed, // Optional
  child: ...
)
```

### 3. Replace Buttons with GlowingButton
```dart
// OLD:
ElevatedButton(...)
FloatingActionButton(...)

// NEW:
GlowingButton(
  label: 'Button Text',
  icon: Icons.add, // Optional
  onPressed: () {},
  showGlow: true, // For primary actions
)
```

### 4. Update Dialogs
```dart
AlertDialog(
  backgroundColor: AppTheme.backgroundWhite,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppTheme.radiusXL),
    side: BorderSide(color: AppTheme.borderGray, width: 1),
  ),
  title: const Text(
    'Title',
    style: TextStyle(color: AppTheme.textPrimary),
  ),
  ...
)
```

### 5. Update Text Fields
```dart
TextField(
  style: const TextStyle(color: AppTheme.textPrimary),
  decoration: InputDecoration(
    labelText: 'Label',
    labelStyle: const TextStyle(color: AppTheme.textSecondary),
    prefixIcon: const Icon(Icons.icon, color: AppTheme.textSecondary),
    filled: true,
    fillColor: AppTheme.backgroundWhiteSoft, // NOT backgroundGray
    ...
  ),
)
```

### 6. Update Search/Filter Containers
```dart
// OLD:
Container(
  color: Colors.white,
  child: ...
)

// NEW:
GlassmorphicCard(
  padding: const EdgeInsets.all(AppTheme.spacingM),
  margin: const EdgeInsets.all(AppTheme.spacingM),
  child: ...
)
```

### 7. Update Status Badges/Chips
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        statusColor.withOpacity(0.3),
        statusColor.withOpacity(0.1),
      ],
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusM),
    border: Border.all(color: statusColor, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: statusColor.withOpacity(0.3),
        blurRadius: 10,
        spreadRadius: 0,
      ),
    ],
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: statusColor,
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
      const SizedBox(width: 6),
      Text(
        statusText.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: statusColor,
          letterSpacing: 0.5,
        ),
      ),
    ],
  ),
)
```

## 🎯 Screens to Update

### High Priority
- [ ] Dashboard screens (all role dashboards)
- [ ] Fuel Management Screen
- [ ] Shift Management screens (start, end, summary, config)
- [ ] Entries screens (entries, meter readings)
- [ ] Customers screens (list, ledger)
- [ ] Expenses list screen
- [ ] Payments screens (all)
- [ ] Ledger screens (overview, entry, detail)
- [ ] Reports screens (main, daily, monthly, analytics)
- [ ] Settings screen

### Medium Priority
- [ ] Supplier Ledger Screen
- [ ] Customer Ledger Screen
- [ ] Payment History Screen
- [ ] All other sub-screens

## 🔧 Import Statements Needed
```dart
import '../../../shared/widgets/glassmorphic_card.dart';
import '../../../shared/widgets/glowing_button.dart';
```

## ⚠️ Important Notes
1. **Never use `backgroundDark`** - Use `backgroundGray` or `backgroundWhite`
2. **Text colors**: Use `textPrimary` (black) on white backgrounds
3. **Cards**: Always use `GlassmorphicCard` instead of `Card`
4. **Buttons**: Use `GlowingButton` for primary actions
5. **Dialogs**: Always set `backgroundColor: AppTheme.backgroundWhite`
6. **Input fields**: Use `fillColor: AppTheme.backgroundWhiteSoft`
