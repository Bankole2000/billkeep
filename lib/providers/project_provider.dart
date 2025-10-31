import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'database_provider.dart';

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

final projectRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return ProjectRepository(database);
});

class ProjectRepository {
  final AppDatabase _database;

  ProjectRepository(this._database);

  Future<String> createProject({
    required String name,
    String? description,
    String? emoji,
    String? imageUrl,
    String? localImagePath,
    String? color,
    required String iconType,
    int? iconCodePoint,
    bool? isArchived,
  }) async {
    final tempId = IdGenerator.tempProject();

    print('Creating project with ID: $tempId');

    try {
      await _database.createProject(
        ProjectsCompanion(
          id: drift.Value(tempId),
          tempId: drift.Value(tempId),
          name: drift.Value(name),
          description: drift.Value(description),
          isSynced: const drift.Value(false),
          iconType: drift.Value(iconType),
          iconEmoji: drift.Value(emoji),
          imageUrl: drift.Value(imageUrl),
          localImagePath: drift.Value(localImagePath),
          iconCodePoint: drift.Value(iconCodePoint),
          color: drift.Value(color),
          isArchived: drift.Value(isArchived!),
        ),
      );
    } catch (e) {
      print('Error creating project: $e');
    }

    print('Project created successfully');

    return tempId;
  }

  // Called after server responds with canonical ID
  Future<void> updateProjectWithCanonicalId({
    required String tempId,
    required String canonicalId,
  }) async {
    // Map the IDs
    await _database.mapId(
      tempId: tempId,
      canonicalId: canonicalId,
      resourceType: 'project',
    );

    // Update project with canonical ID
    await (_database.update(
      _database.projects,
    )..where((t) => t.id.equals(tempId))).write(
      ProjectsCompanion(
        id: drift.Value(canonicalId),
        isSynced: const drift.Value(true),
      ),
    );
  }

  Stream<List<Project>> watchAllProjects() {
    return _database.select(_database.projects).watch();
  }

  // Get unsynced projects for sending to server
  Future<List<Project>> getUnsyncedProjects() {
    return (_database.select(
      _database.projects,
    )..where((t) => t.isSynced.equals(false))).get();
  }

  // Future<void> updateProjectBudget({
  //   required String projectId,
  //   required int budgetAmount,
  //   required String budgetType,
  //   String? budgetFrequency,
  // }) async {
  //   await (_database.update(
  //     _database.projects,
  //   )..where((p) => p.id.equals(projectId))).write(
  //     ProjectsCompanion(
  //       budgetAmount: drift.Value(budgetAmount),
  //       budgetType: drift.Value(budgetType),
  //       budgetFrequency: drift.Value(budgetFrequency),
  //     ),
  //   );
  // }

  Future<String> updateProject({
    required String projectId,
    required String name,
    String? description,
    String? emoji,
    String? imageUrl,
    String? localImagePath,
    String? color,
    required String iconType,
    int? iconCodePoint,
    bool? isArchived,
  }) async {
    try {
      await (_database.update(
        _database.projects,
      )..where((p) => p.id.equals(projectId))).write(
        ProjectsCompanion(
          name: drift.Value(name),
          description: drift.Value(description),
          isSynced: const drift.Value(false),
          iconType: drift.Value(iconType),
          iconEmoji: drift.Value(emoji),
          imageUrl: drift.Value(imageUrl),
          localImagePath: drift.Value(localImagePath),
          iconCodePoint: drift.Value(iconCodePoint),
          color: drift.Value(color),
          isArchived: drift.Value(isArchived!),
        ),
      );
    } catch (e) {
      print('Error creating project: $e');
    }
    print('Project created successfully');

    return projectId;
  }

  Future<void> deleteProject(String projectId) async {
    await (_database.delete(
      _database.projects,
    )..where((p) => p.id.equals(projectId))).go();
  }

  Future<void> toggleArchiveProject(String projectId, bool isArchived) async {
    await (_database.update(_database.projects)
          ..where((p) => p.id.equals(projectId)))
        .write(ProjectsCompanion(isArchived: drift.Value(isArchived)));
  }
}
