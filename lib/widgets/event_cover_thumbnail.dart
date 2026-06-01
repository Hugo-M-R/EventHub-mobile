import 'package:flutter/material.dart';

import '../models/event.dart';

/// Miniatura do evento: imagem do Firestore (bytes) ou gradiente padrão.
class EventCoverThumbnail extends StatelessWidget {
  const EventCoverThumbnail({
    super.key,
    required this.event,
    this.width = 80,
    this.height = 80,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    ),
  });

  final Event event;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final bytes = event.coverImageBytes;

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: bytes != null
            ? Image.memory(bytes, fit: BoxFit.cover)
            : DecoratedBox(
                decoration: BoxDecoration(gradient: event.gradient),
              ),
      ),
    );
  }
}
