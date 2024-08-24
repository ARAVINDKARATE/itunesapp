import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/services/itunes_api_services.dart';

final mediaItemsProvider = StateNotifierProvider<MediaItemsNotifier, AsyncValue<ITunesResponse>>(
  (ref) => MediaItemsNotifier(),
);

class MediaItemsNotifier extends StateNotifier<AsyncValue<ITunesResponse>> {
  final ITunesApiService _apiService;

  MediaItemsNotifier([ITunesApiService? apiService])
      : _apiService = apiService ?? ITunesApiService(),
        super(const AsyncValue.loading());

  Future<void> searchMedia(String query, List<String> selectedItems) async {
    state = const AsyncValue.loading();

    try {
      final result = await _apiService.fetchMediaItems(query, selectedItems);
      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
