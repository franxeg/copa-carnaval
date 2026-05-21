import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/match.dart';
import '../../providers/app_provider.dart';


class ManageMatchesScreen extends StatelessWidget {
  const ManageMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Partidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMatchDialog(context),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.matches.length,
              itemBuilder: (_, i) {
                final m = provider.matches[i];
                final isFinished = m.status == 'finished';
                return Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    title: Text('${m.team1Name} vs ${m.team2Name}',
                        style: const TextStyle(fontSize: 14)),
                    subtitle: Text(
                      'Día ${m.dayNumber} | ${m.groupName != null ? "Grupo ${m.groupName}" : _roundName(m.round)}'
                      '${isFinished ? " | ${m.team1Score} - ${m.team2Score}" : " | Pendiente"}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFinished ? Icons.edit : Icons.add_circle,
                            size: 20,
                          ),
                          onPressed: () =>
                              context.go('/admin/partido/${m.id}/resultado'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteMatch(context, m),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _roundName(String r) {
    switch (r) {
      case 'quarter': return 'Cuartos';
      case 'semi': return 'Semifinal';
      case 'final': return 'Final';
      default: return r;
    }
  }

  void _showAddMatchDialog(BuildContext context) {
    final provider = context.read<AppProvider>();
    String? selectedTeam1;
    String? selectedTeam2;
    String? selectedGroup;
    int day = 1;
    String round = 'group';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setSt) => AlertDialog(
          title: const Text('Agregar Partido'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: round,
                  decoration: const InputDecoration(labelText: 'Fase'),
                  items: const [
                    DropdownMenuItem(value: 'group', child: Text('Grupos')),
                    DropdownMenuItem(value: 'quarter', child: Text('Cuartos')),
                    DropdownMenuItem(value: 'semi', child: Text('Semifinal')),
                    DropdownMenuItem(value: 'final', child: Text('Final')),
                  ],
                  onChanged: (v) => setSt(() => round = v!),
                ),
                if (round == 'group')
                  DropdownButtonFormField<String>(
                    initialValue: selectedGroup,
                    decoration: const InputDecoration(labelText: 'Grupo'),
                    items: provider.groupNames
                        .map((g) => DropdownMenuItem(
                            value: g, child: Text('Grupo $g')))
                        .toList(),
                    onChanged: (v) => setSt(() => selectedGroup = v),
                  ),
                DropdownButtonFormField<String>(
                  initialValue: selectedTeam1,
                  decoration: const InputDecoration(labelText: 'Equipo 1'),
                  items: provider.teams
                      .map((t) => DropdownMenuItem(
                          value: t.id, child: Text(t.name)))
                      .toList(),
                  onChanged: (v) => setSt(() => selectedTeam1 = v),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedTeam2,
                  decoration: const InputDecoration(labelText: 'Equipo 2'),
                  items: provider.teams
                      .where((t) => t.id != selectedTeam1)
                      .map((t) => DropdownMenuItem(
                          value: t.id, child: Text(t.name)))
                      .toList(),
                  onChanged: (v) => setSt(() => selectedTeam2 = v),
                ),
                DropdownButtonFormField<int>(
                  initialValue: day,
                  decoration: const InputDecoration(labelText: 'Día'),
                  items: List.generate(6, (i) => DropdownMenuItem(
                      value: i + 1, child: Text('Día ${i + 1} (${25 + i} Dic)'))),
                  onChanged: (v) => setSt(() => day = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (selectedTeam1 == null || selectedTeam2 == null) return;
                final t1 = provider.teams.firstWhere((t) => t.id == selectedTeam1);
                final t2 = provider.teams.firstWhere((t) => t.id == selectedTeam2);
                final startDate = DateTime(2026, 12, 24 + day);

                provider.addMatch(Match(
                  id: 'match_${DateTime.now().millisecondsSinceEpoch}',
                  round: round,
                  groupName: selectedGroup,
                  team1Id: t1.id,
                  team1Name: t1.name,
                  team2Id: t2.id,
                  team2Name: t2.name,
                  dateTime: startDate.add(const Duration(hours: 16)),
                  status: 'scheduled',
                  dayNumber: day,
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMatch(BuildContext context, Match match) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Partido'),
        content: Text('¿Eliminar ${match.team1Name} vs ${match.team2Name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().deleteMatch(match.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
