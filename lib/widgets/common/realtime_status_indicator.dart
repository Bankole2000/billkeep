import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/realtime_provider.dart';

/// Widget that shows the real-time sync connection status
///
/// Displays a small indicator showing whether the app is connected
/// to PocketBase's real-time updates
class RealtimeStatusIndicator extends ConsumerWidget {
  final bool showLabel;
  final bool compact;

  const RealtimeStatusIndicator({
    super.key,
    this.showLabel = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realtimeState = ref.watch(realtimeSyncProvider);

    if (compact) {
      return _buildCompactIndicator(realtimeState);
    }

    return _buildFullIndicator(context, realtimeState);
  }

  /// Compact version - just an icon with color
  Widget _buildCompactIndicator(RealtimeSyncState state) {
    IconData icon;
    Color color;

    switch (state.status) {
      case RealtimeStatus.connected:
        icon = Icons.sync;
        color = Colors.green;
        break;
      case RealtimeStatus.connecting:
        icon = Icons.sync;
        color = Colors.orange;
        break;
      case RealtimeStatus.error:
        icon = Icons.sync_problem;
        color = Colors.red;
        break;
      case RealtimeStatus.disconnected:
        icon = Icons.sync_disabled;
        color = Colors.grey;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }

  /// Full version - icon, label, and optional details
  Widget _buildFullIndicator(BuildContext context, RealtimeSyncState state) {
    IconData icon;
    Color color;
    String label;

    switch (state.status) {
      case RealtimeStatus.connected:
        icon = Icons.cloud_done;
        color = Colors.green;
        label = 'Live';
        break;
      case RealtimeStatus.connecting:
        icon = Icons.cloud_sync;
        color = Colors.orange;
        label = 'Connecting...';
        break;
      case RealtimeStatus.error:
        icon = Icons.cloud_off;
        color = Colors.red;
        label = 'Offline';
        break;
      case RealtimeStatus.disconnected:
        icon = Icons.cloud_off;
        color = Colors.grey;
        label = 'Disconnected';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Widget that shows a banner when realtime connection is lost
class RealtimeConnectionBanner extends ConsumerWidget {
  const RealtimeConnectionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realtimeState = ref.watch(realtimeSyncProvider);

    if (realtimeState.isConnected || realtimeState.isConnecting) {
      return const SizedBox.shrink();
    }

    return MaterialBanner(
      backgroundColor: realtimeState.hasError ? Colors.red.shade50 : Colors.grey.shade200,
      leading: Icon(
        Icons.cloud_off,
        color: realtimeState.hasError ? Colors.red : Colors.grey,
      ),
      content: Text(
        realtimeState.hasError
            ? 'Real-time updates unavailable'
            : 'Not connected to real-time updates',
        style: TextStyle(
          color: realtimeState.hasError ? Colors.red.shade900 : Colors.grey.shade900,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(realtimeSyncProvider.notifier).startListening();
          },
          child: const Text('Reconnect'),
        ),
      ],
    );
  }
}

/// Button to toggle realtime sync on/off
class RealtimeSyncButton extends ConsumerWidget {
  const RealtimeSyncButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realtimeState = ref.watch(realtimeSyncProvider);

    return IconButton(
      icon: Icon(
        realtimeState.isConnected ? Icons.sync : Icons.sync_disabled,
        color: realtimeState.isConnected ? Colors.green : Colors.grey,
      ),
      tooltip: realtimeState.isConnected
          ? 'Real-time sync active'
          : 'Start real-time sync',
      onPressed: () {
        if (realtimeState.isConnected) {
          ref.read(realtimeSyncProvider.notifier).stopListening();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Real-time sync stopped')),
          );
        } else {
          ref.read(realtimeSyncProvider.notifier).startListening();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Real-time sync started')),
          );
        }
      },
    );
  }
}

/// Detailed realtime status card (for settings/debug)
class RealtimeStatusCard extends ConsumerWidget {
  const RealtimeStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realtimeState = ref.watch(realtimeSyncProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Real-time Sync',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                RealtimeStatusIndicator(showLabel: true),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              'Status',
              _getStatusLabel(realtimeState.status),
              _getStatusColor(realtimeState.status),
            ),
            if (realtimeState.isConnected) ...[
              const SizedBox(height: 8),
              _buildStatusRow(
                'Collections',
                realtimeState.collections.join(', '),
                Colors.black87,
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                'Connected since',
                _formatDuration(
                  DateTime.now().difference(realtimeState.connectedAt!),
                ),
                Colors.black87,
              ),
            ],
            if (realtimeState.hasError) ...[
              const SizedBox(height: 8),
              Text(
                realtimeState.errorMessage ?? 'Unknown error',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: realtimeState.isConnecting
                    ? null
                    : () {
                        if (realtimeState.isConnected) {
                          ref.read(realtimeSyncProvider.notifier).stopListening();
                        } else {
                          ref.read(realtimeSyncProvider.notifier).startListening();
                        }
                      },
                icon: Icon(
                  realtimeState.isConnected ? Icons.stop : Icons.play_arrow,
                ),
                label: Text(
                  realtimeState.isConnecting
                      ? 'Connecting...'
                      : realtimeState.isConnected
                          ? 'Stop Sync'
                          : 'Start Sync',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: valueColor),
        ),
      ],
    );
  }

  String _getStatusLabel(RealtimeStatus status) {
    switch (status) {
      case RealtimeStatus.connected:
        return 'Connected';
      case RealtimeStatus.connecting:
        return 'Connecting';
      case RealtimeStatus.error:
        return 'Error';
      case RealtimeStatus.disconnected:
        return 'Disconnected';
    }
  }

  Color _getStatusColor(RealtimeStatus status) {
    switch (status) {
      case RealtimeStatus.connected:
        return Colors.green;
      case RealtimeStatus.connecting:
        return Colors.orange;
      case RealtimeStatus.error:
        return Colors.red;
      case RealtimeStatus.disconnected:
        return Colors.grey;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds}s';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
  }
}
