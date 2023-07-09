import 'package:flutter/material.dart';
import 'package:verve/views/components/snackbars/snackbar_model.dart';

class FailureSnackBar extends SnackBarModel {
  FailureSnackBar(String text)
      : super(
          text,
          backgroundColor: Colors.red,
        );
}
