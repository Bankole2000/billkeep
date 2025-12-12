import 'package:billkeep/providers/database_provider.dart';
import 'package:billkeep/repositories/preference_repository.dart';
import 'package:billkeep/services/preference_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferenceServiceProvider = Provider<PreferenceService>((ref) {
  final database = ref.watch(databaseProvider);
  final repository = PreferenceRepository(database);
  final preferenceService = PreferenceService(repository);
  return preferenceService;
});