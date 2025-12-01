import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/wallet_model.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:drift/drift.dart' as drift;

class WalletRepository {
  final AppDatabase _database;

  WalletRepository(this._database);

  Future<String> createWallet(WalletModel newWallet) async {
    final tempId = IdGenerator.tempWallet();
    try {
      await _database
          .into(_database.wallets)
          .insert(
            newWallet.toCompanion(
              tempId: newWallet.tempId ?? tempId,
              id: newWallet.id ?? tempId,
            ),
          );
    } catch (e) {
      print('Error creating wallet: $e');
      rethrow;
    }

    return tempId;
  }

  Future<Wallet?> getWalletByTempId({required String tempId}) async {
    return await (_database.select(
      _database.wallets,
    )..where((w) => w.tempId.equals(tempId))).getSingleOrNull();
  }

  // Called after server responds with canonical ID
  Future<void> updateWalletWithCanonicalId({
    required String tempId,
    required String canonicalId,
  }) async {
    // Map the IDs
    await _database.mapId(
      tempId: tempId,
      canonicalId: canonicalId,
      resourceType: 'wallet',
    );

    // Update wallet with canonical ID
    await (_database.update(
      _database.wallets,
    )..where((w) => w.id.equals(tempId))).write(
      WalletsCompanion(
        id: drift.Value(canonicalId),
        isSynced: const drift.Value(true),
      ),
    );
  }

  Stream<List<Wallet>> watchAllWallets() {
    return (_database.select(
      _database.wallets,
    )..orderBy([(w) => drift.OrderingTerm.asc(w.name)])).watch();
  }

  // Get unsynced wallets for sending to server
  Future<List<Wallet>> getUnsyncedWallets() {
    return (_database.select(
      _database.wallets,
    )..where((w) => w.isSynced.equals(false))).get();
  }

