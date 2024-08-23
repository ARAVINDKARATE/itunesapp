// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:itunesapp/view_models/selected_item_view_model.dart';

// class MediaViewScreen extends ConsumerWidget {
//   const MediaViewScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: const Text(
//             'iTunes',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(48.0),
//             child: Container(
//               color: Colors.grey[900],
//               child: TabBar(
//                 indicator: BoxDecoration(
//                   color: Colors.grey[700],
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.white70,
//                 labelStyle: const TextStyle(fontSize: 16.0),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 dividerColor: Colors.black,
//                 tabs: [
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2,
//                     alignment: Alignment.center,
//                     child: const Tab(text: 'Grid View'),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2,
//                     alignment: Alignment.center,
//                     child: const Tab(text: 'List View'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: const MediaTabView(),
//       ),
//     );
//   }
// }

// class MediaTabView extends StatelessWidget {
//   const MediaTabView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const TabBarView(
//       children: [
//         GridViewBuilder(),
//         ListViewBuilder(),
//       ],
//     );
//   }
// }

// class GridViewBuilder extends ConsumerWidget {
//   const GridViewBuilder({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedItems = ref.watch(selectedItemsProvider);

//     return GridView.builder(
//       padding: const EdgeInsets.all(10.0),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10.0,
//         mainAxisSpacing: 10.0,
//       ),
//       itemCount: selectedItems.length,
//       itemBuilder: (context, index) {
//         final item = selectedItems[index];
//         return GridTile(
//           header: Text(
//             item,
//             style: const TextStyle(color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//           child: Container(
//             color: Colors.grey[800],
//             child: Center(
//               child: Text(
//                 item,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ListViewBuilder extends ConsumerWidget {
//   const ListViewBuilder({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedItems = ref.watch(selectedItemsProvider);

//     return ListView.builder(
//       padding: const EdgeInsets.all(10.0),
//       itemCount: selectedItems.length,
//       itemBuilder: (context, index) {
//         final item = selectedItems[index];
//         return Card(
//           color: Colors.grey[800],
//           child: ListTile(
//             title: Text(
//               item,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
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
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: mediaItems.resultCount,
      itemBuilder: (context, index) {
        final item = mediaItems.results[index];
        return GridTile(
          header: Text(
            item.artistName.toString(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          child: Container(
            color: Colors.grey[800],
            child: Center(
              child: Text(
                item.kind.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  final ITunesResponse mediaItems;

  const ListViewBuilder({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: mediaItems.resultCount,
      itemBuilder: (context, index) {
        final item = mediaItems.results[index];
        return Card(
          color: Colors.grey[800],
          child: ListTile(
            title: Text(
              item.artistName.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
