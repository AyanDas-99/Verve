import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class LikePayload extends MapView<String, dynamic> {
  LikePayload({
    required UserId likedBy,
    required PostId postId,
  }) : super({
          FirebaseFieldNames.userId: likedBy,
          FirebaseFieldNames.postId: postId,
        });
}
