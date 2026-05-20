import 'package:flutter/material.dart';

import '../models/event.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final Event event;

  String get _locationText {
    if (event.neighborhood != null) {
      return '${event.location} · ${event.neighborhood}';
    }
    return event.location;
  }

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
                  _buildPrimaryButton(),
                  const SizedBox(height: 12),
                  _buildSecondaryButton(),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Ver eventos parecidos →',
                      style: TextStyle(
                        color: EventHubColors.orangeButton,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
    return Container(
      height: 200,
      decoration: BoxDecoration(gradient: event.gradient),
      child: Stack(
        children: [
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

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
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
}
