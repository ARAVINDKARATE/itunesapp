import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider to manage the expansion state of the description section
final isExpandedProvider = StateProvider<bool>((ref) => false);
