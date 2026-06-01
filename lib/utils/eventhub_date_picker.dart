import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';

/// Date picker padronizado do EventHub (tema laranja).
abstract final class EventHubDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(now.year - 1),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: EventHubColors.orangeButton,
              onPrimary: Colors.white,
              onSurface: EventHubColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
