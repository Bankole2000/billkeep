import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
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
        tileColor: Colors.amber,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        // visualDensity: VisualDensity(vertical: -5),
        leading: DynamicAvatar(
          emojiOffset: Platform.isIOS ? Offset(6, 2) : Offset(3, -1),
          icon: project.iconType == IconSelectionType.icon.name
              ? IconData(project.iconCodePoint!, fontFamily: 'MaterialIcons')
              : null,
          emoji: project.iconType == IconSelectionType.emoji.name
              ? project.iconEmoji
              : null,
          image:
              project.iconType == IconSelectionType.image.name &&
                  project.localImagePath != null
              ? FileImage(File(project.localImagePath!))
              : project.imageUrl != null
              ? NetworkImage(project.imageUrl!)
              : null,
          color: project.color != null
              ? HexColor.fromHex('#${project.color}')
              : colors.textMute,
        ),

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? colors.text : colors.textMute,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
        subtitle: Text(
          project.description ?? 'No description',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? colors.navy : colors.textMute.withAlpha(150),
            fontWeight: isSelected ? FontWeight.w600 : null,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              AppPageRoute.slideRight(AddProjectScreen(projectToEdit: project)),
            );
          },
          icon: Icon(Icons.chevron_right_rounded),
        ),
        onTap: onSelectProject,
      ),
    );
  }
}
