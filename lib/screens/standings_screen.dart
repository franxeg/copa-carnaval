import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return BottomNav(
      currentIndex: 1,
      child: DefaultTabController(
        length: provider.groupNames.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Posiciones'),
            bottom: TabBar(
              tabs: provider.groupNames.map((g) => Tab(text: 'Grupo $g')).toList(),
              labelColor: AppTheme.primaryYellow,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryYellow,
            ),
          ),
          body: TabBarView(
            children: provider.groupNames.map((group) {
              final standings = provider.getStandings(group);
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              alignment: Alignment.center,
                              child: const Text('#',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                                child: Text('Equipo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey))),
                            SizedBox(
                              width: 28,
                              child: Text('PJ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            SizedBox(
                              width: 28,
                              child: Text('G',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            SizedBox(
                              width: 28,
                              child: Text('E',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            SizedBox(
                              width: 28,
                              child: Text('P',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            SizedBox(
                              width: 36,
                              child: Text('DG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            SizedBox(
                              width: 32,
                              child: Text('Pts',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryYellow)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: standings.length,
                        itemBuilder: (_, i) {
                          final s = standings[i];
                          final team = s['team'] as dynamic;
                          final pts = s['pts'] as int;
                          final gd = s['gd'] as int;
                          final teamMatches = provider
                              .getGroupMatches(group)
                              .where((m) =>
                                  m.team1Id == team.id ||
                                  m.team2Id == team.id)
                              .length;
                          final wins = provider
                              .getGroupMatches(group)
                              .where((m) =>
                                  m.status == 'finished' &&
                                  ((m.team1Id == team.id &&
                                          m.team1Score! > m.team2Score!) ||
                                      (m.team2Id == team.id &&
                                          m.team2Score! > m.team1Score!)))
                              .length;
                          final draws = provider
                              .getGroupMatches(group)
                              .where((m) =>
                                  m.status == 'finished' &&
                                  ((m.team1Id == team.id ||
                                          m.team2Id == team.id) &&
                                      m.team1Score == m.team2Score))
                              .length;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 0),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    child: Text('${i + 1}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: i < 2
                                              ? AppTheme.primaryYellow
                                              : Colors.grey,
                                        )),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(team.name,
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text('$teamMatches',
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text('$wins',
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text('$draws',
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text(
                                        '${teamMatches - wins - draws}',
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    width: 36,
                                    child: Text(gd.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: gd > 0
                                              ? Colors.green
                                              : gd < 0
                                                  ? Colors.red
                                                  : null,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    child: Text('$pts',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryYellow,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
