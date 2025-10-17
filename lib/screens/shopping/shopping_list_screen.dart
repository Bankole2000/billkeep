import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/shopping/shopping_list_form.dart';

class AddShoppingListScreen extends ConsumerWidget {
  final String projectId;

  const AddShoppingListScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Shopping List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ShoppingListForm(projectId: projectId),
    );
  }
}
