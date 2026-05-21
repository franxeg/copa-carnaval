import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/team.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class ManageTeamsScreen extends StatelessWidget {
  const ManageTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Equipos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showTeamDialog(context),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.teams.length,
              itemBuilder: (_, i) {
                final team = provider.teams[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.darkGray,
                      child: Text(team.groupName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryYellow)),
                    ),
                    title: Text(team.name),
                    subtitle: Text('Grupo ${team.groupName}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.people, size: 20),
                          onPressed: () => context.go(
                              '/admin/equipo/${team.id}/jugadores'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () =>
                              _showTeamDialog(context, team: team),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20,
                              color: Colors.red),
                          onPressed: () => _deleteTeam(context, team),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showTeamDialog(BuildContext context, {Team? team}) {
    final nameCtrl = TextEditingController(text: team?.name ?? '');
    String selectedGroup = team?.groupName ?? 'A';
    final provider = context.read<AppProvider>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setSt) => AlertDialog(
          title: Text(team == null ? 'Agregar Equipo' : 'Editar Equipo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre del equipo'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedGroup,
                decoration: const InputDecoration(labelText: 'Grupo'),
                items: provider.groupNames
                    .map((g) => DropdownMenuItem(value: g, child: Text('Grupo $g')))
                    .toList(),
                onChanged: (v) => setSt(() => selectedGroup = v!),
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
                if (team == null) {
                  provider.addTeam(Team(
                    id: 'team_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text.trim(),
                    groupName: selectedGroup,
                  ));
                } else {
                  provider.updateTeam(Team(
                    id: team.id,
                    name: nameCtrl.text.trim(),
                    groupName: selectedGroup,
                    logoUrl: team.logoUrl,
                  ));
                }
                Navigator.pop(ctx);
              },
              child: Text(team == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTeam(BuildContext context, Team team) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Equipo'),
        content: Text('¿Eliminar "${team.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().deleteTeam(team.id);
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
