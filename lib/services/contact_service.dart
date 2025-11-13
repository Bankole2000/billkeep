import '../models/contact_model.dart';
import 'base_api_service.dart';

class ContactService extends BaseApiService {
  /// Create a new contact
  Future<ContactModel> createContact({
    required String name,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    return executeRequest<ContactModel>(
      request: () => dio.post(
        '/contacts',
        data: {
          'name': name,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
        },
      ),
      parser: (data) => ContactModel.fromJson(data),
    );
  }

  /// Get all contacts
  Future<List<ContactModel>> getAllContacts({
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<ContactModel>(
      request: () => dio.get(
        '/contacts',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => ContactModel.fromJson(json),
    );
  }

  /// Get a single contact by ID
  Future<ContactModel> getContactById(String id) async {
    return executeRequest<ContactModel>(
      request: () => dio.get('/contacts/$id'),
      parser: (data) => ContactModel.fromJson(data),
    );
  }

  /// Update an existing contact
  Future<ContactModel> updateContact({
    required String id,
    String? name,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
    if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
    if (iconType != null) data['iconType'] = iconType;
    if (color != null) data['color'] = color;

    return executeRequest<ContactModel>(
      request: () => dio.put('/contacts/$id', data: data),
      parser: (data) => ContactModel.fromJson(data),
    );
  }

  /// Delete a contact
  Future<void> deleteContact(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/contacts/$id'),
    );
  }

  /// Create contact info (phone, email, etc.)
  Future<ContactInfoModel> createContactInfo({
    required String contactId,
    required String value,
    required String type,
  }) async {
    return executeRequest<ContactInfoModel>(
      request: () => dio.post(
        '/contacts/$contactId/info',
        data: {
          'value': value,
          'type': type,
        },
      ),
      parser: (data) => ContactInfoModel.fromJson(data),
    );
  }

  /// Get all contact info for a contact
  Future<List<ContactInfoModel>> getContactInfo({
    required String contactId,
    String? type,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (type != null) queryParameters['type'] = type;

    return executeListRequest<ContactInfoModel>(
      request: () => dio.get(
        '/contacts/$contactId/info',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => ContactInfoModel.fromJson(json),
    );
  }

  /// Update contact info
  Future<ContactInfoModel> updateContactInfo({
    required String contactId,
    required String infoId,
    String? value,
    String? type,
  }) async {
    final data = <String, dynamic>{};

    if (value != null) data['value'] = value;
    if (type != null) data['type'] = type;

    return executeRequest<ContactInfoModel>(
      request: () => dio.put(
        '/contacts/$contactId/info/$infoId',
        data: data,
      ),
      parser: (data) => ContactInfoModel.fromJson(data),
    );
  }

  /// Delete contact info
  Future<void> deleteContactInfo({
    required String contactId,
    required String infoId,
  }) async {
    return executeVoidRequest(
      request: () => dio.delete('/contacts/$contactId/info/$infoId'),
    );
  }
}
