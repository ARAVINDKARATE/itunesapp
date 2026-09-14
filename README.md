# iTunes Search — Flutter

A Flutter client for the public iTunes Search API, with a security-hardened
network layer.

## Features

- Search iTunes media and preview results in-app
- Multi-select items and review the selection
- Descriptions arrive as HTML and are converted for Markdown rendering
  (`utilities/html_to_markdown_util.dart`)
- Previews open in an embedded WebView (`flutter_inappwebview` / `webview_flutter`)
- Offline/connectivity awareness via `connectivity_plus`

## Security

This is the part worth reading:

- **SSL certificate pinning** — `dio` is configured against the bundled
  `assets/certificates/certificate.pem`, so the app rejects a proxied or
  MITM'd TLS connection instead of trusting the system store blindly.
  (The bundled file is a public leaf certificate — no private key.)
- **Root / jailbreak detection** via `root_jailbreak_sniffer`
- `pointycastle` + `crypto` for the cryptographic primitives

## Structure

```
lib/
├── services/itunes_api_services.dart     # dio + pinned TLS
├── models/media_model.dart
├── view_models/     media · preview · selected_item · iTunes_response
├── provider/        media_items · preview · selected_items · is_expanded
├── views/           media_search · media · preview · selectable_item
├── widgets/description_section.dart
└── utilities/html_to_markdown_util.dart
```

## State management

`flutter_riverpod` — one provider per concern, with view models holding the
presentation logic.

## Running

```bash
flutter pub get
flutter run
```

## Stack

Flutter · Dart · flutter_riverpod · dio · flutter_markdown · flutter_inappwebview · connectivity_plus · pointycastle
