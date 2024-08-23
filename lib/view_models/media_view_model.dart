// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:itunesapp/services/itunes_api_services.dart';

// final mediaItemsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
//   final apiService = ITunesApiService();
//   String items = 'Music';
//   final mediaItems = await apiService.fetchMediaItems('beatles', items as List<String>);
//   return mediaItems.map((item) => item['trackName'] as String).toList();
// });
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/services/itunes_api_services.dart';

final mediaItemsProvider = StateNotifierProvider<MediaItemsNotifier, AsyncValue<ITunesResponse>>(
  (ref) => MediaItemsNotifier(),
);

class MediaItemsNotifier extends StateNotifier<AsyncValue<ITunesResponse>> {
  final _apiService = ITunesApiService();

  MediaItemsNotifier() : super(const AsyncValue.loading());

  Future<void> searchMedia(String query, List<String> selectedItems) async {
    try {
      final result = await _apiService.fetchMediaItems(query);
      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
