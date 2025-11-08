import 'package:dio/dio.dart';
import '../models/contact_model.dart';
import 'api_client.dart';

class ContactService {
  final ApiClient _apiClient;

  ContactService() : _apiClient = ApiClient();

  /// Create a new contact
  Future<ContactModel> createContact({
    required String name,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/contacts',
        data: {
          'name': name,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
        },
      );

      return ContactModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all contacts
  Future<List<ContactModel>> getAllContacts({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/contacts',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((contact) => ContactModel.fromJson(contact))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((contact) => ContactModel.fromJson(contact))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single contact by ID
  Future<ContactModel> getContactById(String id) async {
    try {
      final response = await _apiClient.dio.get('/contacts/$id');
      return ContactModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
      if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
      if (iconType != null) data['iconType'] = iconType;
      if (color != null) data['color'] = color;

      final response = await _apiClient.dio.put('/contacts/$id', data: data);
      return ContactModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a contact
  Future<void> deleteContact(String id) async {
    try {
      await _apiClient.dio.delete('/contacts/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create contact info (phone, email, etc.)
  Future<ContactInfoModel> createContactInfo({
    required String contactId,
    required String value,
    required String type,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/contacts/$contactId/info',
        data: {
          'value': value,
          'type': type,
        },
      );

      return ContactInfoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all contact info for a contact
  Future<List<ContactInfoModel>> getContactInfo({
    required String contactId,
    String? type,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (type != null) queryParameters['type'] = type;

      final response = await _apiClient.dio.get(
        '/contacts/$contactId/info',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((info) => ContactInfoModel.fromJson(info))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((info) => ContactInfoModel.fromJson(info))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update contact info
  Future<ContactInfoModel> updateContactInfo({
    required String contactId,
    required String infoId,
    String? value,
    String? type,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (value != null) data['value'] = value;
      if (type != null) data['type'] = type;

      final response = await _apiClient.dio.put(
        '/contacts/$contactId/info/$infoId',
        data: data,
      );
      return ContactInfoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete contact info
  Future<void> deleteContactInfo({
    required String contactId,
    required String infoId,
  }) async {
    try {
      await _apiClient.dio.delete('/contacts/$contactId/info/$infoId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Bad request';
        case 401:
          return data['message'] ?? 'Unauthorized';
        case 403:
          return data['message'] ?? 'Forbidden';
        case 404:
          return data['message'] ?? 'Contact not found';
        case 409:
          return data['message'] ?? 'Conflict';
        case 500:
          return 'Internal server error';
        default:
          return data['message'] ?? 'An error occurred';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    } else {
      return error.message ?? 'An unexpected error occurred';
    }
  }
}
