import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/screens/projects/project_details_screen.dart';
import 'package:billkeep/providers/project_provider.dart';

class ProjectListSelectItem extends ConsumerWidget {
  const ProjectListSelectItem({
    super.key,
    required this.isSelected,
    required this.project,
    required this.onSelectProject,
  });

  final Project project;
  final bool isSelected;
  final void Function() onSelectProject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return InkWell(
      onTap: onSelectProject,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        // visualDensity: VisualDensity(vertical: -5),
        leading: DynamicAvatar(
          icon: Icons.folder,
          color: isSelected ? activeColor : colors.textMute,
        ),

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? activeColor : colors.textMute,
              ),
            ),
          ],
        ),
        subtitle: Text(
          project.description ?? 'No description',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_right_rounded),
        ),
        onTap: onSelectProject,
      ),
    );
  }
}
