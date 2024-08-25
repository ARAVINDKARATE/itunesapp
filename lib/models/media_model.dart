class MediaItem {
  // Fields
  final String? wrapperType; // Type of the wrapper (e.g., track, album)
  final String? kind; // Type of the media item (e.g., song, movie)
  final int? artistId; // ID of the artist
  final int? collectionId; // ID of the collection (e.g., album)
  final int? trackId; // ID of the track
  final String? artistName; // Name of the artist
  final String? collectionName; // Name of the collection
  final String? trackName; // Name of the track
  final String? artistViewUrl; // URL to view the artist
  final String? collectionViewUrl; // URL to view the collection
  final String? trackViewUrl; // URL to view the track
  final String? previewUrl; // URL to preview the track
  final String? artworkUrl30; // Artwork URL (30x30)
  final String? artworkUrl60; // Artwork URL (60x60)
  final String? artworkUrl100; // Artwork URL (100x100)
  final double? collectionPrice; // Price of the collection
  final double? trackPrice; // Price of the track
  final String? releaseDate; // Release date of the track
  final String? collectionExplicitness; // Explicitness of the collection
  final String? trackExplicitness; // Explicitness of the track
  final int? discCount; // Number of discs in the collection
  final int? discNumber; // Disc number
  final int? trackCount; // Number of tracks in the collection
  final int? trackNumber; // Track number
  final int? trackTimeMillis; // Track duration in milliseconds
  final String? country; // Country of the media
  final String? currency; // Currency for the price
  final String? primaryGenreName; // Genre of the media
  final String? contentAdvisoryRating; // Content advisory rating
  final bool? isStreamable; // Whether the media is streamable
  final String? description; // Description of the media
  final String? shortDescription; // Short description of the media
  final String? longDescription; // Long description of the media
  final bool? hasITunesExtras; // Whether the media has iTunes extras

  // Constructor
  MediaItem({
    this.wrapperType,
    this.kind,
    this.artistId,
    this.collectionId,
    this.trackId,
    this.artistName,
    this.collectionName,
    this.trackName,
    this.artistViewUrl,
    this.collectionViewUrl,
    this.trackViewUrl,
    this.previewUrl,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.collectionPrice,
    this.trackPrice,
    this.releaseDate,
    this.collectionExplicitness,
    this.trackExplicitness,
    this.discCount,
    this.discNumber,
    this.trackCount,
    this.trackNumber,
    this.trackTimeMillis,
    this.country,
    this.currency,
    this.primaryGenreName,
    this.contentAdvisoryRating,
    this.isStreamable,
    this.description,
    this.shortDescription,
    this.longDescription,
    this.hasITunesExtras,
  });

  // Factory constructor for creating an instance from JSON
  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      wrapperType: json['wrapperType'] as String?,
      kind: json['kind'] as String?,
      artistId: json['artistId'] as int?,
      collectionId: json['collectionId'] as int?,
      trackId: json['trackId'] as int?,
      artistName: json['artistName'] as String?,
      collectionName: json['collectionName'] as String?,
      trackName: json['trackName'] as String?,
      artistViewUrl: json['artistViewUrl'] as String?,
      collectionViewUrl: json['collectionViewUrl'] as String?,
      trackViewUrl: json['trackViewUrl'] as String?,
      previewUrl: json['previewUrl'] as String?,
      artworkUrl30: json['artworkUrl30'] as String?,
      artworkUrl60: json['artworkUrl60'] as String?,
      artworkUrl100: json['artworkUrl100'] as String?,
      collectionPrice: (json['collectionPrice'] as num?)?.toDouble(),
      trackPrice: (json['trackPrice'] as num?)?.toDouble(),
      releaseDate: json['releaseDate'] as String?,
      collectionExplicitness: json['collectionExplicitness'] as String?,
      trackExplicitness: json['trackExplicitness'] as String?,
      discCount: json['discCount'] as int?,
      discNumber: json['discNumber'] as int?,
      trackCount: json['trackCount'] as int?,
      trackNumber: json['trackNumber'] as int?,
      trackTimeMillis: json['trackTimeMillis'] as int?,
      country: json['country'] as String?,
      currency: json['currency'] as String?,
      primaryGenreName: json['primaryGenreName'] as String?,
      contentAdvisoryRating: json['contentAdvisoryRating'] as String?,
      isStreamable: json['isStreamable'] as bool?,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      longDescription: json['longDescription'] as String?,
      hasITunesExtras: json['hasITunesExtras'] as bool?,
    );
  }

  // CopyWith method for creating a modified copy of the instance
  MediaItem copyWith({
    String? wrapperType,
    String? kind,
    int? artistId,
    int? collectionId,
    int? trackId,
    String? artistName,
    String? collectionName,
    String? trackName,
    String? artistViewUrl,
    String? collectionViewUrl,
    String? trackViewUrl,
    String? previewUrl,
    String? artworkUrl30,
    String? artworkUrl60,
    String? artworkUrl100,
    double? collectionPrice,
    double? trackPrice,
    String? releaseDate,
    String? collectionExplicitness,
    String? trackExplicitness,
    int? discCount,
    int? discNumber,
    int? trackCount,
    int? trackNumber,
    int? trackTimeMillis,
    String? country,
    String? currency,
    String? primaryGenreName,
    String? contentAdvisoryRating,
    bool? isStreamable,
    String? description,
    String? shortDescription,
    String? longDescription,
    bool? hasITunesExtras,
  }) {
    return MediaItem(
      wrapperType: wrapperType ?? this.wrapperType,
      kind: kind ?? this.kind,
      artistId: artistId ?? this.artistId,
      collectionId: collectionId ?? this.collectionId,
      trackId: trackId ?? this.trackId,
      artistName: artistName ?? this.artistName,
      collectionName: collectionName ?? this.collectionName,
      trackName: trackName ?? this.trackName,
      artistViewUrl: artistViewUrl ?? this.artistViewUrl,
      collectionViewUrl: collectionViewUrl ?? this.collectionViewUrl,
      trackViewUrl: trackViewUrl ?? this.trackViewUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      artworkUrl30: artworkUrl30 ?? this.artworkUrl30,
      artworkUrl60: artworkUrl60 ?? this.artworkUrl60,
      artworkUrl100: artworkUrl100 ?? this.artworkUrl100,
      collectionPrice: collectionPrice ?? this.collectionPrice,
      trackPrice: trackPrice ?? this.trackPrice,
      releaseDate: releaseDate ?? this.releaseDate,
      collectionExplicitness: collectionExplicitness ?? this.collectionExplicitness,
      trackExplicitness: trackExplicitness ?? this.trackExplicitness,
      discCount: discCount ?? this.discCount,
      discNumber: discNumber ?? this.discNumber,
      trackCount: trackCount ?? this.trackCount,
      trackNumber: trackNumber ?? this.trackNumber,
      trackTimeMillis: trackTimeMillis ?? this.trackTimeMillis,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      primaryGenreName: primaryGenreName ?? this.primaryGenreName,
      contentAdvisoryRating: contentAdvisoryRating ?? this.contentAdvisoryRating,
      isStreamable: isStreamable ?? this.isStreamable,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      hasITunesExtras: hasITunesExtras ?? this.hasITunesExtras,
    );
  }
}