  /// Update wallet using WalletModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentWallet.copyWith(name: 'New Name', balance: 5000);
  /// await repository.updateWallet(updated);
  /// ```
  Future<String> updateWallet(WalletModel updatedWallet) async {
    if (updatedWallet.id == null) {
      throw ArgumentError('Cannot update wallet without an ID');
    }

    try {
      await (_database.update(
        _database.wallets,
      )..where((w) => w.id.equals(updatedWallet.id!))).write(
        updatedWallet.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating wallet: $e');
      rethrow;
    }
    return updatedWallet.id!;
  }

  // Update wallet balance
  Future<void> updateWalletBalance({
    required String walletId,
    required int newBalance,
  }) async {
    await (_database.update(
      _database.wallets,
    )..where((w) => w.id.equals(walletId))).write(
      WalletsCompanion(
        balance: drift.Value(newBalance),
        isSynced: const drift.Value(false),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  /// Adjust wallet balance by a delta amount (positive or negative)
  Future<void> adjustWalletBalance({
    required String walletId,
    required int deltaAmount,
  }) async {
    final wallet = await (_database.select(
      _database.wallets,
    )..where((w) => w.id.equals(walletId))).getSingleOrNull();

    if (wallet == null) {
      throw Exception('Wallet not found');
    }

    final newBalance = wallet.balance + deltaAmount;
    await updateWalletBalance(walletId: walletId, newBalance: newBalance);
  }

  Future<void> deleteWallet(String walletId) async {
    // Check if any transactions use this wallet
    final expensesWithWallet = await (_database.select(
      _database.expenses,
    )..where((e) => e.walletId.equals(walletId))).get();

    if (expensesWithWallet.isNotEmpty) {
      throw Exception(
        'Cannot delete wallet - ${expensesWithWallet.length} expenses use this wallet',
      );
    }

    final incomeWithWallet = await (_database.select(
      _database.income,
    )..where((i) => i.walletId.equals(walletId))).get();

    if (incomeWithWallet.isNotEmpty) {
      throw Exception(
        'Cannot delete wallet - ${incomeWithWallet.length} income records use this wallet',
      );
    }

    // Delete wallet metadata first
    await (_database.delete(
      _database.walletMetadata,
    )..where((m) => m.walletId.equals(walletId))).go();

    // Delete the wallet
    await (_database.delete(
      _database.wallets,
    )..where((w) => w.id.equals(walletId))).go();
  }

  /// Get wallet by ID
  Future<Wallet?> getWallet(String walletId) async {
    return await (_database.select(
      _database.wallets,
    )..where((w) => w.id.equals(walletId))).getSingleOrNull();
  }

  /// Get wallet with relations by ID
  Future<WalletWithRelations?> getWalletWithRelations(String walletId) async {
    final query = _database.select(_database.wallets).join([
      drift.innerJoin(
        _database.currencies,
        _database.currencies.code.equalsExp(_database.wallets.currency),
      ),
      drift.leftOuterJoin(
        _database.walletProviders,
        _database.walletProviders.id.equalsExp(_database.wallets.providerId),
      ),
    ])..where(_database.wallets.id.equals(walletId));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return WalletWithRelations(
      wallet: row.readTable(_database.wallets),
      currency: row.readTable(_database.currencies),
      provider: row.readTableOrNull(_database.walletProviders),
    );
  }

  /// Get all wallets
  Future<List<Wallet>> getAllWallets() async {
    return await (_database.select(
      _database.wallets,
    )..orderBy([(w) => drift.OrderingTerm.asc(w.name)])).get();
  }

  /// Get all wallets with relations
  Future<List<WalletWithRelations>> getAllWalletsWithRelations() async {
    final query = _database.select(_database.wallets).join([
      drift.innerJoin(
        _database.currencies,
        _database.currencies.code.equalsExp(_database.wallets.currency),
      ),
      drift.leftOuterJoin(
        _database.walletProviders,
        _database.walletProviders.id.equalsExp(_database.wallets.providerId),
      ),
    ])..orderBy([drift.OrderingTerm.asc(_database.wallets.name)]);

    final rows = await query.get();
    return rows.map((row) {
      return WalletWithRelations(
        wallet: row.readTable(_database.wallets),
        currency: row.readTable(_database.currencies),
        provider: row.readTableOrNull(_database.walletProviders),
      );
    }).toList();
  }

  /// Get global wallets
  Future<List<Wallet>> getGlobalWallets() async {
    return await (_database.select(_database.wallets)
          ..where((w) => w.isGlobal.equals(true))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get global wallets with relations
  Future<List<WalletWithRelations>> getGlobalWalletsWithRelations() async {
    final query =
        _database.select(_database.wallets).join([
            drift.innerJoin(
              _database.currencies,
              _database.currencies.code.equalsExp(_database.wallets.currency),
            ),
            drift.leftOuterJoin(
              _database.walletProviders,
              _database.walletProviders.id.equalsExp(
                _database.wallets.providerId,
              ),
            ),
          ])
          ..where(_database.wallets.isGlobal.equals(true))
          ..orderBy([drift.OrderingTerm.asc(_database.wallets.name)]);

    final rows = await query.get();
    return rows.map((row) {
      return WalletWithRelations(
        wallet: row.readTable(_database.wallets),
        currency: row.readTable(_database.currencies),
        provider: row.readTableOrNull(_database.walletProviders),
      );
    }).toList();
  }

  /// Get project-specific wallets
  Future<List<Wallet>> getProjectWallets() async {
    return await (_database.select(_database.wallets)
          ..where((w) => w.isGlobal.equals(false))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get project-specific wallets with relations
  Future<List<WalletWithRelations>> getProjectWalletsWithRelations() async {
    final query =
        _database.select(_database.wallets).join([
            drift.innerJoin(
              _database.currencies,
              _database.currencies.code.equalsExp(_database.wallets.currency),
            ),
            drift.leftOuterJoin(
              _database.walletProviders,
              _database.walletProviders.id.equalsExp(
                _database.wallets.providerId,
              ),
            ),
          ])
          ..where(_database.wallets.isGlobal.equals(false))
          ..orderBy([drift.OrderingTerm.asc(_database.wallets.name)]);

    final rows = await query.get();
    return rows.map((row) {
      return WalletWithRelations(
        wallet: row.readTable(_database.wallets),
        currency: row.readTable(_database.currencies),
        provider: row.readTableOrNull(_database.walletProviders),
      );
    }).toList();
  }

  /// Get wallets by type
  Future<List<Wallet>> getWalletsByType(String walletType) async {
    return await (_database.select(_database.wallets)
          ..where((w) => w.walletType.equals(walletType))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get wallets by currency
  Future<List<Wallet>> getWalletsByCurrency(String currency) async {
    return await (_database.select(_database.wallets)
          ..where((w) => w.currency.equals(currency))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Get wallets by provider
  Future<List<Wallet>> getWalletsByProvider(String providerId) async {
    return await (_database.select(_database.wallets)
          ..where((w) => w.providerId.equals(providerId))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Stream global wallets
  Stream<List<Wallet>> watchGlobalWallets() {
    return (_database.select(_database.wallets)
          ..where((w) => w.isGlobal.equals(true))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream project-specific wallets
  Stream<List<Wallet>> watchProjectWallets() {
    return (_database.select(_database.wallets)
          ..where((w) => w.isGlobal.equals(false))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Stream wallets by type
  Stream<List<Wallet>> watchWalletsByType(String walletType) {
    return (_database.select(_database.wallets)
          ..where((w) => w.walletType.equals(walletType))
          ..orderBy([(w) => drift.OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Add metadata to a wallet
  // Future<void> addWalletMetadata({
  //   required String walletId,
  //   required String key,
  //   required String value,
  // }) async {
  //   final metadataId = IdGenerator.tempWalletMeta();
  //   await _database
  //       .into(_database.walletMetadata)
  //       .insert(
  //         WalletMetadataCompanion(
  //           id: drift.Value(metadataId),
  //           walletId: drift.Value(walletId),
  //           key: drift.Value(key),
  //           value: drift.Value(value),
  //         ),
  //       );
  // }

  /// Get all metadata for a wallet
  Future<List<WalletMetadataData>> getWalletMetadata(String walletId) async {
    return await (_database.select(
      _database.walletMetadata,
    )..where((m) => m.walletId.equals(walletId))).get();
  }

  /// Get specific metadata value
  // Future<String?> getWalletMetadataValue(String walletId, String key) async {
  //   final metadata =
  //       await (_database.select(_database.walletMetadata)
  //             ..where((m) => m.walletId.equals(walletId) & m.key.equals(key)))
  //           .getSingleOrNull();

  //   return metadata?.value;
  // }

  /// Update metadata value
  // Future<void> updateWalletMetadata({
  //   required String walletId,
  //   required String key,
  //   required String value,
  // }) async {
  //   await (_database.update(_database.walletMetadata)
  //         ..where((m) => m.walletId.equals(walletId) & m.key.equals(key)))
  //       .write(WalletMetadataCompanion(value: drift.Value(value)));
  // }

  /// Delete specific metadata
  // Future<void> deleteWalletMetadata(String walletId, String key) async {
  //   await (_database.delete(
  //     _database.walletMetadata,
  //   )..where((m) => m.walletId.equals(walletId) & m.key.equals(key))).go();
  // }

  /// Delete all metadata for a wallet
  Future<void> deleteAllWalletMetadata(String walletId) async {
    await (_database.delete(
      _database.walletMetadata,
    )..where((m) => m.walletId.equals(walletId))).go();
  }
}
