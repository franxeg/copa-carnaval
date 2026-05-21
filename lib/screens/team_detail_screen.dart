import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class TeamDetailScreen extends StatelessWidget {
  final String teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final team = provider.teams.where((t) => t.id == teamId).firstOrNull;

    if (team == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Equipo')),
        body: const Center(child: Text('Equipo no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(team.name)),
      body: FutureBuilder(
        future: provider.getPlayers(teamId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final players = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.shield,
                          size: 64, color: AppTheme.primaryYellow),
                      const SizedBox(height: 12),
                      Text(team.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Grupo ${team.groupName}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Jugadores',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryYellow)),
              const SizedBox(height: 8),
              ...players.map((p) => Card(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.darkGray,
                        child: Text('${p.number}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryYellow)),
                      ),
                      title: Text(p.name),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
