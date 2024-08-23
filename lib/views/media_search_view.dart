import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/view_models/media_view_model.dart';
import 'package:itunesapp/view_models/selected_item_view_model.dart';
import 'package:itunesapp/views/media_view.dart';
import 'package:itunesapp/views/selectable_item_view.dart';

class MediaSearchView extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  MediaSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final selectedItems = ref.watch(selectedItemsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/iTunes_logo.jpg', height: 36.0),
                    ],
                  ),
                  SizedBox(height: height * 0.07),
                  const Text(
                    'Search for a variety of content from the iTunes store including iBooks, movies, podcasts, music, music videos, and audiobooks',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: height * 0.04),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.white70),
                      fillColor: Colors.grey[800],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: height * 0.04),
                  const Text(
                    'Specify the parameters for the content to be searched',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: height * 0.04),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectableItemsScreen(),
                        ),
                      );
                      if (result != null) {
                        ref.read(selectedItemsProvider.notifier).setSelectedItems(result);
                      }
                    },
                    child: Container(
                      width: width,
                      height: height * 0.1,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: selectedItems.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  ElevatedButton(
                    onPressed: () async {
                      final searchQuery = _searchController.text;

                      if (searchQuery.isNotEmpty) {
                        // Trigger the state update in the provider
                        ref.read(mediaItemsProvider.notifier).searchMedia(searchQuery, selectedItems);

                        // Navigate to the MediaViewScreen immediately
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MediaViewScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Please specify Search Keyword", style: TextStyle(color: Colors.white, fontSize: 16)),
                            backgroundColor: Colors.grey[800],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.grey[800],
                      minimumSize: Size(width, 48.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 22)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
