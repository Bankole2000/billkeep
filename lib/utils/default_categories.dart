import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

class DefaultCategories {
  // Expense Categories with subcategories
  static final List<Map<String, dynamic>> expenseCategories = [
    // Housing
    {
      'id': 'cat_expense_housing',
      'name': 'Housing',
      'type': 'EXPENSE',
      'icon': '🏠',
      'color': '#FF6B6B',
      'isDefault': true,
      'subcategories': [
        {'name': 'Rent', 'icon': '🔑', 'color': '#FF6B6B'},
        {'name': 'Mortgage', 'icon': '🏦', 'color': '#FF6B6B'},
        {'name': 'Property Tax', 'icon': '📋', 'color': '#FF6B6B'},
        {'name': 'Home Insurance', 'icon': '🛡️', 'color': '#FF6B6B'},
        {'name': 'Maintenance', 'icon': '🔧', 'color': '#FF6B6B'},
      ],
    },
    // Utilities
    {
      'id': 'cat_expense_utilities',
      'name': 'Utilities',
      'type': 'EXPENSE',
      'icon': '⚡',
      'color': '#4ECDC4',
      'isDefault': true,
      'subcategories': [
        {'name': 'Electricity', 'icon': '💡', 'color': '#4ECDC4'},
        {'name': 'Water', 'icon': '💧', 'color': '#4ECDC4'},
        {'name': 'Gas', 'icon': '🔥', 'color': '#4ECDC4'},
        {'name': 'Internet', 'icon': '🌐', 'color': '#4ECDC4'},
        {'name': 'Phone', 'icon': '📱', 'color': '#4ECDC4'},
        {'name': 'Cable/TV', 'icon': '📺', 'color': '#4ECDC4'},
      ],
    },
    // Transportation
    {
      'id': 'cat_expense_transport',
      'name': 'Transportation',
      'type': 'EXPENSE',
      'icon': '🚗',
      'color': '#95E1D3',
      'isDefault': true,
      'subcategories': [
        {'name': 'Fuel/Gas', 'icon': '⛽', 'color': '#95E1D3'},
        {'name': 'Public Transit', 'icon': '🚌', 'color': '#95E1D3'},
        {'name': 'Car Payment', 'icon': '🚘', 'color': '#95E1D3'},
        {'name': 'Car Insurance', 'icon': '🛡️', 'color': '#95E1D3'},
        {'name': 'Maintenance/Repairs', 'icon': '🔧', 'color': '#95E1D3'},
        {'name': 'Parking', 'icon': '🅿️', 'color': '#95E1D3'},
        {'name': 'Ride Share', 'icon': '🚕', 'color': '#95E1D3'},
      ],
    },
    // Food & Dining
    {
      'id': 'cat_expense_food',
      'name': 'Food & Dining',
      'type': 'EXPENSE',
      'icon': '🍽️',
      'color': '#F38181',
      'isDefault': true,
      'subcategories': [
        {'name': 'Groceries', 'icon': '🛒', 'color': '#F38181'},
        {'name': 'Restaurants', 'icon': '🍴', 'color': '#F38181'},
        {'name': 'Fast Food', 'icon': '🍔', 'color': '#F38181'},
        {'name': 'Coffee/Tea', 'icon': '☕', 'color': '#F38181'},
        {'name': 'Snacks', 'icon': '🍿', 'color': '#F38181'},
      ],
    },
    // Healthcare
    {
      'id': 'cat_expense_healthcare',
      'name': 'Healthcare',
      'type': 'EXPENSE',
      'icon': '⚕️',
      'color': '#AA96DA',
      'isDefault': true,
      'subcategories': [
        {'name': 'Insurance', 'icon': '🏥', 'color': '#AA96DA'},
        {'name': 'Doctor Visits', 'icon': '👨‍⚕️', 'color': '#AA96DA'},
        {'name': 'Prescriptions', 'icon': '💊', 'color': '#AA96DA'},
        {'name': 'Dental', 'icon': '🦷', 'color': '#AA96DA'},
        {'name': 'Vision', 'icon': '👓', 'color': '#AA96DA'},
        {'name': 'Pharmacy', 'icon': '💉', 'color': '#AA96DA'},
      ],
    },
    // Entertainment
    {
      'id': 'cat_expense_entertainment',
      'name': 'Entertainment',
      'type': 'EXPENSE',
      'icon': '🎮',
      'color': '#FCBAD3',
      'isDefault': true,
      'subcategories': [
        {'name': 'Streaming Services', 'icon': '📺', 'color': '#FCBAD3'},
        {'name': 'Movies', 'icon': '🎬', 'color': '#FCBAD3'},
        {'name': 'Gaming', 'icon': '🎮', 'color': '#FCBAD3'},
        {'name': 'Concerts/Events', 'icon': '🎫', 'color': '#FCBAD3'},
        {'name': 'Hobbies', 'icon': '🎨', 'color': '#FCBAD3'},
        {'name': 'Books', 'icon': '📚', 'color': '#FCBAD3'},
      ],
    },
    // Shopping
    {
      'id': 'cat_expense_shopping',
      'name': 'Shopping',
      'type': 'EXPENSE',
      'icon': '🛍️',
      'color': '#FFFFD2',
      'isDefault': true,
      'subcategories': [
        {'name': 'Clothing', 'icon': '👕', 'color': '#FFFFD2'},
        {'name': 'Electronics', 'icon': '💻', 'color': '#FFFFD2'},
        {'name': 'Home Goods', 'icon': '🏡', 'color': '#FFFFD2'},
        {'name': 'Personal Care', 'icon': '💄', 'color': '#FFFFD2'},
        {'name': 'Gifts', 'icon': '🎁', 'color': '#FFFFD2'},
      ],
    },
    // Education
    {
      'id': 'cat_expense_education',
      'name': 'Education',
      'type': 'EXPENSE',
      'icon': '📚',
      'color': '#A8E6CF',
      'isDefault': true,
      'subcategories': [
        {'name': 'Tuition', 'icon': '🎓', 'color': '#A8E6CF'},
        {'name': 'Books/Supplies', 'icon': '📖', 'color': '#A8E6CF'},
        {'name': 'Courses', 'icon': '💻', 'color': '#A8E6CF'},
        {'name': 'Student Loans', 'icon': '🏦', 'color': '#A8E6CF'},
      ],
    },
    // Personal
    {
      'id': 'cat_expense_personal',
      'name': 'Personal',
      'type': 'EXPENSE',
      'icon': '👤',
      'color': '#FFD3B6',
      'isDefault': true,
      'subcategories': [
        {'name': 'Gym/Fitness', 'icon': '💪', 'color': '#FFD3B6'},
        {'name': 'Hair/Beauty', 'icon': '💇', 'color': '#FFD3B6'},
        {'name': 'Clothing', 'icon': '👔', 'color': '#FFD3B6'},
        {'name': 'Subscriptions', 'icon': '📬', 'color': '#FFD3B6'},
      ],
    },
    // Savings & Investments
    {
      'id': 'cat_expense_savings',
      'name': 'Savings & Investments',
      'type': 'EXPENSE',
      'icon': '💰',
      'color': '#98D8C8',
      'isDefault': true,
      'subcategories': [
        {'name': 'Emergency Fund', 'icon': '🏦', 'color': '#98D8C8'},
        {'name': 'Retirement', 'icon': '👴', 'color': '#98D8C8'},
        {'name': 'Investments', 'icon': '📈', 'color': '#98D8C8'},
        {'name': 'Savings Goals', 'icon': '🎯', 'color': '#98D8C8'},
      ],
    },
    // Debt Payments
    {
      'id': 'cat_expense_debt',
      'name': 'Debt Payments',
      'type': 'EXPENSE',
      'icon': '💳',
      'color': '#F6A5C0',
      'isDefault': true,
      'subcategories': [
        {'name': 'Credit Card', 'icon': '💳', 'color': '#F6A5C0'},
        {'name': 'Personal Loan', 'icon': '🏦', 'color': '#F6A5C0'},
        {'name': 'Student Loan', 'icon': '🎓', 'color': '#F6A5C0'},
        {'name': 'Car Loan', 'icon': '🚗', 'color': '#F6A5C0'},
      ],
    },
    // Miscellaneous
    {
      'id': 'cat_expense_misc',
      'name': 'Miscellaneous',
      'type': 'EXPENSE',
      'icon': '📦',
      'color': '#B5B5B5',
      'isDefault': true,
      'subcategories': [
        {'name': 'Other', 'icon': '❓', 'color': '#B5B5B5'},
      ],
    },
  ];

