import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBudgetScreen extends ConsumerWidget {
  const AddBudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'Add Budget (Wallets, Budgets) and Goals (Savings, Debts, Investements)',
        ),
      ),
    );
  }
}
