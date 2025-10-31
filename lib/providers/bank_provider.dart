import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';

// Stream provider for all wallet providers
final allWalletProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.walletProviders,
  )..orderBy([(w) => OrderingTerm.asc(w.name)])).watch();
});

// Stream provider for default wallet providers only
final defaultWalletProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.walletProviders)
        ..where((w) => w.isDefault.equals(true))
        ..orderBy([(w) => OrderingTerm.asc(w.name)]))
      .watch();
});

// Stream provider for custom (non-default) wallet providers only
final customWalletProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
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
final mobileMoneyProvidersProvider = StreamProvider<List<WalletProvider>>((ref) {
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
          .where((w) => w.name.toLowerCase().contains(lowerQuery) ||
              (w.description?.toLowerCase().contains(lowerQuery) ?? false))
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

final walletProviderRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return WalletProviderRepository(database);
});

class WalletProviderRepository {
  final AppDatabase _database;

  WalletProviderRepository(this._database);

  /// Create a new wallet provider
  Future<String> createWalletProvider({
    required String name,
    String? description,
    String? imageUrl,
    String? localImagePath,
    String? iconEmoji,
    int? iconCodePoint,
    String? iconType,
    String? color,
    String? websiteUrl,
    bool isFiatBank = false,
    bool isCrypto = false,
    bool isMobileMoney = false,
    bool isCreditCard = false,
    bool isDefault = false,
  }) async {
    final tempId = IdGenerator.tempWalletProvider();

    await _database
        .into(_database.walletProviders)
        .insert(
          WalletProvidersCompanion(
            id: Value(tempId),
            tempId: Value(tempId),
            name: Value(name),
            description: Value(description),
            imageUrl: Value(imageUrl),
            localImagePath: Value(localImagePath),
            iconEmoji: Value(iconEmoji),
            iconCodePoint: Value(iconCodePoint),
            iconType: Value(iconType ?? 'MaterialIcons'),
            color: Value(color),
            websiteUrl: Value(websiteUrl),
            isFiatBank: Value(isFiatBank),
            isCrypto: Value(isCrypto),
            isMobileMoney: Value(isMobileMoney),
            isCreditCard: Value(isCreditCard),
            isDefault: Value(isDefault),
            isSynced: const Value(false),
          ),
        );

    return tempId;
  }

