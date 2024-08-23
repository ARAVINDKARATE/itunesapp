import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';

class MediaViewScreen extends ConsumerWidget {
  final ITunesResponse mediaItems;

  const MediaViewScreen({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              color: Colors.grey[900],
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
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
        ),
        body: MediaTabView(mediaItems: mediaItems),
      ),
    );
  }
}

class MediaTabView extends StatelessWidget {
  final ITunesResponse mediaItems;

  const MediaTabView({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        GridViewBuilder(mediaItems: mediaItems),
        ListViewBuilder(mediaItems: mediaItems),
      ],
    );
  }
}

class GridViewBuilder extends StatelessWidget {
  final ITunesResponse mediaItems;

  const GridViewBuilder({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    // Assuming the media items are of type MediaItem (replace with your actual class name)
    final Map<String, List<MediaItem>> groupedByKind = {};

    for (var item in mediaItems.results) {
      if (!groupedByKind.containsKey(item.kind)) {
        groupedByKind[item.kind ?? 'Unknown'] = [];
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
                      // Heading for each kind
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
                      const SizedBox(
                        height: 20,
                      ),
                      // Grid of media items for each kind
                      GridView.builder(
                        shrinkWrap: true, // Ensures GridView takes up only as much space as needed
                        physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 0, childAspectRatio: 6 / 8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return GridTile(
                            child: Column(
                              children: [
                                Container(
                                  // height: MediaQuery.of(context).size.height * 0.3,
                                  color: Colors.black,
                                  child: Center(
                                    child: Image.network(
                                      item.artworkUrl100.toString(),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    item.artistName.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
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
    // Group items by their kind
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByKind.entries.map((entry) {
            final kind = entry.key;
            final items = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading for each kind
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
                // List of media items for each kind
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              color: Colors.black,
                              child: item.artworkUrl100 != null
                                  ? Image.network(
                                      item.artworkUrl100!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(child: Text('No Image')),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.artistName ?? 'Unknown Artist',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.collectionName != null)
                                    Text(
                                      item.collectionName!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
