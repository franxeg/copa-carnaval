import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/referee.dart';
import '../../providers/app_provider.dart';

class ManageRefereesScreen extends StatelessWidget {
  const ManageRefereesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Árbitros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: provider.referees.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gavel, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Sin árbitros', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.referees.length,
              itemBuilder: (_, i) {
                final r = provider.referees[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.gavel)),
                    title: Text(r.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<AppProvider>().deleteReferee(r.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar Árbitro'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              context.read<AppProvider>().addReferee(Referee(
                    id: 'ref_${DateTime.now().millisecondsSinceEpoch}',
                    name: ctrl.text.trim(),
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
