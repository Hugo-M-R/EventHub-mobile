import 'package:flutter/material.dart';

import '../models/event_profile_status.dart';

class EventProfileStatusTag extends StatelessWidget {
  const EventProfileStatusTag({super.key, required this.status});

  final EventProfileStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, backgroundColor) = switch (status) {
      EventProfileStatus.ativo => ('Ativo', const Color(0xFF4CAF50)),
      EventProfileStatus.alterado => ('Alterado', const Color(0xFFFFC107)),
      EventProfileStatus.cancelado => ('Cancelado', const Color(0xFFF44336)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
