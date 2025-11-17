// import 'package:dio/dio.dart';
// import 'package:drift/drift.dart';
// import '../../database/database.dart';
// import '../../models/income_model.dart';
// import '../../providers/income_provider.dart';
// import '../../services/api_client.dart';
// import '../../utils/exceptions.dart';
// import '../../utils/id_generator.dart';
// import 'base_sync_service.dart';

// /// Synchronization service for Income
// ///
// /// Handles bidirectional sync between local Drift database and remote API
// /// Makes DIRECT API calls (not through IncomeService) to avoid double-writing
// class IncomeSyncService extends BaseSyncService {
//   final AppDatabase _database;
//   final IncomeRepository _repository;
//   final Dio _dio;

//   IncomeSyncService({
//     required AppDatabase database,
//     required IncomeRepository repository,
//     Dio? dio,
//   })  : _database = database,
//         _repository = repository,
//         _dio = dio ?? ApiClient().dio;

//   @override
//   Future<void> syncEntity(String tempId) async {
//     // Check if already synced
//     if (!IdGenerator.isTemporaryId(tempId)) {
//       return; // Already has canonical ID
//     }

//     // Get the local income
//     final localIncome = await (_database.select(
//       _database.incomes,
//     )..where((i) => i.id.equals(tempId))).getSingleOrNull();

//     if (localIncome == null) {
//       throw NotFoundException(
//         'Income with temp ID $tempId not found',
//         'The income you are trying to sync does not exist',
//       );
//     }

//     // Check if it's already synced
//     if (localIncome.isSynced) {
//       return;
//     }

//     // Send to API directly (not through IncomeService to avoid double-writing)
//     try {
//       final response = await _dio.post(
//         '/income/records',
//         data: {
//           'projectId': localIncome.projectId,
//           'name': localIncome.name,
//           'expectedAmount': localIncome.expectedAmount,
//           'currency': localIncome.currency,
//           'type': localIncome.type,
//           'frequency': localIncome.frequency,
//           'startDate': localIncome.startDate.toIso8601String(),
//           'nextRenewalDate': localIncome.nextRenewalDate?.toIso8601String(),
//           'categoryId': localIncome.categoryId,
//           'merchantId': localIncome.merchantId,
//           'contactId': localIncome.contactId,
//           'walletId': localIncome.walletId,
//           'source': localIncome.source,
//           'notes': localIncome.notes,
//           'isActive': localIncome.isActive,
//         },
//       );

//       final apiIncome = IncomeModel.fromJson(response.data);

//       // Update local database with canonical ID
//       await _updateIncomeWithCanonicalId(
//         tempId: tempId,
//         canonicalId: apiIncome.id,
//       );
//     } on DioException catch (e) {
//       final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
//       throw SyncException(
//         'Failed to sync income: $message',
//         'Unable to sync income. Will retry later.',
//       );
//     } catch (e) {
//       throw SyncException(
//         'Failed to sync income: ${e.toString()}',
//         'Unable to sync income. Will retry later.',
//       );
//     }
//   }

//   @override
//   Future<List<String>> getUnsyncedEntityIds() async {
//     final unsyncedIncomes = await (_database.select(
//       _database.incomes,
//     )..where((i) => i.isSynced.equals(false))).get();

//     return unsyncedIncomes.map((i) => i.id).toList();
//   }

//   @override
//   Future<void> pullFromServer({String? projectId}) async {
//     try {
//       // Fetch incomes from API directly
//       final queryParams = projectId != null ? {'projectId': projectId} : null;
//       final response = await _dio.get(
//         '/income/records',
//         queryParameters: queryParams,
//       );

//       List<IncomeModel> apiIncomes;
//       if (response.data is List) {
//         apiIncomes = (response.data as List)
//             .map((item) => IncomeModel.fromJson(item as Map<String, dynamic>))
//             .toList();
//       } else if (response.data is Map && response.data['items'] != null) {
//         apiIncomes = (response.data['items'] as List)
//             .map((item) => IncomeModel.fromJson(item as Map<String, dynamic>))
//             .toList();
//       } else {
//         apiIncomes = [];
//       }

//       // For each API income, update or insert in local database
//       for (final apiIncome in apiIncomes) {
//         final existingIncome = await (_database.select(
//           _database.incomes,
//         )..where((i) => i.id.equals(apiIncome.id))).getSingleOrNull();

