import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/io.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';

class ITunesApiService {
  final Dio _dio;

  ITunesApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://itunes.apple.com/',
            // other Dio options if necessary
          ),
        ) {
    // Customize the HTTP client for SSL pinning
    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Replace with the provided public key hash
        const String pinnedPublicKeyHash = '287db34ced32c2864cc5ed6c0b0ffaf359e9ec170549ab8b3ade466025d5051f';

        // Extract and hash the public key
        final publicKey = cert.pem.trim().split('\n').skip(1).takeWhile((line) => line != '-----END PUBLIC KEY-----').join();
        final publicKeyHash = sha256.convert(utf8.encode(publicKey)).toString();

        return publicKeyHash == pinnedPublicKeyHash;
      };
      return client;
    };
  }

  Future<ITunesResponse> fetchMediaItems(String query) async {
    try {
      final response = await _dio.get(
        'search',
        queryParameters: {
          'term': query,
          'limit': 200,
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
