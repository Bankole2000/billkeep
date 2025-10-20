// my_bottom_sheet.dart
// import 'package:billkeep/screens/projects/settings_screen.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/screens/projects/project_details_screen.dart';
import 'package:billkeep/screens/settings/settings_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/projects/add_project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectSelectBottomSheet extends ConsumerWidget {
  const ProjectSelectBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: 600,
        color: Colors.black87,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Divider(height: 1),
            Expanded(
              child: projectsAsync.when(
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
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    "https://avatars.githubusercontent.com/u/23138415?v=4",
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    project.description ??
                                        'No Description given',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),

                              const Spacer(),
                              if (!project.isSynced)
                                const Icon(
                                  Icons.cloud_off,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              IconButton(
                                onPressed: () {
                                  print('Project settings');
                                },
                                icon: Icon(Icons.chevron_right, size: 30),
                                style: IconButton.styleFrom(
                                  shape: CircleBorder(),
                                  backgroundColor:
                                      Colors.transparent, // Background color
                                  padding: EdgeInsets.all(
                                    8,
                                  ), // Makes the button larger
                                ),
                              ),
                              const SizedBox(width: 5),

                              // Card(
                              //   margin: const EdgeInsets.symmetric(
                              //     horizontal: 16,
                              //     vertical: 8,
                              //   ),
                              //   child: ListTile(
                              //     title: Text(project.name),
                              //     subtitle: project.description != null
                              //         ? Text(project.description!)
                              //         : null,
                              //     trailing: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: [
                              //         if (!project.isSynced)
                              //           const Icon(
                              //             Icons.cloud_off,
                              //             size: 16,
                              //             color: Colors.orange,
                              //           ),
                              //         const SizedBox(width: 8),
                              //         const Icon(Icons.chevron_right),
                              //       ],
                              //     ),
                              //     onTap: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               ProjectDetailScreen(
                              //                 project: project,
                              //               ),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),

            SizedBox(height: 16),
            AddProjectButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
