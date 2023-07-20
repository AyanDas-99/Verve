import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/post_upload/notifiers/post_delete_notifier.dart';
import 'package:verve/state/typedefs/is_loading.dart';

final postDeleteProvider = StateNotifierProvider<PostDeleteNotifier, IsLoading>(
    (_) => PostDeleteNotifier());
