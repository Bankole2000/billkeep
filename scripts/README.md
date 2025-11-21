# Model Generator Script

This directory contains scripts for generating Dart model files from PocketBase JSON schemas.

## generate_model.py

Automatically generates Dart model classes from JSON schema files that represent PocketBase collection structures.

### Features

- ✅ Automatically infers Dart types from JSON values
- ✅ Handles PocketBase relations with expand support
- ✅ Generates both ID and expanded data fields for relations
- ✅ All fields are optional (nullable)
- ✅ Generates `fromJson` and `toJson` methods
- ✅ Handles special fields like `DateTime`, `Map<String, dynamic>`, and relations

### Usage

```bash
python3 scripts/generate_model.py <json_schema_file> [output_file]
```

#### Examples

Generate a single model:
```bash
python3 scripts/generate_model.py lib/models/data/wallet.json lib/models/wallet_model.dart
```

Auto-generate output filename:
```bash
python3 scripts/generate_model.py lib/models/data/wallet.json
# Output: lib/models/wallet_model.dart
```

Generate all models:
```bash
# From the project root
for file in lib/models/data/*.json; do
  name=$(basename "$file" .json)
  python3 scripts/generate_model.py "$file" "lib/models/${name}_model.dart"
done
```

### JSON Schema Format

Your JSON schema files should follow this format:

```json
{
  "collectionId": "pbc_120182150",
  "collectionName": "wallets",
  "id": "test",
  "name": "test",
  "balance": 123,
  "isActive": true,
  "currency": "RELATION_RECORD_ID",
  "metadata": "JSON",
  "createdAt": "2022-01-01 10:00:00.123Z",
  "updatedAt": "2022-01-01 10:00:00.123Z"
}
```

### Field Type Inference

The script infers Dart types based on JSON values:

| JSON Value | Dart Type | Notes |
|------------|-----------|-------|
| `"test"` | `String?` | Regular string |
| `123` | `int?` | Integer |
| `true` | `bool?` | Boolean |
| `"2022-01-01..."` | `DateTime?` | Date strings |
| `"RELATION_RECORD_ID"` | `String?` + `ModelType?` | Creates two fields |
| `"JSON"` | `Map<String, dynamic>?` | JSON object |

### Relation Fields

When a field has the value `"RELATION_RECORD_ID"`, the generator creates two fields:

**JSON:**
```json
{
  "user": "RELATION_RECORD_ID"
}
```

**Generated Dart:**
```dart
final String? user;
final UserModel? userData;
```

The `fromJson` method automatically handles PocketBase's expand feature:

```dart
user: json['user'] as String?,
userData: json['expand']?['user'] != null
    ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
    : null,
```

### Generated Model Structure

Each generated model includes:

1. **Class fields** - All optional properties
2. **Constructor** - Named parameters for all fields
3. **fromJson factory** - Parses JSON to model with expand support
4. **toJson method** - Converts model to JSON (excludes expanded data)

### Example Generated Model

**Input:** `lib/models/data/wallet.json`

**Output:** `lib/models/wallet_model.dart`

```dart
import 'currency_model.dart';
import 'user_model.dart';
import 'provider_model.dart';

class Wallet {
  final String? id;
  final String? name;
  final int? balance;
  final String? currency;
  final CurrencyModel? currencyData;
  final String? user;
  final UserModel? userData;
  final DateTime? createdAt;

  Wallet({
    this.id,
    this.name,
    this.balance,
    this.currency,
    this.currencyData,
    this.user,
    this.userData,
    this.createdAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String?,
      name: json['name'] as String?,
      balance: json['balance'] as int?,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(json['expand']['currency'] as Map<String, dynamic>)
          : null,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
```

### Notes

- The script automatically skips `collectionId` and `collectionName` fields
- All fields are generated as optional (nullable) types
- Import statements are automatically generated for related models
- The class name is derived from the collection name in PascalCase

### Limitations

- Assumes all models follow the `{name}Model` naming convention
- Manual adjustment may be needed for complex nested structures
- Circular dependencies between models may need manual resolution

### Future Enhancements

Potential improvements for this script:

- Support for custom type mappings
- Generate copyWith methods
- Generate equality operators
- Support for freezed/json_serializable annotations
- Batch processing mode for multiple files
