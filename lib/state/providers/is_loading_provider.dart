import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/post_upload/providers/post_upload_provider.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/providers/user_profile_update_provider.dart';

final isLoadingProvider = Provider<IsLoading>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUserProfileUpdating = ref.watch(userProfileUpdateProvider);
  final isPosting = ref.watch(postUploadProvider);
  return authState.isLoading || isUserProfileUpdating || isPosting;
});