  // Income Categories with subcategories
  static final List<Map<String, dynamic>> incomeCategories = [
    // Salary
    {
      'id': 'cat_income_salary',
      'name': 'Salary',
      'type': 'INCOME',
      'icon': '💼',
      'color': '#4CAF50',
      'isDefault': true,
      'subcategories': [
        {'name': 'Primary Job', 'icon': '💼', 'color': '#4CAF50'},
        {'name': 'Bonus', 'icon': '🎁', 'color': '#4CAF50'},
        {'name': 'Commission', 'icon': '💵', 'color': '#4CAF50'},
        {'name': 'Overtime', 'icon': '⏰', 'color': '#4CAF50'},
      ],
    },
    // Business
    {
      'id': 'cat_income_business',
      'name': 'Business Income',
      'type': 'INCOME',
      'icon': '🏢',
      'color': '#2196F3',
      'isDefault': true,
      'subcategories': [
        {'name': 'Sales', 'icon': '💰', 'color': '#2196F3'},
        {'name': 'Services', 'icon': '🛠️', 'color': '#2196F3'},
        {'name': 'Consulting', 'icon': '👔', 'color': '#2196F3'},
        {'name': 'Contracts', 'icon': '📝', 'color': '#2196F3'},
      ],
    },
    // Freelance
    {
      'id': 'cat_income_freelance',
      'name': 'Freelance',
      'type': 'INCOME',
      'icon': '💻',
      'color': '#9C27B0',
      'isDefault': true,
      'subcategories': [
        {'name': 'Projects', 'icon': '📂', 'color': '#9C27B0'},
        {'name': 'Hourly Work', 'icon': '⏱️', 'color': '#9C27B0'},
        {'name': 'Retainer', 'icon': '🤝', 'color': '#9C27B0'},
      ],
    },
    // Investments
    {
      'id': 'cat_income_investments',
      'name': 'Investments',
      'type': 'INCOME',
      'icon': '📈',
      'color': '#FF9800',
      'isDefault': true,
      'subcategories': [
        {'name': 'Dividends', 'icon': '💵', 'color': '#FF9800'},
        {'name': 'Interest', 'icon': '🏦', 'color': '#FF9800'},
        {'name': 'Capital Gains', 'icon': '📊', 'color': '#FF9800'},
        {'name': 'Rental Income', 'icon': '🏘️', 'color': '#FF9800'},
      ],
    },
    // Side Hustle
    {
      'id': 'cat_income_sidehustle',
      'name': 'Side Hustle',
      'type': 'INCOME',
      'icon': '🚀',
      'color': '#E91E63',
      'isDefault': true,
      'subcategories': [
        {'name': 'Gig Work', 'icon': '🚗', 'color': '#E91E63'},
        {'name': 'Online Sales', 'icon': '🛒', 'color': '#E91E63'},
        {'name': 'Creative Work', 'icon': '🎨', 'color': '#E91E63'},
        {'name': 'Tutoring', 'icon': '📚', 'color': '#E91E63'},
      ],
    },
    // Gifts & Windfalls
    {
      'id': 'cat_income_gifts',
      'name': 'Gifts & Windfalls',
      'type': 'INCOME',
      'icon': '🎁',
      'color': '#00BCD4',
      'isDefault': true,
      'subcategories': [
        {'name': 'Cash Gifts', 'icon': '💝', 'color': '#00BCD4'},
        {'name': 'Tax Refund', 'icon': '📋', 'color': '#00BCD4'},
        {'name': 'Lottery/Prizes', 'icon': '🎰', 'color': '#00BCD4'},
        {'name': 'Inheritance', 'icon': '👴', 'color': '#00BCD4'},
      ],
    },
    // Refunds & Reimbursements
    {
      'id': 'cat_income_refunds',
      'name': 'Refunds & Reimbursements',
      'type': 'INCOME',
      'icon': '↩️',
      'color': '#8BC34A',
      'isDefault': true,
      'subcategories': [
        {'name': 'Purchase Refunds', 'icon': '🔄', 'color': '#8BC34A'},
        {'name': 'Insurance Claims', 'icon': '🏥', 'color': '#8BC34A'},
        {'name': 'Expense Reimbursement', 'icon': '💼', 'color': '#8BC34A'},
      ],
    },
    // Other
    {
      'id': 'cat_income_other',
      'name': 'Other Income',
      'type': 'INCOME',
      'icon': '💵',
      'color': '#607D8B',
      'isDefault': true,
      'subcategories': [
        {'name': 'Miscellaneous', 'icon': '❓', 'color': '#607D8B'},
      ],
    },
  ];

