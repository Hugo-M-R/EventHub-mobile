import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Event> _events = Event.getMockEvents();
  final List<String> _categories = ['Hoje', 'Música', 'Teatro', 'Feira', 'Gratuito'];
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Eventos hoje até 5 km'),
                  const SizedBox(height: 16),
                  _buildCategoryFilters(),
                  const SizedBox(height: 20),
                  ..._events.map((event) => EventCard(event: event)),
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
          const Text(
            'EventHub',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: EventHubColors.textPrimary,
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: EventHubColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventHubColors.inputBorder),
      ),
      child: TextField(
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
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

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return Padding(
            padding: EdgeInsets.only(right: index < _categories.length - 1 ? 12 : 0),
            child: FilterChip(
              label: Text(_categories[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              backgroundColor: EventHubColors.cardWhite,
              selectedColor: EventHubColors.orangeButton,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : EventHubColors.textPrimary,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? EventHubColors.orangeButton : EventHubColors.inputBorder,
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
