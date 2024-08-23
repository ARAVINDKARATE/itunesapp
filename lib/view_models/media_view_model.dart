import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/services/itunes_api_services.dart';

// Provider for managing media items state
final mediaItemsProvider = StateNotifierProvider<MediaItemsNotifier, AsyncValue<ITunesResponse>>(
  (ref) => MediaItemsNotifier(),
);

// Notifier class for managing the state of media items
class MediaItemsNotifier extends StateNotifier<AsyncValue<ITunesResponse>> {
  final _apiService = ITunesApiService(); // Instance of the API service

  MediaItemsNotifier() : super(const AsyncValue.loading()); // Initial state is loading

  // Method to search for media items
  Future<void> searchMedia(String query, List<String> selectedItems) async {
    state = const AsyncValue.loading(); // Set state to loading before starting the search
    try {
      final result = await _apiService.fetchMediaItems(
        query,
      ); // Fetch media items
      state = AsyncValue.data(result); // Set state to data if successful
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set state to error if an exception occurs
    }
  }
}
