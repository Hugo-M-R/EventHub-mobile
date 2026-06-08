import 'package:flutter/material.dart';

import '../data/event_catalog.dart';
import '../models/event.dart';
import '../navigation/event_navigation.dart';
import '../screens/create_event_screen.dart';
import '../screens/profile_screen.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/event_card.dart';
import '../widgets/event_cover_thumbnail.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.event});

  final Event event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event get event => widget.event;

  String get _locationText {
    if (event.neighborhood != null) {
      return '${event.location} · ${event.neighborhood}';
    }
    return event.location;
  }

  bool get _isOwnEvent => EventCatalog.isOwnedByCurrentUser(event);

  bool get _isSaved => EventCatalog.isSaved(event.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeroHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '‹ Voltar',
                      style: TextStyle(
                        color: EventHubColors.orangeButton,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: EventHubColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: EventHubColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _locationText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: EventHubColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDescriptionBox(),
                  if (event.artist != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Organizador: ${event.artist}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: EventHubColors.textPrimary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (_isOwnEvent) ...[
                    _buildEditButton(context),
                    const SizedBox(height: 12),
                    _buildDeleteButton(context),
                    if (_isSaved) ...[
                      const SizedBox(height: 12),
                      _buildRemoveFromSavedButton(context),
                    ],
                  ] else if (_isSaved) ...[
                    _buildRemoveFromSavedButton(context),
                    const SizedBox(height: 12),
                    _buildSecondaryButton(),
                  ] else ...[
                    _buildPrimaryButton(context),
                    const SizedBox(height: 12),
                    _buildSecondaryButton(),
                  ],
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => openSimilarEvents(context, event),
                    child: const Text(
                      'Ver eventos parecidos →',
                      style: TextStyle(
                        color: EventHubColors.orangeButton,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Na mesma categoria',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: EventHubColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...EventCatalog.eventsInCategory(event.category)
                      .where((item) => item.id != event.id)
                      .take(3)
                      .map((item) => EventCard(event: item)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const EventHubBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeroHeader() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          EventCoverThumbnail(
            event: event,
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.zero,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black38],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EventHubColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EventHubColors.inputBorder),
      ),
      child: Text(
        event.description ?? 'Texto curto sobre o evento. Leitura rápida em poucas linhas.',
        style: const TextStyle(
          fontSize: 14,
          color: EventHubColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  void _onInterestPressed(BuildContext context) {
    EventCatalog.saveInterest(event.id);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(initialTabIndex: 0),
      ),
      (route) => false,
    );
  }

  void _onRemoveFromSaved(BuildContext context) {
    EventCatalog.removeSavedInterest(event.id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removido dos eventos salvos.')),
    );
  }

  Widget _buildRemoveFromSavedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => _onRemoveFromSaved(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: EventHubColors.textPrimary,
          side: const BorderSide(color: EventHubColors.inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Remover dos salvos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => _onInterestPressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: EventHubColors.orangeButton,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Tenho interesse',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: EventHubColors.textPrimary,
          side: const BorderSide(color: EventHubColors.inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Compartilhar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _openEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEventScreen(eventToEdit: event),
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir evento'),
        content: Text(
          'Excluir "${event.title}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await EventCatalog.removeEvent(event.id);
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento excluído.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir o evento.')),
      );
    }
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => _openEdit(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: EventHubColors.orangeButton,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Editar evento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => _confirmAndDelete(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Excluir evento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
