import 'package:flutter/material.dart';

import '../data/event_catalog.dart';
import '../models/event_profile_status.dart';
import '../session/app_session.dart';
import '../services/auth_service.dart';
import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/auth_gate.dart';
import '../widgets/event_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  List<ProfileEventEntry> get _savedEvents => EventCatalog.savedEvents;
  List<ProfileEventEntry> get _myEvents => EventCatalog.myEvents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    EventCatalog.version.addListener(_onCatalogChanged);

    _tabController.addListener(() {
      if (_selectedIndex != _tabController.index) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    EventCatalog.version.removeListener(_onCatalogChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onCatalogChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHubColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildUserInfo(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEventList(_savedEvents),
                  _buildEventList(_myEvents),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
      bottomNavigationBar: const EventHubBottomNav(currentIndex: 3),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: const Text(
        'Perfil',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: EventHubColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: EventHubColors.orange,
            ),
            child: const Icon(
              Icons.person,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppSession.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: EventHubColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppSession.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: EventHubColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildCustomTabButton(
              index: 0,
              title: 'Eventos salvos',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCustomTabButton(
              index: 1,
              title: 'Meus eventos',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabButton({required int index, required String title}) {
    final isActive = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _tabController.animateTo(index);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? EventHubColors.orangeButton : EventHubColors.cardWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.transparent : EventHubColors.inputBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : EventHubColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<ProfileEventEntry> entries) {
    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum evento encontrado',
          style: TextStyle(
            color: EventHubColors.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return EventCard(
          event: EventCatalog.byId(entry.eventId),
          profileStatus: entry.status,
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          const Text(
            'Status ajuda quando a agenda muda.',
            style: TextStyle(
              fontSize: 12,
              color: EventHubColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await AuthService.instance.signOut();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: EventHubColors.cardWhite,
                foregroundColor: EventHubColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: EventHubColors.inputBorder),
                ),
              ),
              child: const Text(
                'Sair da conta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
