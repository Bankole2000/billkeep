#!/usr/bin/env python3
"""
Script to add isEqualTo and merge methods to all model files.
"""

import os
import re
from pathlib import Path

def parse_model_fields(content):
    """Extract field names and types from a model class."""
    fields = []

    # Find the class definition
    class_match = re.search(r'class\s+(\w+)\s*{', content)
    if not class_match:
        return fields, None

    class_name = class_match.group(1)

    # Find all final fields
    field_pattern = r'final\s+(\S+)\s+(\w+);'
    for match in re.finditer(field_pattern, content):
        field_type = match.group(1)
        field_name = match.group(2)
        fields.append((field_name, field_type))

    return fields, class_name

def generate_is_equal_to_method(fields, class_name):
    """Generate the isEqualTo method."""
    # Exclude createdAt and updatedAt from comparison
    comparable_fields = [f for f in fields if f[0] not in ['createdAt', 'updatedAt']]

    # Exclude *Data fields (expanded relations) from comparison
    comparable_fields = [f for f in comparable_fields if not f[0].endswith('Data')]

    # Exclude metadata from comparison
    comparable_fields = [f for f in comparable_fields if f[0] != 'metadata']

    if not comparable_fields:
        return None

    method = f'''  /// Compares this {class_name} with another for equality
  bool isEqualTo({class_name} other) {{
    return '''

    comparisons = [f'{field[0]} == other.{field[0]}' for field in comparable_fields]

    # Join with proper formatting
    method += ' &&\n        '.join(comparisons)
    method += ';\n  }'

    return method

def generate_merge_method(fields, class_name):
    """Generate the merge method."""
    if not fields:
        return None

    method = f'''  /// Updates this {class_name} with another, prioritizing non-null fields from the other
  {class_name} merge({class_name} other) {{
    return {class_name}(\n'''

    field_assignments = []
    for field_name, _ in fields:
        field_assignments.append(f'      {field_name}: other.{field_name} ?? {field_name}')

    method += ',\n'.join(field_assignments)
    method += ',\n    );\n  }'

    return method

def add_methods_to_model(file_path):
    """Add isEqualTo and merge methods to a model file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Check if methods already exist
    if 'bool isEqualTo(' in content or 'merge(' in content:
        print(f"  Skipping {file_path.name} - methods already exist")
        return False

    # Parse fields and get class name
    fields, class_name = parse_model_fields(content)
    if not fields or not class_name:
        print(f"  Skipping {file_path.name} - could not parse fields")
        return False

    # Generate methods
    is_equal_to = generate_is_equal_to_method(fields, class_name)
    merge = generate_merge_method(fields, class_name)

    if not is_equal_to or not merge:
        print(f"  Skipping {file_path.name} - could not generate methods")
        return False

    # Find the best place to insert (after fromDrift or fromJson, before copyWith or toJson)
    insert_pattern = r'(\n\s*///[^\n]*\n\s*factory\s+\w+\.fromDrift\([^}]+}\s*\n)'
    match = re.search(insert_pattern, content, re.DOTALL)

    if not match:
        # Try after fromJson
        insert_pattern = r'(\n\s*factory\s+\w+\.fromJson\([^}]+}\s*\n)'
        match = re.search(insert_pattern, content, re.DOTALL)

    if not match:
        print(f"  Skipping {file_path.name} - could not find insertion point")
        return False

    # Insert the methods
    insertion_point = match.end()
    new_content = (
        content[:insertion_point] +
        '\n' + is_equal_to + '\n\n' +
        merge + '\n' +
        content[insertion_point:]
    )

    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print(f"  [+] Added methods to {file_path.name}")
    return True

def main():
    # Get the models directory
    script_dir = Path(__file__).parent
    models_dir = script_dir.parent / 'lib' / 'models'

    if not models_dir.exists():
        print(f"Error: Models directory not found: {models_dir}")
        return

    # Find all *_model.dart files
    model_files = list(models_dir.glob('*_model.dart'))

    print(f"Found {len(model_files)} model files\n")

    # Exclude user_model.dart since it already has the methods
    model_files = [f for f in model_files if f.name != 'user_model.dart']

    updated = 0
    for model_file in sorted(model_files):
        if add_methods_to_model(model_file):
            updated += 1

    print(f"\n[+] Updated {updated} out of {len(model_files)} model files")

if __name__ == '__main__':
    main()
