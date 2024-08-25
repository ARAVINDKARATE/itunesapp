import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:itunesapp/models/media_model.dart';
import 'package:itunesapp/view_models/iTunes_response_view_model.dart';
import 'package:itunesapp/view_models/media_view_model.dart';
import 'package:itunesapp/views/preview_view.dart';

/// The main screen that displays media items fetched from the iTunes API.
/// Allows the user to view the items in either Grid or List view.
class MediaViewScreen extends ConsumerWidget {
  final List<String> selectedItems;

  const MediaViewScreen(this.selectedItems, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the media items state from the provider
    final mediaItemsState = ref.watch(mediaItemsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'iTunes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: mediaItemsState.when(
        data: (mediaItems) => MediaTabView(
          mediaItems: mediaItems,
          selectedItems: selectedItems,
        ),
        loading: () => Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[900],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  radius: 12.0,
                  color: Colors.white,
                ),
                SizedBox(width: 30),
                Text(
                  'Loading',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        error: (err, stack) => const Center(
          child: Text(
            'Error: While Loading the api',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// A widget that displays media items in either Grid or List view using tabs.
class MediaTabView extends StatelessWidget {
  final ITunesResponse mediaItems;
  final List<String> selectedItems;

  const MediaTabView({
    super.key,
    required this.mediaItems,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare and filter the media items for display
    final updatedMediaItems = mediaItems.results.map((item) {
      return item.copyWith(kind: item.kind ?? 'None');
    }).toList();

    final filteredResponse = ITunesResponse(
      resultCount: updatedMediaItems.length,
      results: updatedMediaItems,
    );

    return DefaultTabController(
      length: 2, // Two tabs for Grid and List views
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[900],
              ),
              child: filteredResponse.results.isEmpty
                  ? const SizedBox()
                  : TabBar(
                      indicator: BoxDecoration(
                        color: Colors.grey[700], // Dark grey color for selected tab
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.black,
                      tabs: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          child: const Tab(text: 'Grid View'),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          child: const Tab(text: 'List View'),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        body: filteredResponse.results.isEmpty
            ? const Center(
                child: Text(
                  'No Results Found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : TabBarView(
                children: [
                  GridViewBuilder(mediaItems: filteredResponse),
                  ListViewBuilder(mediaItems: filteredResponse),
                ],
              ),
      ),
    );
  }
}

/// A widget that displays media items in a grid view.
class GridViewBuilder extends StatelessWidget {
  final ITunesResponse mediaItems;

  const GridViewBuilder({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    // Group media items by their kind
    final Map<String, List<MediaItem>> groupedByKind = {};
    for (var item in mediaItems.results) {
      if (!groupedByKind.containsKey(item.kind)) {
        groupedByKind[item.kind!] = [];
      }
      groupedByKind[item.kind]?.add(item);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedByKind.entries.map((entry) {
          final kind = entry.key;
          final items = entry.value;

          return (items.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[900],
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        kind.substring(0, 1).toUpperCase() + kind.substring(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GridView.builder(
                        shrinkWrap: true, // Allow the grid to fit its content
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns in the grid
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                          childAspectRatio: 4 / 7, // Aspect ratio for the grid items
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewScreen(mediaItem: item),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.grey[900],
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item.artworkUrl100.toString(),
                                        fit: BoxFit.cover, // Ensure the image covers the available space
                                        width: double.infinity, // Full width
                                        height: double.infinity, // Full height
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.trackName ?? item.collectionName ?? 'Unknown',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.primaryGenreName ?? 'Genre Unknown',
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 176, 98, 8),
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatReleaseDate(item.releaseDate),
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              : const SizedBox();
        }).toList(),
      ),
    );
  }

  /// Formats the release date to a readable string.
  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
}

/// A widget that displays media items in a list view.
class ListViewBuilder extends StatelessWidget {
  final ITunesResponse mediaItems;

  const ListViewBuilder({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    // Group media items by their kind
    final Map<String, List<MediaItem>> groupedByKind = {};
    for (var item in mediaItems.results) {
      if (item.kind != null) {
        if (!groupedByKind.containsKey(item.kind)) {
          groupedByKind[item.kind!] = [];
        }
        groupedByKind[item.kind!]?.add(item);
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedByKind.entries.map((entry) {
          final kind = entry.key;
          final items = entry.value;

          return (items.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[900],
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        kind.substring(0, 1).toUpperCase() + kind.substring(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...items.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewScreen(mediaItem: item),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey[900],
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.artworkUrl100!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.trackName ?? item.collectionName ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (item.collectionName != null)
                                        Text(
                                          item.artistName ?? item.collectionName ?? 'Unknown',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      const SizedBox(height: 10),
                                      Text(
                                        item.primaryGenreName ?? 'Genre Unknown',
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 176, 98, 8),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _formatReleaseDate(item.releaseDate),
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                )
              : const SizedBox();
        }).toList(),
      ),
    );
  }

  /// Formats the release date to a readable string.
  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
