import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/view_models/preview_view_model.dart';

// Provider for PreviewViewModel using ChangeNotifierProvider
final previewModelProvider = ChangeNotifierProvider((ref) => PreviewViewModel());
