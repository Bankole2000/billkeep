#!/usr/bin/env python3
"""
Script to remove repository providers from repository files.

Since repositories are injected into services and services are provided via
service providers, repository providers are redundant.

Usage:
    python scripts/remove_repository_providers.py
"""

import os
import re
from pathlib import Path


class RepositoryProviderRemover:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.repositories_dir = self.project_root / "lib" / "repositories"

    def find_repository_files(self):
        """Find all repository files."""
        if not self.repositories_dir.exists():
            print(f"Error: Repositories directory not found at {self.repositories_dir}")
            return []

        return list(self.repositories_dir.glob("*_repository.dart"))

    def remove_provider_from_file(self, file_path: Path):
        """Remove repository provider definition from file."""
        print(f"\nProcessing: {file_path.name}")

        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Pattern to match repository provider definition
        # Matches: final xxxRepositoryProvider = Provider((ref) { ... });
        provider_pattern = r'final\s+\w+RepositoryProvider\s*=\s*Provider\([^)]+\)\s*\{[^}]+\}\s*\)\s*;'

        # Remove the provider
        content = re.sub(provider_pattern, '', content, flags=re.MULTILINE | re.DOTALL)

        # Remove flutter_riverpod import if it's no longer needed
        # Check if there are any other Provider references
        if 'Provider' not in content and 'Riverpod' not in content:
            content = re.sub(
                r"import\s+['\"]package:flutter_riverpod/flutter_riverpod\.dart['\"]\s*;\s*\n",
                '',
                content
            )

        # Remove database_provider import if it's no longer needed
        if 'databaseProvider' not in content:
            content = re.sub(
                r"import\s+['\"][.\/]*providers/database_provider\.dart['\"]\s*;\s*\n",
                '',
                content
            )
            content = re.sub(
                r"import\s+['\"]package:billkeep/providers/database_provider\.dart['\"]\s*;\s*\n",
                '',
                content
            )

        # Clean up multiple consecutive blank lines (more than 2)
        content = re.sub(r'\n{3,}', '\n\n', content)

        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"  + Removed repository provider")
            return True
        else:
            print(f"  - No provider found to remove")
            return False

    def run(self):
        """Run the removal process on all repository files."""
        print("=" * 70)
        print("Repository Provider Removal Script")
        print("=" * 70)

        repo_files = self.find_repository_files()

        if not repo_files:
            print("\nNo repository files found!")
            return

        print(f"\nFound {len(repo_files)} repository files")

        success_count = 0
        for file_path in repo_files:
            if self.remove_provider_from_file(file_path):
                success_count += 1

        print("\n" + "=" * 70)
        print(f"Summary: Processed {success_count}/{len(repo_files)} files")
        print("=" * 70)


def main():
    # Get project root (assuming script is in scripts/ directory)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    remover = RepositoryProviderRemover(str(project_root))
    remover.run()


if __name__ == "__main__":
    main()
