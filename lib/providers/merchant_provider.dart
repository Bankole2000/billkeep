import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';

// Stream provider for all merchants
final allMerchantsProvider = StreamProvider<List<Merchant>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.merchants,
  )..orderBy([(m) => OrderingTerm.asc(m.name)])).watch();
});

// Stream provider for default merchants only
final defaultMerchantsProvider = StreamProvider<List<Merchant>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.merchants)
        ..where((m) => m.isDefault.equals(true))
        ..orderBy([(m) => OrderingTerm.asc(m.name)]))
      .watch();
});

// Stream provider for custom (non-default) merchants only
final customMerchantsProvider = StreamProvider<List<Merchant>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.merchants)
        ..where((m) => m.isDefault.equals(false))
        ..orderBy([(m) => OrderingTerm.asc(m.name)]))
      .watch();
});

final merchantSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredMerchantsProvider = Provider<List<Merchant>>((ref) {
  final query = ref.watch(merchantSearchQueryProvider);
  final merchantsAsync = ref.watch(allMerchantsProvider);

  return merchantsAsync.when(
    data: (merchants) {
      if (query.isEmpty) return merchants;
      final lowerQuery = query.toLowerCase();
      return merchants
          .where((m) => m.name.toLowerCase().contains(lowerQuery))
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Stream provider family for a single merchant
final merchantProvider = StreamProviderFamily<Merchant?, String>((
  ref,
  merchantId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.merchants,
  )..where((m) => m.id.equals(merchantId))).watchSingleOrNull();
});

final merchantRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return MerchantRepository(database);
});

class MerchantRepository {
  final AppDatabase _database;

  MerchantRepository(this._database);

  /// Create a new merchant
  Future<String> createMerchant({
    required String name,
    String? website,
    String? imageUrl,
    String? localImagePath,
    String? iconEmoji,
    int? iconCodePoint,
    String? iconType,
    String? color,
    bool isDefault = false,
  }) async {
    final tempId = IdGenerator.tempMerchant();

    await _database
        .into(_database.merchants)
        .insert(
          MerchantsCompanion(
            id: Value(tempId),
            tempId: Value(tempId),
            name: Value(name),
            website: Value(website),
            imageUrl: Value(imageUrl),
            localImagePath: Value(localImagePath),
            iconEmoji: Value(iconEmoji),
            iconCodePoint: Value(iconCodePoint),
            iconType: Value(iconType ?? 'MaterialIcons'),
            color: Value(color),
            isDefault: Value(isDefault),
            isSynced: const Value(false),
          ),
        );

    return tempId;
  }

