import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:root_jailbreak_sniffer/rjsniffer.dart';
import 'views/media_search_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create a SecurityContext that does not trust the OS's certificates
  SecurityContext context = SecurityContext(withTrustedRoots: false);

  try {
    // Load the certificate from assets
    ByteData data = await rootBundle.load('assets/certificates/certificate.pem');

    // Set the certificate to be trusted
    context.setTrustedCertificatesBytes(data.buffer.asUint8List());
    debugPrint('Certificate loaded and pinned successfully.');
  } catch (e) {
    debugPrint('Failed to load or pin the certificate: $e');
  }

  // Check if the device is rooted or compromised
  bool isSafeDevice = await rootChecker();

  if (isSafeDevice) {
    // Handle the case where the device is not safe
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Device is not safe to use this app.'),
          ),
        ),
      ),
    );
    return;
  }

  runApp(const ProviderScope(child: MyApp()));
}

Future<bool> rootChecker() async {
  // Check for device compromise
  bool isSafeDevice = await Rjsniffer.amICompromised() ?? false;
  return isSafeDevice;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iTunes Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MediaSearchView(),
    );
  }
}
