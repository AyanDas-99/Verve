import 'package:flutter/material.dart';
import 'package:verve/views/components/snackbars/snackbar_model.dart';

class SuccessSnackBar extends SnackBarModel {
  SuccessSnackBar(String text)
      : super(
          text,
          backgroundColor: Colors.green.shade300,
          color: Colors.white,
        );
}