//         if (existingIncome != null) {
//           // Update existing
//           await (_database.update(
//             _database.incomes,
//           )..where((i) => i.id.equals(apiIncome.id))).write(
//             IncomesCompanion(
//               name: Value(apiIncome.name),
//               expectedAmount: Value(apiIncome.expectedAmount),
//               currency: Value(apiIncome.currency),
//               type: Value(apiIncome.type),
//               frequency: Value(apiIncome.frequency),
//               startDate: Value(apiIncome.startDate),
//               nextRenewalDate: Value(apiIncome.nextRenewalDate),
//               categoryId: Value(apiIncome.categoryId),
//               merchantId: Value(apiIncome.merchantId),
//               notes: Value(apiIncome.notes),
//               isActive: Value(apiIncome.isActive),
//               isSynced: const Value(true),
//             ),
//           );
//         } else {
//           // Insert new (would need all required fields)
//           // Skipping insert for now as it requires all mandatory fields
//         }
//       }
//     } on DioException catch (e) {
//       final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
//       throw SyncException(
//         'Failed to pull incomes from server: $message',
//         'Unable to fetch incomes from server.',
//       );
//     } catch (e) {
//       throw SyncException(
//         'Failed to pull incomes from server: ${e.toString()}',
//         'Unable to fetch incomes from server.',
//       );
//     }
//   }

//   /// Perform bidirectional sync
//   Future<SyncResult> performFullSync() async {
//     if (!await isOnline()) {
//       return SyncResult.failure('No internet connection');
//     }

//     try {
//       // First push local changes
//       final pushResult = await syncAll();

//       // Then pull from server
//       await pullFromServer();

//       return pushResult;
//     } catch (e) {
//       return SyncResult.failure(e.toString());
//     }
//   }

//   /// Update an income with its canonical ID after successful sync
//   Future<void> _updateIncomeWithCanonicalId({
//     required String tempId,
//     required String canonicalId,
//   }) async {
//     // Map the IDs
//     await _database.mapId(
//       tempId: tempId,
//       canonicalId: canonicalId,
//       resourceType: 'income',
//     );

//     // Update income with canonical ID
//     await (_database.update(
//       _database.incomes,
//     )..where((i) => i.id.equals(tempId))).write(
//       IncomesCompanion(
//         id: Value(canonicalId),
//         isSynced: const Value(true),
//       ),
//     );
//   }

//   /// Delete an income both locally and on server
//   Future<void> deleteIncome(String incomeId) async {
//     // Delete from server if it's a canonical ID
//     if (!IdGenerator.isTemporaryId(incomeId) && await isOnline()) {
//       try {
//         await _dio.delete('/income/records/$incomeId');
//       } on DioException catch (e) {
//         final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
//         throw SyncException(
//           'Failed to delete income from server: $message',
//           'Unable to delete income from server.',
//         );
//       }
//     }

//     // Delete from local database
//     await (_database.delete(
//       _database.incomes,
//     )..where((i) => i.id.equals(incomeId))).go();
//   }

//   /// Update an income both locally and on server
//   Future<void> updateIncome({
//     required String incomeId,
//     required String name,
//     int? expectedAmount,
//     // Add other fields as needed
//   }) async {
//     // Update locally first (offline-first approach)
//     await (_database.update(
//       _database.incomes,
//     )..where((i) => i.id.equals(incomeId))).write(
//       IncomesCompanion(
//         name: Value(name),
//         expectedAmount: expectedAmount != null ? Value(expectedAmount) : const Value.absent(),
//         isSynced: const Value(false), // Mark as needing sync
//       ),
//     );

//     // If online and has canonical ID, sync immediately
//     if (!IdGenerator.isTemporaryId(incomeId) && await isOnline()) {
//       try {
//         await _dio.patch(
//           '/income/records/$incomeId',
//           data: {
//             'name': name,
//             if (expectedAmount != null) 'expectedAmount': expectedAmount,
//           },
//         );

//         // Mark as synced
//         await (_database.update(_database.incomes)
//               ..where((i) => i.id.equals(incomeId)))
//             .write(const IncomesCompanion(isSynced: Value(true)));
//       } on DioException catch (e) {
//         final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
//         throw SyncException(
//           'Updated locally but failed to sync: $message',
//           'Changes saved locally and will sync when connection is available',
//         );
//       }
//     }
//   }
// }
