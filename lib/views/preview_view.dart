import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:itunesapp/models/media_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/provider/is_expanded_provider.dart';
import 'package:itunesapp/provider/preview_provider.dart';
import 'package:itunesapp/utilities/html_to_markdown_util.dart';
import 'package:itunesapp/widgets/description_section.dart';
import 'package:itunesapp/widgets/detail_row.dart';

class PreviewScreen extends ConsumerWidget {
  final MediaItem mediaItem;

  const PreviewScreen({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewUrl = mediaItem.previewUrl ?? ''; // Get the preview URL or default to an empty string
    final isValidUrl = Uri.tryParse(previewUrl)?.hasAbsolutePath ?? false; // Validate the URL
    final description = HtmlToMarkdownUtil.convert(mediaItem.shortDescription ?? mediaItem.longDescription ?? mediaItem.description ?? "N/A"); // Convert HTML description to Markdown
    final isExpanded = ref.watch(isExpandedProvider); // Watch the state of the description expansion

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
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMediaHeader(context, ref), // Builds the media header section
              const SizedBox(height: 20),
              _buildPreviewSection(context, isValidUrl, previewUrl), // Builds the preview section
              const SizedBox(height: 10),
              const Divider(color: Colors.white, thickness: 0.4, height: 0.3, indent: 20),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(color: Colors.white, thickness: 0.4, height: 0.3, indent: 20),
              _buildDescriptionSection(description, isExpanded, ref), // Builds the description section
              const Text(
                'Additional Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Divider(color: Colors.white, thickness: 0.4, height: 0.3, indent: 20),
              _buildAdditionalDetails(), // Builds additional details section
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the media header section containing artwork, track info, and preview link
  Widget _buildMediaHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white70, width: 0.5),
            bottom: BorderSide(color: Colors.white70, width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display artwork image or placeholder
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.black,
              child: mediaItem.artworkUrl100 != null
                  ? Image.network(
                      mediaItem.artworkUrl100!,
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Text('No Image')),
            ),
            const SizedBox(width: 10),
            // Display track and collection details
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                height: MediaQuery.of(context).size.height * 0.18,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mediaItem.trackName ?? mediaItem.collectionName ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          mediaItem.artistName ?? mediaItem.collectionName ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          mediaItem.primaryGenreName ?? 'Genre Unknown',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 176, 98, 8),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      // Preview link button
                      child: GestureDetector(
                        onTap: () {
                          ref.read(previewModelProvider).openUrl(mediaItem.trackViewUrl, mediaItem.artistViewUrl);
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Preview',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              CupertinoIcons.compass,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the preview section with an InAppWebView if the URL is valid
  Widget _buildPreviewSection(BuildContext context, bool isValidUrl, String previewUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const Divider(color: Colors.white, thickness: 0.4, height: 0.3, indent: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.26,
          child: isValidUrl
              ? InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(previewUrl)),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        useOnLoadResource: true,
                        useShouldOverrideUrlLoading: true,
                        allowUniversalAccessFromFileURLs: true,
                        allowFileAccessFromFileURLs: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        mediaPlaybackRequiresUserGesture: false),
                  ),
                  onWebViewCreated: (controller) {
                    debugPrint('WebView created');
                  },
                  onLoadStart: (controller, url) {
                    debugPrint('Loading URL: $url');
                  },
                  onLoadStop: (controller, url) {
                    debugPrint('Loaded URL: $url');
                  },
                  onLoadError: (controller, url, code, message) {
                    debugPrint('Error loading URL: $message');
                  },
                  onLoadHttpError: (controller, url, statusCode, description) {
                    debugPrint('HTTP Error: $description');
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint('Console Message: ${consoleMessage.message}');
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    // Add logging for debugging
                    debugPrint("Attempting to load URL: ${navigationAction.request.url}");

                    // Let the WebView load the URL normally
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadResource: (controller, resource) {
                    debugPrint('Resource loaded: ${resource.url}');
                  },
                )
              : const Center(
                  child: Text(
                    'Preview Not Available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ],
    );
  }

  /// Builds the description section with expandable functionality
  Widget _buildDescriptionSection(String description, bool isExpanded, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DescriptionSection(
        description: description,
        isExpanded: isExpanded,
        onToggleExpand: () => ref.read(isExpandedProvider.notifier).state = !isExpanded,
      ),
    );
  }

  /// Builds the additional details section displaying extra information about the media item
  Widget _buildAdditionalDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(title: 'Artist Name', value: mediaItem.artistName),
          DetailRow(title: 'Collection Name', value: mediaItem.collectionName),
          DetailRow(title: 'Track Count', value: mediaItem.trackCount?.toString()),
          DetailRow(title: 'Release Date', value: _formatReleaseDate(mediaItem.releaseDate)),
          DetailRow(title: 'Price', value: mediaItem.collectionPrice != null ? '\$${mediaItem.collectionPrice}' : 'N/A'),
          DetailRow(title: 'Country', value: mediaItem.country),
          DetailRow(title: 'Currency', value: mediaItem.currency),
        ],
      ),
    );
  }

  /// Helper function to format the release date string into a readable format
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
