import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppProvider>().logout();
              context.go('/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Administración',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow)),
            const SizedBox(height: 4),
            const Text('Gestioná los datos del torneo',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _AdminCard(
              icon: Icons.groups,
              title: 'Equipos',
              subtitle: 'Agregar, editar o eliminar equipos',
              onTap: () => context.push('/admin/equipos'),
            ),
            _AdminCard(
              icon: Icons.sports_soccer,
              title: 'Partidos',
              subtitle: 'Programar partidos y cargar resultados',
              onTap: () => context.push('/admin/partidos'),
            ),
            _AdminCard(
              icon: Icons.gavel,
              title: 'Árbitros',
              subtitle: 'Gestionar árbitros del torneo',
              onTap: () => context.push('/admin/arbitros'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryYellow.withValues(alpha: 0.15),
          child: Icon(icon, color: AppTheme.primaryYellow),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
