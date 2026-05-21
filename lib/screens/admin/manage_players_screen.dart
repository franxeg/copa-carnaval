import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/player.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class ManagePlayersScreen extends StatelessWidget {
  final String teamId;

  const ManagePlayersScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final team = provider.teams.where((t) => t.id == teamId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(team?.name ?? 'Jugadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPlayerDialog(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: provider.getPlayers(teamId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final players = snapshot.data!;
          if (players.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Sin jugadores', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: players.length,
            itemBuilder: (_, i) {
              final p = players[i];
              return Card(
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () {
                      context.read<AppProvider>().deletePlayer(p.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jugador eliminado')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPlayerDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final numberCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar Jugador'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: numberCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final num = int.tryParse(numberCtrl.text) ?? 0;
              context.read<AppProvider>().addPlayer(Player(
                    id: 'player_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text.trim(),
                    number: num,
                    teamId: teamId,
                  ));
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
