import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewViewModel extends ChangeNotifier {
  void openUrl(String? trackViewUrl, String? artistViewUrl) async {
    final url = trackViewUrl ?? artistViewUrl;
    if (url != null) {
      final uri = Uri.parse(url);
      print('Attempting to launch URL: $uri');
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          print("Cannot launch the URL: $url");
          // Optionally, notify the user here with a dialog or a toast
        }
      } catch (e) {
        print('Error launching URL: $e');
      }
    } else {
      print('No valid URL provided');
    }
  }
}
