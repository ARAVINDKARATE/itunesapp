import 'package:itunesapp/models/media_model.dart';

class ITunesResponse {
  final int resultCount;
  final List<MediaItem> results;

  ITunesResponse({required this.resultCount, required this.results});

  factory ITunesResponse.fromJson(Map<String, dynamic> json) {
    // Safely extract the results list and map it to MediaItem
    final resultsJson = json['results'] as List<dynamic>? ?? [];
    final mediaList = resultsJson.map((item) {
      if (item is Map<String, dynamic>) {
        return MediaItem.fromJson(item);
      } else {
        // Handle or log error if the item is not a valid Map
        throw const FormatException('Invalid item format in results list');
      }
    }).toList();

    // Safely extract resultCount, ensuring it's an integer
    final resultCount = json['resultCount'] is int ? json['resultCount'] as int : int.tryParse(json['resultCount'].toString()) ?? 0;

    return ITunesResponse(
      resultCount: resultCount,
      results: mediaList,
    );
  }
}
