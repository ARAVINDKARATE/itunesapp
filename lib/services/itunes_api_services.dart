import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:itunesapp/models/media_model.dart';
import 'package:itunesapp/view_models/itunes_response_view_model.dart';

class ITunesApiService {
  final Dio _dio;

  ITunesApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://itunes.apple.com/',
          ),
        );

  /// Fetches media items from the iTunes API based on the search query and selected media types.
  /// If `selectedItems` is empty, it defaults to fetching all media types.
  /// Returns an [ITunesResponse] containing a list of combined results.
  Future<ITunesResponse> fetchMediaItems(String query, List<String> selectedItems) async {
    try {
      // If no media type is selected, default to 'all' media types
      if (selectedItems.isEmpty) {
        selectedItems = ['all'];
      }

      List<MediaItem> allResults = [];
      int totalCount = 0;

      // Fetch data for each media type in the selectedItems list
      for (String mediaType in selectedItems) {
        final response = await _dio.get(
          'search',
          queryParameters: {
            'term': query,
            'media': mediaType,
            'limit': 200 / selectedItems.length, // Limit results to 30 items per request
          },
        );

        if (response.statusCode == 200) {
          // Check if the response data is a JSON string and decode it if necessary
          final data = response.data is String ? jsonDecode(response.data) : response.data;
          final iTunesResponse = ITunesResponse.fromJson(data);

          // Accumulate results and update the total count
          allResults.addAll(iTunesResponse.results);
          totalCount += iTunesResponse.resultCount;
        } else {
          // Handle non-200 responses as errors
          throw Exception('Failed to load media items: ${response.statusCode}');
        }
      }

      // Return a single ITunesResponse with combined results and total count
      return ITunesResponse(
        resultCount: totalCount,
        results: allResults,
      );
    } catch (e) {
      // Catch and rethrow any exceptions that occur during the fetch process
      throw Exception('Error occurred while fetching media items: $e');
    }
  }
}
