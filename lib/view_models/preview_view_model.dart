import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewViewModel extends ChangeNotifier {
  /// Opens a URL from the given [trackViewUrl] or [artistViewUrl].
  /// If both are null, it will log a message and do nothing.
  Future<void> openUrl(String? trackViewUrl, String? artistViewUrl) async {
    final url = trackViewUrl ?? artistViewUrl;

    if (url != null) {
      final uri = Uri.parse(url);
      debugPrint('Attempting to launch URL: $uri');

      try {
        // Check if the URL can be launched
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          debugPrint("Cannot launch the URL: $url");
          // Optionally, notify the user here with a dialog or a toast
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    } else {
      debugPrint('No valid URL provided');
    }
  }
}
