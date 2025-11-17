import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import '../services/currency_service.dart';
import 'database_provider.dart';
import 'user_preferences_provider.dart';

// Stream provider for all currencies
final allCurrenciesProvider = StreamProvider<List<Currency>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.currencies,
  )..orderBy([(c) => OrderingTerm.asc(c.name)])).watch();
});

// Stream provider for active currencies only
final activeCurrenciesProvider = StreamProvider<List<Currency>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.currencies)
        ..where((c) => c.isActive.equals(true))
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .watch();
});

// Stream provider for inactive currencies only
final inactiveCurrenciesProvider = StreamProvider<List<Currency>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.currencies)
        ..where((c) => c.isActive.equals(false))
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .watch();
});

// Stream provider for fiat currencies only (non-crypto)
final fiatCurrenciesProvider = StreamProvider<List<Currency>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.currencies)
        ..where((c) => c.isCrypto.equals(false))
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .watch();
});

// Stream provider for crypto currencies only
final cryptoCurrenciesProvider = StreamProvider<List<Currency>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.currencies)
        ..where((c) => c.isCrypto.equals(true))
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .watch();
});

// State provider for search query
final currencySearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered currencies based on search query
final filteredCurrenciesProvider = Provider<List<Currency>>((ref) {
  final query = ref.watch(currencySearchQueryProvider);
  final currenciesAsync = ref.watch(allCurrenciesProvider);

  return currenciesAsync.when(
    data: (currencies) {
      if (query.isEmpty) return currencies;
      final lowerQuery = query.toLowerCase();
      return currencies
          .where(
            (c) =>
                c.name.toLowerCase().contains(lowerQuery) ||
                c.code.toLowerCase().contains(lowerQuery) ||
                c.symbol.toLowerCase().contains(lowerQuery),
          )
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Stream provider family for a single currency by code
final currencyProvider = StreamProviderFamily<Currency?, String>((
  ref,
  currencyCode,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.currencies,
  )..where((c) => c.code.equals(currencyCode))).watchSingleOrNull();
});

// Stream provider for the default currency based on user preferences
final defaultCurrencyObjectProvider = StreamProvider<Currency?>((ref) {
  final defaultCurrencyCode = ref.watch(defaultCurrencyProvider);
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.currencies,
  )..where((c) => c.code.equals(defaultCurrencyCode))).watchSingleOrNull();
});

// Repository provider
final currencyRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return CurrencyRepository(database);
});

// Service provider
final currencyServiceProvider = Provider((ref) {
  final repository = ref.watch(currencyRepositoryProvider);
  return CurrencyService(repository);
});

class CurrencyRepository {
  final AppDatabase _database;

  CurrencyRepository(this._database);

  /// Create a new currency
  Future<String> createCurrency({
    required String code,
    required String name,
    required String symbol,
    int decimals = 2,
    String? countryISO2,
    bool isCrypto = false,
    bool isActive = true,
    String? userId,
  }) async {
    final currencyCode = code.toUpperCase();
    final tempId = IdGenerator.tempCurrency();

    try {   
      await _database
          .into(_database.currencies)
          .insert(
            CurrenciesCompanion(
              id: Value(tempId),
              tempId: Value(tempId),
              code: Value(currencyCode),
              name: Value(name),
              symbol: Value(symbol),
              decimals: Value(decimals),
              countryISO2: Value(countryISO2 ?? '🪙'),
              isCrypto: Value(isCrypto),
              isActive: Value(isActive),
              userId: Value(userId),
            ),
          );
    } catch (e) {
      print('Error creating currency: $e');
      rethrow;
    }
  
    return tempId;
  }

  /// Update an existing currency
  Future<void> updateCurrency({
    required String currencyCode,
    String? name,
    String? symbol,
    int? decimals,
    String? countryISO2,
    bool? isCrypto,
    bool? isActive,
  }) async {
    final currency =
        await (_database.select(_database.currencies)
              ..where((c) => c.code.equals(currencyCode.toUpperCase())))
            .getSingleOrNull();

    if (currency == null) {
      throw Exception('Currency not found');
    }

    await (_database.update(
      _database.currencies,
    )..where((c) => c.code.equals(currencyCode.toUpperCase()))).write(
      CurrenciesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        symbol: symbol != null ? Value(symbol) : const Value.absent(),
        decimals: decimals != null ? Value(decimals) : const Value.absent(),
        countryISO2: Value(countryISO2),
        isCrypto: isCrypto != null ? Value(isCrypto) : const Value.absent(),
        isActive: isActive != null ? Value(isActive) : const Value.absent(),
      ),
    );
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
    return await (_database.select(_database.currencies)
          ..where((c) => c.tempId.equals(tempId)))
        .getSingleOrNull();
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

    await updateCurrency(
      currencyCode: currencyCode,
      isActive: !currency.isActive,
    );
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
