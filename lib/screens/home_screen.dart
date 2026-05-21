import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/banner_ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await context.read<AppProvider>().loadData();
        if (mounted) {
          await context.read<AppProvider>().seedIfEmpty();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final t = provider.tournament;

    return BottomNav(
      currentIndex: 0,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t?.name ?? 'Copa Carnaval',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t?.city ?? 'Lincoln',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (t != null) _CountdownWidget(targetDate: t.startDate),
                  const SizedBox(height: 24),
                  _QuickActions(context),
                  const SizedBox(height: 16),
                  _InfoCard(),
                  if (provider.userId != null && !provider.isAdmin) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/apuestas'),
                        icon: const Icon(Icons.casino),
                        label: const Text('Ir a Apuestas'),
                      ),
                    ),
                  ],
                  if (provider.isAdmin) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/admin'),
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Panel Admin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}

class _CountdownWidget extends StatelessWidget {
  final DateTime targetDate;
  const _CountdownWidget({required this.targetDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = targetDate.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: AppTheme.primaryYellow),
            const SizedBox(width: 8),
            Text(
              days > 0
                  ? 'Comienza en $days días y $hours horas'
                  : '¡El torneo ya comenzó!',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _QuickActions(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: _ActionCard(
          icon: Icons.emoji_events,
          label: 'Posiciones',
          onTap: () => context.go('/posiciones'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ActionCard(
          icon: Icons.sports_soccer,
          label: 'Partidos',
          onTap: () => context.go('/partidos'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ActionCard(
          icon: Icons.groups,
          label: 'Equipos',
          onTap: () => context.go('/equipos'),
        ),
      ),
    ],
  );
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, size: 36, color: AppTheme.primaryYellow),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(fontSize: 13),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información del Torneo',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow)),
            const SizedBox(height: 12),
            _InfoRow(Icons.group, '4 Grupos (A, B, C, D)'),
            _InfoRow(Icons.groups, '3 Equipos por grupo'),
            _InfoRow(Icons.sports_soccer, 'Fútbol 11 Masculino - Div I'),
            _InfoRow(
                Icons.calendar_today, '25 al 30 de Diciembre - 6 días'),
            _InfoRow(Icons.emoji_events,
                'Clasifican 2 por grupo → 8vos de final'),
            if (provider.userId == null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('Iniciar sesión para apostar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryYellow,
                    side: const BorderSide(color: AppTheme.primaryYellow),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _InfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}
