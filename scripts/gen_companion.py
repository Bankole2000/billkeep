import sys
import re

def simple_pluralize(word):
    """Pluralizes a word using simple English rules."""
    if word.endswith("y") and word[-2] not in "aeiou":
        return word[:-1] + "ies"
    if word.endswith(("s", "x", "z", "ch", "sh")):
        return word + "es"
    return word + "s"

def extract_class_name(content):
    match = re.search(r"class\s+(\w+)Model", content)
    return match.group(1) if match else None

def extract_fields(content):
    pattern = r"final\s+([\w<>?]+)\s+(\w+);"
    return re.findall(pattern, content)

def generate_companion_method(entity, fields):
    plural_entity = simple_pluralize(entity)
    companion_name = f"{plural_entity}Companion"

    params = [f"    {ftype} {fname}," for ftype, fname in fields]
    params_block = "\n".join(params)

    body_lines = [
        (
            f"      {fname}: {fname} != null "
            f"? Value({fname}) "
            f": (this.{fname} != null ? Value(this.{fname}!) : const Value.absent()),"
        )
        for ftype, fname in fields
    ]
    body_block = "\n".join(body_lines)

    return f"""
  /// Converts this model to a Drift Companion for database operations
  {companion_name} toCompanion({{
{params_block}
  }}) {{
    return {companion_name}(
{body_block}
    );
  }}
"""

def insert_method_into_class(content, method):
    if "toCompanion(" in content:
        print("⚠️  Method already exists. No changes made.")
        return content

    class_end = content.rfind("}")
    if class_end == -1:
        print("❌ Could not find class closing brace.")
        return content

    new_content = content[:class_end] + method + "\n}" + content[class_end+1:]
    return new_content

def main():
    if len(sys.argv) < 2:
        print("Usage: python gen_companion_insert.py <path_to_dart_model_file>")
        return

    path = sys.argv[1]

    try:
        with open(path, "r") as f:
            content = f.read()
    except FileNotFoundError:
        print("❌ File not found:", path)
        return

    entity = extract_class_name(content)
    if not entity:
        print("❌ No class <Entity>Model found in file.")
        return

    fields = extract_fields(content)
    if not fields:
        print("❌ No fields found in model.")
        return

    method = generate_companion_method(entity, fields)
    updated_content = insert_method_into_class(content, method)

    with open(path, "w") as f:
        f.write(updated_content)

    print(f"✅ Companion method successfully inserted into {path}")


if __name__ == "__main__":
    main()
