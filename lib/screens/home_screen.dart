import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/event_card.dart';
import '../widgets/event_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Event> _events = Event.getMockEvents();
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'Hoje',
    'Música',
    'Teatro',
    'Feira',
    'Gratuito',
  ];

  String _selectedCategory = _categories.first;
  String _searchQuery = '';

  List<Event> get _filteredEvents {
    final byCategory = filterEventsByCategory(_events, _selectedCategory);
    return filterEventsByQuery(byCategory, _searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _filteredEvents;

    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  EventSearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Eventos hoje até 5 km'),
                  const SizedBox(height: 16),
                  CategoryFilterBar(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  const SizedBox(height: 20),
                  if (filteredEvents.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredEvents.map((event) => EventCard(event: event)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EventHubBottomNav(currentIndex: _currentIndex),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'EventHub',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: EventHubColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Descubra cultura perto de você',
            style: TextStyle(
              fontSize: 14,
              color: EventHubColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: EventHubColors.textPrimary,
      ),
    );
  }

  Widget _buildEmptyState() {
    final message = _searchQuery.trim().isNotEmpty
        ? 'Nenhum evento encontrado para "${_searchQuery.trim()}".'
        : 'Nenhum evento encontrado para "$_selectedCategory".';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: EventHubColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
