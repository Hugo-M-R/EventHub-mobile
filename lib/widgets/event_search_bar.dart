import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/eventhub_colors.dart';

/// Campo de busca da home — filtra por título, local, categoria, artista e bairro.
class EventSearchBar extends StatelessWidget {
  const EventSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EventHubColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventHubColors.inputBorder),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Buscar eventos, artistas ou bairros...',
          hintStyle: TextStyle(
            color: EventHubColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: EventHubColors.textSecondary,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    color: EventHubColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

/// Filtra eventos pelo termo de busca (case-insensitive).
List<Event> filterEventsByQuery(List<Event> events, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return events;

  return events.where((event) => event.matchesQuery(normalized)).toList();
}
