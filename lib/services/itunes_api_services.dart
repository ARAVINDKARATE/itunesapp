import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:itunesapp/models/media_model.dart';
import 'package:itunesapp/view_models/itunes_response_view_model.dart';
import 'package:flutter/foundation.dart';

class ITunesApiService {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  ITunesApiService({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://itunes.apple.com/',
            connectTimeout: const Duration(seconds: 2),
            receiveTimeout: const Duration(seconds: 2),
          ),
        );

  /// Fetches media items from the iTunes API based on the search query and selected media types.
  /// If `selectedItems` is empty, it defaults to fetching all media types.
  /// Returns an [ITunesResponse] containing a list of combined results.
  Future<ITunesResponse> fetchMediaItems(String query, List<String> selectedItems) async {
    if (selectedItems.isEmpty) {
      selectedItems = ['all'];
    }

    List<Future<ITunesResponse>> requests = selectedItems.map((mediaType) async {
      int attempt = 0;

      while (attempt < maxRetries) {
        try {
          final response = await _dio.get(
            'search',
            queryParameters: {
              'term': query,
              'media': mediaType,
              'limit': 200 ~/ selectedItems.length,
            },
          );

          if (response.statusCode == 200) {
            final data = response.data is String ? jsonDecode(response.data) : response.data;

            // Explicitly specify the types for compute function
            final iTunesResponse = await compute<Map<String, dynamic>, ITunesResponse>(
              ITunesResponse.fromJson,
              data,
            );

            return iTunesResponse;
          } else {
            throw Exception('Failed to load media items: ${response.statusCode}');
          }
        } catch (e) {
          attempt++;
          if (attempt >= maxRetries) {
            debugPrint(e.toString());
            throw Exception('Error occurred while fetching media items after $attempt attempts: $e');
          }
          await Future.delayed(retryDelay);
        }
      }
      return ITunesResponse(resultCount: 0, results: []);
    }).toList();

    final responses = await Future.wait(requests);

    // Combine all results from parallel requests
    List<MediaItem> allResults = [];
    int totalCount = 0;

    for (var response in responses) {
      allResults.addAll(response.results);
      totalCount += response.resultCount;
    }

    return ITunesResponse(
      resultCount: totalCount,
      results: allResults,
    );
  }
}
