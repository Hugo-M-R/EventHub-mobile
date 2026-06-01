import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/eventhub_colors.dart';

/// Barra horizontal de filtros por categoria exibida na home.
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 12 : 0,
            ),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              backgroundColor: EventHubColors.cardWhite,
              selectedColor: EventHubColors.orangeButton,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : EventHubColors.textPrimary,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? EventHubColors.orangeButton
                      : EventHubColors.inputBorder,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}

/// Aplica o filtro de categoria selecionado na lista de eventos.
List<Event> filterEventsByCategory(List<Event> events, String category) {
  switch (category) {
    case 'Todos':
      return events;
    case 'Gratuito':
      return events.where((e) => e.isFree).toList();
    default:
      return events.where((e) => e.category == category).toList();
  }
}
