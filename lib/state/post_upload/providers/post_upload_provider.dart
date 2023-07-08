import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/post_upload/notifiers/post_upload_notifier.dart';
import 'package:verve/state/typedefs/is_loading.dart';

final postUploadProvider =
    StateNotifierProvider<PostUploadNotifier, IsLoading>((_) {
  return PostUploadNotifier();
});
