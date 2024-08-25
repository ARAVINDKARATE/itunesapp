import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';

class ITunesApiService {
  final Dio _dio;

  ITunesApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://itunes.apple.com/',
            // other Dio options if necessary
          ),
        );

  Future<ITunesResponse> fetchMediaItems(String query, List<String> selectedItems) async {
    try {
      // If selectedItems is empty, set media to 'all'
      if (selectedItems.isEmpty) {
        selectedItems = ['all'];
      }

      List<MediaItem> allResults = [];
      int totalCount = 0;

      // Fetch data for each media type in selectedItems
      for (String mediaType in selectedItems) {
        final response = await _dio.get(
          'search',
          queryParameters: {
            'term': query,
            'media': mediaType,
            'limit': 30,
          },
        );

        if (response.statusCode == 200) {
          final data = response.data is String ? jsonDecode(response.data) : response.data;
          final iTunesResponse = ITunesResponse.fromJson(data);

          // Add results to the combined list
          allResults.addAll(iTunesResponse.results);
          totalCount += iTunesResponse.resultCount;
        } else {
          throw Exception('Failed to load media items: ${response.statusCode}');
        }
      }

      // Return a single ITunesResponse with all results combined
      return ITunesResponse(
        resultCount: totalCount,
        results: allResults,
      );
    } catch (e) {
      print(e);
      throw Exception('Error occurred while fetching media items: $e');
    }
  }
}
