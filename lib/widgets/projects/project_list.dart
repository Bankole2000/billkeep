import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/screens/projects/project_details_screen.dart';
import 'package:billkeep/providers/project_provider.dart';

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

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
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: "https://avatars.githubusercontent.com/u/23138415?v=4",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    httpHeaders: const {
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                    },
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                title: Text(project.name),
                subtitle: project.description != null
                    ? Text(project.description!)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!project.isSynced)
                      const Icon(
                        Icons.cloud_off,
                        size: 16,
                        color: Colors.orange,
                      ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectDetailScreen(project: project),
                    ),
                  );
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
