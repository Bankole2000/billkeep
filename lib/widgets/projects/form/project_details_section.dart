import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ui_providers.dart';

/// Project name and description input section
class ProjectDetailsSection extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const ProjectDetailsSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Column(
      children: [
        // Project Name
        ListTile(
          tileColor: colors.surface,
          contentPadding: const EdgeInsets.only(
            top: 0,
            left: 10,
            right: 20,
          ),
          visualDensity: const VisualDensity(vertical: 0.1),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Icon(
              Icons.edit_sharp,
              size: 30,
              color: colors.textMute,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 0, left: 10),
            child: Text('Project Name', textAlign: TextAlign.start),
          ),
          subtitle: CupertinoTextFormFieldRow(
            controller: nameController,
            style: const TextStyle(fontSize: 30),
            padding: EdgeInsets.zero,
            placeholder: 'Required',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          onTap: () {},
          minTileHeight: 10,
        ),

        Divider(height: 1, color: colors.textMute.withAlpha(50)),

        // Project Description
        ListTile(
          tileColor: colors.surface,
          contentPadding: const EdgeInsets.only(
            top: 0,
            left: 10,
            right: 20,
          ),
          visualDensity: const VisualDensity(vertical: 0.1),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Icon(
              Icons.description,
              size: 30,
              color: colors.textMute,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 0, left: 10),
            child: Text('Description', textAlign: TextAlign.start),
          ),
          subtitle: CupertinoTextFormFieldRow(
            controller: descriptionController,
            style: const TextStyle(fontSize: 20),
            padding: EdgeInsets.zero,
            placeholder: 'Optional',
            maxLines: 3,
          ),
          onTap: () {},
          minTileHeight: 10,
        ),
      ],
    );
  }
}
