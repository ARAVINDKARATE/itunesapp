import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:itunesapp/view_models/media_view_model.dart';
import 'package:itunesapp/view_models/selected_item_view_model.dart';
import 'package:itunesapp/views/media_view.dart';
import 'package:itunesapp/views/selectable_item_view.dart';

/// A widget that allows users to search for media items and select search parameters.
class MediaSearchView extends ConsumerWidget {
  /// Creates an instance of [MediaSearchView].
  MediaSearchView({super.key});

  final TextEditingController _searchController = TextEditingController();

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
                  _buildLogo(),
                  SizedBox(height: height * 0.07),
                  _buildDescriptionText(),
                  SizedBox(height: height * 0.04),
                  _buildSearchField(),
                  SizedBox(height: height * 0.04),
                  _buildParametersDescription(),
                  SizedBox(height: height * 0.04),
                  _buildSelectedItems(selectedItems, context, ref),
                  SizedBox(height: height * 0.04),
                  _buildSubmitButton(context, ref, width, selectedItems),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/iTunes_logo.jpg', height: 36.0),
      ],
    );
  }

  Widget _buildDescriptionText() {
    return const Text(
      'Search for a variety of content from the iTunes store including iBooks, movies, podcasts, music, music videos, and audiobooks',
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _buildSearchField() {
    return TextField(
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
    );
  }

  Widget _buildParametersDescription() {
    return const Text(
      'Specify the parameters for the content to be searched',
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _buildSelectedItems(List<String> selectedItems, BuildContext context, WidgetRef ref) {
    return GestureDetector(
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
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
    );
  }

  Widget _buildSubmitButton(BuildContext context, WidgetRef ref, double width, List<String> selectedItems) {
    return ElevatedButton(
      onPressed: () async {
        final searchQuery = _searchController.text.trim();

        if (searchQuery.isNotEmpty) {
          try {
            // Check internet connectivity
            final connectivityResult = await (Connectivity().checkConnectivity());

            if (connectivityResult.contains(ConnectivityResult.none)) {
              // No internet connection
              Fluttertoast.showToast(
                msg: "No internet connection. Please check your connection and try again.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey[800],
                textColor: Colors.white,
              );
            } else {
              // Trigger the state update in the provider
              ref.read(mediaItemsProvider.notifier).searchMedia(searchQuery, selectedItems);

              // Navigate to the MediaViewScreen immediately
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaViewScreen(selectedItems),
                ),
              );
            }
          } catch (error) {
            // Handle errors
            Fluttertoast.showToast(
              msg: "Error occurred: $error",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[800],
              textColor: Colors.white,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Please specify Search Keyword",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
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
    );
  }
}
