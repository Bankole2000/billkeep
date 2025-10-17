import 'package:drift/drift.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_telephony/telephony.dart' hide Value;
import 'package:permission_handler/permission_handler.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';

// Provider for rules stream
final messageRulesStreamProvider = StreamProvider<List<MessageRule>>((ref) {
  return ref.watch(smsRepositoryProvider).watchMessageRules();
});

final smsRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return SmsRepository(database);
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

class SmsRepository {
  final AppDatabase _database;
  final Telephony telephony = Telephony.instance;

  SmsRepository(this._database);

  // Request SMS permissions
  Future<bool> requestSmsPermissions() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  // Check if permissions are granted
  Future<bool> hasSmsPermissions() async {
    return await Permission.sms.isGranted;
  }

  // Read recent SMS messages
  Future<void> readRecentSms({int daysBack = 7}) async {
    final hasPermission = await hasSmsPermissions();
    if (!hasPermission) {
      throw Exception('SMS permission not granted');
    }

    final messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      filter: SmsFilter.where(SmsColumn.DATE).greaterThan(
        DateTime.now()
            .subtract(Duration(days: daysBack))
            .millisecondsSinceEpoch
            .toString(),
      ),
    );

    // Parse each message against rules
    for (final message in messages) {
      await _parseAndStoreSms(
        sender: message.address ?? 'Unknown',
        body: message.body ?? '',
        date: message.date != null
            ? DateTime.fromMillisecondsSinceEpoch(message.date!)
            : DateTime.now(),
      );
    }
  }

  // Parse SMS against all active rules
  Future<void> _parseAndStoreSms({
    required String sender,
    required String body,
    required DateTime date,
  }) async {
    // Get all active rules
    final rules = await (_database.select(
      _database.messageRules,
    )..where((r) => r.isActive.equals(true) & r.type.equals('SMS'))).get();

    for (final rule in rules) {
      // Check if sender matches
      if (!sender.contains(rule.sender)) continue;

      // Check if message matches pattern
      final patternRegex = RegExp(rule.pattern, caseSensitive: false);
      if (!patternRegex.hasMatch(body)) continue;

      // Extract amount
      final amountRegex = RegExp(rule.amountPattern, caseSensitive: false);
      final amountMatch = amountRegex.firstMatch(body);
      if (amountMatch == null) continue;

      final amountStr = amountMatch.group(1)?.replaceAll(',', '') ?? '0';
      final amount =
          (double.tryParse(amountStr) ?? 0) * 100; // Convert to cents

      // Extract description if pattern exists
      String? description;
      if (rule.descriptionPattern != null) {
        final descRegex = RegExp(
          rule.descriptionPattern!,
          caseSensitive: false,
        );
        final descMatch = descRegex.firstMatch(body);
        description = descMatch?.group(1);
      }

      // Determine transaction type (DEBIT or CREDIT)
      final transactionType =
          body.toLowerCase().contains('debit') ||
              body.toLowerCase().contains('debited') ||
              body.toLowerCase().contains('sent')
          ? 'DEBIT'
          : 'CREDIT';

      // Check if this message was already parsed
      final existing =
          await (_database.select(_database.parsedMessages)..where(
                (m) =>
                    m.sender.equals(sender) &
                    m.messageDate.equals(date) &
                    m.amount.equals(amount.toInt()),
              ))
              .getSingleOrNull();

      if (existing != null) continue; // Skip if already exists

      // Store parsed message
      await _database
          .into(_database.parsedMessages)
          .insert(
            ParsedMessagesCompanion(
              id: Value(IdGenerator.generateTempId('msg')),
              ruleId: Value(rule.id),
              rawMessage: Value(body),
              sender: Value(sender),
              amount: Value(amount.toInt()),
              description: Value(description ?? 'Transaction'),
              transactionType: Value(transactionType),
              messageDate: Value(date),
              projectId: Value(rule.defaultProjectId),
              isProcessed: const Value(false),
              isConfirmed: const Value(false),
            ),
          );

      break; // Only match first rule
    }
  }

  // Create default Nigerian bank rules
  Future<void> createDefaultRules() async {
    final defaultRules = [
      // GTBank - Based on actual SMS format
      {
        'name': 'GTBank Credit (CR Amt)',
        'sender': 'GTBANK',
        'pattern': r'CR Amt:([\d,]+\.?\d{0,2})',
        'amountPattern': r'CR Amt:([\d,]+\.?\d{0,2})',
        'descriptionPattern':
            r'(?:NIP|CIP)/(?:CR|DR)/?/?([^\n]+?)(?=\s*(?:CR|DR) Amt:)',
        'type': 'CREDIT',
      },
      {
        'name': 'GTBank Debit (DR Amt)',
        'sender': 'GTBANK',
        'pattern': r'DR Amt:([\d,]+\.?\d{0,2})',
        'amountPattern': r'DR Amt:([\d,]+\.?\d{0,2})',
        'descriptionPattern':
            r'(?:NIP|CIP)/(?:CR|DR)/?/?([^\n]+?)(?=\s*(?:CR|DR) Amt:)',
        'type': 'DEBIT',
      },
      {
        'name': 'Access Bank',
        'sender': 'Access',
        'pattern': r'(debit|credit)',
        'amountPattern': r'NGN\s*([\d,]+\.?\d*)',
        'descriptionPattern': null,
      },
      {
        'name': 'First Bank',
        'sender': 'FirstBank',
        'pattern': r'(debit|credit)',
        'amountPattern': r'Amount:\s*NGN\s*([\d,]+\.?\d*)',
        'descriptionPattern': null,
      },
      {
        'name': 'Zenith Bank',
        'sender': 'ZENITHBANK',
        'pattern': r'CR Amt:([\d,]+\.?\d{0,2})',
        'amountPattern': r'CR Amt:([\d,]+\.?\d{0,2})',
        'descriptionPattern': null,
        'type': 'CREDIT',
      },
      {
        'name': 'UBA',
        'sender': 'UBA',
        'pattern': r'(debit|credit)',
        'amountPattern': r'NGN\s*([\d,]+\.?\d*)',
        'descriptionPattern': null,
      },
    ];

    for (final ruleData in defaultRules) {
      await _database
          .into(_database.messageRules)
          .insert(
            MessageRulesCompanion(
              id: Value(IdGenerator.generateTempId('rule')),
              name: Value(ruleData['name'] as String),
              type: const Value('SMS'),
              sender: Value(ruleData['sender'] as String),
              pattern: Value(ruleData['pattern'] as String),
              amountPattern: Value(ruleData['amountPattern'] as String),
              descriptionPattern: Value(ruleData['descriptionPattern']),
              isActive: const Value(true),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  // Confirm parsed message and create expense/income
  Future<void> confirmParsedMessage({
    required String messageId,
    required String projectId,
    bool createRecord = true,
  }) async {
    final message = await (_database.select(
      _database.parsedMessages,
    )..where((m) => m.id.equals(messageId))).getSingle();

    if (createRecord) {
      String? recordId;

      if (message.transactionType == 'DEBIT') {
        // Create expense
        recordId = IdGenerator.tempExpense();
        await _database
            .into(_database.expenses)
            .insert(
              ExpensesCompanion(
                id: Value(recordId),
                tempId: Value(recordId),
                projectId: Value(projectId),
                name: Value(message.description ?? 'SMS Transaction'),
                expectedAmount: Value(message.amount),
                type: const Value('ONE_TIME'),
                notes: Value('Auto-imported from SMS: ${message.sender}'),
                isSynced: const Value(false),
              ),
            );

        // Create payment
        await _database
            .into(_database.payments)
            .insert(
              PaymentsCompanion(
                id: Value(IdGenerator.tempPayment()),
                tempId: Value(IdGenerator.tempPayment()),
                paymentType: const Value('DEBIT'),
                expenseId: Value(recordId),
                actualAmount: Value(message.amount),
                paymentDate: Value(message.messageDate),
                source: const Value('SMS'),
                verified: const Value(true),
                notes: Value(message.rawMessage),
                isSynced: const Value(false),
              ),
            );
      } else {
        // Create income
        recordId = IdGenerator.tempIncome();
        await _database
            .into(_database.income)
            .insert(
              IncomeCompanion(
                id: Value(recordId),
                tempId: Value(recordId),
                projectId: Value(projectId),
                description: Value(message.description ?? 'SMS Transaction'),
                expectedAmount: Value(message.amount),
                type: const Value('ONE_TIME'),
                startDate: Value(message.messageDate),
                notes: Value('Auto-imported from SMS: ${message.sender}'),
                isSynced: const Value(false),
              ),
            );

        // Create payment
        await _database
            .into(_database.payments)
            .insert(
              PaymentsCompanion(
                id: Value(IdGenerator.tempPayment()),
                tempId: Value(IdGenerator.tempPayment()),
                paymentType: const Value('CREDIT'),
                incomeId: Value(recordId),
                actualAmount: Value(message.amount),
                paymentDate: Value(message.messageDate),
                source: const Value('SMS'),
                verified: const Value(true),
                notes: Value(message.rawMessage),
                isSynced: const Value(false),
              ),
            );
      }

      // Update message as confirmed and processed
      await (_database.update(
        _database.parsedMessages,
      )..where((m) => m.id.equals(messageId))).write(
        ParsedMessagesCompanion(
          isProcessed: const Value(true),
          isConfirmed: const Value(true),
          createdRecordId: Value(recordId),
          recordType: Value(
            message.transactionType == 'DEBIT' ? 'expense' : 'income',
          ),
          projectId: Value(projectId),
        ),
      );
    } else {
      // Just mark as processed without creating record
      await (_database.update(
        _database.parsedMessages,
      )..where((m) => m.id.equals(messageId))).write(
        const ParsedMessagesCompanion(
          isProcessed: Value(true),
          isConfirmed: Value(false),
        ),
      );
    }
  }

  // Dismiss parsed message
  Future<void> dismissParsedMessage(String messageId) async {
    await (_database.update(
      _database.parsedMessages,
    )..where((m) => m.id.equals(messageId))).write(
      const ParsedMessagesCompanion(
        isProcessed: Value(true),
        isConfirmed: Value(false),
      ),
    );
  }

  // Add these methods to your SmsRepository class

  Future<void> createMessageRule({
    required String name,
    required String type,
    required String sender,
    required String pattern,
    required String amountPattern,
    String? descriptionPattern,
    String? defaultProjectId,
  }) async {
    final tempMessageRuleId = IdGenerator.tempMessageRule();
    await _database
        .into(_database.messageRules)
        .insert(
          MessageRulesCompanion(
            id: drift.Value(tempMessageRuleId),
            name: drift.Value(name),
            type: drift.Value(type),
            sender: drift.Value(sender),
            pattern: drift.Value(pattern),
            amountPattern: drift.Value(amountPattern),
            descriptionPattern: drift.Value(descriptionPattern),
            defaultProjectId: drift.Value(defaultProjectId),
            isActive: const drift.Value(true),
          ),
        );
  }

  Future<void> updateMessageRule({
    required String ruleId,
    String? name,
    bool? isActive,
    String? defaultProjectId,
  }) async {
    await (_database.update(
      _database.messageRules,
    )..where((r) => r.id.equals(ruleId))).write(
      MessageRulesCompanion(
        name: name != null ? drift.Value(name) : const drift.Value.absent(),
        isActive: isActive != null
            ? drift.Value(isActive)
            : const drift.Value.absent(),
        defaultProjectId: defaultProjectId != null
            ? drift.Value(defaultProjectId)
            : const drift.Value.absent(),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteMessageRule(String ruleId) async {
    await (_database.delete(
      _database.messageRules,
    )..where((r) => r.id.equals(ruleId))).go();
  }

  Stream<List<MessageRule>> watchMessageRules() {
    return (_database.select(
      _database.messageRules,
    )..orderBy([(r) => drift.OrderingTerm.asc(r.name)])).watch();
  }

  Future<List<MessageRule>> getActiveMessageRules() async {
    return (_database.select(
      _database.messageRules,
    )..where((r) => r.isActive.equals(true))).get();
  }

  Future<void> updateMessageRuleComplete({
    required String ruleId,
    required String name,
    required String sender,
    required String pattern,
    required String amountPattern,
    String? descriptionPattern,
  }) async {
    await (_database.update(
      _database.messageRules,
    )..where((r) => r.id.equals(ruleId))).write(
      MessageRulesCompanion(
        name: drift.Value(name),
        sender: drift.Value(sender),
        pattern: drift.Value(pattern),
        amountPattern: drift.Value(amountPattern),
        descriptionPattern: drift.Value(descriptionPattern),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Future<Map<String, dynamic>> testRuleMatch({
    required MessageRule rule,
    required String smsText,
    required String sender,
  }) async {
    try {
      // Check sender match if rule has sender specified
      if (rule.sender.isNotEmpty && sender.isNotEmpty) {
        if (!sender.toUpperCase().contains(rule.sender.toUpperCase())) {
          return {
            'matched': false,
            'message':
                'Sender does not match. Expected: ${rule.sender}, Got: $sender',
          };
        }
      }

      // Test main pattern
      final mainRegex = RegExp(rule.pattern, caseSensitive: false);
      if (!mainRegex.hasMatch(smsText)) {
        return {
          'matched': false,
          'message': 'Message does not match main pattern',
        };
      }

      // Extract amount
      final amountRegex = RegExp(rule.amountPattern, caseSensitive: false);
      final amountMatch = amountRegex.firstMatch(smsText);

      if (amountMatch == null || amountMatch.groupCount < 1) {
        return {
          'matched': false,
          'message': 'Could not extract amount from message',
        };
      }

      final amountStr = amountMatch.group(1)?.replaceAll(',', '') ?? '0';
      final amount = double.tryParse(amountStr) ?? 0.0;
      final amountInCents = (amount * 100).toInt();

      // Extract description (optional)
      String? description;
      if (rule.descriptionPattern != null) {
        final descRegex = RegExp(
          rule.descriptionPattern!,
          caseSensitive: false,
        );
        final descMatch = descRegex.firstMatch(smsText);
        description = descMatch?.group(1)?.trim();
      }

      // Determine transaction type from the rule type
      final transactionType = rule.type == 'SMS'
          ? (smsText.toUpperCase().contains('DEBIT') ||
                    smsText.toUpperCase().contains('DR AMT')
                ? 'DEBIT'
                : 'CREDIT')
          : rule.type;

      return {
        'matched': true,
        'ruleName': rule.name,
        'ruleId': rule.id,
        'amount': amountStr,
        'amountInCents': amountInCents,
        'description': description ?? 'No description extracted',
        'transactionType': transactionType,
        'sender': sender,
        'rawAmountMatch': amountMatch.group(0),
      };
    } catch (e) {
      return {'matched': false, 'error': e.toString()};
    }
  }
}
