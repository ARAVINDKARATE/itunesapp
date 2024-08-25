import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:root_jailbreak_sniffer/rjsniffer.dart';
// import 'package:safe_device/safe_device.dart'; // Import the safe_device package
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
    print('Certificate loaded and pinned successfully.');
  } catch (e) {
    print('Failed to load or pin the certificate: $e');
  }

  // Check if the device is rooted
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
  // bool isSafeDevice = await FlutterJailbreakDetection.jailbroken;
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
