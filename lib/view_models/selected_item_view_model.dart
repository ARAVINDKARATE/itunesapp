import 'package:flutter_riverpod/flutter_riverpod.dart';

// ViewModel: Handles the state for selected items
class SelectedItemsViewModel extends StateNotifier<List<String>> {
  SelectedItemsViewModel() : super([]);

  void selectItem(String item) {
    state = [...state, item];
  }

  void deselectItem(String item) {
    state = state.where((i) => i != item).toList();
  }

  void setSelectedItems(List<String> items) {
    state = items;
  }
}

// Provider for the ViewModel
final selectedItemsProvider = StateNotifierProvider<SelectedItemsViewModel, List<String>>((ref) {
  return SelectedItemsViewModel();
});
