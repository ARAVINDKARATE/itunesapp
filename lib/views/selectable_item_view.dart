import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/view_models/selected_item_view_model.dart';

/// A screen that allows users to select or deselect media types.
class SelectableItemsScreen extends ConsumerWidget {
  /// List of media types available for selection.
  final List<String> _items = ['ebook', 'tvShow', 'shortFilm', 'audiobook', 'movie', 'musicVideo', 'podcast', 'music'];

  /// Creates an instance of [SelectableItemsScreen].
  SelectableItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected items state
    final selectedItems = ref.watch(selectedItemsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, selectedItems); // Return selected items on back
          },
        ),
        title: const Text(
          'Media',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final isSelected = selectedItems.contains(item);

          return Column(
            children: [
              ListTile(
                title: Text("${item.substring(0, 1).toUpperCase()}${item.substring(1).toLowerCase()}", style: const TextStyle(color: Colors.white)),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.check, color: Colors.white),
                onTap: () {
                  final viewModel = ref.read(selectedItemsProvider.notifier);
                  if (isSelected) {
                    viewModel.deselectItem(item);
                  } else {
                    viewModel.selectItem(item);
                  }
                },
              ),
              const Divider(
                thickness: 0.5,
                indent: 15,
                endIndent: 15,
              ),
            ],
          );
        },
      ),
    );
  }
}
