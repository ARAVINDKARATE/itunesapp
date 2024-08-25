import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel that manages the state of selected items.
class SelectedItemsViewModel extends StateNotifier<List<String>> {
  /// Creates an instance of [SelectedItemsViewModel].
  SelectedItemsViewModel() : super([]);

  /// Adds an item to the selected items list.
  void selectItem(String item) {
    if (!state.contains(item)) {
      state = [...state, item];
    }
  }

  /// Removes an item from the selected items list.
  void deselectItem(String item) {
    state = state.where((i) => i != item).toList();
  }

  /// Sets the selected items to a new list.
  void setSelectedItems(List<String> items) {
    state = items;
  }
}
