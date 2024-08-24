// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:itunesapp/models/iTunes_response_model.dart';

// class ITunesApiService {
//   final Dio _dio = Dio();

//   Future<ITunesResponse> fetchMediaItems(String query) async {
//     try {
//       final response = await _dio.get(
//         'https://itunes.apple.com/search',
//         queryParameters: {
//           'term': query,
//           'limit': 200,
//           // 'media': 'music', // Assuming selectedItems is a list of media types
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = response.data is String ? jsonDecode(response.data) : response.data;
//         return ITunesResponse.fromJson(data);
//       } else {
//         throw Exception('Failed to load media items');
//       }
//     } catch (e) {
//       throw Exception('Error occurred: $e');
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';

class ITunesApiService {
  final Dio _dio;

  ITunesApiService() : _dio = Dio() {
    // Create a new HttpClientAdapter with SSL pinning
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Extract the public key and compare with pinned key
        final publicKeyBytes = cert.der;
        final publicKeyBase64 = base64.encode(publicKeyBytes);

        // Replace the following with your actual pinned public key base64 string
        const pinnedPublicKeyBase64 = 'YOUR_PINNED_PUBLIC_KEY_BASE64';

        return publicKeyBase64 == pinnedPublicKeyBase64;
      };
    };
  }

  Future<ITunesResponse> fetchMediaItems(String query) async {
    try {
      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'term': query,
          'limit': 200,
          // 'media': 'music', // Assuming selectedItems is a list of media types
        },
      );
      if (response.statusCode == 200) {
        final data = response.data is String ? jsonDecode(response.data) : response.data;
        return ITunesResponse.fromJson(data);
      } else {
        throw Exception('Failed to load media items');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
