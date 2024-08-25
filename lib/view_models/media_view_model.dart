import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/services/itunes_api_services.dart';
import 'package:itunesapp/view_models/itunes_response_view_model.dart';

// Provider for MediaItemsNotifier, managing the state of ITunesResponse
final mediaItemsProvider = StateNotifierProvider<MediaItemsNotifier, AsyncValue<ITunesResponse>>(
  (ref) => MediaItemsNotifier(),
);

class MediaItemsNotifier extends StateNotifier<AsyncValue<ITunesResponse>> {
  final ITunesApiService _apiService;

  // Constructor with optional ITunesApiService for dependency injection
  // If no ITunesApiService is provided, a default instance is created
  MediaItemsNotifier([ITunesApiService? apiService])
      : _apiService = apiService ?? ITunesApiService(),
        super(const AsyncValue.loading());

  /// Searches for media items based on the provided query and selected items.
  /// Updates the state with the result of the search or with an error if the request fails.
  Future<void> searchMedia(String query, List<String> selectedItems) async {
    state = const AsyncValue.loading(); // Set the state to loading before making the request

    try {
      final result = await _apiService.fetchMediaItems(query, selectedItems); // Fetch media items from the API
      state = AsyncValue.data(result); // Update the state with the fetched media items
    } catch (e, stackTrace) {
      // Handle any errors and update the state with the error
      debugPrint(e.toString());
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
