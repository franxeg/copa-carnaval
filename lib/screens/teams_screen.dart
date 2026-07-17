import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return BottomNav(
      currentIndex: 3,
      child: DefaultTabController(
        length: provider.groupNames.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Equipos'),
            bottom: TabBar(
              tabs: provider.groupNames
                  .map((g) => Tab(text: 'Grupo $g'))
                  .toList(),
              labelColor: AppTheme.primaryYellow,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryYellow,
            ),
          ),
          body: TabBarView(
            children: provider.groupNames.map((group) {
              final teams = provider.getTeamsByGroup(group);
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: teams.length,
                itemBuilder: (_, i) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.darkGray,
                      child: const Icon(Icons.shield,
                          color: AppTheme.primaryYellow),
                    ),
                    title: Text(teams[i].name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/equipo/${teams[i].id}'),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
