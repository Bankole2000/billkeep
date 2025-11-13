import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/providers/project_provider.dart';

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key});

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        ref.read(projectRepositoryProvider);
        // .createProject(
        //   name: _nameController.text.trim(),
        //   description: _descriptionController.text.trim().isEmpty
        //       ? null
        //       : _descriptionController.text.trim(),
        // );

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveProject,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Create Project'),
          ),
        ],
      ),
    );
  }
}
