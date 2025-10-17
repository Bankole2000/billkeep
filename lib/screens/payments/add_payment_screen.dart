import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/widgets/payments/payment_form.dart';
import 'package:billkeep/database/database.dart';

class AddPaymentScreen extends ConsumerWidget {
  final Expense expense;

  const AddPaymentScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Payment'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PaymentForm(expense: expense),
    );
  }
}
