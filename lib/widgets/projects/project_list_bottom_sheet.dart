import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/screens/projects/project_details_screen.dart';
import 'package:billkeep/providers/project_provider.dart';

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    final activeProject = ref.watch(activeProjectProvider);

    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return const Center(
            child: Text('No projects yet. Tap + to create one.'),
          );
        }

        return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: activeProject.project?.id == project.id
                      ? activeColor
                      : Colors.grey.shade400,
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                contentPadding: EdgeInsets.only(
                  left: 10,
                  right: 3,
                  top: -1,
                  bottom: 1,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    "https://avatars.githubusercontent.com/u/23138415?v=4",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  project.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  project.description ?? 'No Description given',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (activeProject.project?.id == project.id)
                      IconButton(
                        onPressed: () {
                          print('Project settings');
                        },
                        icon: Icon(Icons.star, size: 24, color: activeColor),
                        style: IconButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor:
                              Colors.transparent, // Background color
                          padding: EdgeInsets.all(2), // Makes the button larger
                        ),
                      ),
                    // const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          AppPageRoute.slideRight(
                            ProjectDetailScreen(project: project),
                          ),
                        );
                      },
                      icon: Icon(Icons.chevron_right, size: 24),
                      style: IconButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.transparent, // Background color
                        padding: EdgeInsets.all(2), // Makes the button larger
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  ref
                      .read(activeProjectProvider.notifier)
                      .setActiveProject(project);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
