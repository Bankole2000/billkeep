import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/currency_model.dart';
import '../utils/id_generator.dart';
import '../services/currency_service.dart';
import 'database_provider.dart';
import 'user_preferences_provider.dart';
import '../repositories/currency_repository.dart';

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
  final defaultCurrencyCode = ref.watch(defaultCurrencyCodeProvider);
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.currencies,
  )..where((c) => c.code.equals(defaultCurrencyCode))).watchSingleOrNull();
});

// Service provider
final currencyServiceProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  final repository = CurrencyRepository(database);
  return CurrencyService(repository);
});

