import 'package:flutter/material.dart';

import '../session/app_session.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/auth_widgets.dart';
import 'login_screen.dart';

class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  static const _sampleEvents = [
    (
      title: 'Festival de Jazz na Praça',
      date: 'Sáb, 24 Mai · 19h',
      place: 'Centro Histórico',
    ),
    (
      title: 'Feira de Artesanato Local',
      date: 'Dom, 25 Mai · 10h',
      place: 'Parque Municipal',
    ),
    (
      title: 'Cinema ao Ar Livre',
      date: 'Sex, 30 Mai · 20h30',
      place: 'Orla da Cidade',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('EventHub'),
        centerTitle: true,
        backgroundColor: EventHubColors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Olá, ${AppSession.displayName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: EventHubColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Eventos perto de você.',
            style: TextStyle(
              fontSize: 14,
              color: EventHubColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Eventos em destaque',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: EventHubColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._sampleEvents.map((e) => _EventCard(
                title: e.title,
                date: e.date,
                place: e.place,
              )),
          const SizedBox(height: 24),
          AuthPrimaryButton(
            label: 'Sair',
            onPressed: () {
              AppSession.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({
    required this.title,
    required this.date,
    required this.place,
  });

  final String title;
  final String date;
  final String place;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _pressed || _hovered
                  ? EventHubColors.cardWhite
                  : EventHubColors.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered || _pressed
                    ? EventHubColors.orangeButton
                    : EventHubColors.inputBorder,
                width: _hovered || _pressed ? 1.5 : 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: EventHubColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: EventHubColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: EventHubColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 14,
                      color: EventHubColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.place,
                        style: const TextStyle(
                          fontSize: 13,
                          color: EventHubColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