  /// Update an existing merchant
  Future<void> updateMerchant({
    required String merchantId,
    String? name,
    String? website,
    String? imageUrl,
    String? localImagePath,
    String? iconEmoji,
    int? iconCodePoint,
    String? iconType,
    String? color,
  }) async {
    // Check if merchant is default
    final merchant = await (_database.select(
      _database.merchants,
    )..where((m) => m.id.equals(merchantId))).getSingleOrNull();

    if (merchant == null) {
      throw Exception('Merchant not found');
    }

    if (merchant.isDefault) {
      throw Exception('Cannot update default merchants');
    }

    await (_database.update(
      _database.merchants,
    )..where((m) => m.id.equals(merchantId))).write(
      MerchantsCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        website: Value(website),
        imageUrl: Value(imageUrl),
        localImagePath: Value(localImagePath),
        iconEmoji: Value(iconEmoji),
        iconCodePoint: Value(iconCodePoint),
        iconType: iconType != null ? Value(iconType) : const Value.absent(),
        color: Value(color),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a merchant (only if not default and not used in any expenses)
  Future<void> deleteMerchant(String merchantId) async {
    // Check if merchant is default
    final merchant = await (_database.select(
      _database.merchants,
    )..where((m) => m.id.equals(merchantId))).getSingleOrNull();

    if (merchant == null) {
      throw Exception('Merchant not found');
    }

    if (merchant.isDefault) {
      throw Exception('Cannot delete default merchants');
    }

    // Check if any expenses use this merchant
    final expensesWithMerchant = await (_database.select(
      _database.expenses,
    )..where((e) => e.merchantId.equals(merchantId))).get();

    if (expensesWithMerchant.isNotEmpty) {
      throw Exception(
        'Cannot delete merchant - ${expensesWithMerchant.length} expenses use this merchant',
      );
    }

    // Check if any income uses this merchant
    final incomeWithMerchant = await (_database.select(
      _database.income,
    )..where((i) => i.merchantId.equals(merchantId))).get();

    if (incomeWithMerchant.isNotEmpty) {
      throw Exception(
        'Cannot delete merchant - ${incomeWithMerchant.length} income records use this merchant',
      );
    }

    // Delete merchant metadata first
    await (_database.delete(
      _database.merchantMetadata,
    )..where((m) => m.merchantId.equals(merchantId))).go();

    // Delete the merchant
    await (_database.delete(
      _database.merchants,
    )..where((m) => m.id.equals(merchantId))).go();
  }

  /// Get merchant by ID
  Future<Merchant?> getMerchant(String merchantId) async {
    return await (_database.select(
      _database.merchants,
    )..where((m) => m.id.equals(merchantId))).getSingleOrNull();
  }

  /// Get all merchants
  Future<List<Merchant>> getAllMerchants() async {
    return await (_database.select(
      _database.merchants,
    )..orderBy([(m) => OrderingTerm.asc(m.name)])).get();
  }

  /// Get default merchants
  Future<List<Merchant>> getDefaultMerchants() async {
    return await (_database.select(_database.merchants)
          ..where((m) => m.isDefault.equals(true))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .get();
  }

  /// Get custom merchants
  Future<List<Merchant>> getCustomMerchants() async {
    return await (_database.select(_database.merchants)
          ..where((m) => m.isDefault.equals(false))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .get();
  }

  /// Search merchants by name
  Future<List<Merchant>> searchMerchants(String query) async {
    return await (_database.select(_database.merchants)
          ..where((m) => m.name.contains(query))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .get();
  }

  /// Stream all merchants
  Stream<List<Merchant>> watchAllMerchants() {
    return (_database.select(
      _database.merchants,
    )..orderBy([(m) => OrderingTerm.asc(m.name)])).watch();
  }

  /// Stream default merchants
  Stream<List<Merchant>> watchDefaultMerchants() {
    return (_database.select(_database.merchants)
          ..where((m) => m.isDefault.equals(true))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .watch();
  }

  /// Stream custom merchants
  Stream<List<Merchant>> watchCustomMerchants() {
    return (_database.select(_database.merchants)
          ..where((m) => m.isDefault.equals(false))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .watch();
  }

  /// Add metadata to a merchant
  Future<void> addMerchantMetadata({
    required String merchantId,
    required String key,
    required String value,
  }) async {
    await _database
        .into(_database.merchantMetadata)
        .insert(
          MerchantMetadataCompanion(
            merchantId: Value(merchantId),
            key: Value(key),
            value: Value(value),
          ),
        );
  }

  /// Get all metadata for a merchant
  Future<List<MerchantMetadataData>> getMerchantMetadata(
    String merchantId,
  ) async {
    return await (_database.select(
      _database.merchantMetadata,
    )..where((m) => m.merchantId.equals(merchantId))).get();
  }

  /// Get specific metadata value
  Future<String?> getMerchantMetadataValue(
    String merchantId,
    String key,
  ) async {
    final metadata =
        await (_database.select(_database.merchantMetadata)..where(
              (m) => m.merchantId.equals(merchantId) & m.key.equals(key),
            ))
            .getSingleOrNull();

    return metadata?.value;
  }

  /// Update metadata value
  Future<void> updateMerchantMetadata({
    required String merchantId,
    required String key,
    required String value,
  }) async {
    await (_database.update(_database.merchantMetadata)
          ..where((m) => m.merchantId.equals(merchantId) & m.key.equals(key)))
        .write(MerchantMetadataCompanion(value: Value(value)));
  }

  /// Delete specific metadata
  Future<void> deleteMerchantMetadata(String merchantId, String key) async {
    await (_database.delete(
      _database.merchantMetadata,
    )..where((m) => m.merchantId.equals(merchantId) & m.key.equals(key))).go();
  }

  /// Delete all metadata for a merchant
  Future<void> deleteAllMerchantMetadata(String merchantId) async {
    await (_database.delete(
      _database.merchantMetadata,
    )..where((m) => m.merchantId.equals(merchantId))).go();
  }
}
