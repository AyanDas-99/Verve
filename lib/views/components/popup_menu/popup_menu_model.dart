import 'package:flutter/material.dart';
import 'package:verve/views/components/text/regular_text.dart';

class PopupMenuModel extends StatelessWidget {
  final Map<String, VoidCallback> buttons;
  const PopupMenuModel(this.buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => buttons.entries
          .map((button) => PopupMenuItem(
                value: button.key,
                child: regularText(button.key),
              ))
          .toList(),
      onSelected: (value) {
        buttons[value]!();
      },
    );
  }
}
