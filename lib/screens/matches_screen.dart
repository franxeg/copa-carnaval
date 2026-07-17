import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return BottomNav(
      currentIndex: 2,
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Partidos'),
            bottom: TabBar(
              isScrollable: false,
              tabs: List.generate(6,
                  (i) => Tab(text: 'Día ${i + 1} (${25 + i} Dic)')),
              labelColor: AppTheme.primaryYellow,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryYellow,
            ),
          ),
          body: TabBarView(
            children: List.generate(6, (day) {
              final dayMatches = provider.getMatchesByDay(day + 1);
              if (dayMatches.isEmpty) {
                return const Center(
                    child: Text('Sin partidos programados'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: dayMatches.length,
                itemBuilder: (_, i) => _MatchCard(match: dayMatches[i]),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final dynamic match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final time =
        '${match.dateTime.hour.toString().padLeft(2, '0')}:${match.dateTime.minute.toString().padLeft(2, '0')}';
    final isFinished = match.status == 'finished';
    final isLive = match.status == 'live';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('/partido/${match.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (match.groupName != null)
                    Chip(
                      label: Text('Grupo ${match.groupName}',
                          style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppTheme.darkGray,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (match.round != 'group')
                    Chip(
                      label: Text(_roundName(match.round),
                          style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppTheme.primaryYellow,
                      labelStyle:
                          const TextStyle(color: AppTheme.primaryBlack),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  const Spacer(),
                  if (isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('EN VIVO',
                          style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  Text(time,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(match.team1Name,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 12),
                  if (isFinished || isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.darkGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${match.team1Score ?? '-'} - ${match.team2Score ?? '-'}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryYellow),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('vs',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(match.team2Name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              if (match.refereeName != null) ...[
                const SizedBox(height: 8),
                Text('Árbitro: ${match.refereeName}',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
        ),
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
}
