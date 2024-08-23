import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/view_models/media_view_model.dart';
import 'package:itunesapp/views/preview_view.dart';

class MediaViewScreen extends ConsumerWidget {
  const MediaViewScreen({super.key});

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
        data: (mediaItems) => MediaTabView(mediaItems: mediaItems),
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

  const MediaTabView({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
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
            GridViewBuilder(mediaItems: mediaItems),
            ListViewBuilder(mediaItems: mediaItems),
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[900], // Set background color to black
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 6 / 8,
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
                            child: GridTile(
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.black, // Set background color to black
                                    child: Center(
                                      child: Image.network(
                                        item.artworkUrl100.toString(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.black, // Set background color to black
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByKind.entries.map((entry) {
            final kind = entry.key;
            final items = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[900], // Set background color to black
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: items.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewScreen(mediaItem: item),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height * 0.16,
                                color: Colors.black, // Set background color to black
                                child: item.artworkUrl100 != null
                                    ? Image.network(
                                        item.artworkUrl100!,
                                        fit: BoxFit.contain,
                                      )
                                    : const Center(child: Text('No Image')),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.artistName ?? 'Unknown Artist',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (item.collectionName != null)
                                        Text(
                                          item.collectionName!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
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
