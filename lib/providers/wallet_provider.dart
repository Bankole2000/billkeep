import 'package:billkeep/models/wallet_model.dart';
import 'package:billkeep/utils/currency_helper.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'database_provider.dart';
import '../repositories/wallet_repository.dart';

/// Model class for wallet with related currency and provider data
class WalletWithRelations {
  final Wallet wallet;
  final Currency currency;
  final WalletProvider? provider;

  WalletWithRelations({
    required this.wallet,
    required this.currency,
    this.provider,
  });
}

class ActiveWalletState {
  final Wallet? wallet;
  final bool isLoading;
  final String? error;

  ActiveWalletState({this.wallet, required this.isLoading, this.error});
}

class ActiveWalletNotifier extends Notifier<ActiveWalletState> {
  @override
  ActiveWalletState build() {
    final wallets = ref.watch(walletsProvider);
    return wallets.when(
      data: (w) =>
          ActiveWalletState(wallet: w.isEmpty ? null : w[0], isLoading: false),
      loading: () => ActiveWalletState(wallet: null, isLoading: true),
      error: (error, stack) => ActiveWalletState(
        wallet: null,
        isLoading: false,
        error: error.toString(),
      ),
    );
  }

  void setActiveWallet(Wallet wallet) {
    if (state.wallet == null || state.wallet?.id != wallet.id) {
      state = ActiveWalletState(isLoading: false, wallet: wallet);
    }
  }
}

final activeWalletProvider =
    NotifierProvider<ActiveWalletNotifier, ActiveWalletState>(
      ActiveWalletNotifier.new,
    );

// Stream provider for all wallets
final walletsProvider = StreamProvider<List<Wallet>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.wallets,
  )..orderBy([(w) => drift.OrderingTerm.asc(w.name)])).watch();
});

// Stream provider for all wallets with related data (currency and provider)
final walletsWithRelationsProvider = StreamProvider<List<WalletWithRelations>>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  final query = database.select(database.wallets).join([
    innerJoin(
      database.currencies,
      database.currencies.code.equalsExp(database.wallets.currency),
    ),
    leftOuterJoin(
      database.walletProviders,
      database.walletProviders.id.equalsExp(database.wallets.providerId),
    ),
  ])..orderBy([drift.OrderingTerm.asc(database.wallets.name)]);

  return query.watch().map((rows) {
    return rows.map((row) {
      return WalletWithRelations(
        wallet: row.readTable(database.wallets),
        currency: row.readTable(database.currencies),
        provider: row.readTableOrNull(database.walletProviders),
      );
    }).toList();
  });
});

// Stream provider for global wallets only
final globalWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.wallets)
        ..where((w) => w.isGlobal.equals(true))
        ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for global wallets with relations
final globalWalletsWithRelationsProvider =
    StreamProvider<List<WalletWithRelations>>((ref) {
      final database = ref.watch(databaseProvider);
      final query =
          database.select(database.wallets).join([
              innerJoin(
                database.currencies,
                database.currencies.code.equalsExp(database.wallets.currency),
              ),
              leftOuterJoin(
                database.walletProviders,
                database.walletProviders.id.equalsExp(
                  database.wallets.providerId,
                ),
              ),
            ])
            ..where(database.wallets.isGlobal.equals(true))
            ..orderBy([drift.OrderingTerm.asc(database.wallets.name)]);

      return query.watch().map((rows) {
        return rows.map((row) {
          return WalletWithRelations(
            wallet: row.readTable(database.wallets),
            currency: row.readTable(database.currencies),
            provider: row.readTableOrNull(database.walletProviders),
          );
        }).toList();
      });
    });

// Stream provider for project-specific wallets
final projectWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.wallets)
        ..where((w) => w.isGlobal.equals(false))
        ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for project-specific wallets with relations
final projectWalletsWithRelationsProvider =
    StreamProvider<List<WalletWithRelations>>((ref) {
      final database = ref.watch(databaseProvider);
      final query =
          database.select(database.wallets).join([
              innerJoin(
                database.currencies,
                database.currencies.code.equalsExp(database.wallets.currency),
              ),
              leftOuterJoin(
                database.walletProviders,
                database.walletProviders.id.equalsExp(
                  database.wallets.providerId,
                ),
              ),
            ])
            ..where(database.wallets.isGlobal.equals(false))
            ..orderBy([drift.OrderingTerm.asc(database.wallets.name)]);

      return query.watch().map((rows) {
        return rows.map((row) {
          return WalletWithRelations(
            wallet: row.readTable(database.wallets),
            currency: row.readTable(database.currencies),
            provider: row.readTableOrNull(database.walletProviders),
          );
        }).toList();
      });
    });

// Stream provider for wallets by type
final walletsByTypeProvider = StreamProviderFamily<List<Wallet>, String>((
  ref,
  walletType,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.wallets)
        ..where((w) => w.walletType.equals(walletType))
        ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider family for a single wallet
final walletProvider = StreamProviderFamily<Wallet?, String>((ref, walletId) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.wallets,
  )..where((w) => w.id.equals(walletId))).watchSingleOrNull();
});

// Stream provider family for a single wallet with relations
final walletWithRelationsProvider =
    StreamProviderFamily<WalletWithRelations?, String>((ref, walletId) {
      final database = ref.watch(databaseProvider);
      final query = database.select(database.wallets).join([
        innerJoin(
          database.currencies,
          database.currencies.code.equalsExp(database.wallets.currency),
        ),
        leftOuterJoin(
          database.walletProviders,
          database.walletProviders.id.equalsExp(database.wallets.providerId),
        ),
      ])..where(database.wallets.id.equals(walletId));

      return query.watchSingleOrNull().map((row) {
        if (row == null) return null;
        return WalletWithRelations(
          wallet: row.readTable(database.wallets),
          currency: row.readTable(database.currencies),
          provider: row.readTableOrNull(database.walletProviders),
        );
      });
    });


