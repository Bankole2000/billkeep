import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../models/wallet_model.dart';
import '../../providers/wallet_provider.dart';

/// Project creation step in onboarding
class ProjectStep extends ConsumerWidget {
  final TextEditingController projectNameController;
  final TextEditingController projectDescriptionController;
  final WalletModel? createdWallet;
  final String? selectedWalletId;
  final ValueChanged<String?> onWalletChanged;

  const ProjectStep({
    super.key,
    required this.projectNameController,
    required this.projectDescriptionController,
    required this.onWalletChanged,
    this.createdWallet,
    this.selectedWalletId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your First Project',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Projects help you organize expenses by different areas of your life.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Project name
          TextFormField(
            controller: projectNameController,
            decoration: InputDecoration(
              labelText: 'Project Name',
              hintText: 'e.g., Personal, Business, Family',
              prefixIcon: const Icon(Icons.folder_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Project description
          TextFormField(
            controller: projectDescriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'What will you use this project for?',
              prefixIcon: const Icon(Icons.description_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Default Wallet Selection
          walletsAsync.when(
            data: (wallets) {
              return DropdownButtonFormField<String>(
                value: selectedWalletId,
                decoration: InputDecoration(
                  labelText: 'Default Wallet',
                  hintText: 'Select default wallet for this project',
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: wallets.map((Wallet wallet) {
                  return DropdownMenuItem<String>(
                    value: wallet.id,
                    child: Text(wallet.name),
                  );
                }).toList(),
                onChanged: onWalletChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a default wallet';
                  }
                  return null;
                },
              );
            },
            loading: () => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Default Wallet',
                hintText: 'Loading wallets...',
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [],
              onChanged: null,
            ),
            error: (error, stack) => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Default Wallet',
                hintText: 'Error loading wallets',
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: 'Failed to load wallets',
              ),
              items: const [],
              onChanged: null,
            ),
          ),
        ],
      ),
    );
  }
}
