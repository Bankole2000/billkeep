import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/wallet_repository.dart';
import '../repositories/project_repository.dart';
import '../services/wallet_service.dart';
import '../services/project_service.dart';
import '../services/sync/realtime_sync_service.dart';
import '../services/sync/sync_coordinator.dart';
import '../services/pocketbase_realtime_service.dart';
import 'database_provider.dart';

/// Provider for WalletService with injected WalletRepository
final walletServiceProvider = Provider<WalletService>((ref) {
  final database = ref.watch(databaseProvider);
  final repository = WalletRepository(database);
  return WalletService(repository);
});

/// Provider for ProjectService with injected ProjectRepository
final projectServiceProvider = Provider<ProjectService>((ref) {
  final database = ref.watch(databaseProvider);
  final repository = ProjectRepository(database);
  return ProjectService(repository);
});

/// Provider for PocketBase Realtime Service (singleton)
final pocketbaseRealtimeServiceProvider = Provider<PocketBaseRealtimeService>((ref) {
  return PocketBaseRealtimeService();
});

/// Provider for RealtimeSyncService with all dependencies
final realtimeSyncServiceProvider = Provider<RealtimeSyncService>((ref) {
  final database = ref.watch(databaseProvider);
  final realtimeService = ref.watch(pocketbaseRealtimeServiceProvider);
  final walletRepository = WalletRepository(database);
  final projectRepository = ProjectRepository(database);

  return RealtimeSyncService(
    realtimeService: realtimeService,
    walletRepository: walletRepository,
    projectRepository: projectRepository,
  );
});

/// Provider for SyncCoordinator with all dependencies
final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final database = ref.watch(databaseProvider);
  final projectRepository = ProjectRepository(database);

  return SyncCoordinator(
    database: database,
    projectRepository: projectRepository,
  );
});
