import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import '../models/merchant_model.dart';
import '../utils/id_generator.dart';

class MerchantRepository {
  final AppDatabase _database;

  MerchantRepository(this._database);

  /// Create a new merchant using MerchantModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final merchant = MerchantModel(
  ///   name: 'Amazon',
  ///   website: 'https://amazon.com',
  ///   iconEmoji: '📦',
  ///   color: '#FF9900',
  /// );
  /// final id = await repository.createMerchant(merchant);
  /// ```
  Future<String> createMerchant(MerchantModel newMerchant) async {
    final tempId = IdGenerator.tempMerchant();

    try {
      await _database
          .into(_database.merchants)
          .insert(newMerchant.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error creating merchant: $e');
      rethrow;
    }

    return tempId;
  }

  /// Update merchant using MerchantModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentMerchant.copyWith(name: 'New Name', website: 'https://example.com');
  /// await repository.updateMerchant(updated);
  /// ```
  Future<String> updateMerchant(MerchantModel updatedMerchant) async {
    if (updatedMerchant.id == null) {
      throw ArgumentError('Cannot update merchant without an ID');
    }

    // Check if merchant is default
    final merchant = await (_database.select(
      _database.merchants,
    )..where((m) => m.id.equals(updatedMerchant.id!))).getSingleOrNull();

    if (merchant == null) {
      throw Exception('Merchant not found');
    }

    if (merchant.isDefault) {
      throw Exception('Cannot update default merchants');
    }

    try {
      await (_database.update(
        _database.merchants,
      )..where((m) => m.id.equals(updatedMerchant.id!))).write(
        updatedMerchant.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating merchant: $e');
      rethrow;
    }
    return updatedMerchant.id!;
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
  // Future<void> addMerchantMetadata({
  //   required String merchantId,
  //   required String key,
  //   required String value,
  // }) async {
  //   await _database
  //       .into(_database.merchantMetadata)
  //       .insert(
  //         MerchantMetadataCompanion(
  //           merchantId: Value(merchantId),
  //           key: Value(key),
  //           value: Value(value),
  //         ),
  //       );
  // }

  /// Get all metadata for a merchant
  Future<List<MerchantMetadataData>> getMerchantMetadata(
    String merchantId,
  ) async {
    return await (_database.select(
      _database.merchantMetadata,
    )..where((m) => m.merchantId.equals(merchantId))).get();
  }

  /// Get specific metadata value
  // Future<String?> getMerchantMetadataValue(
  //   String merchantId,
  //   String key,
  // ) async {
  //   final metadata =
  //       await (_database.select(_database.merchantMetadata)..where(
  //             (m) => m.merchantId.equals(merchantId) & m.key.equals(key),
  //           ))
  //           .getSingleOrNull();

  //   return metadata?.value;
  // }

  // /// Update metadata value
  // Future<void> updateMerchantMetadata({
  //   required String merchantId,
  //   required String key,
  //   required String value,
  // }) async {
  //   await (_database.update(_database.merchantMetadata)
  //         ..where((m) => m.merchantId.equals(merchantId) & m.key.equals(key)))
  //       .write(MerchantMetadataCompanion(value: Value(value)));
  // }

  // /// Delete specific metadata
  // Future<void> deleteMerchantMetadata(String merchantId, String key) async {
  //   await (_database.delete(
  //     _database.merchantMetadata,
  //   )..where((m) => m.merchantId.equals(merchantId) & m.key.equals(key))).go();
  // }

  /// Delete all metadata for a merchant
  Future<void> deleteAllMerchantMetadata(String merchantId) async {
    await (_database.delete(
      _database.merchantMetadata,
    )..where((m) => m.merchantId.equals(merchantId))).go();
  }
}
