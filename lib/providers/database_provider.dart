import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
