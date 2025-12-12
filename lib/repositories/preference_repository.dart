import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/preference_model.dart';
import 'package:billkeep/utils/id_generator.dart';

class PreferenceRepository {
  final AppDatabase _database;

  PreferenceRepository(this._database);

  Future<String> createPreference(PreferenceModel newPreference) async {
    final tempId = IdGenerator.tempPreference();
    try {
      await _database.into(_database.preferences).insert(
        newPreference.toCompanion(tempId: newPreference.tempId ?? tempId, id: newPreference.id ?? tempId),
      );
    } catch (e) {
      print('❌ Error creating preference in local DB: $e');
      rethrow;
    }
    return tempId;
  }

  Future<PreferenceModel?> getPreferenceByTempId({required String tempId}) async {
    final preferenceRecord = await (_database.select(
      _database.preferences,
    )..where((p) => p.tempId.equals(tempId))).getSingleOrNull();
    if(preferenceRecord != null) {
      return PreferenceModel.fromDrift(preferenceRecord);
    }
    return null;
  }

  Future<String> updatePreference(PreferenceModel preference) async {
    if (preference.id == null) {
      throw ArgumentError('Cannot update preference without an ID');
    }
    try {
      await (_database.update(
        _database.preferences,
      )..where((tbl) => tbl.id.equals(preference.id!))).write(preference.toCompanion());
    } catch (e) {
      print('❌ Error updating preference in local DB: $e');
      rethrow;
    }

    return preference.id!;
  }

  Future<void> deletePreferenceByTempId(String tempId) async {
    try {
      await (_database.delete(
        _database.preferences,
      )..where((tbl) => tbl.tempId.equals(tempId))).go();
    } catch (e) {
      print('❌ Error deleting preference from local DB: $e');
      rethrow;
    }
  }
}