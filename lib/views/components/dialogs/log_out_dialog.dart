import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/views/components/dialogs/get_confirmation_dialog_model.dart';
import 'package:verve/views/constants/strings.dart';

@immutable
class LogOutDialog extends GetConfirmationDialogModel {
  LogOutDialog()
      : super(
          title: Strings.areYouSureYouWantToLogOut,
          entries: {
            Strings.cancel: false,
            Strings.confirm: true,
          },
        );
}
