#!/usr/bin/env python3
"""
Dart Model Generator from PocketBase JSON Schema

This script generates Dart model files from JSON schema files that represent
PocketBase collection structures.

Usage:
    python scripts/generate_model.py <json_file> [output_file]

Example:
    python scripts/generate_model.py lib/models/data/wallet.json lib/models/wallet_model.dart
"""

import json
import sys
import os
from typing import Dict, List, Tuple, Any
from pathlib import Path


def to_pascal_case(snake_str: str) -> str:
    """Convert snake_case to PascalCase"""
    return ''.join(word.capitalize() for word in snake_str.split('_'))


def to_camel_case(snake_str: str) -> str:
    """Convert snake_case to camelCase"""
    components = snake_str.split('_')
    return components[0] + ''.join(x.capitalize() for x in components[1:])


def infer_dart_type(value: Any) -> str:
    """Infer Dart type from JSON value"""
    if isinstance(value, bool):
        return 'bool'
    elif isinstance(value, int):
        return 'int'
    elif isinstance(value, str):
        if value == 'RELATION_RECORD_ID':
            return 'RELATION'
        elif value == 'JSON':
            return 'Map<String, dynamic>'
        elif 'date' in value.lower() or value.endswith('Z') or value.endswith('.123Z'):
            return 'DateTime'
        else:
            return 'String'
    else:
        return 'String'


def parse_json_schema(json_data: Dict) -> Tuple[str, List[Tuple[str, str, bool]]]:
    """
    Parse JSON schema and extract field information

    Returns:
        Tuple of (collection_name, fields)
        where fields is a list of (field_name, dart_type, is_relation)
    """
    collection_name = json_data.get('collectionName', 'Unknown')
    fields = []

    for key, value in json_data.items():
        # Skip collection metadata
        if key in ['collectionId', 'collectionName']:
            continue

        dart_type = infer_dart_type(value)
        is_relation = dart_type == 'RELATION'

        if is_relation:
            # For relations, we'll create two fields
            fields.append((key, 'String', True))
        else:
            fields.append((key, dart_type, False))

    return collection_name, fields


def generate_imports(fields: List[Tuple[str, str, bool]]) -> List[str]:
    """Generate import statements based on field types"""
    imports = set()

    # Check if we need user_model
    for field_name, _, is_relation in fields:
        if is_relation and field_name == 'user':
            imports.add("import 'user_model.dart';")
        elif is_relation:
            # Generate import for related model
            model_file = f"{field_name}_model.dart"
            imports.add(f"import '{model_file}';")

    return sorted(list(imports))


def generate_class_fields(class_name: str, fields: List[Tuple[str, str, bool]]) -> str:
    """Generate class field declarations"""
    lines = []

    for field_name, dart_type, is_relation in fields:
        if is_relation:
            # Create ID field
            lines.append(f"  final String? {field_name};")
            # Create data field
            related_class = to_pascal_case(field_name)
            lines.append(f"  final {related_class}Model? {field_name}Data;")
        else:
            lines.append(f"  final {dart_type}? {field_name};")

    return '\n'.join(lines)


def generate_constructor(class_name: str, fields: List[Tuple[str, str, bool]]) -> str:
    """Generate constructor"""
    lines = [f"  {class_name}({{"]

    for field_name, _, is_relation in fields:
        lines.append(f"    this.{field_name},")
        if is_relation:
            lines.append(f"    this.{field_name}Data,")

    lines.append("  });")
    return '\n'.join(lines)


