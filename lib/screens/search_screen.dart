import 'package:flutter/material.dart';

import '../data/event_catalog.dart';
import '../models/event.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_calendar.dart';
import '../widgets/event_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const int _currentIndex = 1;

  late Set<DateTime> _eventDates;

  /// `null` = sem filtro de data (lista completa).
  DateTime? _selectedDate;

  List<Event> get _filteredEvents {
    final events = EventCatalog.events;
    if (_selectedDate == null) return List<Event>.from(events);
    return filterEventsByDate(events, _selectedDate!);
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _syncEventDates();
    EventCatalog.version.addListener(_onCatalogChanged);
  }

  @override
  void dispose() {
    EventCatalog.version.removeListener(_onCatalogChanged);
    super.dispose();
  }

  void _onCatalogChanged() {
    if (!mounted) return;
    setState(_syncEventDates);
  }

  void _syncEventDates() {
    _eventDates = datesWithEvents(EventCatalog.events);
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _filteredEvents;
    final sectionTitle = _selectedDate == null
        ? 'Todos os eventos'
        : 'Eventos em ${Event.formatDayLabel(_selectedDate!)}';

    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                children: [
                  EventCalendar(
                    eventDates: _eventDates,
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate =
                            DateTime(date.year, date.month, date.day);
                      });
                    },
                    onClearSelection: () {
                      setState(() => _selectedDate = null);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(sectionTitle),
                  const SizedBox(height: 16),
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
      bottomNavigationBar: const EventHubBottomNav(currentIndex: _currentIndex),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          const Text(
            'Buscar eventos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: EventHubColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dias em azul têm eventos; toque para filtrar',
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
    final message = _selectedDate == null
        ? 'Nenhum evento cadastrado.'
        : 'Nenhum evento em ${Event.formatDayLabel(_selectedDate!)}.';

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
