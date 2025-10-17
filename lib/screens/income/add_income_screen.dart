import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/widgets/income/income_form.dart';

class AddIncomeScreen extends ConsumerWidget {
  final String projectId;

  const AddIncomeScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Income'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IncomeForm(projectId: projectId),
    );
  }
}