def generate_from_json(class_name: str, fields: List[Tuple[str, str, bool]]) -> str:
    """Generate fromJson factory method"""
    lines = [
        f"  factory {class_name}.fromJson(Map<String, dynamic> json) {{",
        f"    return {class_name}("
    ]

    for field_name, dart_type, is_relation in fields:
        if is_relation:
            # ID field
            lines.append(f"      {field_name}: json['{field_name}'] as String?,")
            # Data field from expand
            related_class = to_pascal_case(field_name)
            lines.append(f"      {field_name}Data: json['expand']?['{field_name}'] != null")
            lines.append(f"          ? {related_class}.fromJson(json['expand']['{field_name}'] as Map<String, dynamic>)")
            lines.append(f"          : null,")
        elif dart_type == 'DateTime':
            lines.append(f"      {field_name}: json['{field_name}'] != null")
            lines.append(f"          ? DateTime.parse(json['{field_name}'] as String)")
            lines.append(f"          : null,")
        elif dart_type == 'Map<String, dynamic>':
            lines.append(f"      {field_name}: json['{field_name}'] as Map<String, dynamic>?,")
        else:
            lines.append(f"      {field_name}: json['{field_name}'] as {dart_type}?,")

    lines.append("    );")
    lines.append("  }")
    return '\n'.join(lines)


def generate_to_json(fields: List[Tuple[str, str, bool]]) -> str:
    """Generate toJson method"""
    lines = [
        "  Map<String, dynamic> toJson() {",
        "    return {"
    ]

    for field_name, dart_type, is_relation in fields:
        if is_relation:
            # Only include the ID in toJson, not the expanded data
            lines.append(f"      '{field_name}': {field_name},")
        elif dart_type == 'DateTime':
            lines.append(f"      '{field_name}': {field_name}?.toIso8601String(),")
        else:
            lines.append(f"      '{field_name}': {field_name},")

    lines.append("    };")
    lines.append("  }")
    return '\n'.join(lines)


def generate_model_file(json_file_path: str, output_path: str = None) -> str:
    """
    Generate a complete Dart model file from JSON schema

    Args:
        json_file_path: Path to the JSON schema file
        output_path: Optional output path for the generated Dart file

    Returns:
        The generated Dart code as a string
    """
    # Read JSON file
    with open(json_file_path, 'r') as f:
        json_data = json.load(f)

    # Parse schema
    collection_name, fields = parse_json_schema(json_data)

    # Generate class name from collection name
    class_name = to_pascal_case(collection_name.rstrip('s'))  # Remove trailing 's'

    # Generate imports
    imports = generate_imports(fields)

    # Build the file content
    lines = []

    # Add imports
    for imp in imports:
        lines.append(imp)

    if imports:
        lines.append('')

    # Add class
    lines.append(f"class {class_name} {{")
    lines.append(generate_class_fields(class_name, fields))
    lines.append('')
    lines.append(generate_constructor(class_name, fields))
    lines.append('')
    lines.append(generate_from_json(class_name, fields))
    lines.append('')
    lines.append(generate_to_json(fields))
    lines.append("}")

    dart_code = '\n'.join(lines) + '\n'

    # Write to file if output path is provided
    if output_path:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, 'w') as f:
            f.write(dart_code)
        print(f"✅ Generated {output_path}")

    return dart_code


def main():
    if len(sys.argv) < 2:
        print("Usage: python scripts/generate_model.py <json_file> [output_file]")
        print("\nExample:")
        print("  python scripts/generate_model.py lib/models/data/wallet.json lib/models/wallet_model.dart")
        sys.exit(1)

    json_file = sys.argv[1]

    if not os.path.exists(json_file):
        print(f"❌ Error: File not found: {json_file}")
        sys.exit(1)

    # Determine output path
    if len(sys.argv) >= 3:
        output_file = sys.argv[2]
    else:
        # Auto-generate output filename
        base_name = os.path.basename(json_file).replace('.json', '')
        output_file = f"lib/models/{base_name}_model.dart"

    # Generate the model
    try:
        generate_model_file(json_file, output_file)
        print(f"\n✨ Successfully generated Dart model!")
        print(f"📁 Input:  {json_file}")
        print(f"📄 Output: {output_file}")
    except Exception as e:
        print(f"❌ Error generating model: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
