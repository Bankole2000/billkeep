#!/usr/bin/env python3
"""
Compare Dart models with Drift database tables to find missing fields.
"""

import os
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple


def parse_model_fields(model_content: str) -> Dict[str, str]:
    """Extract fields from a Dart model class."""
    fields = {}
    # Match pattern: final Type? fieldName;
    pattern = r'final\s+(\w+[\w<>,\s]*\??)\s+(\w+);'

    for match in re.finditer(pattern, model_content):
        dart_type = match.group(1).strip()
        field_name = match.group(2).strip()

        # Skip expanded relation fields (ending in Data)
        if field_name.endswith('Data'):
            continue
        # Skip metadata field
        if field_name == 'metadata':
            continue

        fields[field_name] = dart_type

    return fields


def parse_table_columns(table_content: str) -> Set[str]:
    """Extract column names from a Drift table class."""
    columns = set()
    # Match pattern: TypeColumn get columnName =>
    pattern = r'(?:Text|Int|Bool|DateTime)Column\s+get\s+(\w+)\s+=>'

    for match in re.finditer(pattern, table_content):
        column_name = match.group(1)
        columns.add(column_name)

    return columns


def dart_type_to_drift(dart_type: str) -> str:
    """Convert Dart type to Drift column type."""
    dart_type = dart_type.replace('?', '').strip()

    type_map = {
        'String': 'TextColumn',
        'int': 'IntColumn',
        'bool': 'BoolColumn',
        'DateTime': 'DateTimeColumn',
    }

    for dart, drift in type_map.items():
        if dart in dart_type:
            return drift

    return 'TextColumn'  # Default


def extract_table_definition(database_content: str, table_name: str) -> str:
    """Extract a table class definition from database.dart."""
    pattern = rf'class {table_name} extends Table {{(.*?)^\}}'
    match = re.search(pattern, database_content, re.MULTILINE | re.DOTALL)
    return match.group(1) if match else ''


def get_model_to_table_mapping() -> List[Tuple[str, str, str]]:
    """Return list of (model_file, model_class, table_name) tuples."""
    return [
        ('user_model.dart', 'UserModel', 'Users'),
        ('project_model.dart', 'ProjectModel', 'Projects'),
        ('expense_model.dart', 'ExpenseModel', 'Expenses'),
        ('income_model.dart', 'IncomeModel', 'Income'),
        ('payment_model.dart', 'Payment', 'Payments'),
        ('category_model.dart', 'CategoryModel', 'Categories'),
        ('category_group_model.dart', 'CategoryGroupModel', 'CategoryGroups'),
        ('budget_model.dart', 'BudgetModel', 'Budgets'),
        ('wallet_model.dart', 'WalletModel', 'Wallets'),
        ('wallet_provider_model.dart', 'WalletProviderModel', 'WalletProviders'),
        ('goal_model.dart', 'GoalModel', 'Goals'),
        ('goal_contributions_model.dart', 'GoalContribution', 'GoalContribution'),
        ('investment_model.dart', 'InvestmentModel', 'Investments'),
        ('investment_payment_model.dart', 'InvestmentPayment', 'InvestmentPayments'),
        ('reminder_model.dart', 'ReminderModel', 'Reminders'),
        ('merchant_model.dart', 'MerchantModel', 'Merchants'),
        ('contact_model.dart', 'ContactModel', 'Contacts'),
        ('currency_model.dart', 'CurrencyModel', 'Currencies'),
        ('todo_model.dart', 'TodoItem', 'TodoItems'),
        ('shopping_list_model.dart', 'ShoppingList', 'ShoppingLists'),
        ('shopping_list_item_model.dart', 'ShoppingListItem', 'ShoppingListItems'),
    ]


