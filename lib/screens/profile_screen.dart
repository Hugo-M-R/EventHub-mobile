import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';
import '../widgets/bottom_nav.dart';
import 'login_screen.dart';

enum EventStatus {
  ativo,
  alterado,
  cancelado,
}

class ProfileEvent {
  final String title;
  final EventStatus status;

  ProfileEvent({
    required this.title,
    required this.status,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // Variável para controlar a cor do botão ativo

  final List<ProfileEvent> _savedEvents = [
    ProfileEvent(
      title: 'Jazz na praça',
      status: EventStatus.ativo,
    ),
    ProfileEvent(
      title: 'Oficina de cerâmica',
      status: EventStatus.alterado,
    ),
    ProfileEvent(
      title: 'Cinema ao ar livre',
      status: EventStatus.cancelado,
    ),
  ];

  final List<ProfileEvent> _myEvents = [
    ProfileEvent(
      title: 'Show independente',
      status: EventStatus.ativo,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Adiciona o listener para sincronizar o swipe na tela com o botão
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
    _tabController.dispose();
    super.dispose();
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maria Silva',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: EventHubColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'maria@email.com',
                style: TextStyle(
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
    // Usa o _selectedIndex para verificar se está ativo
    final bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () {
        // Atualiza a cor na hora e muda a aba
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
            width: 1,
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

  Widget _buildEventList(List<ProfileEvent> events) {
    if (events.isEmpty) {
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
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index]);
      },
    );
  }

  Widget _buildEventCard(ProfileEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHubColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventHubColors.inputBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: EventHubColors.textPrimary,
            ),
          ),
          _buildStatusTag(event.status),
        ],
      ),
    );
  }

  Widget _buildStatusTag(EventStatus status) {
    String label;
    Color backgroundColor;

    switch (status) {
      case EventStatus.ativo:
        label = 'Ativo';
        backgroundColor = const Color(0xFF4CAF50);
        break;
      case EventStatus.alterado:
        label = 'Alterado';
        backgroundColor = const Color(0xFFFFC107);
        break;
      case EventStatus.cancelado:
        label = 'Cancelado';
        backgroundColor = const Color(0xFFF44336);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
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
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
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