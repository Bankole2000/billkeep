import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/merchant_model.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';
import '../repositories/merchant_repository.dart';

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


