import 'package:billkeep/models/preference_model.dart';
import 'package:billkeep/repositories/preference_repository.dart';
import 'package:billkeep/services/base_api_service.dart';
import 'package:billkeep/utils/connectivity_helper.dart';
import 'package:billkeep/utils/preference_enums.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends BaseApiService {
  final PreferenceRepository _repository;
  SharedPreferences? _sharedPreferences;

  PreferenceService(this._repository) {
    print('Preference Service initialized');
    _setupRealtimeSync();
  }

 /// Initialize SharedPreferences
  Future<void> _initializeSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  /// Setup realtime sync for preferences collection
  void _setupRealtimeSync() {
    subscribeToCollection('preferences', _handlePreferenceUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handlePreferenceUpdate(RecordSubscriptionEvent event) {
    print('🔄 Preference ${event.action}: ${event.record?.id}');
    _initializeSharedPreferences();

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncPreferenceFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            _repository.getPreferenceByTempId(
              tempId: event.record!.getStringValue('tempId'),
            ).then((preference) {
              if (preference != null) {
                _repository.deletePreferenceByTempId(preference.tempId!);
              }
            });
            print('🗑️ Preference deleted: ${event.record!.id}');
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling preference update: $e');
    }
  }

  /// Sync preference from backend to local DB
  Future<void> _syncPreferenceFromBackend(RecordModel record) async {
    try {
      final canonicalId = record.id;
      
      final localPreference = await _repository.getPreferenceByTempId(
        tempId: record.getStringValue('tempId'),
      );
      print('🔍 Search for local preference record');
      print('🔍 Found - ${localPreference.toString()}');
      print('♻️ Converting remote record to PreferenceModel');
      final remotePreference = PreferenceModel.fromJson(record.toJson());
      print('♻️ Conversion complete - ${remotePreference.toString()}');
      _initializeSharedPreferences();
      if(localPreference == null) {
        print('🔐 local record exists, checking if record for current user');
        // Check if preference is for current user
        final currentUserId = _sharedPreferences!.getString(PreferenceKey.LOGGED_IN_USER.toString());
        
        if (remotePreference.user == currentUserId) {
          print('📥 Creating new preference from backend: $canonicalId');
          await _repository.createPreference(remotePreference);
          await _setSharedPreference(remotePreference);
        }
        // Create new preference locally
      } else if (!localPreference.isEqualTo(remotePreference)){

        // Update existing preference locally
        print('🔄 Updating preference from backend: $canonicalId');
        final mergedPreference = localPreference.merge(remotePreference);
        await _repository.updatePreference(mergedPreference);
        await _setSharedPreference(mergedPreference);
      }
      print('📥 Syncing preference: canonicalId=$canonicalId');
    } catch (e) {
      print('⚠️ Error syncing preference: $e');
    }
  }

  // Set shared preference by field type
  Future<void> _setSharedPreference(PreferenceModel preference) async {
    await _initializeSharedPreferences();
    switch (preference.type) {
      case 'string':
      case 'url':
      case 'email':
        if (preference.stringValue != null) {
          _sharedPreferences!.setString(preference.key, preference.stringValue!);
        }
        break;
      case 'number':
        if (preference.numberValue != null) {
          _sharedPreferences!.setInt(preference.key, preference.numberValue!);
        }
        break;
      case 'boolean':
        if (preference.booleanValue != null) {
          _sharedPreferences!.setBool(preference.key, preference.booleanValue!);
        }
        break;
      case 'datetime':
        if (preference.dateTimeValue != null) {
          _sharedPreferences!.setString(preference.key, preference.dateTimeValue!.toIso8601String());
        }
        break;
      case 'object':
        if (preference.objectValue != null) {
          _sharedPreferences!.setString(preference.key, preference.objectValue.toString());
        }
        break;
      default:
        print('⚠️ Unsupported preference field type: ${preference.type}');
    }
  }
  /// Create a new preference
  Future<PreferenceModel> createPreference(PreferenceModel newPreferenceData) async {
    final tempId = await _repository.createPreference(newPreferenceData);
    await _initializeSharedPreferences();
    _sharedPreferences!.setString(newPreferenceData.key, newPreferenceData.stringValue ?? '');

    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline) {
      try {
        final apiPreference = await executeRequest<PreferenceModel>(
          request: () => dio.post(
            '/preferences/records', 
            data: newPreferenceData.toJson()..['tempId'] = tempId,), 
          parser: (data) => PreferenceModel.fromJson(data));
        return apiPreference;
      } catch (e) {
        print('❌ Error creating preference on backend: $e');
      }
    }

    final localPreference = await _repository.getPreferenceByTempId(tempId: tempId);
    if (localPreference != null) {
      return localPreference;
    }
    throw Exception('Failed to create preference locally or on backend');
  }

  Future<List<PreferenceModel>> getUserPreferences(String userId) async {
    final apiPreferences = await executeRequest<List<PreferenceModel>>(
      request: () => dio.get('/preferences/records', 
        queryParameters: {
          'filter': 'user="$userId"',
          'expand': 'user',
        }),
      parser: (data) {
        final records = data['items'] as List<dynamic>;
        return records
            .map((item) => PreferenceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
    return apiPreferences;
  }

}