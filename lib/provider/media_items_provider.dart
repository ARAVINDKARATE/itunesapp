import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/view_models/itunes_response_view_model.dart';
import 'package:itunesapp/view_models/media_view_model.dart';

// Provider for MediaItemsNotifier, managing the state of ITunesResponse
final mediaItemsProvider = StateNotifierProvider<MediaItemsNotifier, AsyncValue<ITunesResponse>>(
  (ref) => MediaItemsNotifier(),
);
