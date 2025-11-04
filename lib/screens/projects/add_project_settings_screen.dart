import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProjectSettingsScreen extends ConsumerStatefulWidget {
  const AddProjectSettingsScreen({super.key, this.project });

  final Project? project;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProjectSettingsScreenState();
}

class _AddProjectSettingsScreenState extends ConsumerState<AddProjectSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text(
          'Project Settings',
          style: TextStyle(color: colors.text),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Text(
          'Add Project Settings Screen',
          style: TextStyle(color: colors.text),
        ),
      ),
    );
  }
}