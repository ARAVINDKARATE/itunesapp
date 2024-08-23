import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';
import 'package:itunesapp/provider/preview_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewScreen extends ConsumerWidget {
  // Changed to ConsumerWidget
  final MediaItem mediaItem;

  const PreviewScreen({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
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
                                    mediaItem.artistName ?? 'Unknown Artist',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (mediaItem.collectionName != null)
                                    Text(
                                      mediaItem.collectionName ?? 'Unknown Collection',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    mediaItem.primaryGenreName ?? 'Genre Unknown',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 176, 98, 8),
                                      fontSize: 18,
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
                                    // Read the MediaViewModel and trigger the openUrl method
                                    ref.read(PreviewModelProvider).openUrl(mediaItem.trackViewUrl, mediaItem.artistViewUrl); // Use ref.read
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
                  fontSize: 16,
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
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
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
                child: Text(
                  mediaItem.description ?? "N/A",
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