  // Helper method to seed default categories
  static Future<void> seedDefaultCategories(AppDatabase database) async {
    // Check if categories already exist
    final existingCategories = await database.select(database.categories).get();
    if (existingCategories.isNotEmpty) {
      return; // Already seeded
    }

    // Insert expense categories
    for (final category in expenseCategories) {
      final categoryId = category['id'] as String;

      // Insert parent category
      await database.into(database.categories).insert(
            CategoriesCompanion(
              id: Value(categoryId),
              tempId: Value(categoryId),
              name: Value(category['name'] as String),
              type: Value(category['type'] as String),
              icon: Value(category['icon'] as String),
              color: Value(category['color'] as String),
              isDefault: Value(category['isDefault'] as bool),
              isSynced: const Value(false),
            ),
          );

      // Insert subcategories
      final subcategories = category['subcategories'] as List<Map<String, dynamic>>;
      for (var i = 0; i < subcategories.length; i++) {
        final sub = subcategories[i];
        final subId = '${categoryId}_sub_$i';

        await database.into(database.categories).insert(
              CategoriesCompanion(
                id: Value(subId),
                tempId: Value(subId),
                name: Value(sub['name'] as String),
                type: Value(category['type'] as String),
                icon: Value(sub['icon'] as String),
                color: Value(sub['color'] as String),
                isDefault: Value(category['isDefault'] as bool),
                parentCategoryId: Value(categoryId),
                isSynced: const Value(false),
              ),
            );
      }
    }

    // Insert income categories
    for (final category in incomeCategories) {
      final categoryId = category['id'] as String;

      // Insert parent category
      await database.into(database.categories).insert(
            CategoriesCompanion(
              id: Value(categoryId),
              tempId: Value(categoryId),
              name: Value(category['name'] as String),
              type: Value(category['type'] as String),
              icon: Value(category['icon'] as String),
              color: Value(category['color'] as String),
              isDefault: Value(category['isDefault'] as bool),
              isSynced: const Value(false),
            ),
          );

      // Insert subcategories
      final subcategories = category['subcategories'] as List<Map<String, dynamic>>;
      for (var i = 0; i < subcategories.length; i++) {
        final sub = subcategories[i];
        final subId = '${categoryId}_sub_$i';

        await database.into(database.categories).insert(
              CategoriesCompanion(
                id: Value(subId),
                tempId: Value(subId),
                name: Value(sub['name'] as String),
                type: Value(category['type'] as String),
                icon: Value(sub['icon'] as String),
                color: Value(sub['color'] as String),
                isDefault: Value(category['isDefault'] as bool),
                parentCategoryId: Value(categoryId),
                isSynced: const Value(false),
              ),
            );
      }
    }
  }
}
