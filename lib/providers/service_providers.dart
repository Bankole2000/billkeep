import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/wallet_service.dart';
import '../services/project_service.dart';
import '../services/sync/realtime_sync_service.dart';
import '../services/sync/sync_coordinator.dart';
import '../services/pocketbase_realtime_service.dart';
import 'wallet_provider.dart';
import 'project_provider.dart';
import 'database_provider.dart';

/// Provider for WalletService with injected WalletRepository
final walletServiceProvider = Provider<WalletService>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return WalletService(repository);
});

/// Provider for ProjectService with injected ProjectRepository
final projectServiceProvider = Provider<ProjectService>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectService(repository);
});

/// Provider for PocketBase Realtime Service (singleton)
final pocketbaseRealtimeServiceProvider = Provider<PocketBaseRealtimeService>((ref) {
  return PocketBaseRealtimeService();
});

/// Provider for RealtimeSyncService with all dependencies
final realtimeSyncServiceProvider = Provider<RealtimeSyncService>((ref) {
  final realtimeService = ref.watch(pocketbaseRealtimeServiceProvider);
  final walletRepository = ref.watch(walletRepositoryProvider);
  final projectRepository = ref.watch(projectRepositoryProvider);

  return RealtimeSyncService(
    realtimeService: realtimeService,
    walletRepository: walletRepository,
    projectRepository: projectRepository,
  );
});

/// Provider for SyncCoordinator with all dependencies
final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final database = ref.watch(databaseProvider);
  final projectRepository = ref.watch(projectRepositoryProvider);

  return SyncCoordinator(
    database: database,
    projectRepository: projectRepository,
  );
});
