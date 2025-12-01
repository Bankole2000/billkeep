import 'package:drift/drift.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_telephony/telephony.dart' hide Value;
import 'package:permission_handler/permission_handler.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'database_provider.dart';
import 'package:billkeep/repositories/sms_repository.dart';

// Provider for rules stream
final messageRulesStreamProvider = StreamProvider<List<MessageRule>>((ref) {
  final database = ref.watch(databaseProvider);
  final repository = SmsRepository(database /* Telephony.instance */);
  return repository.watchMessageRules();
});

final parsedMessagesProvider = StreamProvider<List<ParsedMessage>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.parsedMessages)
        ..where((m) => m.isProcessed.equals(false))
        ..orderBy([(m) => OrderingTerm.desc(m.messageDate)]))
      .watch();
});

final messageRulesProvider = StreamProvider<List<MessageRule>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.messageRules,
  )..orderBy([(r) => OrderingTerm.desc(r.createdAt)])).watch();
});
