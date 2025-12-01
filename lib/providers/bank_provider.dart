import 'package:billkeep/models/wallet_provider_metadata_model.dart';
import 'package:billkeep/models/wallet_provider_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'database_provider.dart';
import 'package:billkeep/repositories/wallet_provider_repository.dart';

// Stream provider for all wallet providers
final allWalletProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.walletProviders,
  )..orderBy([(w) => OrderingTerm.asc(w.name)])).watch();
});

// Stream provider for default wallet providers only
final defaultWalletProvidersProvider = StreamProvider<List<WalletProvider>>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isDefault.equals(true))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for custom (non-default) wallet providers only
final customWalletProvidersProvider = StreamProvider<List<WalletProvider>>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isDefault.equals(false))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for fiat bank providers only
final fiatBankProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isFiatBank.equals(true))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for crypto providers only
final cryptoProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isCrypto.equals(true))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for mobile money providers only
final mobileMoneyProvidersProvider = StreamProvider<List<WalletProvider>>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isMobileMoney.equals(true))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for credit card providers only
final creditCardProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isCreditCard.equals(true))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

final walletProviderSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredWalletProvidersProvider = Provider<List<WalletProvider>>((ref) {
  final query = ref.watch(walletProviderSearchQueryProvider);
  final providersAsync = ref.watch(allWalletProvidersProvider);

  return providersAsync.when(
    data: (providers) {
      if (query.isEmpty) return providers;
      final lowerQuery = query.toLowerCase();
      return providers
          .where(
            (w) =>
                w.name.toLowerCase().contains(lowerQuery) ||
                (w.description?.toLowerCase().contains(lowerQuery) ?? false),
          )
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Stream provider family for a single wallet provider
final walletProviderProvider = StreamProviderFamily<WalletProvider?, String>((
  ref,
  providerId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.walletProviders,
  )..where((w) => w.id.equals(providerId))).watchSingleOrNull();
});
