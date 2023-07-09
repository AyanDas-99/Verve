import 'package:hooks_riverpod/hooks_riverpod.dart';

// Determines if the floating action button in mainview is visible

final isFloatingActionProvider = StateProvider<bool>((ref) {
  return true;
});
