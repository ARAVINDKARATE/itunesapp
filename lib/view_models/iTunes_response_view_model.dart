import 'package:itunesapp/models/media_model.dart';

class ITunesResponse {
  final int resultCount;
  final List<MediaItem> results;

  ITunesResponse({required this.resultCount, required this.results});

  factory ITunesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<MediaItem> mediaList = list.map((i) => MediaItem.fromJson(i)).toList();
    return ITunesResponse(
      resultCount: json['resultCount'] as int,
      results: mediaList,
    );
  }
}
