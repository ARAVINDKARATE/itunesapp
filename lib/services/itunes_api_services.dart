import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';

class ITunesApiService {
  final Dio _dio = Dio();

  Future<ITunesResponse> fetchMediaItems(String query) async {
    try {
      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'term': query,
          'limit': 300,
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
