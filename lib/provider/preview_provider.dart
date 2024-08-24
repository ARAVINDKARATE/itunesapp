import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunesapp/view_models/preview_view_model.dart';

final previewModelProvider = ChangeNotifierProvider((ref) => PreviewViewModel());
