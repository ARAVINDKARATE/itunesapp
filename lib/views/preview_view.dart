import 'package:flutter/material.dart';
import 'package:itunesapp/models/iTunes_response_model.dart';

class PreviewScreen extends StatelessWidget {
  final MediaItem mediaItem;

  const PreviewScreen({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                mediaItem.artworkUrl100 ?? '',
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              mediaItem.artistName ?? 'Unknown Artist',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              mediaItem.collectionName ?? 'No Collection Name',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Track Name: ${mediaItem.trackName ?? 'No Track Name'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Collection Price: ${mediaItem.collectionPrice?.toStringAsFixed(2) ?? 'N/A'} USD',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Release Date: ${mediaItem.releaseDate?.substring(0, 10) ?? 'N/A'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Genre: ${mediaItem.primaryGenreName ?? 'N/A'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
