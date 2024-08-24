import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/provider/preview_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/utilities/html_to_markdown_util.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  final MediaItem mediaItem;

  const PreviewScreen({super.key, required this.mediaItem});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final previewUrl = widget.mediaItem.previewUrl ?? '';
    final isValidUrl = Uri.tryParse(previewUrl)?.hasAbsolutePath ?? false;
    final description = HtmlToMarkdownUtil.convert(widget.mediaItem.description ?? "N/A");

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
              Padding(
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
                        child: widget.mediaItem.artworkUrl100 != null
                            ? Image.network(
                                widget.mediaItem.artworkUrl100!,
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
                                    widget.mediaItem.trackName ?? widget.mediaItem.collectionName ?? 'Unknown',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (widget.mediaItem.collectionName != null)
                                    Text(
                                      widget.mediaItem.artistName ?? widget.mediaItem.collectionName ?? 'Unknown',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 25),
                                  Text(
                                    widget.mediaItem.primaryGenreName ?? 'Genre Unknown',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 176, 98, 8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.16,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(PreviewModelProvider).openUrl(widget.mediaItem.trackViewUrl, widget.mediaItem.artistViewUrl);
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
              ),
              const SizedBox(height: 20),
              const Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.4,
                height: 0.3,
                indent: 20,
              ),
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
                      )
                    : const Center(
                        child: Text(
                          'Preview URL is not valid',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.white,
                thickness: 0.4,
                height: 0.3,
                indent: 20,
              ),
              const SizedBox(height: 20),
              const Text(
                'Description:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.4,
                height: 0.3,
                indent: 20,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarkdownBody(
                      data: _isExpanded ? description : _shortenDescription(description),
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (description.length > 200) // Arbitrary length to check for long descriptions
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'Show less' : 'Read more',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
              ),
              const Text(
                'Additional Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.4,
                height: 0.3,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Artist Name', widget.mediaItem.artistName),
                    _buildDetailRow('Collection Name', widget.mediaItem.collectionName),
                    _buildDetailRow('Track Count', widget.mediaItem.trackCount.toString()),
                    _buildDetailRow('Release Date', _formatReleaseDate(widget.mediaItem.releaseDate)),
                    _buildDetailRow('Price', widget.mediaItem.collectionPrice != null ? '\$${widget.mediaItem.collectionPrice}' : 'N/A'),
                    _buildDetailRow('Country', widget.mediaItem.country),
                    _buildDetailRow('Currency', widget.mediaItem.currency),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _shortenDescription(String description) {
    return description.length > 200 ? '${description.substring(0, 200)}...' : description;
  }

  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return DateFormat('MMMM d, yyyy').format(date); // Format as "August 24, 2024"
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Unknown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