def main():
    project_root = Path('/Users/bankoleesan/projects/flutter-projects/billkeep')
    models_dir = project_root / 'lib' / 'models'
    database_file = project_root / 'lib' / 'database' / 'database.dart'

    # Read database file
    with open(database_file, 'r') as f:
        database_content = f.read()

    print("=" * 80)
    print("MODEL vs TABLE COMPARISON REPORT")
    print("=" * 80)
    print()

    tables_to_create = []
    tables_to_update = {}

    for model_file, model_class, table_name in get_model_to_table_mapping():
        model_path = models_dir / model_file

        if not model_path.exists():
            print(f"⚠️  Model file not found: {model_file}")
            print()
            continue

        # Read model
        with open(model_path, 'r') as f:
            model_content = f.read()

        model_fields = parse_model_fields(model_content)

        # Check if table exists
        table_def = extract_table_definition(database_content, table_name)

        if not table_def:
            print(f"❌ Table: {table_name} (DOES NOT EXIST)")
            print(f"   Model: {model_class} in {model_file}")
            print(f"   Action: CREATE NEW TABLE")
            print(f"   Fields needed:")
            for field_name, dart_type in sorted(model_fields.items()):
                drift_type = dart_type_to_drift(dart_type)
                nullable = '.nullable()' if '?' in dart_type else ''
                print(f"      - {field_name}: {drift_type}(){nullable}")
            print()
            tables_to_create.append((table_name, model_class, model_fields))
            continue

        # Compare existing table
        table_columns = parse_table_columns(table_def)
        missing_fields = {}

        for field_name, dart_type in model_fields.items():
            # Map common field name variations
            db_field_name = field_name
            if field_name == 'user':
                db_field_name = 'userId'
            elif field_name == 'project':
                db_field_name = 'projectId'
            elif field_name == 'category':
                db_field_name = 'categoryId'
            elif field_name == 'merchant':
                db_field_name = 'merchantId'
            elif field_name == 'contact':
                db_field_name = 'contactId'
            elif field_name == 'wallet':
                db_field_name = 'walletId'
            elif field_name == 'expense':
                db_field_name = 'expenseId'
            elif field_name == 'income':
                db_field_name = 'incomeId'
            elif field_name == 'investment':
                db_field_name = 'investmentId'
            elif field_name == 'goal':
                db_field_name = 'goalId'
            elif field_name == 'budget':
                db_field_name = 'budgetId'
            elif field_name == 'reminder':
                db_field_name = 'reminderId'
            elif field_name == 'provider':
                db_field_name = 'providerId'
            elif field_name == 'categoryGroup':
                db_field_name = 'categoryGroupId'
            elif field_name == 'shoppingList':
                db_field_name = 'shoppingListId'
            elif field_name == 'parentTodo':
                db_field_name = 'parentTodoId'
            elif field_name == 'payment':
                db_field_name = 'paymentId'

            if db_field_name not in table_columns and field_name not in table_columns:
                missing_fields[field_name] = dart_type

        if missing_fields:
            print(f"⚠️  Table: {table_name}")
            print(f"   Model: {model_class} in {model_file}")
            print(f"   Missing fields:")
            for field_name, dart_type in sorted(missing_fields.items()):
                drift_type = dart_type_to_drift(dart_type)
                nullable = '.nullable()' if '?' in dart_type else ''
                print(f"      - {field_name}: {drift_type}(){nullable}")
            print()
            tables_to_update[table_name] = (model_class, missing_fields)
        else:
            print(f"✅ Table: {table_name}")
            print(f"   Model: {model_class} in {model_file}")
            print(f"   Status: All fields present")
            print()

    # Summary
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"Tables to create: {len(tables_to_create)}")
    for table_name, model_class, fields in tables_to_create:
        print(f"  - {table_name} (from {model_class}) - {len(fields)} fields")
    print()
    print(f"Tables to update: {len(tables_to_update)}")
    for table_name, (model_class, fields) in tables_to_update.items():
        print(f"  - {table_name} (from {model_class}) - {len(fields)} missing fields")
    print()


if __name__ == '__main__':
    main()
