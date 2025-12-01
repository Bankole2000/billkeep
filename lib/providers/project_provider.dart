import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/project_model.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'database_provider.dart';
import '../repositories/project_repository.dart';

class ActiveProjectState {
  final Project? project;
  final bool isLoading;
  final String? error;

  ActiveProjectState({this.project, required this.isLoading, this.error});
}

class ActiveProjectNotifier extends Notifier<ActiveProjectState> {
  @override
  ActiveProjectState build() {
    final projects = ref.watch(projectsProvider);
    return projects.when(
      data: (p) => ActiveProjectState(
        project: p.isEmpty ? null : p[0],
        isLoading: false,
      ),
      loading: () => ActiveProjectState(project: null, isLoading: true),
      error: (error, stack) => ActiveProjectState(
        project: null,
        isLoading: false,
        error: error.toString(),
      ),
    );
  }

  void setActiveProject(Project project) {
    if (state.project == null || state.project?.id != project.id) {
      state = ActiveProjectState(isLoading: false, project: project);
    }
  }
}

final activeProjectProvider =
    NotifierProvider<ActiveProjectNotifier, ActiveProjectState>(
      ActiveProjectNotifier.new,
    );

final projectsProvider = StreamProvider<List<Project>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.projects).watch();
});


