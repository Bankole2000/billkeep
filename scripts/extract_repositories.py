#!/usr/bin/env python3
"""
Script to extract repository classes from provider files and move them to dedicated repository files.

Usage:
    python scripts/extract_repositories.py
"""

import os
import re
from pathlib import Path
from typing import List, Tuple, Optional


class RepositoryExtractor:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.providers_dir = self.project_root / "lib" / "providers"
        self.repositories_dir = self.project_root / "lib" / "repositories"

        # Ensure repositories directory exists
        self.repositories_dir.mkdir(parents=True, exist_ok=True)

    def find_provider_files(self) -> List[Path]:
        """Find all provider files that might contain repository classes."""
        if not self.providers_dir.exists():
            print(f"Error: Providers directory not found at {self.providers_dir}")
            return []

        return list(self.providers_dir.glob("*_provider.dart"))

    def extract_repository_class(self, content: str) -> Optional[Tuple[str, str, int, int]]:
        """
        Extract repository class from file content.

        Returns:
            Tuple of (class_name, class_content, start_line, end_line) or None if not found
        """
        # Pattern to match repository class definition
        class_pattern = r'class\s+(\w+Repository)\s*\{'

        match = re.search(class_pattern, content)
        if not match:
            return None

        class_name = match.group(1)
        start_pos = match.start()

        # Find the start line number
        start_line = content[:start_pos].count('\n')

        # Find matching closing brace
        brace_count = 0
        in_class = False
        end_pos = start_pos

        for i in range(start_pos, len(content)):
            char = content[i]
            if char == '{':
                brace_count += 1
                in_class = True
            elif char == '}':
                brace_count -= 1
                if in_class and brace_count == 0:
                    end_pos = i + 1
                    break

        # Find the end line number
        end_line = content[:end_pos].count('\n')

        # Extract the class content
        class_content = content[start_pos:end_pos]

        return (class_name, class_content, start_line, end_line)

    def extract_repository_provider(self, content: str, class_name: str) -> Optional[Tuple[str, int, int]]:
        """
        Extract the repository provider definition.

        Returns:
            Tuple of (provider_content, start_line, end_line) or None if not found
        """
        # Convert ClassName to camelCase for provider name
        provider_name = class_name[0].lower() + class_name[1:] + 'Provider'

        # Pattern to match the provider definition
        pattern = rf'final\s+{provider_name}\s*=\s*Provider\([^)]+\)\s*\{{[^}}]+\}}\s*\);'

        match = re.search(pattern, content, re.MULTILINE | re.DOTALL)
        if not match:
            return None

        start_pos = match.start()
        end_pos = match.end()

        start_line = content[:start_pos].count('\n')
        end_line = content[:end_pos].count('\n')

        provider_content = content[start_pos:end_pos]

        return (provider_content, start_line, end_line)

    def extract_imports(self, content: str) -> List[str]:
        """Extract import statements from file content."""
        import_pattern = r"^import\s+['\"]([^'\"]+)['\"];?\s*$"
        imports = []

        for line in content.split('\n'):
            match = re.match(import_pattern, line.strip())
            if match:
                imports.append(line.strip())

        return imports

    def determine_required_imports(self, class_content: str, original_imports: List[str]) -> List[str]:
        """Determine which imports are needed for the repository class."""
        required_imports = []

        # Always include these core imports
        core_imports = [
            "import 'package:drift/drift.dart';",
            "import '../database/database.dart';",
            "import '../utils/id_generator.dart';",
        ]

        for imp in core_imports:
            if any(imp_line.startswith(imp.split("'")[1].split("'")[0]) for imp_line in original_imports):
                required_imports.append(imp)

        # Check for model imports
        model_pattern = r'(\w+Model)'
        models_used = set(re.findall(model_pattern, class_content))

        for model in models_used:
            # Convert CamelCase to snake_case
            snake_case = re.sub(r'(?<!^)(?=[A-Z])', '_', model).lower()
            import_stmt = f"import '../models/{snake_case}.dart';"

            # Check if this import exists in original imports
            for original_import in original_imports:
                if snake_case in original_import:
                    required_imports.append(original_import)
                    break

        # Check for helper/utility imports
        if 'CurrencyHelper' in class_content:
            for imp in original_imports:
                if 'currency_helper' in imp:
                    required_imports.append(imp)

        if 'IdGenerator' in class_content:
            for imp in original_imports:
                if 'id_generator' in imp:
                    required_imports.append(imp)

        # Check for enum imports
        if re.search(r'\b(TransactionRecurrence|TransactionSource)\b', class_content):
            for imp in original_imports:
                if 'app_enums' in imp:
                    required_imports.append(imp)

        # Check for date helper imports
        if 'DateHelper' in class_content or 'calculateNextDueDate' in class_content:
            for imp in original_imports:
                if 'date_helper' in imp:
                    required_imports.append(imp)

        return list(set(required_imports))  # Remove duplicates

    def create_repository_file(self, class_name: str, class_content: str, imports: List[str]) -> Path:
        """Create a new repository file with the extracted class."""
        # Convert ClassName to snake_case
        file_name = re.sub(r'(?<!^)(?=[A-Z])', '_', class_name).lower() + '.dart'
        file_path = self.repositories_dir / file_name

        # Build file content
        file_lines = []

        # Add imports
        for imp in sorted(imports):
            file_lines.append(imp)

        file_lines.append('')  # Empty line after imports
        file_lines.append(class_content)
        file_lines.append('')  # Empty line at end of file

        # Write file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(file_lines))

        return file_path

    def update_provider_file(self, file_path: Path, content: str,
                            class_start: int, class_end: int,
                            provider_start: Optional[int] = None,
                            provider_end: Optional[int] = None,
                            repository_file: str = None) -> None:
        """Remove repository class from provider file and add import for repository."""
        lines = content.split('\n')

        # Remove repository class
        del lines[class_start:class_end + 1]

        # Adjust provider line numbers if provider comes after class
        if provider_start is not None and provider_end is not None:
            if provider_start > class_end:
                # Provider is after class, adjust line numbers
                lines_removed = class_end - class_start + 1
                provider_start -= lines_removed
                provider_end -= lines_removed

            # Remove provider definition
            del lines[provider_start:provider_end + 1]

        # Add import for repository file
        if repository_file:
            # Find the last import statement
            last_import_idx = 0
            for i, line in enumerate(lines):
                if line.strip().startswith('import '):
                    last_import_idx = i

            # Insert new import after last import
            repo_import = f"import '../repositories/{repository_file}';"
            lines.insert(last_import_idx + 1, repo_import)

        # Write updated content
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))

    def add_provider_to_repository_file(self, repo_file_path: Path,
                                       provider_content: str,
                                       class_name: str) -> None:
        """Add the repository provider to the repository file."""
        with open(repo_file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Add import for riverpod
        if "import 'package:flutter_riverpod/flutter_riverpod.dart';" not in content:
            lines = content.split('\n')
            # Find last import
            last_import_idx = 0
            for i, line in enumerate(lines):
                if line.strip().startswith('import '):
                    last_import_idx = i

            lines.insert(last_import_idx + 1, "import 'package:flutter_riverpod/flutter_riverpod.dart';")
            content = '\n'.join(lines)

        # Add provider at the end before the last closing brace
        lines = content.split('\n')

        # Find the last non-empty line
        insert_idx = len(lines) - 1
        while insert_idx > 0 and not lines[insert_idx].strip():
            insert_idx -= 1

        # Add provider definition
        lines.insert(insert_idx + 1, '')
        lines.insert(insert_idx + 2, provider_content)

        with open(repo_file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))

    def process_file(self, file_path: Path) -> bool:
        """Process a single provider file."""
        print(f"\nProcessing: {file_path.name}")

        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract repository class
        result = self.extract_repository_class(content)
        if not result:
            print(f"  X No repository class found")
            return False

        class_name, class_content, class_start, class_end = result
        print(f"  + Found repository class: {class_name}")
        print(f"    Lines: {class_start + 1} - {class_end + 1}")

        # Extract repository provider
        provider_result = self.extract_repository_provider(content, class_name)
        if provider_result:
            provider_content, provider_start, provider_end = provider_result
            print(f"  + Found repository provider")
            print(f"    Lines: {provider_start + 1} - {provider_end + 1}")
        else:
            print(f"  X No repository provider found")
            provider_content = None
            provider_start = None
            provider_end = None

        # Extract imports
        imports = self.extract_imports(content)
        required_imports = self.determine_required_imports(class_content, imports)

        # Create repository file
        repo_file_name = re.sub(r'(?<!^)(?=[A-Z])', '_', class_name).lower() + '.dart'
        repo_file_path = self.create_repository_file(class_name, class_content, required_imports)
        print(f"  + Created repository file: {repo_file_path.name}")

        # Add provider to repository file if found
        if provider_content:
            self.add_provider_to_repository_file(repo_file_path, provider_content, class_name)
            print(f"  + Added provider to repository file")

        # Update provider file
        self.update_provider_file(
            file_path,
            content,
            class_start,
            class_end,
            provider_start,
            provider_end,
            repo_file_name
        )
        print(f"  + Updated provider file")

        return True

    def run(self):
        """Run the extraction process on all provider files."""
        print("=" * 70)
        print("Repository Extraction Script")
        print("=" * 70)

        provider_files = self.find_provider_files()

        if not provider_files:
            print("\nNo provider files found!")
            return

        print(f"\nFound {len(provider_files)} provider files")

        success_count = 0
        for file_path in provider_files:
            if self.process_file(file_path):
                success_count += 1

        print("\n" + "=" * 70)
        print(f"Summary: Processed {success_count}/{len(provider_files)} files successfully")
        print("=" * 70)


def main():
    # Get project root (assuming script is in scripts/ directory)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    extractor = RepositoryExtractor(str(project_root))
    extractor.run()


if __name__ == "__main__":
    main()
