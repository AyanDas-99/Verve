import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verve/views/components/text/regular_text.dart';

class DateTimeView extends StatelessWidget {
  final DateTime dateTime;
  final double fontSize;
  const DateTimeView(this.dateTime, {super.key, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('d MMMM, yyyy, hh:mm a');
    return regularText(
      formatter.format(dateTime),
      fontSize: fontSize,
    );
  }
}
