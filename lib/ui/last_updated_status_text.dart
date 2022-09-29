import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedDateFormatter {
  const LastUpdatedDateFormatter({required this.lastUpdated});
  final DateTime lastUpdated;

  String lastUpdatedStatusText() {
    final formatter = DateFormat.yMd().add_Hms();
    final formatted = formatter.format(lastUpdated);
    return 'Last updated: $formatted';
  }
}

class LastUpdatedStatusText extends StatelessWidget {
  const LastUpdatedStatusText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}
