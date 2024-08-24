import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/view_models/media_view_model.dart';
import 'package:itunesapp/views/preview_view.dart';

class MediaViewScreen extends ConsumerWidget {
  final List<String> selectedItems;
  const MediaViewScreen(this.selectedItems, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItemsState = ref.watch(mediaItemsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
        data: (mediaItems) => MediaTabView(mediaItems: mediaItems, selectedItems: selectedItems),
        loading: () => Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
              color: Colors.grey[900],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  radius: 12.0,
                  color: Colors.white, // Adjust the size as needed
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
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class MediaTabView extends StatelessWidget {
  final ITunesResponse mediaItems;
  final List<String> selectedItems;

  const MediaTabView({super.key, required this.mediaItems, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    // Step 1: Update `kind` values to "None" if they are null
    final updatedMediaItems = mediaItems.results.map((item) {
      // Create a new MediaItem with updated `kind` if it's null
      final updatedItem = item.copyWith(
        kind: item.kind ?? 'None',
      );
      return updatedItem;
    }).toList();

// Step 2: Convert to lowercase and filter based on the updated `kind`
    final lowercaseSelectedKinds = selectedItems.map((kind) => kind.toLowerCase()).toList();

    final List<MediaItem> filteredItems = updatedMediaItems.where((item) {
      final itemKindLower = item.kind!.toLowerCase();
      return lowercaseSelectedKinds.any((kind) => itemKindLower.contains(kind));
    }).toList();

// Create the filtered response
    final filteredResponse = (selectedItems.isEmpty)
        ? ITunesResponse(
            resultCount: updatedMediaItems.length, // Set the result count
            results: updatedMediaItems,
          )
        : ITunesResponse(
            resultCount: filteredItems.length, // Set the result count
            results: filteredItems,
          );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Colors.grey[900], // Set background color to black
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.grey[700], // Dark grey color for selected tab
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 16.0),
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
        body: TabBarView(
          children: [
            GridViewBuilder(mediaItems: filteredResponse),
            ListViewBuilder(mediaItems: filteredResponse),
          ],
        ),
      ),
    );
  }
}

class GridViewBuilder extends StatelessWidget {
  final ITunesResponse mediaItems;

  const GridViewBuilder({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MediaItem>> groupedByKind = {};

    for (var item in mediaItems.results) {
      if (!groupedByKind.containsKey(item.kind)) {
        groupedByKind[item.kind!] = [];
      }
      groupedByKind[item.kind]?.add(item);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2 / 3,
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
                                    child: Center(
                                      child: Image.network(
                                        item.artworkUrl100.toString(),
                                        fit: BoxFit.cover,
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
                                          maxLines: 2,
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
                    ],
                  )
                : const SizedBox();
          }).toList(),
        ),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  final ITunesResponse mediaItems;

  const ListViewBuilder({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByKind.entries.map((entry) {
            final kind = entry.key;
            final items = entry.value;

            return (items.isNotEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  width: MediaQuery.of(context).size.width * 0.3,
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
                                            fontWeight: FontWeight.bold,
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
                      }).toList(),
                    ],
                  )
                : const SizedBox();
          }).toList(),
        ),
      ),
    );
  }

  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
}

String _formatReleaseDate(String? releaseDate) {
  if (releaseDate == null) return 'Unknown';
  try {
    final date = DateTime.parse(releaseDate);
    return DateFormat('MMMM d, yyyy').format(date);
  } catch (e) {
    return 'Invalid date';
  }
}
