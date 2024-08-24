import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/provider/preview_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/utilities/html_to_markdown_util.dart';
import 'package:itunesapp/widgets/description_section.dart';
import 'package:itunesapp/widgets/detail_row.dart';

final isExpandedProvider = StateProvider<bool>((ref) => false);

class PreviewScreen extends ConsumerWidget {
  final MediaItem mediaItem;

  const PreviewScreen({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewUrl = mediaItem.previewUrl ?? '';
    final isValidUrl = Uri.tryParse(previewUrl)?.hasAbsolutePath ?? false;
    final description = HtmlToMarkdownUtil.convert(mediaItem.description ?? "N/A");
    final isExpanded = ref.watch(isExpandedProvider);

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
              _buildMediaHeader(context, ref),
              const SizedBox(height: 20),
              _buildPreviewSection(context, isValidUrl, previewUrl),
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
              _buildDescriptionSection(description, isExpanded, ref),
              const Text(
                'Additional Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(color: Colors.white, thickness: 0.4, height: 0.3, indent: 20),
              _buildAdditionalDetails(),
            ],
          ),
        ),
      ),
    );
  }

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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
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
                        if (mediaItem.collectionName != null)
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.17,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
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
                  initialUrlRequest: URLRequest(
                    url: WebUri(previewUrl),
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    print('WebView created');
                  },
                  onLoadStart: (controller, url) {
                    print('Loading URL: $url');
                  },
                  onLoadStop: (controller, url) {
                    print('Loaded URL: $url');
                  },
                  onLoadError: (controller, url, code, message) {
                    print('Error loading URL: $message');
                  },
                )
              : const Center(
                  child: Text(
                    'Preview URL is not valid',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ],
    );
  }

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

  Widget _buildAdditionalDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(title: 'Artist Name', value: mediaItem.artistName),
          DetailRow(title: 'Collection Name', value: mediaItem.collectionName),
          DetailRow(title: 'Track Count', value: mediaItem.trackCount.toString()),
          DetailRow(title: 'Release Date', value: _formatReleaseDate(mediaItem.releaseDate)),
          DetailRow(title: 'Price', value: mediaItem.collectionPrice != null ? '\$${mediaItem.collectionPrice}' : 'N/A'),
          DetailRow(title: 'Country', value: mediaItem.country),
          DetailRow(title: 'Currency', value: mediaItem.currency),
        ],
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
