import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSettingsScreen extends ConsumerWidget {
  const AddSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'Add Settings (Categories, Reminders, Databases, PassCode, & FAQs)',
        ),
      ),
    );
  }
}
