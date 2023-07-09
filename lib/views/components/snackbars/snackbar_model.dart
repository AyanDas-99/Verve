import 'package:flutter/material.dart';

@immutable
class SnackBarModel {
  final Color? backgroundColor;
  final String text;
  final Color? color;
  const SnackBarModel(
    this.text, {
    this.backgroundColor,
    this.color,
  });
}

extension ShowSnackBar on SnackBarModel {
  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: true,
      closeIconColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(
        text,
        style: TextStyle(color: color, fontSize: 20),
      ),
      backgroundColor: backgroundColor,
    ));
  }
}
