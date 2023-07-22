// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:verve/views/components/button.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/constants/strings.dart';

@immutable
class TextUpdateDialogModel<String> {
  final String title;
  final String previousText;
  const TextUpdateDialogModel({
    required this.title,
    required this.previousText,
  });
}

extension Present<String> on TextUpdateDialogModel {
  Future<String?> present(BuildContext context) {
    final controller = TextEditingController();
    controller.text = previousText.toString();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: regularText(
            title.toString(),
            fontSize: 20,
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            button(
                backgroundColor: Colors.red.shade100,
                text: Strings.cancel,
                onPress: () {
                  Navigator.of(context).pop(null);
                }),
            button(
              backgroundColor: Colors.purple.shade300,
              text: Strings.save,
              color: Colors.white,
              onPress: () async {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}