  /// Update an existing wallet provider
  Future<void> updateWalletProvider({
    required String providerId,
    String? name,
    String? description,
    String? imageUrl,
    String? localImagePath,
    String? iconEmoji,
    int? iconCodePoint,
    String? iconType,
    String? color,
    String? websiteUrl,
    bool? isFiatBank,
    bool? isCrypto,
    bool? isMobileMoney,
    bool? isCreditCard,
  }) async {
    // Check if provider is default
    final provider = await (_database.select(
      _database.walletProviders,
    )..where((w) => w.id.equals(providerId))).getSingleOrNull();

    if (provider == null) {
      throw Exception('Wallet provider not found');
    }

    if (provider.isDefault) {
      throw Exception('Cannot update default wallet providers');
    }

    await (_database.update(
      _database.walletProviders,
    )..where((w) => w.id.equals(providerId))).write(
      WalletProvidersCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        description: Value(description),
        imageUrl: Value(imageUrl),
        localImagePath: Value(localImagePath),
        iconEmoji: Value(iconEmoji),
        iconCodePoint: Value(iconCodePoint),
        iconType: iconType != null ? Value(iconType) : const Value.absent(),
        color: Value(color),
        websiteUrl: Value(websiteUrl),
        isFiatBank: isFiatBank != null ? Value(isFiatBank) : const Value.absent(),
        isCrypto: isCrypto != null ? Value(isCrypto) : const Value.absent(),
        isMobileMoney: isMobileMoney != null ? Value(isMobileMoney) : const Value.absent(),
        isCreditCard: isCreditCard != null ? Value(isCreditCard) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a wallet provider (only if not default and not used in any wallets)
  Future<void> deleteWalletProvider(String providerId) async {
    // Check if provider is default
    final provider = await (_database.select(
      _database.walletProviders,
    )..where((w) => w.id.equals(providerId))).getSingleOrNull();

    if (provider == null) {
      throw Exception('Wallet provider not found');
    }

    if (provider.isDefault) {
      throw Exception('Cannot delete default wallet providers');
    }

    // Check if any wallets use this provider
    final walletsWithProvider = await (_database.select(
      _database.wallets,
    )..where((w) => w.providerId.equals(providerId))).get();

    if (walletsWithProvider.isNotEmpty) {
      throw Exception(
        'Cannot delete wallet provider - ${walletsWithProvider.length} wallets use this provider',
      );
    }

    // Delete provider metadata first
    await (_database.delete(
      _database.walletProviderMetadata,
    )..where((m) => m.providerId.equals(providerId))).go();

    // Delete the provider
    await (_database.delete(
      _database.walletProviders,
    )..where((w) => w.id.equals(providerId))).go();
  }

  /// Get wallet provider by ID
  Future<WalletProvider?> getWalletProvider(String providerId) async {
    return await (_database.select(
      _database.walletProviders,
    )..where((w) => w.id.equals(providerId))).getSingleOrNull();
  }

  /// Get all wallet providers
  Future<List<WalletProvider>> getAllWalletProviders() async {
    return await (_database.select(
      _database.walletProviders,
    )..orderBy([(w) => OrderingTerm.asc(w.name)])).get();
  }

  /// Get default wallet providers
  Future<List<WalletProvider>> getDefaultWalletProviders() async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.isDefault.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get custom wallet providers
  Future<List<WalletProvider>> getCustomWalletProviders() async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.isDefault.equals(false))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get fiat bank providers
  Future<List<WalletProvider>> getFiatBankProviders() async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.isFiatBank.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get crypto providers
  Future<List<WalletProvider>> getCryptoProviders() async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.isCrypto.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get mobile money providers
  Future<List<WalletProvider>> getMobileMoneyProviders() async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.isMobileMoney.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get credit card providers
  Future<List<WalletProvider>> getCreditCardProviders() async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.isCreditCard.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Search wallet providers by name or description
  Future<List<WalletProvider>> searchWalletProviders(String query) async {
    return await (_database.select(_database.walletProviders)
          ..where((w) => w.name.contains(query) | w.description.contains(query))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Stream all wallet providers
  Stream<List<WalletProvider>> watchAllWalletProviders() {
    return (_database.select(
      _database.walletProviders,
    )..orderBy([(w) => OrderingTerm.asc(w.name)])).watch();
  }

  /// Stream default wallet providers
  Stream<List<WalletProvider>> watchDefaultWalletProviders() {
    return (_database.select(_database.walletProviders)
          ..where((w) => w.isDefault.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream custom wallet providers
  Stream<List<WalletProvider>> watchCustomWalletProviders() {
    return (_database.select(_database.walletProviders)
          ..where((w) => w.isDefault.equals(false))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream fiat bank providers
  Stream<List<WalletProvider>> watchFiatBankProviders() {
    return (_database.select(_database.walletProviders)
          ..where((w) => w.isFiatBank.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream crypto providers
  Stream<List<WalletProvider>> watchCryptoProviders() {
    return (_database.select(_database.walletProviders)
          ..where((w) => w.isCrypto.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream mobile money providers
  Stream<List<WalletProvider>> watchMobileMoneyProviders() {
    return (_database.select(_database.walletProviders)
          ..where((w) => w.isMobileMoney.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream credit card providers
  Stream<List<WalletProvider>> watchCreditCardProviders() {
    return (_database.select(_database.walletProviders)
          ..where((w) => w.isCreditCard.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Add metadata to a wallet provider
  Future<void> addWalletProviderMetadata({
    required String providerId,
    required String key,
    required String value,
  }) async {
    await _database
        .into(_database.walletProviderMetadata)
        .insert(
          WalletProviderMetadataCompanion(
            providerId: Value(providerId),
            key: Value(key),
            value: Value(value),
          ),
        );
  }

  /// Get all metadata for a wallet provider
  Future<List<WalletProviderMetadataData>> getWalletProviderMetadata(
    String providerId,
  ) async {
    return await (_database.select(
      _database.walletProviderMetadata,
    )..where((m) => m.providerId.equals(providerId))).get();
  }

  /// Get specific metadata value
  Future<String?> getWalletProviderMetadataValue(
    String providerId,
    String key,
  ) async {
    final metadata =
        await (_database.select(_database.walletProviderMetadata)..where(
              (m) => m.providerId.equals(providerId) & m.key.equals(key),
            ))
            .getSingleOrNull();

    return metadata?.value;
  }

  /// Update metadata value
  Future<void> updateWalletProviderMetadata({
    required String providerId,
    required String key,
    required String value,
  }) async {
    await (_database.update(_database.walletProviderMetadata)
          ..where((m) => m.providerId.equals(providerId) & m.key.equals(key)))
        .write(WalletProviderMetadataCompanion(value: Value(value)));
  }

  /// Delete specific metadata
  Future<void> deleteWalletProviderMetadata(String providerId, String key) async {
    await (_database.delete(
      _database.walletProviderMetadata,
    )..where((m) => m.providerId.equals(providerId) & m.key.equals(key))).go();
  }

  /// Delete all metadata for a wallet provider
  Future<void> deleteAllWalletProviderMetadata(String providerId) async {
    await (_database.delete(
      _database.walletProviderMetadata,
    )..where((m) => m.providerId.equals(providerId))).go();
  }
}
