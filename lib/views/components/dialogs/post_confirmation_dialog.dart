import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/views/components/dialogs/get_confirmation_dialog_model.dart';
import 'package:verve/views/constants/strings.dart';

@immutable
class PostConfirmationDialog extends GetConfirmationDialogModel {
  PostConfirmationDialog()
      : super(title: Strings.areYouSureYouWantToPost, entries: {
          Strings.cancel: false,
          Strings.confirm: true,
        });
}
