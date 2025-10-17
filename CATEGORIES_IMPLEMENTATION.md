# Categories Feature Implementation Guide

## Overview
The BillKeep app now includes a comprehensive category system for organizing both expenses and income. Categories are **global** (not project-specific), support **parent-child hierarchies** (subcategories), and come with **default predefined categories** with icons and colors.

## Database Schema

### Categories Table
- `id`: Primary key
- `name`: Category name (e.g., "Housing", "Salary")
- `type`: Either "EXPENSE" or "INCOME"
- `icon`: Emoji or icon name (e.g., "🏠", "💼")
- `color`: Hex color code (e.g., "#FF6B6B")
- `isDefault`: Boolean indicating if it's a system-provided category
- `parentCategoryId`: Foreign key to parent category (null for top-level categories)
- `isSynced`, `tempId`, `createdAt`, `updatedAt`: Standard sync fields

### Updated Tables
**Expenses Table:**
- Added `categoryId` field (nullable foreign key to Categories)

**Income Table:**
- Added `categoryId` field (nullable foreign key to Categories)

### Migration
- Schema upgraded from v4 to v5
- Migration automatically adds the Categories table and categoryId columns

## Default Categories

### Expense Categories (12 top-level)
1. **Housing** (🏠, #FF6B6B)
   - Rent, Mortgage, Property Tax, Home Insurance, Maintenance

2. **Utilities** (⚡, #4ECDC4)
   - Electricity, Water, Gas, Internet, Phone, Cable/TV

3. **Transportation** (🚗, #95E1D3)
   - Fuel/Gas, Public Transit, Car Payment, Insurance, Maintenance, Parking, Ride Share

4. **Food & Dining** (🍽️, #F38181)
   - Groceries, Restaurants, Fast Food, Coffee/Tea, Snacks

5. **Healthcare** (⚕️, #AA96DA)
   - Insurance, Doctor Visits, Prescriptions, Dental, Vision, Pharmacy

6. **Entertainment** (🎮, #FCBAD3)
   - Streaming Services, Movies, Gaming, Concerts/Events, Hobbies, Books

7. **Shopping** (🛍️, #FFFFD2)
   - Clothing, Electronics, Home Goods, Personal Care, Gifts

8. **Education** (📚, #A8E6CF)
   - Tuition, Books/Supplies, Courses, Student Loans

9. **Personal** (👤, #FFD3B6)
   - Gym/Fitness, Hair/Beauty, Clothing, Subscriptions

10. **Savings & Investments** (💰, #98D8C8)
    - Emergency Fund, Retirement, Investments, Savings Goals

11. **Debt Payments** (💳, #F6A5C0)
    - Credit Card, Personal Loan, Student Loan, Car Loan

12. **Miscellaneous** (📦, #B5B5B5)
    - Other

### Income Categories (8 top-level)
1. **Salary** (💼, #4CAF50)
   - Primary Job, Bonus, Commission, Overtime

2. **Business Income** (🏢, #2196F3)
   - Sales, Services, Consulting, Contracts

3. **Freelance** (💻, #9C27B0)
   - Projects, Hourly Work, Retainer

4. **Investments** (📈, #FF9800)
   - Dividends, Interest, Capital Gains, Rental Income

5. **Side Hustle** (🚀, #E91E63)
   - Gig Work, Online Sales, Creative Work, Tutoring

6. **Gifts & Windfalls** (🎁, #00BCD4)
   - Cash Gifts, Tax Refund, Lottery/Prizes, Inheritance

7. **Refunds & Reimbursements** (↩️, #8BC34A)
   - Purchase Refunds, Insurance Claims, Expense Reimbursement

8. **Other Income** (💵, #607D8B)
   - Miscellaneous

## Code Structure

### Files Created
1. **lib/database/database.dart** - Updated with Categories table and categoryId columns
2. **lib/utils/default_categories.dart** - Default category definitions and seeding logic
3. **lib/providers/category_provider.dart** - Category repository and Riverpod providers
4. **lib/screens/settings/categories_screen.dart** - Category management UI
5. **lib/widgets/category_picker.dart** - Reusable category selection widget

### Files Modified
1. **lib/providers/expense_provider.dart** - Added categoryId parameter to createExpense() and updateExpense()
2. **lib/providers/income_provider.dart** - Added categoryId parameter to createIncome() and updateIncome()
3. **lib/main.dart** - Added default category seeding on app initialization

## Usage

### 1. Managing Categories

Access category management via Settings screen (you'll need to add navigation):

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const CategoriesScreen()),
);
```

Features:
- View expense and income categories in separate tabs
- Expand parent categories to see subcategories
- Add custom categories and subcategories
- Edit category name, icon, and color
- Delete custom categories (default categories cannot be deleted)
- Categories with associated expenses/income cannot be deleted

### 2. Using Categories in Expense Forms

Update your expense forms to include the CategoryPicker widget:

```dart
import 'package:billkeep/widgets/category_picker.dart';

// In your form state
String? _selectedCategoryId;

// In your form UI
CategoryPicker(
  type: 'EXPENSE',
  selectedCategoryId: _selectedCategoryId,
  onCategorySelected: (categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  },
),

// When creating expense
await ref.read(expenseRepositoryProvider).createExpense(
  projectId: widget.projectId,
  name: _nameController.text,
  amount: _amountController.text,
  type: _selectedType,
  frequency: _selectedFrequency,
  categoryId: _selectedCategoryId, // Pass the selected category
  notes: _notesController.text,
);
```

### 3. Using Categories in Income Forms

Similar to expenses, but use `type: 'INCOME'`:

```dart
CategoryPicker(
  type: 'INCOME',
  selectedCategoryId: _selectedCategoryId,
  onCategorySelected: (categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  },
),
```

### 4. Displaying Categories

To show category information for an expense/income:

```dart
// Get category using provider
final categoryAsync = ref.watch(categoryProvider(expense.categoryId ?? ''));

categoryAsync.when(
  data: (category) {
    if (category == null) return const SizedBox.shrink();

    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Color(int.parse(
            category.color!.replaceFirst('#', '0xFF')
          )),
          child: Text(category.icon ?? '📁', style: TextStyle(fontSize: 12)),
        ),
        SizedBox(width: 8),
        Text(category.name),
      ],
    );
  },
  loading: () => CircularProgressIndicator(),
  error: (_, __) => SizedBox.shrink(),
);
```

### 5. Filtering by Category

Get expenses for a specific category:

```dart
final expenses = await ref
  .read(databaseProvider)
  .select(database.expenses)
  .where((e) => e.categoryId.equals(selectedCategoryId))
  .get();
```

### 6. Category Analytics

Get spending by category:

```dart
Future<Map<String, double>> getSpendingByCategory(String projectId) async {
  final expenses = await database.select(database.expenses)
    .where((e) => e.projectId.equals(projectId))
    .get();

  Map<String, double> categorySpending = {};

  for (final expense in expenses) {
    if (expense.categoryId == null) continue;

    final payments = await database.select(database.payments)
      .where((p) => p.expenseId.equals(expense.id))
      .get();

    final total = payments.fold<double>(0, (sum, p) => sum + p.actualAmount / 100);

    categorySpending[expense.categoryId!] =
      (categorySpending[expense.categoryId!] ?? 0) + total;
  }

  return categorySpending;
}
```

## Providers Available

### Stream Providers
- `allCategoriesProvider` - All categories
- `expenseCategoriesProvider` - Parent expense categories only
- `incomeCategoriesProvider` - Parent income categories only
- `subcategoriesProvider(parentId)` - Subcategories of a parent
- `categoryProvider(categoryId)` - Single category by ID

### Repository Methods
**CategoryRepository:**
- `createCategory()` - Create custom category
- `updateCategory()` - Update category name/icon/color
- `deleteCategory()` - Delete custom category (with validation)
- `getParentCategories(type)` - Get all parent categories by type
- `getSubcategories(parentId)` - Get subcategories
- `watchAllCategories()` - Stream all categories
- `searchCategories(query, type)` - Search categories by name

## Next Steps

### To Fully Integrate:

1. **Update Expense Form Screen** (`lib/screens/expenses/add_expense_screen.dart`)
   - Import CategoryPicker widget
   - Add category selection UI
   - Pass categoryId to createExpense()

2. **Update Income Form Screen**
   - Add CategoryPicker for income categories
   - Pass categoryId to createIncome()

3. **Update Expense List Items**
   - Display category icon and name with each expense
   - Add category filtering options

4. **Add Category Analytics**
   - Create pie chart showing spending by category
   - Add category breakdown to Planning screen

5. **Add Navigation to Categories Screen**
   - Add menu item in Settings to access CategoriesScreen

6. **Handle SMS Parsing**
   - Update SMS parser to auto-assign categories based on keywords
   - Add category suggestion logic in ParsedMessages screen

## Tips

- **Color Parsing**: Use `Color(int.parse(colorHex.replaceFirst('#', '0xFF')))` to convert hex colors
- **Default Categories**: Cannot be edited or deleted by users
- **Cascade Deletion**: Prevents deleting categories that are in use
- **Subcategories**: Always inherit the type from their parent
- **Icon/Emoji Support**: Both work - emojis render directly, icon names can be mapped to IconData

## Testing

To test the implementation:

1. Run the app - default categories will be seeded automatically
2. Navigate to CategoriesScreen to view all categories
3. Create a custom expense category
4. Add a subcategory to it
5. Use the CategoryPicker in an expense form
6. Verify the category appears with the expense

## Troubleshooting

**"Category already exists" errors:**
- Default categories are only seeded once (checks if table is empty)
- If needed, clear app data to re-seed

**Migration issues:**
- If migration fails, increment schemaVersion and add new migration step
- For clean slate: delete database file and restart app

**Category not showing:**
- Ensure categoryId is properly saved when creating expense/income
- Check that category exists in database
- Verify provider is watching the correct category ID
