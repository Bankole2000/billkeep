// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:dio/dio.dart';

// /// Custom FileService using Dio instead of `package:http`
// class DioFileService implements FileService {
//   final Dio _dio;

//   DioFileService({Dio? dio})
//     : _dio =
//           dio ??
//           Dio(
//             BaseOptions(
//               headers: {
//                 'User-Agent':
//                     'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
//                     '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
//                 'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
//               },
//               responseType: ResponseType.bytes,
//             ),
//           );

//   @override
//   Future<FileServiceResponse> get(
//     String url, {
//     Map<String, String>? headers,
//   }) async {
//     final response = await _dio.get<List<int>>(
//       url,
//       options: Options(headers: headers),
//     );
//     return _DioFileServiceResponse(response);
//   }

//   @override
//   Future<void> delete(String url, {Map<String, String>? headers}) async {
//     await _dio.delete(url, options: Options(headers: headers));
//   }
// }

// class _DioFileServiceResponse implements FileServiceResponse {
//   final Response<List<int>> _response;
//   _DioFileServiceResponse(this._response);

//   @override
//   int get statusCode => _response.statusCode ?? 500;

//   @override
//   Stream<List<int>> get content => Stream.value(_response.data ?? []);

//   @override
//   Map<String, String> get headers =>
//       _response.headers.map.map((k, v) => MapEntry(k, v.join(',')));

//   @override
//   void dispose() {}
// }

// /// Your custom CacheManager that uses DioFileService
// final customCacheManager = CacheManager(
//   Config(
//     'customLogoCache',
//     stalePeriod: const Duration(days: 30),
//     maxNrOfCacheObjects: 200,
//     fileService: DioFileService(),
//   ),
// );
