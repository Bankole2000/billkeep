import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/widgets/projects/project_form.dart';

class AddProjectScreen extends ConsumerWidget {
  const AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Project'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const ProjectForm(),
    );
  }
}
