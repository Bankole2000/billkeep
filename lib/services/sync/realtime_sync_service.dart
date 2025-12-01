import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/repositories/project_repository.dart';
import 'package:billkeep/repositories/wallet_repository.dart';
import 'package:billkeep/services/pocketbase_realtime_service.dart';
import 'package:billkeep/services/logging_service.dart';

/// Realtime Sync Service
///
/// Listens to PocketBase realtime events (SSE) and updates local database
/// when records are created, updated, or deleted on the backend
class RealtimeSyncService {
  final PocketBaseRealtimeService _realtimeService;
  final WalletRepository _walletRepository;
  final ProjectRepository _projectRepository;

  RealtimeSyncService({
    required PocketBaseRealtimeService realtimeService,
    required WalletRepository walletRepository,
    required ProjectRepository projectRepository,
  }) : _realtimeService = realtimeService,
       _walletRepository = walletRepository,
       _projectRepository = projectRepository;

  /// Start listening to all relevant collections
  Future<void> startSync() async {
    await _realtimeService.initialize();

    // Subscribe to wallets collection
    _subscribeToWallets();

    // Subscribe to projects collection
    _subscribeToProjects();

    LoggingService.info('Realtime sync started');
  }

  /// Subscribe to wallet changes
  void _subscribeToWallets() {
    _realtimeService
        .subscribe('wallets')
        .listen(
          (event) async {
            try {
              if (event.isCreate || event.isUpdate) {
                await _handleWalletCreateOrUpdate(event);
              } else if (event.isDelete) {
                await _handleWalletDelete(event);
              }
            } catch (e, stackTrace) {
              LoggingService.error(
                'Error handling wallet realtime event',
                error: e,
                stackTrace: stackTrace,
              );
            }
          },
          onError: (error) {
            LoggingService.error(
              'Wallet realtime subscription error',
              error: error,
            );
          },
        );
  }

  /// Subscribe to project changes
  void _subscribeToProjects() {
    _realtimeService
        .subscribe('projects')
        .listen(
          (event) async {
            try {
              if (event.isCreate || event.isUpdate) {
                await _handleProjectCreateOrUpdate(event);
              } else if (event.isDelete) {
                await _handleProjectDelete(event);
              }
            } catch (e, stackTrace) {
              LoggingService.error(
                'Error handling project realtime event',
                error: e,
                stackTrace: stackTrace,
              );
            }
          },
          onError: (error) {
            LoggingService.error(
              'Project realtime subscription error',
              error: error,
            );
          },
        );
  }

  /// Handle wallet create or update from backend
  Future<void> _handleWalletCreateOrUpdate(RealtimeEvent event) async {
    final walletData = event.record!;
    final canonicalId = walletData['id'] as String;

    LoggingService.debug(
      'Syncing wallet from backend',
      data: {'id': canonicalId, 'action': event.action},
    );

    // Check if we have a local wallet with this ID (temp or canonical)
    final existingWallet = await _walletRepository.getWallet(canonicalId);

    if (existingWallet != null && existingWallet.isSynced) {
      // Already synced, just update if needed
      await _updateExistingWallet(canonicalId, walletData);
    } else {
      // This might be a response to our local create
      // Find if there's an unsynced wallet with matching data
      final unsyncedWallets = await _walletRepository.getUnsyncedWallets();

      final matchingLocal = unsyncedWallets.cast<dynamic>().firstWhere(
        (w) =>
            w.name == walletData['name'] &&
            w.walletType == walletData['walletType'],
        orElse: () => null,
      );

      if (matchingLocal != null) {
        // Update temp ID with canonical ID
        await _walletRepository.updateWalletWithCanonicalId(
          tempId: matchingLocal.id,
          canonicalId: canonicalId,
        );

        LoggingService.info(
          'Wallet synced: temp ID replaced with canonical ID',
          data: {'tempId': matchingLocal.id, 'canonicalId': canonicalId},
        );
      } else {
        // This is a new wallet from another client/session
        // We need to insert it into local DB
        await _insertWalletFromBackend(walletData);
      }
    }
  }

  /// Handle wallet delete from backend
  Future<void> _handleWalletDelete(RealtimeEvent event) async {
    final walletId = event.recordId;

    LoggingService.debug(
      'Deleting wallet from local DB',
      data: {'id': walletId},
    );

    try {
      await _walletRepository.deleteWallet(walletId);
    } catch (e) {
      LoggingService.error('Failed to delete wallet locally', error: e);
    }
  }

  /// Handle project create or update from backend
  Future<void> _handleProjectCreateOrUpdate(RealtimeEvent event) async {
    final projectData = event.record!;
    final canonicalId = projectData['id'] as String;

    LoggingService.debug(
      'Syncing project from backend',
      data: {'id': canonicalId, 'action': event.action},
    );

    // Find if there's an unsynced project with matching data
    final unsyncedProjects = await _projectRepository.getUnsyncedProjects();

    final matchingLocal = unsyncedProjects.cast<dynamic>().firstWhere(
      (p) => p.name == projectData['name'],
      orElse: () => null,
    );

    if (matchingLocal != null) {
      // Update temp ID with canonical ID
      await _projectRepository.updateProjectWithCanonicalId(
        tempId: matchingLocal.id,
        canonicalId: canonicalId,
      );

      LoggingService.info(
        'Project synced: temp ID replaced with canonical ID',
        data: {'tempId': matchingLocal.id, 'canonicalId': canonicalId},
      );
    } else {
      // This is a new project from another client or an update
      // For now, we'll just log it. You might want to implement insert/update logic
      LoggingService.debug(
        'Project from another client',
        data: {'id': canonicalId, 'name': projectData['name']},
      );
    }
  }

  /// Handle project delete from backend
  Future<void> _handleProjectDelete(RealtimeEvent event) async {
    final projectId = event.recordId;

    LoggingService.debug(
      'Deleting project from local DB',
      data: {'id': projectId},
    );

    try {
      await _projectRepository.deleteProject(projectId);
    } catch (e) {
      LoggingService.error('Failed to delete project locally', error: e);
    }
  }

  /// Update existing wallet in local DB
  Future<void> _updateExistingWallet(
    String walletId,
    Map<String, dynamic> data,
  ) async {
    // Implement update logic if needed
    LoggingService.debug('Updating existing wallet', data: {'id': walletId});
  }

  /// Insert new wallet from backend into local DB
  Future<void> _insertWalletFromBackend(Map<String, dynamic> data) async {
    // This would require converting the backend data to local format
    // and inserting it. For now, we'll just log it.
    LoggingService.debug(
      'New wallet from another client',
      data: {'id': data['id'], 'name': data['name']},
    );

    // TODO: Implement insertion of wallets from other clients
    // This requires careful handling of the data transformation
  }

  /// Stop all subscriptions
  void stopSync() {
    _realtimeService.unsubscribeAll();
    LoggingService.info('Realtime sync stopped');
  }

  /// Dispose resources
  void dispose() {
    _realtimeService.dispose();
    LoggingService.info('Realtime sync service disposed');
  }
}
