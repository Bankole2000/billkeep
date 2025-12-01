import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import '../utils/id_generator.dart';
import 'package:billkeep/models/wallet_provider_metadata_model.dart';
import 'package:billkeep/models/wallet_provider_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProviderRepository {
  final AppDatabase _database;

  WalletProviderRepository(this._database);

  /// Create a new wallet provider using WalletProviderModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final walletProvider = WalletProviderModel(
  ///   name: 'Chase Bank',
  ///   description: 'Major US bank',
  ///   isFiatBank: true,
  ///   iconEmoji: '🏦',
  ///   color: '#0047AB',
  /// );
  /// final id = await repository.createWalletProvider(walletProvider);
  /// ```
  Future<String> createWalletProvider(
    WalletProviderModel newWalletProvider,
  ) async {
    final tempId = IdGenerator.tempWalletProvider();

    try {
      await _database
          .into(_database.walletProviders)
          .insert(newWalletProvider.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error creating wallet provider: $e');
      rethrow;
    }

    return tempId;
  }

  /// Update wallet provider using WalletProviderModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentWalletProvider.copyWith(
  ///   name: 'New Name',
  ///   description: 'Updated description',
  /// );
  /// await repository.updateWalletProvider(updated);
  /// ```
  Future<String> updateWalletProvider(
    WalletProviderModel updatedWalletProvider,
  ) async {
    if (updatedWalletProvider.id == null) {
      throw ArgumentError('Cannot update wallet provider without an ID');
    }

    // Check if provider is default
    final provider = await (_database.select(
      _database.walletProviders,
    )..where((w) => w.id.equals(updatedWalletProvider.id!))).getSingleOrNull();

    if (provider == null) {
      throw Exception('Wallet provider not found');
    }

    if (provider.isDefault) {
      throw Exception('Cannot update default wallet providers');
    }

    try {
      await (_database.update(
        _database.walletProviders,
      )..where((w) => w.id.equals(updatedWalletProvider.id!))).write(
        updatedWalletProvider.toCompanion(
          isSynced: false,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      print('Error updating wallet provider: $e');
      rethrow;
    }

    return updatedWalletProvider.id!;
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
    )..where((m) => m.walletProviderId.equals(providerId))).go();

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
  Future<void> addWalletProviderMetadata(
    WalletProviderMetadataModel walletProviderMetadata,
  ) async {
    await _database
        .into(_database.walletProviderMetadata)
        .insert(walletProviderMetadata.toCompanion());
  }

  /// Get all metadata for a wallet provider
  Future<List<WalletProviderMetadataData>> getWalletProviderMetadata(
    String providerId,
  ) async {
    return await (_database.select(
      _database.walletProviderMetadata,
    )..where((m) => m.walletProviderId.equals(providerId))).get();
  }

  // /// Get specific metadata value
  Future<WalletProviderMetadataData?> getWalletProviderMetadataValue(
    String providerId,
    String key,
  ) async {
    return await (_database.select(_database.walletProviderMetadata)..where(
          (m) => m.walletProviderId.equals(providerId) & m.name.equals(key),
        ))
        .getSingleOrNull();
  }

  /// Update metadata value
  Future<void> updateWalletProviderMetadata(
    WalletProviderMetadataModel updateData,
  ) async {
    await (_database.update(_database.walletProviderMetadata)..where(
          (m) =>
              m.walletProviderId.equals(updateData.walletProvider!) &
              m.id.equals(updateData.id!),
        ))
        .write(updateData.toCompanion());
  }

  /// Delete specific metadata
  Future<void> deleteWalletProviderMetadata(
    String providerId,
    String id,
  ) async {
    await (_database.delete(_database.walletProviderMetadata)..where(
          (m) => m.walletProviderId.equals(providerId) & m.id.equals(id),
        ))
        .go();
  }

  /// Delete all metadata for a wallet provider
  Future<void> deleteAllWalletProviderMetadata(String providerId) async {
    await (_database.delete(
      _database.walletProviderMetadata,
    )..where((m) => m.walletProviderId.equals(providerId))).go();
  }
}
