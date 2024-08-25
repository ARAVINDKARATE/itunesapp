import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/view_models/selected_item_view_model.dart';

/// Provider for managing the selected items state
final selectedItemsProvider = StateNotifierProvider<SelectedItemsViewModel, List<String>>(
  (ref) => SelectedItemsViewModel(),
);
