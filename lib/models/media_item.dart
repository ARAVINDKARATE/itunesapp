// lib/models/media_item.dart
class MediaItem {
  final String mediaType;
  final String title;
  final String artist;
  final String artworkUrl;
  final String previewUrl;

  MediaItem({
    required this.mediaType,
    required this.title,
    required this.artist,
    required this.artworkUrl,
    required this.previewUrl,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      mediaType: json['kind'] ?? 'unknown',
      title: json['trackName'] ?? 'No Title',
      artist: json['artistName'] ?? 'Unknown Artist',
      artworkUrl: json['artworkUrl100'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }
}
