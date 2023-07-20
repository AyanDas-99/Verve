import 'package:flutter/material.dart';
import 'package:verve/views/components/button.dart';
import 'package:verve/views/components/text/regular_text.dart';

@immutable
class GetConfirmationDialogModel<bool> {
  final String title;
  final Map<String, bool> entries;
  const GetConfirmationDialogModel({
    required this.title,
    required this.entries,
  });
}

extension Present<bool> on GetConfirmationDialogModel<bool> {
  Future<bool?> present(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: regularText(
            title.toString(),
            fontSize: 20,
          ),
          actions: entries.entries.map((entry) {
            final bool isTrue = entry.value;
            return button(
                text: entry.key,
                color: Colors.white,
                backgroundColor:
                    (isTrue == true) ? Colors.green : Colors.red.shade500,
                onPress: () {
                  Navigator.of(context).pop(entry.value);
                });
          }).toList(),
        );
      },
    );
  }
}
