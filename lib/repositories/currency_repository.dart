import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import '../models/currency_model.dart';
import '../utils/id_generator.dart';

class CurrencyRepository {
  final AppDatabase _database;

  CurrencyRepository(this._database);

  /// Create a new currency using CurrencyModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final currency = CurrencyModel(
  ///   code: 'USD',
  ///   name: 'US Dollar',
  ///   symbol: '$',
  ///   decimals: 2,
  ///   countryISO2: 'US',
  /// );
  /// final id = await repository.createCurrency(currency);
  /// ```
  Future<String> createCurrency(CurrencyModel newCurrency) async {
    final tempId = IdGenerator.tempCurrency();

    try {
      await _database
          .into(_database.currencies)
          .insert(newCurrency.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error creating currency: $e');
      rethrow;
    }

    return tempId;
  }

  /// Update currency using CurrencyModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentCurrency.copyWith(name: 'New Name', symbol: '€');
  /// await repository.updateCurrency(updated);
  /// ```
  Future<String> updateCurrency(CurrencyModel updatedCurrency) async {
    if (updatedCurrency.code == null) {
      throw ArgumentError('Cannot update currency without a code');
    }

    final currency =
        await (_database.select(
              _database.currencies,
            )..where((c) => c.code.equals(updatedCurrency.code!.toUpperCase())))
            .getSingleOrNull();

    if (currency == null) {
      throw Exception('Currency not found');
    }

    try {
      await (_database.update(_database.currencies)
            ..where((c) => c.code.equals(updatedCurrency.code!.toUpperCase())))
          .write(updatedCurrency.toCompanion());
    } catch (e) {
      print('Error updating currency: $e');
      rethrow;
    }
    return updatedCurrency.code!;
  }

  /// Delete a currency (only if not used in any transactions)
  Future<void> deleteCurrency(String currencyCode) async {
    final currency =
        await (_database.select(_database.currencies)
              ..where((c) => c.code.equals(currencyCode.toUpperCase())))
            .getSingleOrNull();

    if (currency == null) {
      throw Exception('Currency not found');
    }

    // Check if any expenses use this currency
    final expensesWithCurrency = await (_database.select(
      _database.expenses,
    )..where((e) => e.currency.equals(currencyCode.toUpperCase()))).get();

    if (expensesWithCurrency.isNotEmpty) {
      throw Exception(
        'Cannot delete currency - ${expensesWithCurrency.length} expenses use this currency',
      );
    }

    // Check if any income uses this currency
    final incomeWithCurrency = await (_database.select(
      _database.income,
    )..where((i) => i.currency.equals(currencyCode.toUpperCase()))).get();

    if (incomeWithCurrency.isNotEmpty) {
      throw Exception(
        'Cannot delete currency - ${incomeWithCurrency.length} income records use this currency',
      );
    }

    // Check if any wallets use this currency
    final walletsWithCurrency = await (_database.select(
      _database.wallets,
    )..where((w) => w.currency.equals(currencyCode.toUpperCase()))).get();

    if (walletsWithCurrency.isNotEmpty) {
      throw Exception(
        'Cannot delete currency - ${walletsWithCurrency.length} wallets use this currency',
      );
    }

    // Delete the currency
    await (_database.delete(
      _database.currencies,
    )..where((c) => c.code.equals(currencyCode.toUpperCase()))).go();
  }

  /// Get currency by code
  Future<Currency?> getCurrency(String currencyCode) async {
    return await (_database.select(_database.currencies)
          ..where((c) => c.code.equals(currencyCode.toUpperCase())))
        .getSingleOrNull();
  }

  /// Get currency by tempId
  Future<Currency?> getCurrencyByTempId(String tempId) async {
    return await (_database.select(
      _database.currencies,
    )..where((c) => c.tempId.equals(tempId))).getSingleOrNull();
  }

  /// Get all currencies
  Future<List<Currency>> getAllCurrencies() async {
    return await (_database.select(
      _database.currencies,
    )..orderBy([(c) => OrderingTerm.asc(c.name)])).get();
  }

  /// Get active currencies
  Future<List<Currency>> getActiveCurrencies() async {
    return await (_database.select(_database.currencies)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Get inactive currencies
  Future<List<Currency>> getInactiveCurrencies() async {
    return await (_database.select(_database.currencies)
          ..where((c) => c.isActive.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Get fiat currencies (non-crypto)
  Future<List<Currency>> getFiatCurrencies() async {
    return await (_database.select(_database.currencies)
          ..where((c) => c.isCrypto.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Get crypto currencies
  Future<List<Currency>> getCryptoCurrencies() async {
    return await (_database.select(_database.currencies)
          ..where((c) => c.isCrypto.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Search currencies by name, code, or symbol
  Future<List<Currency>> searchCurrencies(String query) async {
    final lowerQuery = query.toLowerCase();
    final allCurrencies = await getAllCurrencies();

    return allCurrencies
        .where(
          (c) =>
              c.name.toLowerCase().contains(lowerQuery) ||
              c.code.toLowerCase().contains(lowerQuery) ||
              c.symbol.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Stream all currencies
  Stream<List<Currency>> watchAllCurrencies() {
    return (_database.select(
      _database.currencies,
    )..orderBy([(c) => OrderingTerm.asc(c.name)])).watch();
  }

  /// Stream active currencies
  Stream<List<Currency>> watchActiveCurrencies() {
    return (_database.select(_database.currencies)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  /// Stream inactive currencies
  Stream<List<Currency>> watchInactiveCurrencies() {
    return (_database.select(_database.currencies)
          ..where((c) => c.isActive.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  /// Stream fiat currencies
  Stream<List<Currency>> watchFiatCurrencies() {
    return (_database.select(_database.currencies)
          ..where((c) => c.isCrypto.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  /// Stream crypto currencies
  Stream<List<Currency>> watchCryptoCurrencies() {
    return (_database.select(_database.currencies)
          ..where((c) => c.isCrypto.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  /// Toggle currency active status
  Future<void> toggleCurrencyStatus(String currencyCode) async {
    final currency = await getCurrency(currencyCode);
    if (currency == null) {
      throw Exception('Currency not found');
    }

    final updatedCurrency = CurrencyModel.fromDrift(
      currency,
    ).copyWith(isActive: !currency.isActive);

    await updateCurrency(updatedCurrency);
  }

  /// Get currencies by country ISO2 code
  Future<List<Currency>> getCurrenciesByCountry(String countryISO2) async {
    return await (_database.select(_database.currencies)
          ..where((c) => c.countryISO2.equals(countryISO2.toUpperCase()))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Check if currency code exists
  Future<bool> currencyExists(String currencyCode) async {
    final currency = await getCurrency(currencyCode);
    return currency != null;
  }
}
