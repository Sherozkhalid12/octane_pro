# 🔥 COMPREHENSIVE CURSOR PROMPT - OctanePro Fuel Station Management System

## 🎯 PROJECT OVERVIEW

You are building **OctanePro** - a **production-grade, enterprise-level Fuel Station Management System** with **extraordinary, modern, eye-catching design**. This is **NOT a demo or MVP** - it must be **scalable, auditable, role-based, and financially accurate**.

**Color Scheme:** Red (#DC2626), White (#FFFFFF), Black (#000000)
**Design Style:** Modern, professional, premium, with smooth animations and micro-interactions

---

## 👥 USER ROLES & PERMISSIONS (CRITICAL)

Implement **strict role-based access control (RBAC)** with different dashboards/views per role:

### Roles:
1. **Admin (Owner)** - Full system access, all modules
2. **Manager** - Operational management, dip management, reports
3. **Operator** - Shift & sales entry only, limited view
4. **Accountant** - Financial reports, ledger, payments only

**IMPORTANT:** Each role must see **different dashboard layouts and navigation** based on permissions. Use conditional rendering based on `user.role`.

---

## 🎨 DESIGN REQUIREMENTS (MANDATORY - EXTRAORDINARY LEVEL)

### Visual Design Standards:
- **Premium, modern aesthetic** - Think Apple/Stripe/Tesla level design quality - NOT basic Material Design
- **Smooth, fluid animations** - Use `flutter_animate` for ALL transitions - nothing should appear instantly
- **Micro-interactions** - Button presses (scale + ripple), card hovers (elevation change), number counting animations
- **Glassmorphism effects** - Subtle blur and transparency for modals and overlays
- **Gradient accents** - Use gradients for primary buttons, hero sections, and key metrics
- **Professional typography** - Clear hierarchy with proper font weights (300, 400, 500, 600, 700)
- **Consistent spacing** - Strict 4px grid system (4, 8, 12, 16, 24, 32, 48px) - NO arbitrary spacing
- **Card-based layouts** - Elevated cards with subtle shadows (0 2px 8px rgba(0,0,0,0.08))
- **Color-coded indicators** - Green (positive), Red (negative), Blue (info) - use consistently
- **Skeleton loaders** - Replace ALL spinners with skeleton screens (shimmer effect)
- **Lottie animations** - For loading states, empty states, and success confirmations
- **Neumorphism touches** - Subtle depth effects on buttons and cards where appropriate
- **Custom icons** - Use Material Icons but with custom styling and colors
- **Visual hierarchy** - Clear distinction between primary, secondary, and tertiary information

### Animation Requirements (MANDATORY - EVERYTHING MUST ANIMATE):
- **Page transitions:** Slide + fade (300ms ease-in-out) - NO instant page changes
- **Card appearances:** Staggered fade-in with scale (100ms delay between cards, 200ms duration)
- **Number counting:** Animate ALL numbers counting up (0 to target value in 1.5s with ease-out curve)
- **Button interactions:** Scale down to 0.95 on press (150ms), bounce back with spring animation
- **List items:** Slide in from right (200ms) + fade (300ms) - staggered by 50ms per item
- **Charts:** Animate bars growing from 0, pie slices appearing with rotation, line charts drawing
- **Pull to refresh:** Custom animated refresh indicator with Lottie animation
- **Modal appearances:** Slide up from bottom (300ms) with backdrop fade-in
- **Form field focus:** Border color transition (200ms), label float animation (300ms)
- **Error messages:** Slide down from top (300ms) with bounce
- **Success confirmations:** Scale + fade animation (400ms)
- **Loading states:** Skeleton shimmer effect (continuous)
- **Empty states:** Fade in with scale (400ms) + Lottie animation
- **Tab switches:** Smooth slide animation (200ms)
- **Dropdown opens:** Scale + fade (200ms)
- **Tooltips:** Fade in with slight scale (200ms)

### UI Components (EXTRAORDINARY QUALITY REQUIRED):

**Custom Buttons:**
- Primary: Red gradient (linear gradient from #DC2626 to #EF4444), white text, 16px padding, 12px border radius
- Secondary: White background, red border (2px), red text, same padding
- Icon buttons: Circular (48px), with ripple effect, icon size 24px
- Hover effects: Elevation increase (shadow becomes more prominent)
- Press effects: Scale to 0.95 with spring animation
- Disabled state: 50% opacity, no interaction

**Input Fields:**
- Modern Material 3 style with floating labels
- Border radius: 8px
- Focus: Red border (2px width), smooth transition (200ms)
- Error: Red border + error message slide down (300ms)
- Success: Green checkmark icon appears
- Floating label animation: Smooth float up on focus (300ms)

**Cards:**
- Elevated with subtle shadows: `BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 2))`
- Rounded corners: 12px (MANDATORY - no sharp corners)
- Padding: 16px minimum
- Hover effect: Slight elevation increase (shadow becomes 0 4px 12px)
- Background: White with subtle gradient overlay for premium feel

**Tables:**
- Sticky headers with red background
- Zebra striping (alternating row colors: white and #F9FAFB)
- Smooth scrolling with momentum
- Row hover effect: Background color change
- Sortable columns with animated sort indicators

**Charts:**
- Beautiful, animated charts using fl_chart
- Tooltips on tap/hover with smooth fade-in
- Legend with icons and color indicators
- Animated appearance: Bars grow, pie slices rotate in, lines draw
- Interactive: Tap to highlight, long press for details

**Modals:**
- Slide up from bottom (300ms) with spring animation
- Backdrop: Blurred overlay (backdropFilter with blur(10))
- Rounded top corners: 24px
- Maximum height: 90% of screen
- Dismissible by swiping down or tapping backdrop

**Bottom Sheets:**
- Smooth slide animation (300ms)
- Handle bar at top (visual indicator)
- Rounded top corners: 16px
- Backdrop blur effect

---

## 📱 APP STRUCTURE & NAVIGATION

### Mobile App Navigation (Bottom Bar):
1. **Dashboard** - Role-specific dashboard
2. **Shifts** - Shift management
3. **Entries** - Quick entry options
4. **Reports** - Analytics & reports
5. **More** - Settings, fuel management, etc.

### Web/Admin Panel (Sidebar Navigation):
- Dashboard
- Users Management
- Fuel Setup
- Shifts
- Customers
- Suppliers
- Ledger
- Expenses
- Inventory
- Reports
- Settings

---

## 🏗️ CORE MODULES (IMPLEMENT ALL - NO EXCEPTIONS)

### 1️⃣ Authentication & User Management

**Login Screen:**
- Beautiful, centered login form with gradient background
- Smooth input field animations
- Password visibility toggle with animation
- "Forgot Password" link
- Loading state with Lottie animation
- Error messages with slide-in animation

**User Management (Admin Only):**
- User list with search and filters
- Add user modal with form validation
- Role assignment with visual role badges
- Activate/deactivate toggle switches
- Activity logs with timeline view
- Beautiful user cards with avatars

**Role-Based Dashboard Redirect:**
- Admin → Full dashboard
- Manager → Operational dashboard
- Operator → Simplified dashboard (sales entry focus)
- Accountant → Financial dashboard

---

### 2️⃣ Dashboard (Role-Specific)

**Admin Dashboard:**
- Large hero card with station name and current date
- **Animated stat cards** with counting numbers:
  - Today's Total Sales (large, prominent)
  - Fuel Sold by Type (Petrol, Diesel, High Octane) with icons
  - Cash vs Credit Sales (pie chart or split view)
  - Total Expenses (with trend indicator)
  - Net Balance (large, color-coded)
- Active shift indicator banner (if shift active)
- Quick action buttons (Start Shift, End Shift, Add Expense, Record Payment)
- Recent transactions list (last 10)
- Sales by fuel type chart (animated pie/bar chart)
- Performance metrics cards

**Manager Dashboard:**
- Similar to admin but without user management
- Focus on operations and inventory

**Operator Dashboard:**
- Simplified view
- Active shift card (prominent)
- Quick sales entry
- Today's sales summary

**Accountant Dashboard:**
- Financial metrics focus
- Ledger summary
- Outstanding receivables/payables
- Cash flow indicators

**Design Requirements (CRITICAL - MUST IMPLEMENT):**
- Use **fl_chart** for beautiful animated charts - ALL charts must animate on appearance
- Number counting animations using `flutter_animate` - EVERY number must count up, not appear instantly
- Staggered card animations (each card appears 100ms after previous) - creates premium feel
- Gradient backgrounds for key metrics (red gradient for primary metrics)
- Icon-based visual indicators (every stat must have a relevant icon)
- Glassmorphism for hero sections (blur + transparency)
- Custom shadows for depth (multiple shadow layers)
- Smooth color transitions (no instant color changes)
- Loading states: Skeleton screens with shimmer, NOT spinners
- Empty states: Beautiful illustrations with Lottie animations
- Success states: Animated checkmarks with confetti (optional but premium)

---

### 3️⃣ Fuel Management

**Fuel Types Screen:**
- Grid/list view of fuel types
- Each card shows:
  - Fuel icon/color
  - Name
  - Current price (large, prominent)
  - Edit price button (opens modal)
- Add new fuel type button (floating action button)
- Price history chart per fuel type

**Nozzle Management:**
- List of nozzles grouped by fuel type
- Each nozzle card:
  - Nozzle number/ID
  - Linked fuel type badge
  - Active/inactive toggle
  - Current meter reading (if available)
- Add nozzle modal
- Link nozzle to fuel type with visual selector

**Price Update:**
- Beautiful modal with price input
- Price history timeline
- Animated price change indicator

---

### 4️⃣ Shift Management

**Shifts Configuration (Admin):**
- List of shifts (Morning, Evening, Night, Custom)
- Each shift card shows:
  - Shift name
  - Time range
  - Active status
  - Edit/Delete actions
- Add shift button
- Shift creation modal

**Start Shift Screen (Operator):**
- Beautiful form with:
  - Shift selector (dropdown)
  - Opening cash input (with currency formatting)
  - Opening meter readings per nozzle (expandable list)
  - Start button (prominent, animated)
- Real-time validation
- Smooth form animations

**Active Shift View:**
- Large banner showing active shift
- Current time display
- Quick actions (End Shift, Add Sale, Add Expense)
- Live sales counter
- Shift progress indicator

**End Shift Screen:**
- Closing meter readings input (per nozzle)
- Auto-calculated liters and amounts
- Cash collection input
- Credit sales summary
- Expenses during shift
- Short/excess calculation (highlighted if non-zero)
- Remarks field (required if variance)
- Beautiful summary card before submission
- Submit button with confirmation

**Shift Summary Screen:**
- Detailed breakdown:
  - Fuel sold by nozzle (expandable cards)
  - Fuel sold by type (visual chart)
  - Cash vs Credit (pie chart)
  - Expenses breakdown
  - Net balance (large, prominent)
- Export options (PDF/Excel)
- Beautiful timeline view

---

### 5️⃣ Daily Fuel Entry & Meter Readings

**Daily Entry Screen:**
- Date selector (beautiful calendar picker)
- Shift selector
- Fuel type tabs (Petrol, Diesel, High Octane) - animated tab bar
- For each nozzle:
  - Card with nozzle info
  - Opening reading (auto-filled, grayed out)
  - Closing reading input (large, prominent)
  - Auto-calculated liters (animated number)
  - Auto-calculated amount (animated number)
  - Visual indicator if variance detected
- Validation alerts (slide-in notifications)
- Save button with loading state

**Meter Reading Cards:**
- Beautiful card design
- Large number inputs
- Real-time calculation display
- Color-coded variance indicators

---

### 6️⃣ Customers (Debtors Management)

**Customer List Screen:**
- Search bar (animated, with filter icon)
- Customer cards showing:
  - Avatar/Initial circle
  - Customer name
  - Company name (if applicable)
  - Current balance (large, color-coded)
  - Credit limit indicator (progress bar)
  - Status badge (Clear/Due/Overdue)
- Add customer FAB
- Filter options (All, Due, Overdue, Clear)

**Add/Edit Customer:**
- Beautiful form modal
- Fields:
  - Customer name
  - Phone number (with country code selector)
  - Email
  - Company name
  - Address (multi-line)
  - Credit limit (with currency formatting)
  - Opening balance
- Form validation with animated error messages
- Save button with loading animation

**Customer Ledger Screen:**
- Customer header card (name, balance, credit limit)
- Transaction timeline:
  - Date
  - Transaction type (Sale/Payment) with icon
  - Description
  - Debit/Credit amount
  - Running balance
- Color-coded transactions (green for credit, red for debit)
- Export button (PDF/Excel)
- Beautiful statement view

**Customer Detail View:**
- Profile card at top
- Quick stats (Total sales, Payments, Outstanding)
- Transaction list with filters
- Payment button (prominent)

---

### 7️⃣ Suppliers (Creditors Management)

**Supplier List Screen:**
- Similar design to customers
- Outstanding payable balance (red indicator)
- Supplier cards with:
  - Company logo/initial
  - Supplier name
  - Contact info
  - Outstanding balance
  - Status

**Add/Edit Supplier:**
- Form similar to customer
- Opening balance (negative for payables)

**Supplier Ledger:**
- Purchase entries
- Payment entries
- Running balance
- Export functionality

---

### 8️⃣ General Ledger

**Ledger Overview:**
- Account cards showing:
  - Account name
  - Account type badge
  - Current balance (large, color-coded)
  - Trend indicator (up/down arrow)
- Account selector
- Date range filter

**Ledger Entry Screen:**
- Double-entry form:
  - Debit account selector
  - Credit account selector
  - Amount input
  - Reference number
  - Description
  - Date
- Real-time validation (debits must equal credits)
- Visual balance indicator
- Save button (disabled until balanced)

**Ledger Detail View:**
- Transaction list with:
  - Date
  - Voucher number
  - Description
  - Debit amount
  - Credit amount
  - Running balance
- Filters (date range, account, transaction type)
- Export options
- Beautiful table design with sticky headers

**Account Balance Cards:**
- Visual representation of account balances
- Color-coded by account type
- Trend charts

---

### 9️⃣ Expenses Management

**Expense Categories:**
- Visual category cards with icons:
  - Salaries (people icon)
  - Electricity (bolt icon)
  - Generator (power icon)
  - Maintenance (build icon)
  - Commissions (percent icon)
  - Miscellaneous (category icon)

**Add Expense Screen:**
- Beautiful form with:
  - Date picker (calendar)
  - Shift selector (optional)
  - Category selector (visual cards)
  - Description (multi-line)
  - Amount (with currency formatting)
  - Payment method selector (Cash/Bank/Card/Mobile Money)
  - Receipt attachment (image picker with preview)
  - Remarks
- Form validation
- Save button with animation

**Expense Listing:**
- Filter bar (date, category, shift)
- Expense cards:
  - Category icon and badge
  - Description
  - Amount (large, red)
  - Date and payment method
  - Receipt thumbnail (if attached)
- Total expenses summary card
- Export options

**Expense Summary:**
- Category-wise breakdown (pie chart)
- Monthly trend (line chart)
- Top expenses list

---

### 🔟 Payments & Settlements

**Record Payment Received (From Customers):**
- Customer selector (searchable)
- Amount input
- Payment method selector
- Date picker
- Reference number
- Remarks
- Auto-update customer balance preview
- Save button

**Record Payment Made (To Suppliers):**
- Supplier selector
- Similar form to customer payment
- Auto-update supplier balance

**Payment History:**
- Timeline view
- Filter by customer/supplier
- Export options

---

### 1️⃣1️⃣ Reports & Analytics

**Reports Dashboard:**
- Tab navigation (Daily, Monthly, Yearly, Custom)
- Report type cards:
  - Sales Report
  - Expense Report
  - Profit & Loss
  - Cash Flow
  - Debtors Aging
  - Creditors Aging
  - Tank Variance
  - Shift Performance

**Daily Report:**
- Date selector
- Summary cards (Sales, Expenses, Profit)
- Fuel sales breakdown (chart)
- Shift-wise performance
- Transaction list
- Export buttons (PDF/Excel)

**Monthly Report:**
- Month selector
- Monthly trend charts (animated)
- Category breakdowns
- Comparison with previous month
- Beautiful data visualization

**Analytics Dashboard:**
- Key performance indicators (KPIs)
- Trend charts
- Comparative analysis
- Forecasting (optional)

**Report Export:**
- PDF generation with professional formatting
- Excel export with formatting
- Email sharing option

---

### 1️⃣2️⃣ Settings & Configuration

**Station Settings:**
- Station information form
- Address
- Contact details
- Currency settings
- Tax configuration (optional)
- Logo upload

**Pricing Settings:**
- Fuel price management
- Price history timeline
- Bulk price update

**User Management (Admin):**
- User list with roles
- Add/edit user
- Permission management
- Activity logs

**Backup & Security:**
- Data backup options
- Export database
- User activity logs viewer
- Security settings

---

### 1️⃣3️⃣ Tank Dip Chart & Inventory Reconciliation (CRITICAL)

**Tank Setup:**
- Tank list with status indicators
- Add tank form:
  - Tank ID/Name
  - Fuel type selector
  - Capacity (liters)
  - Linked nozzles (multi-select)
- Tank cards showing:
  - Tank ID
  - Fuel type badge
  - Capacity
  - Current stock (with progress bar)
  - Last dip date
  - Status indicator

**Dip Chart Configuration:**
- Upload Excel file option
- Manual entry option
- Visual chart preview (dip vs liters graph)
- Chart versioning
- Effective date range

**Dip Entry Screen (Manager Only):**
- Date & time picker
- Tank selector
- Fuel type (auto-filled)
- Dip depth input (cm/mm)
- **Auto-conversion to liters** (using dip chart)
- System stock display (calculated)
- Physical stock display (from dip)
- **Variance calculation** (highlighted if non-zero)
- Remarks field (required if variance > threshold)
- Save button with validation

**Pre-Delivery Dip:**
- Special dip entry mode
- Before delivery dip reading
- Delivery details form:
  - Supplier selector
  - Invoice number
  - Invoice quantity
- Post-delivery dip entry
- **Auto-calculate received quantity** (dip-based)
- **Compare with invoice quantity**
- Variance display (highlighted)
- Remarks required for mismatch

**Tank Stock Screen:**
- Current physical stock (from latest dip)
- System stock (calculated from sales/deliveries)
- Variance indicator (color-coded)
- Last dip date & time
- Stock movement graph
- Historical dip entries timeline

**Inventory Integration:**
- Auto-update fuel inventory balance
- Ledger posting (Inventory, Stock Adjustment, Supplier)
- Loss/gain entries
- Audit trail

**Dip Reports:**
- Daily dip report
- Tank-wise variance report
- Delivery reconciliation report
- Export options (PDF/Excel)

---

## 🎨 DESIGN IMPLEMENTATION DETAILS

### Color Palette:
```dart
Primary Red: #DC2626 (Red-600)
Primary Red Dark: #991B1B (Red-800)
Primary Red Light: #EF4444 (Red-500)
Primary Red Lighter: #FEE2E2 (Red-100)

Secondary Black: #000000
Secondary Black Light: #1F2937 (Gray-800)

Background White: #FFFFFF
Background Gray: #F9FAFB (Gray-50)

Success Green: #10B981 (Green-500)
Error Red: #EF4444 (Red-500)
Warning Yellow: #F59E0B (Yellow-500)
Info Blue: #3B82F6 (Blue-500)
```

### Typography:
- **Display:** Large, bold (32-40px) for hero numbers
- **Headline:** Medium (20-24px) for section titles
- **Body:** Regular (14-16px) for content
- **Label:** Small (12px) for metadata
- **Font Family:** System default (SF Pro on iOS, Roboto on Android)

### Spacing System:
- XS: 4px
- S: 8px
- M: 16px
- L: 24px
- XL: 32px
- XXL: 48px

### Animation Specifications:
- **Page transitions:** 300ms ease-in-out
- **Card stagger:** 100ms delay between cards
- **Number counting:** 1.5s duration with ease-out
- **Button press:** Scale to 0.95, 150ms
- **Modal slide:** 300ms from bottom
- **List item:** Slide from right 200ms, fade 300ms

### Component Specifications:

**Stat Cards:**
- Rounded corners: 16px
- Shadow: Subtle elevation
- Gradient background for primary metrics
- Icon in top-right corner
- Large number (24-32px, bold)
- Label below (12px, secondary color)

**Action Buttons:**
- Primary: Red gradient, white text, 16px padding
- Secondary: White background, red border, red text
- Icon buttons: Circular, 48px, with ripple effect

**Input Fields:**
- Floating labels
- Border radius: 8px
- Focus: Red border, 2px width
- Error: Red border, error message below
- Smooth focus transition

**Cards:**
- Border radius: 12px
- Shadow: 0 2px 8px rgba(0,0,0,0.1)
- Padding: 16px
- Hover effect: Slight elevation increase

**Charts:**
- Animated appearance
- Tooltips on tap
- Color-coded by category
- Legend with icons

---

## 📊 DATA REQUIREMENTS

### Mock Data Needed:
- **Users:** Admin, Manager, Operator, Accountant (with different permissions)
- **Fuel Types:** Petrol, Diesel, High Octane (with prices)
- **Nozzles:** Multiple nozzles per fuel type
- **Shifts:** Morning, Evening, Night shifts
- **Shift Sessions:** Active and closed shifts with full data
- **Customers:** 5-10 customers with balances and credit limits
- **Suppliers:** 3-5 suppliers with balances
- **Expenses:** Various expenses across categories
- **Sales:** Daily sales data by fuel type
- **Tanks:** 3-5 tanks with dip charts and current stock
- **Dip Entries:** Historical dip readings
- **Transactions:** Payment and sales transactions
- **Ledger Entries:** Sample ledger transactions

---

## 🔧 TECHNICAL REQUIREMENTS

### State Management:
- Use **Riverpod** for all state
- Separate providers per feature
- Use `StateNotifier` for complex state

### Navigation:
- Use **GoRouter** for navigation
- Role-based route guards
- Deep linking support

### Animations:
- Use **flutter_animate** for all animations
- Use **Lottie** for loading states
- Custom animated widgets where needed

### Charts:
- Use **fl_chart** for all charts
- Animate chart appearances
- Interactive tooltips

### Forms:
- Use **flutter_form_builder** for complex forms
- Real-time validation
- Beautiful error messages

### File Handling:
- Image picker for receipts
- PDF generation for reports
- Excel export functionality

---

## ✅ IMPLEMENTATION CHECKLIST

### Must Have:
- [ ] Role-based authentication with different dashboards
- [ ] Beautiful, modern UI with animations
- [ ] All modules implemented (no placeholders)
- [ ] Mock data for all features
- [ ] Smooth animations throughout
- [ ] Professional charts and visualizations
- [ ] Responsive design
- [ ] Form validation
- [ ] Error handling
- [ ] Loading states
- [ ] Empty states
- [ ] Export functionality (PDF/Excel)

### Design Quality:
- [ ] Premium aesthetic (not basic)
- [ ] Consistent spacing and typography
- [ ] Color-coded indicators
- [ ] Smooth transitions
- [ ] Micro-interactions
- [ ] Professional charts
- [ ] Beautiful modals and bottom sheets
- [ ] Skeleton loaders
- [ ] Number counting animations
- [ ] Staggered card animations

---

## 🚀 DELIVERABLES

1. **Complete app** with all modules
2. **Beautiful, extraordinary design** (not basic)
3. **Smooth animations** throughout
4. **Role-based dashboards** (different for each role)
5. **Mock data** for all features
6. **Professional charts** and visualizations
7. **Export functionality** (PDF/Excel)
8. **Responsive layouts**
9. **Form validation** and error handling
10. **Loading and empty states**

---

## ⚠️ CRITICAL REQUIREMENTS (MUST FOLLOW)

1. **DO NOT** create basic/plain designs - make it EXTRAORDINARY, PREMIUM, STUNNING
   - Every screen must look like a $100M+ app
   - Use gradients, shadows, animations, glassmorphism
   - NO flat, boring Material Design - make it unique and beautiful

2. **DO NOT** skip any module - implement EVERYTHING listed above
   - No "coming soon" placeholders
   - No empty screens with just text
   - Every feature must have a beautiful, functional UI

3. **DO NOT** use placeholder screens - full functionality required
   - All forms must work (with mock data)
   - All buttons must have actions
   - All navigation must work

4. **DO** implement role-based dashboards (DIFFERENT per role - CRITICAL)
   - Admin: Full dashboard with all metrics
   - Manager: Operations-focused dashboard
   - Operator: Simplified, sales-entry focused
   - Accountant: Financial metrics only
   - Use conditional rendering: `if (user.role == UserRole.admin) { ... }`

5. **DO** use animations EVERYWHERE (smooth, professional)
   - Every page transition
   - Every card appearance
   - Every number display
   - Every button press
   - Every list item
   - NO instant appearances - everything must animate

6. **DO** make charts beautiful and animated
   - Use fl_chart with custom styling
   - Animate all chart elements on appearance
   - Add interactive tooltips
   - Use gradients in charts
   - Make them visually stunning

7. **DO** ensure all forms have validation
   - Real-time validation
   - Beautiful error messages (slide-in animations)
   - Success confirmations
   - Disabled states until valid

8. **DO** use mock data (no database needed)
   - All data from MockData class
   - Realistic, professional data
   - Enough data to showcase features

9. **DO** follow the color scheme (Red, White, Black)
   - Primary: Red (#DC2626)
   - Secondary: Black (#000000)
   - Background: White (#FFFFFF)
   - Use consistently throughout

10. **DO** make it production-ready quality
    - No console errors
    - Proper error handling
    - Loading states
    - Empty states
    - Responsive design
    - Professional polish

11. **DO** implement number counting animations
    - Use `AnimatedCount` or similar
    - Count from 0 to target value
    - Duration: 1.5s with ease-out curve
    - Apply to ALL numbers on dashboard

12. **DO** use skeleton loaders
    - Replace ALL CircularProgressIndicator with skeleton screens
    - Shimmer effect on skeleton
    - Match the actual content layout

13. **DO** add micro-interactions
    - Button press feedback (scale)
    - Card hover effects (elevation)
    - Input field focus animations
    - List item tap feedback
    - Swipe gestures where appropriate

---

## 📝 NOTES

- This is a **frontend-only** implementation with mock data
- No database required - use `MockData` class
- Focus on **UI/UX excellence** and **design quality**
- Make it **visually stunning** and **professionally polished**
- All animations should be **smooth** and **purposeful**
- Charts should be **beautiful** and **interactive**
- Forms should have **real-time validation** and **beautiful error states**

---

**END OF PROMPT**

Use this prompt in Cursor to generate the complete, beautiful, extraordinary OctanePro application with all features implemented.
